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

package com.golfzon.gfl.video.controllerClasses
{
	
import com.golfzon.gfl.controls.Button;
import com.golfzon.gfl.controls.UITextField;
import com.golfzon.gfl.core.BorderBasedComponent;
import com.golfzon.gfl.events.SliderEvent;
import com.golfzon.gfl.events.TextEvent;
import com.golfzon.gfl.events.VideoEvent;
import com.golfzon.gfl.nullObject.Null;
import com.golfzon.gfl.nullObject.NullVideoController;
import com.golfzon.gfl.styles.CSSStyleDeclaration;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.MathUtil;
import com.golfzon.gfl.utils.replaceNullorUndefined;
import com.golfzon.gfl.video.IVideoPlayer;
import com.golfzon.gfl.video.VideoPlayer;

import flash.display.StageDisplayState;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import gs.TweenMax;
import com.golfzon.gfl.video.VideoFormat;
import com.golfzon.gfl.video.VideoMode;
import com.golfzon.gfl.video.VideoPlayState;

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *	화면 모드 버튼의 스타일명
 *	@default value none
 */
[Style(name="modeButtonStyleName", type="String", inherit="no")]

/**
 *	일시정지 버튼의 스타일명
 *	@default value none
 */
[Style(name="pauseButtonStyleName", type="String", inherit="no")]

/**
 *	플레이 버튼의 스타일명
 *	@default value none
 */
[Style(name="playButtonStyleName", type="String", inherit="no")]

/**
 *	SeekBar의 스타일명
 *	@default value none
 */
[Style(name="seekBarStyleName", type="String", inherit="no")]

/**
 *	볼륨 바 숨기기 딜레이 시간(밀리세컨드)
 *	@default value 1000
 */
[Style(name="volumeBarHideDelay", type="uint", inherit="no")]

/**
 *	볼륨 조절 바의 스타일명
 *	@default value none
 */
[Style(name="volumeBarStyleName", type="String", inherit="no")]

/**
 *	볼륨 버튼의 스타일명
 *	@default value none
 */
[Style(name="volumeButtonStyleName", type="String", inherit="no")]

/**
 *	@Author				KHKim
 *	@Version			1.0
 *	@Lanaguage			Action Script 3.0
 *	@Date				2010.03.11
 *	@Modify
 *	@Description
 */
public class BaseVideoController extends BorderBasedComponent implements IVideoController, Null
{
	//--------------------------------------------------------------------------
	//
	//	Instance constants
	//
	//--------------------------------------------------------------------------
	
	protected const MODE_BUTTON_STYLE_NAME:String = "modeButtonStyleName";
	protected const PAUSE_BUTTON_STYLE_NAME:String = "pauseButtonStyleName";
	protected const PLAY_BUTTON_STYLE_NAME:String = "playButtonStyleName";
	protected const SEEK_BAR_STYLE_NAME:String = "seekBarStyleName";
	protected const VOLUME_BAR_HIDE_DELAY_STYLE_PROP:String = "volumeBarHideDelay";
	protected const VOLUME_BAR_STYLE_NAME:String = "volumeBarStyleName";
	protected const VOLUME_BUTTON_STYLE_NAME:String = "volumeButtonStyleName";
	
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	[Embed(source="/assets/GZSkin.swf", symbol="VideoController_borderSkin")]
	private var borderSkin:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="VideoController_modeButton_upSkin")]
	private var modeButtonUpSkin:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="VideoController_modeButton_overSkin")]
	private var modeButtonOverSkin:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="VideoController_modeButton_downSkin")]
	private var modeButtonDownSkin:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="VideoController_modeButton_disabledSkin")]
	private var modeButtonDisabledSkin:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="VideoController_modeButton_selectedUpSkin")]
	private var modeButtonSelectedUpSkin:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="VideoController_modeButton_selectedOverSkin")]
	private var modeButtonSelectedOverSkin:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="VideoController_modeButton_selectedDownSkin")]
	private var modeButtonSelectedDownSkin:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="VideoController_modeButton_selectedDisabledSkin")]
	private var modeButtonSelectedDisabledSkin:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="VideoController_pauseButton_upSkin")]
	private var pauseButtonUpSkin:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="VideoController_pauseButton_overSkin")]
	private var pauseButtonOverSkin:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="VideoController_pauseButton_downSkin")]
	private var pauseButtonDownSkin:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="VideoController_pauseButton_disabledSkin")]
	private var pauseButtonDisabledSkin:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="VideoController_playButton_upSkin")]
	private var playButtonUpSkin:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="VideoController_playButton_overSkin")]
	private var playButtonOverSkin:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="VideoController_playButton_downSkin")]
	private var playButtonDownSkin:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="VideoController_playButton_disabledSkin")]
	private var playButtonDisabledSkin:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="VideoController_volumeButton_upSkin")]
	private var volumeButtonUpSkin:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="VideoController_volumeButton_overSkin")]
	private var volumeButtonOverSkin:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="VideoController_volumeButton_downSkin")]
	private var volumeButtonDownSkin:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="VideoController_volumeButton_disabledSkin")]
	private var volumeButtonDisabledSkin:Class;
	
	private var volumeBarDowned:Boolean;
	
	private var timer:Timer;
	
	protected var modeButton:Button;
	protected var pauseButton:Button;
	protected var playButton:Button;
	protected var volumeButton:Button;		
	protected var seekBar:VideoSeekBar;		
	protected var timeLabel:UITextField;		
	protected var volumeBar:VideoVolumeBar;
			
	// 추가		
	private var isDowned:Boolean;
	private var seekValue:Number;	
	
	/**
	 *	@Constructor
	 */
	public function BaseVideoController() {
		super();
		
		height = 20;
		
		setStyle(StyleProp.BORDER_SKIN, borderSkin);
	}
	
	//--------------------------------------------------------------------------
	//
	//	Class methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Public
	//--------------------------------------------------------------------------
	
	/**
	 *	새로운 Null객체를 생성해 반환한다.
	 */
	public static function newNull():NullVideoController {
		return new NullVideoController();
	}
	
	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Overriden : BorderBasedComponent
	//--------------------------------------------------------------------------
	
	/**
	 * 	자식 객체 생성 및 추가
	 */
	override protected function createChildren():void {
		super.createChildren();
		
		playButton = createButton(PLAY_BUTTON_STYLE_NAME);
		
		pauseButton = createButton(PAUSE_BUTTON_STYLE_NAME);
		pauseButton.visible = false;
		
		modeButton = createButton(MODE_BUTTON_STYLE_NAME);
		modeButton.toggle = true;
		
		volumeButton = createButton(VOLUME_BUTTON_STYLE_NAME);
		volumeButton.buttonMode = false;
		
		volumeBar = new VideoVolumeBar();
		volumeBar.alpha = 0;
		volumeBar.mouseChildren = volumeBar.mouseEnabled = false;
		volumeBar.value = _volume;
		volumeBar.styleName = getStyle(VOLUME_BAR_STYLE_NAME);
		
		seekBar = getSeekBar();
		seekBar.snapInterval = 0.1;
		
		timeLabel = new UITextField();
		timeLabel.selectable = false;
		timeLabel.text = "00:00 / 00:00";
		
		configureListeners();
		setDefaultStyles();
		addChild(seekBar);
		addChild(timeLabel);
		addChild(volumeBar);
	}
	
	/**
	 *	enabled에 따른 구현
	 */
	override protected function setStateToChangeEnabled():void {
		super.setStateToChangeEnabled();
		
		modeButton.enabled = pauseButton.enabled = pauseButton.enabled =
			volumeButton.enabled = seekBar.enabled = timeLabel.enabled = enabled;
	}
	
	/**
	 *	스타일 프로퍼티로 값을 설정한다.
	 */
	override public function styleChanged(styleProp:String):void {
		super.styleChanged(styleProp);
		
		switch( styleProp ) {
			case MODE_BUTTON_STYLE_NAME:
				modeButton.styleName = getStyle(styleProp);
				break;
			
			case PAUSE_BUTTON_STYLE_NAME:
				pauseButton.styleName = getStyle(styleProp);
				break;
			
			case PLAY_BUTTON_STYLE_NAME:
				playButton.styleName = getStyle(styleProp);
				break;
			
			case SEEK_BAR_STYLE_NAME:
				seekBar.styleName = getStyle(styleProp);
				break;
			
			case VOLUME_BAR_STYLE_NAME:
				volumeBar.styleName = getStyle(styleProp);
				break;
			
			case VOLUME_BUTTON_STYLE_NAME:
				volumeButton.styleName = getStyle(styleProp);
				break;
		}
	}
	
	/**
	 * 	디스플레이 변경사항에 대한 처리
	 */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		modeButton.x = unscaledWidth - modeButton.width;
		volumeButton.x = playButton.x + playButton.width + 5;
		volumeBar.x = volumeButton.x;
		volumeBar.y = volumeBar.height * -1 + 1;		
		timeLabel.x = volumeButton.x + volumeButton.width + 5;
		timeLabel.y = uint((unscaledHeight - timeLabel.measuredHeight) / 2);
		seekBar.width = modeButton.x - (timeLabel.x + timeLabel.measuredWidth) - 8;		
		seekBar.x = timeLabel.x + timeLabel.measuredWidth + 7;
	}
	
	//--------------------------------------------------------------------------
	//  Protected
	//--------------------------------------------------------------------------
	
	protected function createButton(styleName:String):Button {
		var button:Button = new Button();
		button.buttonMode = true;
		button.height = height;
		button.styleName = getStyle(styleName);
		
		return Button(addChild(button));
	}
	
	//--------------------------------------------------------------------------
	//  Public
	//--------------------------------------------------------------------------
			
	/**
	 *	자신이 Null객체인지 아닌지 반환한다.
	 */
	public function isNull():Boolean {
		return false;
	}
	
	/**
	 *	비디오를 버퍼링할 때의 비주얼을 설정한다.
	 */
	public function buffering(current:Number, total:Number):void {
		seekBar.setProgress(current, total);
	}
	
	/**
	 *	컨트롤러의 상태를 초기화한다.
	 */
	public function reset():void {
		playButton.visible = true;
		pauseButton.visible = false;
		timeLabel.text = "00:00 / 00:00";
		seekBar.value = _player.controller.seek == -1 ? 0 : _player.controller.seek;
		seekBar.setProgress(0, 100);
	}
	
	/**
	 *	비디오의 상태에 따른 상태를 설정한다.
	 */
	public function setState(state:String):void {
		switch( state ) {
			case VideoPlayState.PAUSE:
				playButton.visible = true;
				pauseButton.visible = false;
				break;
			
			case VideoPlayState.PLAY:
				playButton.visible = false;
				pauseButton.visible = true;
				break;
			
			case StageDisplayState.FULL_SCREEN:
				modeButton.selected = true;
				break;
			
			case StageDisplayState.NORMAL:
				modeButton.selected = false;
				break;
		}
	}
	
	/**
	 *	진행률을 보여준다.
	 */
	public function updateTimeSeek(time:Number, duration:Number):void {
		seekBar.minimum = 0;
		seekBar.maximum = duration;
		
		_seek = _seek <= 0 ? 0 : _seek;
		
		if( VideoPlayer(_player).format == VideoFormat.MP4 ) {
			if( (VideoPlayer(_player).mode == VideoMode.DOWNLOAD) ) {
				seekBar.value = time;
			} else {
				if(_seek == time) {
					seekBar.value = time;
				} else {
					seekBar.value = _seek + time > duration ? duration : _seek + time;
				}
			}
		} else {
			seekBar.value = time;
		}	
		
		var t:String = MathUtil.decimalToSexagesimal(uint(time)).toString();
		var d:String = MathUtil.decimalToSexagesimal(uint(duration)).toString();
		timeLabel.text = t + " / " + d;
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	private function configureListeners():void {
		modeButton.addEventListener(Event.CHANGE, modeButton_changeHandler, false, 0, true);
		playButton.addEventListener(MouseEvent.CLICK, playButton_clickHandler, false, 0, true);
		pauseButton.addEventListener(MouseEvent.CLICK, pauseButton_clickHandler, false, 0, true);

		if( !VideoPlayer(_player).slowMotion ) {
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp, false, 0, true);
			seekBar.addEventListener(SliderEvent.CHANGE, seekBar_changeHandler, false, 0, true);
		} else {
			seekBar.addEventListener(SliderEvent.CHANGE, seekBar_changeHandler_downloadMode, false, 0, true);
		}		
		
		volumeBar.addEventListener(SliderEvent.CHANGE, volumeBar_changeHandler, false, 0, true);
		volumeBar.addEventListener(MouseEvent.MOUSE_DOWN, volumeBar_mouseDownHandler, false, 0, true);
		volumeBar.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler, false, 0, true);
		volumeBar.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler, false, 0, true);
		volumeButton.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler, false, 0, true);
		volumeButton.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler, false, 0, true);
	}
	
	private function getSeekBar():VideoSeekBar {
		if( _player.mode != VideoMode.DOWNLOAD )
			return	new StreamingVideoSeekBar();				
		return	new VideoSeekBar();		
	}
	
	private function setDefaultStyles():void {
		var pauseButtonStyleName:CSSStyleDeclaration = new CSSStyleDeclaration();
		pauseButtonStyleName.setStyle(StyleProp.UP_SKIN, pauseButtonUpSkin);
		pauseButtonStyleName.setStyle(StyleProp.OVER_SKIN, pauseButtonOverSkin);
		pauseButtonStyleName.setStyle(StyleProp.DOWN_SKIN, pauseButtonDownSkin);
		pauseButtonStyleName.setStyle(StyleProp.DISABLED_SKIN, pauseButtonDisabledSkin);
		
		var playButtonStyleName:CSSStyleDeclaration = new CSSStyleDeclaration();
		playButtonStyleName.setStyle(StyleProp.UP_SKIN, playButtonUpSkin);
		playButtonStyleName.setStyle(StyleProp.OVER_SKIN, playButtonOverSkin);
		playButtonStyleName.setStyle(StyleProp.DOWN_SKIN, playButtonDownSkin);
		playButtonStyleName.setStyle(StyleProp.DISABLED_SKIN, playButtonDisabledSkin);
		
		var modeButtonStyleName:CSSStyleDeclaration = new CSSStyleDeclaration();
		modeButtonStyleName.setStyle(StyleProp.UP_SKIN, modeButtonUpSkin);
		modeButtonStyleName.setStyle(StyleProp.OVER_SKIN, modeButtonOverSkin);
		modeButtonStyleName.setStyle(StyleProp.DOWN_SKIN, modeButtonDownSkin);
		modeButtonStyleName.setStyle(StyleProp.DISABLED_SKIN, modeButtonDisabledSkin);
		modeButtonStyleName.setStyle(StyleProp.SELECTED_UP_SKIN, modeButtonSelectedUpSkin);
		modeButtonStyleName.setStyle(StyleProp.SELECTED_OVER_SKIN, modeButtonSelectedOverSkin);
		modeButtonStyleName.setStyle(StyleProp.SELECTED_DOWN_SKIN, modeButtonSelectedDownSkin);
		modeButtonStyleName.setStyle(StyleProp.SELECTED_DISABLED_SKIN, modeButtonSelectedDisabledSkin);
		
		var volumeButtonStyleName:CSSStyleDeclaration = new CSSStyleDeclaration();
		volumeButtonStyleName.setStyle(StyleProp.UP_SKIN, volumeButtonUpSkin);
		volumeButtonStyleName.setStyle(StyleProp.OVER_SKIN, volumeButtonOverSkin);
		volumeButtonStyleName.setStyle(StyleProp.DOWN_SKIN, volumeButtonDownSkin);
		volumeButtonStyleName.setStyle(StyleProp.DISABLED_SKIN, volumeButtonDisabledSkin);
		
		modeButton.styleName = replaceNullorUndefined(getStyle(MODE_BUTTON_STYLE_NAME), modeButtonStyleName);
		pauseButton.styleName = replaceNullorUndefined(getStyle(PAUSE_BUTTON_STYLE_NAME), pauseButtonStyleName);
		playButton.styleName = replaceNullorUndefined(getStyle(PLAY_BUTTON_STYLE_NAME), playButtonStyleName);
		volumeButton.styleName = replaceNullorUndefined(getStyle(VOLUME_BUTTON_STYLE_NAME), volumeButtonStyleName);
	}
	
	private function hideVolumeBar():void {
		if( !volumeBarDowned ) {
			TweenMax.to(volumeBar, 0.3, {alpha:0});
			volumeBar.mouseChildren = volumeBar.mouseEnabled = false;
		}
	}
	
	private function showVolumeBar():void {
		volumeBar.mouseChildren = volumeBar.mouseEnabled = true;
		TweenMax.to(volumeBar, 0.4, {alpha:1});
	}
	
	private function removeTimer():void {
		if( timer ) {
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
			timer = null;
		}
	}
	
	private function startTimer():void {
		removeTimer();
		
		var delay:uint = replaceNullorUndefined(getStyle(VOLUME_BAR_HIDE_DELAY_STYLE_PROP), 1000);
		timer = new Timer(delay, 1);
		timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler, false, 0, true);
		timer.start();
	}
	
	private function released():void {
		volumeBarDowned = false;
		systemManager.stage.removeEventListener(Event.MOUSE_LEAVE, systemManager_stage_mouseLeaveHandler);
		systemManager.stage.removeEventListener(MouseEvent.MOUSE_UP, systemManager_stage_mouseUpHandler);
	}
	
	//--------------------------------------------------------------------------
	//
	//	Event handlers
	//
	//--------------------------------------------------------------------------
	
	private function rollOverHandler(event:MouseEvent):void {
		removeTimer();
		showVolumeBar();
	}
	
	private function rollOutHandler(event:MouseEvent):void {
		startTimer();
	}
	
	private function textChangeHandler(event:TextEvent):void {
		invalidateDisplayList();
	}
	
	private function timerCompleteHandler(event:TimerEvent):void {
		hideVolumeBar();
	}
	
	private function modeButton_changeHandler(event:Event):void {
		_player.setDisplayState(
			modeButton.selected ? StageDisplayState.FULL_SCREEN : StageDisplayState.NORMAL);
	}
	
	private function pauseButton_clickHandler(event:MouseEvent):void {
		playButton.visible = pauseButton.visible;
		pauseButton.visible = !playButton.visible;
		
		if( _player.pause() )
			_player.dispatchEvent(new VideoEvent(VideoEvent.PAUSE));
	}
	
	private function playButton_clickHandler(event:MouseEvent):void {
		playButton.visible = pauseButton.visible;
		pauseButton.visible = !playButton.visible;
		
		if( _player.play() )
			_player.dispatchEvent(new VideoEvent(VideoEvent.PLAY));
	}
	
	private function seekBar_changeHandler(event:SliderEvent):void {
		_player.pause();
		isDowned = true;
		seekValue = seekBar.value;
		
		if( _player.mode != VideoMode.DOWNLOAD )
			StreamingVideoSeekBar(seekBar).xChange = true; 
	}
	
	private function seekBar_changeHandler_downloadMode(event:SliderEvent):void {
		if( _player.seek(seekBar.value) )
			_player.dispatchEvent(new VideoEvent(VideoEvent.SEEK));			
	}
	
	private var seekTimeID:int;
	
	private function onStageMouseUp(event:MouseEvent):void {
		if( isDowned ) {
			if( _player.mode != VideoMode.DOWNLOAD )
				StreamingVideoSeekBar(seekBar).xChange = false;
			
			if( _player.seek(seekValue) )
				_player.dispatchEvent(new VideoEvent(VideoEvent.SEEK));								
			
			isDowned = false;
			clearTimeout( seekTimeID );
			seekTimeID = setTimeout( _player.play, 100 );
		}
	}
	
	private function volumeBar_changeHandler(event:SliderEvent):void {
		if( volumeBar.value == _player.volume )
			return;
		
		_volume = volumeBar.value;
		_player.volume = _volume;
		
		_player.dispatchEvent(new VideoEvent(VideoEvent.VOLUME_CHANGE));
	}
	
	private function volumeBar_mouseDownHandler(event:MouseEvent):void {
		volumeBarDowned = true;
		systemManager.stage.addEventListener(
			Event.MOUSE_LEAVE, systemManager_stage_mouseLeaveHandler, false, 0, true);
		systemManager.stage.addEventListener(
			MouseEvent.MOUSE_UP, systemManager_stage_mouseUpHandler, false, 0, true);
	}
	
	private function systemManager_stage_mouseLeaveHandler(event:Event):void {
		released();
	}
	
	private function systemManager_stage_mouseUpHandler(event:MouseEvent):void {
		released();
		
		if( !volumeBar.hitTestPoint(stage.mouseX, stage.mouseY, true) &&
			!volumeButton.hitTestPoint(stage.mouseX, stage.mouseY, true) )
			startTimer();
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//	player
	//--------------------------------------
	
	private var _player:IVideoPlayer;
	
	public function get player():IVideoPlayer {
		return _player;
	}
	
	public function set player(value:IVideoPlayer):void {
		_player = value;
	}
	
	//--------------------------------------
	//	currentTime
	//--------------------------------------
	
	private var _currentTime:Number;
	
	public function get currentTime():Number {
		return _duration;
	}
	
	public function set currentTime(value:Number):void {
		_duration = value;
	}
	
	//--------------------------------------
	//	duration
	//--------------------------------------
	
	private var _duration:Number;
	
	public function get duration():Number {
		return _duration;
	}
	
	public function set duration(value:Number):void {
		_duration = value;
	}
	
	//--------------------------------------
	//	seek
	//--------------------------------------
	
	private var _seek:Number = -1;
	
	public function get seek():Number {
		return _seek;
	}
	
	public function set seek(value:Number):void {
		_seek = value;
	}
	
	//--------------------------------------
	//	volume
	//--------------------------------------
	
	private var _volume:Number;
	
	public function get volume():Number {
		return _volume;
	}
	
	public function set volume(value:Number):void {
		_volume = value;
	}
}

}