////////////////////////////////////////////////////////////////////////////////
//
//  GOLFZON
//  Copyright(c) GOLFZON.CO.,LTD.
//  All Rights Reserved.
//
//  NOTICE: GOLFZON permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.golfzon.gfl.video
{

import com.adobe.utils.ObjectUtil;
import com.golfzon.gfl.controls.Alert;
import com.golfzon.gfl.core.BorderBasedComponent;
import com.golfzon.gfl.core.IInteractiveObject;
import com.golfzon.gfl.events.VideoEvent;
import com.golfzon.gfl.styles.IStyleClient;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;
import com.golfzon.gfl.video.controllerClasses.BaseVideoController;
import com.golfzon.gfl.video.controllerClasses.IVideoController;

import flash.display.DisplayObject;
import flash.display.StageDisplayState;
import flash.events.AsyncErrorEvent;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.NetStatusEvent;
import flash.events.TimerEvent;
import flash.media.SoundTransform;
import flash.media.Video;
import flash.net.NetConnection;
import flash.net.NetStream;
import flash.ui.Mouse;
import flash.utils.Timer;

import gs.TweenMax;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *	비디오가 일시정지되면 발송한다.
 */
[Event(name="pause", type="com.golfzon.gfl.events.VideoEvent")]

/**
 *	비디오가 플레이되면 발송한다.
 */
[Event(name="play", type="com.golfzon.gfl.events.VideoEvent")]

/**
 *	비디오가 구간 검색되면 발송한다.
 */
[Event(name="seek", type="com.golfzon.gfl.events.VideoEvent")]

/**
 *	비디오가 정지되면 발송한다.
 */
[Event(name="stop", type="com.golfzon.gfl.events.VideoEvent")]

/**
 *	비디오의 볼륨이 변경되면 발송한다.
 */
[Event(name="volumeChange", type="com.golfzon.gfl.events.VideoEvent")]

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *	일시정지 아이콘
 *	@default value none
 */
[Style(name="pauseIcon", type="Class", inherit="no")]

/**
 *	플레이 아이콘
 *	@default value none
 */
[Style(name="playIcon", type="Class", inherit="no")]

/**
 *	@Author				KHKim
 *	@Version			1.0
 *	@Lanaguage			Action Script 3.0
 *	@Date				2010.03.16
 *	@Modify				2010.09.01 by rrobbie
 *	@Description
 * 	@includeExample		VideoPlayerSample.as
 */
public class VideoPlayer extends BorderBasedComponent implements IVideoPlayer
{
	//--------------------------------------------------------------------------
	//
	//	Instance constants
	//
	//--------------------------------------------------------------------------
	
	private const PAUSE_ICON_STYLE_PROP:String = "pauseIcon";
	private const PLAY_ICON_STYLE_PROP:String = "playIcon";
	
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	private var playing:Boolean;
	
	[Embed(source="/assets/GZSkin.swf", symbol="VideoPlayer_pauseIcon")]
	private var pauseIconClass:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="VideoPlayer_playIcon")]
	private var playIconClass:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="ProgressBar_animationSkin")]
	private var bufferSkin:Class;	
	
	private var icon:DisplayObject;
	private var bufferIcon:DisplayObject;
	private var connection:NetConnection;	
	private var stream:NetStream;	
	private var video:Video;
	private var timer:Timer;	
	private var nullController:IVideoController;
	
	private var slowMotionCount:Number = 0;
	private var slowMotionSeekPoints:Number = -1;
	
	/**
	 *	@Constructor
	 */
	public function VideoPlayer() {
		super();
		
		width = 420;
		height = 240;
		controller = new BaseVideoController();
		nullController = BaseVideoController.newNull();
		
		addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true);
		addEventListener(VideoEvent.STOP, onStopToButton, false, 0, true);
		
		setStyle(StyleProp.BACKGROUND_COLOR, 0x000000);
		setStyle(StyleProp.BORDER_THICKNESS, 0);
	}
	
	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Overriden : ComponentBase
	//--------------------------------------------------------------------------
	
	/**
	 * 	프로퍼티 변경 사항에 대한 처리
	 */
	override protected function commitProperties():void {
		super.commitProperties();
		
		if( bufferTimeChanged ) {
			bufferTimeChanged = false;
			stream.bufferTime = _bufferTime;
		}
		
		if( controllerChanged ) {
			controllerChanged = false;
			
			if( controller is IStyleClient )
				IStyleClient(controller).styleName = getStyle(StyleProp.VIDEO_CONTROLLER_STYLE_NAME);
			
			addChild(DisplayObject(controller));
		}
		
		if( urlChanged ) {
			urlChanged = false;
			stop();
			controller.seek = 0;
			controller.reset();	
		}
		
		if( volumeChanged ) {
			volumeChanged = true;
			controller.volume = _volume;
			stream.soundTransform = new SoundTransform(_volume / 100);
		}
		
		if( slowMotionChanged ) {
			slowMotionChanged = false;
			
		}		
	}
	
	/**
	 * 	자식 객체 생성 및 추가
	 */
	override protected function createChildren():void {
		super.createChildren();
		
		createBufferIcon();
		
		video = new Video();		
		addChild(video);
		
		if( _mode ==  VideoMode.RTMP_STREAMING ) {
			connection = createConnectionForRTMP();
		} else {
			connection = createConnection();
			stream = createStream(connection);
			video.attachNetStream(stream);
		}
	}
	
	private function createBufferIcon():void {
		bufferIcon = new bufferSkin();
		bufferIcon.visible = false;
		addChild(bufferIcon);			
	}
	
	private function createStream(connection:NetConnection):NetStream {
		var netStream:NetStream = new NetStream(connection);
		netStream.bufferTime = _bufferTime;
		netStream.client = { onCuePoint:onCuePoint, onMetaData:onMetaData };
		netStream.soundTransform = new SoundTransform(_volume / 100);
		netStream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler, false, 0, true);
		netStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler, false, 0, true);
		return netStream;
	}
	
	private function resetSlowMotion():void {
		if( _slowMotion ) {
			slowMotionSeekPoints = -1;
			slowMotionCount = 0;
		}
	}
	
	private function getHTTPParameter(value:Number):String {
		return (_format == VideoFormat.MP4) ? getTimeForMp4( value ) : getTimeForFlv( value );
	}
	
	private function getRealURL(value:String):String {
		var index:int = 0;
		for(var i:Number=0; i<value.length; i++) {
			if( value.charAt(i) == "?" ) { 
				index = i;
				return value.substring(0, i);
			}
		}
		return value;
	}
	
	/**
	 *	enabled에 따른 구현
	 */
	override protected function setStateToChangeEnabled():void {
		super.setStateToChangeEnabled();
		
		if( controller is IInteractiveObject )
			IInteractiveObject(controller).enabled = enabled;
	}
	
	/**
	 * 	디스플레이 변경사항에 대한 처리
	 */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		controller.width = unscaledWidth;
		controller.y = unscaledHeight - controller.height;
		
		video.width = unscaledWidth;
		video.height = isFullScreen() ? unscaledHeight : unscaledHeight - controller.height;
		
		bufferIcon.width = 26;
		bufferIcon.height = 25;
		
		bufferIcon.x = (unscaledWidth - bufferIcon.width)/2;
		bufferIcon.y = (unscaledHeight - bufferIcon.height)/2 - controller.height/2;
	}
	
	//--------------------------------------------------------------------------
	//  Public
	//--------------------------------------------------------------------------
	
	/**
	 *	전체화면 또는 일반화면으로 모드를 변경한다.
	 */
	public function setDisplayState(state:String):void {
		systemManager.stage.removeEventListener(Event.RESIZE, systemManager_stage_resizeHandler);
		systemManager.stage.addEventListener(Event.RESIZE, systemManager_stage_resizeHandler, false, 0, true);
		systemManager.stage.displayState = state;
	}
	
	/**
	 *	일시정지 
	 */
	public function pause():Boolean {
		if( notPrepared() )
			return false;
		
		playing = false;
		_currentState = VideoPlayState.PAUSE;
		stream.pause();
		
		removeEventListener(Event.ENTER_FRAME, enterFrameHandler);		
		controller.setState(_currentState);
		return true;
	}
	
	/**
	 *	재생
	 */
	public function play():Boolean {	
		if( notPrepared() || !stream )
			return false;
		
		playing = true;
		
		_currentState = VideoPlayState.PLAY;
		
		if( stream.time > 0 && stream.time < _duration )  {
			stream.resume();
		} else {
			resetSlowMotion();
			stream.play(_url);
		} 
		
		if( _slowMotion )
			stream.pause();
		
		removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
		controller.setState(_currentState);
		bufferIcon.visible = true;
		return true;
	}
	
	/**
	 *	시크
	 */
	public function seek(offset:Number):Boolean {
		if( notPrepared() || (_mode != VideoMode.RTMP_STREAMING && stream.bytesLoaded < 1) )
			return false;				
		
		switch( _mode ) {
			case VideoMode.DOWNLOAD :
				_time = offset;	
				_slowMotion ? setSlowMotionSeek(offset) : stream.seek(offset);
				break;
			
			case VideoMode.HTTP_STREAMING :
				_time = offset;
				_url = getRealURL(_url) + "?start=" + getHTTPParameter(offset);
				stop();
				controller.reset();
				controller.seek = offset;
				play();
				break;
			
			case VideoMode.RTMP_STREAMING :
				stream.seek(offset);
				_time = stream.time;
				break;
		}
		
		controller.buffering(stream.bytesLoaded, stream.bytesTotal);
		controller.updateTimeSeek(_time, _duration);
		return true;
	}
	
	/**
	 *	멈춤
	 */
	public function stop():Boolean {		
		if( notPrepared() )
			return false;
		
		playing = false;
		_currentState = VideoPlayState.STOP;
		
		stream.close();		
		video.clear();
		bufferIcon.visible = false;
		removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		controller.updateTimeSeek(0, _duration);
		
		resetSlowMotion();
		return true;
	}
	
	/**
	 *	FMS CallBack Function 
	 */ 
	public function OnBWDone():void {
		trace("Flash Media Server CallBack Function");
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	private function createConnection():NetConnection {
		var connection:NetConnection = new NetConnection();
		connection.connect(null);
		return connection;
	}
	
	private function createConnectionForRTMP():NetConnection {
		var connection:NetConnection = new NetConnection();
		connection.client = { OnBWDone:OnBWDone };
		connection.addEventListener(NetStatusEvent.NET_STATUS, connectionHandler, false, 0, true);				
		connection.connect(_serverPath);
		return connection;
	}
	
	/**
	 * 	스테이지 디스플레이모드가 풀스크린인지에 대한 부울값.
	 */
	private function isFullScreen():Boolean {
		if( !stage )	return false;
		return stage.displayState == StageDisplayState.FULL_SCREEN;
	}
	
	/**
	 *  비디오를 컨트롤 할 수 있는 준비가 되었는지에 대한 부울값.
	 */	
	private function notPrepared():Boolean {
		return !_url || !creationComplete;
	}
	
	private function cancelHideDelay():void {
		DisplayObject(controller).alpha = 1;
		Mouse.show();
		
		if( timer ) {
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
			timer = null;
		}
	}
	
	private function startHideDelay():void {
		if( !DisplayObject(controller).hitTestPoint(stage.mouseX, stage.mouseY, true) ) {
			timer = new Timer(_hideDelay, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler, false, 0, true);
			timer.start();
		}
	}
	
	private function removeIcon():void {
		if( icon && contains(icon) ) {
			removeChild(icon);
			icon = null;
		}
	}
	
	private function setSlowMotionSeek(offset:Number):void {
		var value:Array = getSlowMotionSeek(offset);		
		slowMotionSeekPoints = value[1];
		slowMotionCount = 0;
		_time = _seekPoints[slowMotionSeekPoints].time;
		stream.seek( _time );
		controller.updateTimeSeek( _time, _duration);		
		slowMotionCount++;
	}
	
	private function setSeekPoints(data:Object):void {
		_seekPoints = new Array();

		if( data.seekpoints ) {				
			for(var o:Object in data.seekpoints)
				_seekPoints.push( {time:data.seekpoints[o].time, bytes:data.seekpoints[o].offset} );
			_format = VideoFormat.MP4;
		}
		
		if( data.keyframes ) {
			for(var ob:Object in data.keyframes.filepositions)
				_seekPoints.push( {time:data.keyframes.times[ob], bytes:data.keyframes.filepositions[ob]} );
			_format = VideoFormat.FLV;
		}
	}
	
	private function setSlowMotion():void {	
		if( !_seekPoints )
			return;
		
		if( slowMotionCount % _slowMotionAccessTime == 0 ) {
			if( slowMotionSeekPoints == _seekPoints.length-1 )
				return;
			
			_time = _seekPoints[++slowMotionSeekPoints].time;
			stream.seek( _time );
			controller.updateTimeSeek( _time, _duration);
		}
		
		slowMotionCount++;
	}
	
	private function setPauseState():void {
		if( pause() )
			dispatchEvent(new VideoEvent(VideoEvent.PAUSE));			
	}
	
	private function setStopState():void {
		if( stop() )
			dispatchEvent(new VideoEvent(VideoEvent.STOP));			
	}
	
	private function getTimeForMp4(value:Number):String {
		for(var i:Number=0; i<_seekPoints.length; i++) {
			if( int(_seekPoints[i].time) == int(value) )
				return _seekPoints[i].time;
		}
		return "";
	}
	
	private function getTimeForFlv(value:Number):String {
		for(var i:Number=0; i<_seekPoints.length; i++) {
			if( int(_seekPoints[i].time) == int(value) )
				return _seekPoints[i].bytes;	
		}
		
		var min:Number = 100;
		var v:Number;
		var index:Number = -1;
		
		for(var j:Number=0; j<_seekPoints.length; j++) {
			v = Math.abs( value - int(_seekPoints[j].time) );
			if( min > v ) {
				min = v;
				index = j;
			}			
		}
		return _seekPoints[index].bytes;		
	}
	
	private function getDecimal(value:Number):Number {
		var temp:String = value.toString();		
		return Number(temp.substring(0, String(int(value)).length + 2));
	} 
	
	private function getSlowMotionSeek(value:Number):Array {		
		for(var i:Number=0; i<_seekPoints.length; i++) {			
			if( _seekPoints[i].time == getDecimal(value) ) {
				slowMotionSeekPoints = i;
				return [_seekPoints[i].time, i];	
			}
		}
		
		var min:Number = 100;
		var v:Number;
		var index:Number = -1;
		
		for(var j:Number=0; j<_seekPoints.length; j++) {
			v = Math.abs( value - int(_seekPoints[j].time) );
			if( min > v ) {
				min = v;
				index = j;
			}			
		}
		
		slowMotionSeekPoints = index;
		return [_seekPoints[index].time, index];			
	}
	//--------------------------------------------------------------------------
	//
	//	Event handlers
	//
	//--------------------------------------------------------------------------
	
	private function connectionHandler(event:NetStatusEvent):void {
		if( event.info.code == "NetConnection.Connect.Success" ) {
			stream = new NetStream(connection);
			stream.bufferTime = _bufferTime;
			stream.client = { onCuePoint:onCuePoint, onMetaData:onMetaData };
			stream.soundTransform = new SoundTransform(_volume / 100);
			stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler, false, 0, true);			
			video.attachNetStream(stream);
		} else {
			Alert.show("Fail to make Connection");
		}
	}
	
	private function onStopToButton(event:VideoEvent):void {
		url = getRealURL(_url);;
		controller.seek = 0;
		controller.reset();
	}
	
	private function mouseUpHandler(event:MouseEvent):void {
		if( DisplayObject(controller).hitTestPoint(stage.mouseX, stage.mouseY, true) )
			return;
		
		var Definition:Class = playing ?
			replaceNullorUndefined(getStyle(PAUSE_ICON_STYLE_PROP), pauseIconClass) :
			replaceNullorUndefined(getStyle(PLAY_ICON_STYLE_PROP), playIconClass);
		
		icon = DisplayObject(new Definition());
		icon.x = uint(video.width / 2);
		icon.y = uint(video.height / 2);
		
		addChild(icon);
		
		TweenMax.to(
			icon, 0.5, 
			{
				alpha:0, width:icon.width * 2, height:icon.height * 2,
				onComplete:removeIcon
			}
		);
		
		playing ? pause() : play();
	}
	
	private function enterFrameHandler(event:Event):void {
		if( _mode == VideoMode.DOWNLOAD && _slowMotion ) {			
			setSlowMotion();			
		} else {
			if( stream.time == 0 )	return;
			
			_time = stream.time;
			controller.buffering(stream.bytesLoaded, stream.bytesTotal);
			controller.updateTimeSeek(_time, _duration);
		}
	}
	
	private function netStatusHandler(event:NetStatusEvent):void {
		switch( event.info.code ) {
			case "NetStream.Play.Stop":
				_closeState ? setPauseState() : setStopState();
				break;
			
			case "NetStream.Play.StreamNotFound":
				dispatchEvent(new VideoEvent(VideoEvent.NOT_FOUND));
				break;
		}
	}
	
	private function asyncErrorHandler(event:AsyncErrorEvent):void {
		trace("asyncErrorHandler");
	}
	
	/**
	 *  큐 포인트 핸들러
	 */	
	private function onCuePoint(info:Object):void {
	}
	
	/**
	 *  메타 데이터 핸들러
	 */	
	private function onMetaData(data:Object):void {
		if( isFullScreen() )
			return;
		
		var w:Number = _fitting ? data.width : unscaledWidth;
		var h:Number = _fitting ? data.height : unscaledHeight;
		
		setActualSize(w, h);
		invalidateDisplayList();

		if (!_metadataLoaded) {
			_duration = data.duration;
			
			if( _mode != VideoMode.RTMP_STREAMING )
				setSeekPoints(data);

			_metadataLoaded = true;
			dispatchEvent(new VideoEvent(VideoEvent.SUCCESS));
		}
	}
	
	private function systemManager_stage_mouseMoveHandler(event:Event):void {
		cancelHideDelay();
		startHideDelay();
	}
	
	private function systemManager_stage_resizeHandler(event:Event):void {
		setActualSize(
			isFullScreen() ? stage.stageWidth : origineWidth,
			isFullScreen() ? stage.stageHeight : origineHeight
		);
		
		invalidateDisplayList();
		controller.setState(stage.displayState);
		
		if( isFullScreen() ) {
			systemManager.stage.addEventListener(
				MouseEvent.MOUSE_MOVE, systemManager_stage_mouseMoveHandler, false, 0, true);
			startHideDelay();
		} else {
			systemManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE, systemManager_stage_mouseMoveHandler);
			cancelHideDelay();
		}
	}
	
	private function timerCompleteHandler(event:TimerEvent):void {
		Mouse.hide();
		TweenMax.to(controller, 0.4, {alpha:0});
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//	bufferTime
	//--------------------------------------
	
	private var bufferTimeChanged:Boolean;
	
	private var _bufferTime:Number = 1;
	
	public function get bufferTime():Number {
		return _bufferTime;
	}
	
	public function set bufferTime(time:Number):void {
		if( _bufferTime == time ) 
			return;
		
		_bufferTime = time;
		bufferTimeChanged = true;
		invalidateProperties();
	}
	
	//--------------------------------------
	//	Controller
	//--------------------------------------
	
	private var controllerChanged:Boolean;
	
	private var _controller:IVideoController;
	
	public function get controller():IVideoController {
		return _controller ? _controller : nullController;
	}
	
	public function set controller(value:IVideoController):void {
		if( value === _controller ) 
			return;
		
		if( _controller && contains(DisplayObject(_controller)) )
			removeChild(DisplayObject(_controller));
		
		_controller = value;
		_controller.volume = _volume;
		_controller.player = this;
		
		controllerChanged = true;
		
		invalidateProperties();
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	duration
	//--------------------------------------
	
	private var _duration:Number;
	
	public function get duration():Number {
		return _duration;
	}
	
	//--------------------------------------
	//	time
	//--------------------------------------
	
	private var _time:Number;
	
	public function get time():Number {
		return _time;
	}
	
	public function set time(value:Number):void {
		_time = value;
	}
	
	//--------------------------------------
	//	currentState
	//--------------------------------------
	
	private var _currentState:String;
	
	public function get currentState():String {
		return _currentState;
	}
	
	//--------------------------------------
	//	fitting
	//--------------------------------------
	
	private var _fitting:Boolean;
	
	public function get fitting():Boolean {
		return _fitting;
	}
	
	public function set fitting(value:Boolean):void {
		if( value == _fitting ) 
			return;
		
		_fitting = value;
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	hideDelay
	//--------------------------------------
	
	private var _hideDelay:uint = 1500;
	
	public function get hideDelay():uint {
		return _hideDelay;
	}
	
	public function set hideDelay(value:uint):void {
		if( _hideDelay == value ) 
			return;
		
		_hideDelay = value;
	}
	
	//--------------------------------------
	//	url
	//--------------------------------------
	
	private var urlChanged:Boolean;
	
	private var _url:String;
	
	public function get url():String {
		return _url;
	}
	
	public function set url(value:String):void {
		if( value == _url ) 
			return;
		
		_url = value;
		urlChanged = true;
		_metadataLoaded = false;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//	volume
	//--------------------------------------
	
	private var volumeChanged:Boolean;
	
	private var _volume:Number = 50;
	
	public function get volume():Number {
		return _volume;
	}
	
	public function set volume(value:Number):void {
		if( value == _volume ) 
			return;
		
		_volume = value;
		volumeChanged = true;
		invalidateProperties();
	}
	
	//--------------------------------------
	//	seekPoints
	//--------------------------------------
	
	private var _seekPoints:Array;
	
	public function get seekPoints():Array {
		return _seekPoints;
	}
	
	public function set seekPoints(value:Array):void {
		_seekPoints = value;
	}
	
	//--------------------------------------
	//	mode
	//--------------------------------------
	
	private var _mode:int;
	
	/**
	 *	1: download , 2: HTTP Streaming, 3: RTMP Streaming 
	 */ 
	public function get mode():int {
		return _mode;
	}
	
	public function set mode(value:int):void {
		_mode = value;
	}	
	
	//--------------------------------------
	//	serverPath
	//--------------------------------------
	
	private var _serverPath:String;
	
	/**
	 *	RTMP Streaming 방식일 경우 영상파일이 존재하는 디렉토리 경로 
	 */ 
	public function get serverPath():String {
		return _serverPath;
	}
	
	public function set serverPath(value:String):void {
		_serverPath = value;
	}
	
	//--------------------------------------
	//	format
	//--------------------------------------
	
	private var _format:String;
	
	/**
	 *	MP4 / FLV
	 */ 
	public function get format():String {
		return _format;
	}
	
	//--------------------------------------
	//	slowMotion
	//--------------------------------------
	
	private var slowMotionChanged:Boolean;
	
	private var _slowMotion:Boolean;
	
	/**
	 *	Slow Motion 여부 
	 */ 
	public function get slowMotion():Boolean {
		return _slowMotion;
	}
	
	public function set slowMotion(value:Boolean):void {
		_slowMotion = value;
		slowMotionChanged = true;
		invalidateProperties();
	}	
	
	//--------------------------------------
	//	slowMotionAccessTime
	//--------------------------------------
	
	private var _slowMotionAccessTime:int = 2;
	
	/**
	 *	Slow Motion 배속 
	 */ 	
	public function set slowMotionAccessTime(value:int):void {
		_slowMotionAccessTime = value;
	}
	
	//--------------------------------------
	//	closeState
	//--------------------------------------
	
	private var _closeState:Boolean;
	
	/**
	 *	영상 종료시 pause ? stop 상태 설정 
	 */ 	
	public function set closeState(value:Boolean):void {
		_closeState = value;
	}	
	
	//--------------------------------------
	//	metadataLoaded
	//--------------------------------------
	
	private var _metadataLoaded:Boolean;
	
	public function get metadataLoaded():Boolean {
		return _metadataLoaded;
	}
}
	
}