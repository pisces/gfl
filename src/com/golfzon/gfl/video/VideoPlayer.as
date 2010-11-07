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

import com.golfzon.gfl.core.ComponentBase;
import com.golfzon.gfl.events.VideoContollerEvent;
import com.golfzon.gfl.skins.Border;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;
import com.golfzon.gfl.video.controllerClasses.IVideoController;
import com.golfzon.gfl.video.controllerClasses.VideoController;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.NetStatusEvent;
import flash.media.SoundTransform;
import flash.media.Video;
import flash.net.NetConnection;
import flash.net.NetStream;

//--------------------------------------
//  Style
//--------------------------------------

/**
 *  백그라운드 이미지
 * 	@default value com.golfzon.gfl.skins.Border
 */
[Style(name="backgroundImage", type="class", inherit="no")]

/**
 *	@Author				SH Jung
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.11.17
 *	@Modify
 *	@Description
 * 	@includeExample		VideoPlayerSample.as
 */
public class VideoPlayer extends ComponentBase
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	private var backgroundImg:DisplayObject;
	private var connection:NetConnection;
	private var pauseMode:Boolean;
	private var stream:NetStream;
	private var totalTime:Number;
	private var video:Video;
	
	/**
	 *	@Constructor
	 */
	public function VideoPlayer() {
		super();
		
		width = 320;
		height = 240;
	}
	
	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  큐 포인트
	 */	
	public function onCuePoint(info:Object):void {
	}
	
	/**
	 *  메타 데이터
	 */	
	public function onMetaData(data:Object):void {
		totalTime = data.duration;
		
		_controller.totalTime = totalTime;
		
		if( _fitting ) {
			width = data.width;
			height = data.height + ComponentBase(_controller).height;
			measure();
			invalidateDisplayList();
		}
	}
	
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
		
		if( urlChanged ) {
			urlChanged = false;
			stop();
		}
		
		if( volumeChanged ) {
			volumeChanged = true;
			stream.soundTransform = new SoundTransform(_volume);
		}
	}
	
	/**
	 * 	자식 객체 생성 및 추가
	 */
	override protected function createChildren():void {
		backgroundImg = createBg();
		
		if( !_controller )
			controller = new VideoController();
		
		connection = createConnection();
		
		stream = new NetStream(connection);
		stream.bufferTime = _bufferTime;
		stream.client = this;
		stream.soundTransform = new SoundTransform(_volume);
		stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler, false, 0, true);
			
		video = new Video();
		video.attachNetStream(stream);
		
		addChild(backgroundImg);
		addChild(video);
	}
    
    /**
     *	enabled에 따른 구현
     */
	override protected function setEnabledState():void {
		super.setEnabledState();
		
		ComponentBase(_controller).enabled = enabled;
	}
	
    /**
     * 	컴퍼넌트의 기본 크기와 최소 크기를 설정한다.
     */
    override protected function measure():void {
    	super.measure();
		
		measureWidth = isNaN(unscaledWidth) ? video.width : unscaledWidth;
		
		measureHeight = isNaN(unscaledHeight) ? video.height : unscaledHeight;
    	
    	setActureSize(measureWidth, measureHeight);
    }
	
	/**
	 * 	디스플레이 변경사항에 대한 처리
	 */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		if( controllerChanged ) {
			controllerChanged = false;
			addController();
		}
		
		backgroundImg.width = unscaledWidth;
		backgroundImg.height = unscaledHeight;
		
		ComponentBase(_controller).width = unscaledWidth;
		ComponentBase(_controller).y = unscaledHeight - ComponentBase(_controller).height;
		
		video.width = unscaledWidth;
		video.height = ComponentBase(_controller).y;
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	/**
	 *	컨트롤을 추가한다.
	 */
	private function addController():void {
		ComponentBase(_controller).addEventListener(VideoContollerEvent.PAUSE_CLICK, controller_pauseClickHandelr, false, 0, true);
		ComponentBase(_controller).addEventListener(VideoContollerEvent.PLAY_CLICK, controller_playClickHandelr, false, 0, true);
		ComponentBase(_controller).addEventListener(VideoContollerEvent.SEEK_CHANGE, controller_seekChangeHandelr, false, 0, true);
		ComponentBase(_controller).addEventListener(VideoContollerEvent.STOP_CLICK, controller_stopClickHandelr, false, 0, true);
		ComponentBase(_controller).addEventListener(VideoContollerEvent.VOLUME_CHANGE, controller_volumeChangeHandelr, false, 0, true);
		ComponentBase(_controller).y = height;
		addChild(ComponentBase(_controller));
	}
	
	/**
	 *  비디오가 생성되었는지 체크
	 */	
	private function checkVideo():Boolean {
		return !_url || !connection || !stream || !video;
	}
	
	/**
     * 	배경 이미지 생성
     */
    private function createBg():DisplayObject {
		var bgClass:Class = replaceNullorUndefined(getStyle(StyleProp.BACKGROUND_IMAGE), Border);
		if( bgClass ) {
			var bg:DisplayObject = createSkinBy(bgClass);
			
			if( bg is Border ) {
				Border(bg).styleName = getCSSStyleDeclaration();
			}
			return bg;
		}
		return null;
    }
    
	/**
	 * 	커넥션 생성
	 */
	private function createConnection():NetConnection {
		var connection:NetConnection = new NetConnection();
        connection.connect(null);
		return connection;
	}
	
	/**
	 *	일시정지
	 */
	private function pause():void {
		if( checkVideo() )
			return;
		
		if( stream.bytesTotal == 0 )
			return; 
		
		pauseMode = !pauseMode;
		
		if( pauseMode ) {
			stream.pause();
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		else {
			stream.resume();
			addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
		}			
	}
	
	/**
	 *	재생
	 */
	private function play():void {
		if( checkVideo() )
			return;
		
		pauseMode = false;
		
		if( stream.time == 0 || stream.time >= totalTime )
			stream.play(_url);
		else
			stream.resume();
		
		addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
	}
	
	/**
	 *	컨트롤을 제거한다.
	 */
	private function removeController():void {
		ComponentBase(_controller).removeEventListener(VideoContollerEvent.PAUSE_CLICK, controller_pauseClickHandelr);
		ComponentBase(_controller).removeEventListener(VideoContollerEvent.PLAY_CLICK, controller_playClickHandelr);
		ComponentBase(_controller).removeEventListener(VideoContollerEvent.SEEK_CHANGE, controller_seekChangeHandelr);
		ComponentBase(_controller).removeEventListener(VideoContollerEvent.STOP_CLICK, controller_stopClickHandelr);
		ComponentBase(_controller).removeEventListener(VideoContollerEvent.VOLUME_CHANGE, controller_volumeChangeHandelr);
		removeChild(ComponentBase(_controller));
	}
	
	/**
	 *	시크
	 */
	private function seek(time:Number):void {
		if( checkVideo() )
			return;
		
		stream.seek(time);
	}
	
	/**
	 *	멈춤
	 */
	private function stop():void {
		if( checkVideo() )
			return;
		
		pauseMode = false;
		
		_controller.reSet();
		stream.close();
		video.clear();
		
		removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
	}
	
	//--------------------------------------------------------------------------
	//
	//	Event handlers
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  @VideoContollerEvent.PAUSE_CLICK
	 */	
	private function controller_pauseClickHandelr(event:VideoContollerEvent):void {
		pause();
	}
	
	/**
	 *  @VideoContollerEvent.PLAY_CLICK
	 */	
	private function controller_playClickHandelr(event:VideoContollerEvent):void {
		play();
	}
	
	/**
	 *  @VideoContollerEvent.SEEK_CHANGE
	 */	
	private function controller_seekChangeHandelr(event:VideoContollerEvent):void {
		seek(_controller.seek);
	}
	
	/**
	 *  @VideoContollerEvent.STOP_CLICK
	 */	
	private function controller_stopClickHandelr(event:VideoContollerEvent):void {
		stop();
	}
	
	/**
	 *  @Event.ENTER_FRAME
	 */	
	private function enterFrameHandler(event:Event):void {
		_controller.buffering(stream.bytesLoaded, stream.bytesTotal);
		_controller.currentTime(stream.time);
	}
	
	/**
	 *  @NetStatusEvent.NET_STATUS
	 */	
	private function netStatusHandler(event:NetStatusEvent):void {
		if( event.info.code == "NetStream.Play.Stop" )
			pause();
	}
	
	/**
	 *  @VideoContollerEvent.VOLUME_CHANGE
	 */	
	private function controller_volumeChangeHandelr(event:VideoContollerEvent):void {
		volume = _controller.volume;
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
	
	public function set controller(client:IVideoController):void {
		if( _controller == client ) 
			return;
		
		if( _controller ) removeController();
		_controller = client;
		controllerChanged = true;
		
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	fitting
	//--------------------------------------
	
	private var _fitting:Boolean;
	
	public function get fitting():Boolean {
		return _fitting;
	}
	
	public function set fitting(value:Boolean):void {
		if( _fitting == value ) 
			return;
		
		_fitting = value;
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
		if( _url == value ) 
			return;
		
		_url = value;
		urlChanged = true;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//	volume
	//--------------------------------------
	
	private var volumeChanged:Boolean;
	
	private var _volume:Number = 1;
	
	public function get volume():Number {
		return _volume;
	}
	
	public function set volume(value:Number):void {
		if( _volume == value ) 
			return;
		
		_volume = value;
		volumeChanged = true;
		
		invalidateProperties();
	}
}

}