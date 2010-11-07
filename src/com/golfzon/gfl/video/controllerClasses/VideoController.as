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
import com.golfzon.gfl.controls.VSlider;
import com.golfzon.gfl.core.ComponentBase;
import com.golfzon.gfl.core.gz_internal;
import com.golfzon.gfl.events.VideoContollerEvent;
import com.golfzon.gfl.skins.Border;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.display.DisplayObject;
import flash.display.StageDisplayState;
import flash.events.Event;
import flash.events.MouseEvent;

use namespace gz_internal;

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *	@Include the external file to define videoController styles.
 */
include "VideoControllerStyles.as";

/**
 *	@Author				SH Jung
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.11.18
 *	@Modify
 *	@Description
 * 	@includeExample		VideoPlayerSample.as
 */
public class VideoController extends ComponentBase implements IVideoController
{
	//--------------------------------------------------------------------------
	//
	//	Instance constants
	//
    //--------------------------------------------------------------------------
    
    [Embed(source="/assets/GZSkin.swf", symbol="VideoControllerBorder_skin")]
    private var BORDER_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="VideoControllerFullScreen_disabledSkin")]
    private var FULLSCREEN_DISABLED_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="VideoControllerFullScreen_downSkin")]
    private var FULLSCREEN_DOWN_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="VideoControllerFullScreen_overSkin")]
    private var FULLSCREEN_OVER_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="VideoControllerFullScreen_upSkin")]
    private var FULLSCREEN_UP_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="VideoControllerPause_disabledSkin")]
    private var PAUSE_DISABLED_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="VideoControllerPause_downSkin")]
    private var PAUSE_DOWN_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="VideoControllerPause_overSkin")]
    private var PAUSE_OVER_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="VideoControllerPause_upSkin")]
    private var PAUSE_UP_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="VideoControllerPlay_disabledSkin")]
    private var PLAY_DISABLED_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="VideoControllerPlay_downSkin")]
    private var PLAY_DOWN_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="VideoControllerPlay_overSkin")]
    private var PLAY_OVER_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="VideoControllerPlay_upSkin")]
    private var PLAY_UP_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="VideoControllerStop_disabledSkin")]
    private var STOP_DISABLED_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="VideoControllerStop_downSkin")]
    private var STOP_DOWN_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="VideoControllerStop_overSkin")]
    private var STOP_OVER_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="VideoControllerStop_upSkin")]
    private var STOP_UP_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="VideoControllerVolume_disabledSkin")]
    private var VOLUME_DISABLED_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="VideoControllerVolume_downSkin")]
    private var VOLUME_DOWN_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="VideoControllerVolume_overSkin")]
    private var VOLUME_OVER_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="VideoControllerVolume_upSkin")]
    private var VOLUME_UP_SKIN:Class;
    
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	private var border:DisplayObject;
	private var fullScreenBtn:Button;
	private var pauseBtn:Button;
	private var playBtn:Button;
	private var stopBtn:Button;
	private var timeLine:TimeLine;
	private var volumeBtn:Button;
	private var volumeSlider:VSlider;
	private var volumeSliderBorder:Border;
	
	/**
	 *	@Constructor
	 */
	public function VideoController() {
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  버퍼링
	 */	
	public function buffering(loaded:Number, total:Number):void {
		timeLine.buffering(loaded, total);
	}
	
	/**
	 *  현재 플레이 시간
	 */	
	public function currentTime(time:Number):void {
		timeLine.currentTime(time);
	}
	
	/**
	 *  컨트롤 리셋
	 */
	public function reSet():void {
		if( !timeLine )
			return;
		
		_seek = 0;
		
		timeLine.enabled = false;
		timeLine.buffering(0, 100);
		timeLine.currentTime(_seek);
		timeLine.value = _seek;
		
		volumeSlider.enabled = 
		volumeSlider.visible = 
		volumeSliderBorder.enabled =
		volumeSliderBorder.visible = false;
	}
	
	//--------------------------------------------------------------------------
	//  Overriden : ComponentBase
	//--------------------------------------------------------------------------
	
	 /**
	 * 	프로퍼티 변경 사항에 대한 처리
	 */
	override protected function commitProperties():void {
		super.commitProperties();
		
		if( totalTimeChanged ) {
			totalTimeChanged = false;
			timeLine.maximum = _totalTime;
			timeLine.enabled = true;
		}
		
		if( volumeChanged ) {
			volumeChanged = true;
			dispatchEvent(new VideoContollerEvent(VideoContollerEvent.VOLUME_CHANGE));
		}
	}
	
	/**
	 * 	자식 객체 생성 및 추가
	 */
	override protected function createChildren():void {
		border = createBorder();
		
		fullScreenBtn = new Button();
		
		pauseBtn = new Button();
		
		playBtn = new Button();
		
		stopBtn = new Button();
		
		timeLine = new TimeLine();
		timeLine.enabled = false;
		
		volumeBtn = new Button();
		
		volumeSlider = createVolumeSlider();
		
		volumeSliderBorder = new Border();
		volumeSliderBorder.enabled = false;
		volumeSliderBorder.visible = false;
		volumeSliderBorder.addChild(volumeSlider);
		
		configureListeners();
		setDefaultStyle();
		
		addChild(border);
		addChild(fullScreenBtn);
		addChild(playBtn);
		addChild(pauseBtn);
		addChild(stopBtn);
		addChild(timeLine);
		addChild(volumeBtn);
		addChild(volumeSliderBorder);
	}
	
    /**
     *	enabled에 따른 구현
     */
	override protected function setEnabledState():void {
		super.setEnabledState();
		
		playBtn.enabled = enabled;
		fullScreenBtn.enabled = enabled;
		pauseBtn.enabled = enabled;
		stopBtn.enabled = enabled;
		timeLine.enabled = enabled;
		volumeBtn.enabled = enabled;
		volumeSliderBorder.enabled = enabled;
	}
	
    /**
     *	스타일 프로퍼티로 값을 설정한다.
     */
	override public function styleChanged(styleProp:String):void {
		super.styleChanged(styleProp);
    
		switch( styleProp ) {
			case StyleProp.FULLSCREEN_BTN_DISABLED_SKIN:	case StyleProp.FULLSCREEN_BTN_DOWN_SKIN:
			case StyleProp.FULLSCREEN_BTN_OVER_SKIN:		case StyleProp.FULLSCREEN_BTN_UP_SKIN:
				setFullScreenStyle(styleProp);
				break;
			
			case StyleProp.PAUSE_BTN_DISABLED_SKIN:	case StyleProp.PAUSE_BTN_DOWN_SKIN:
			case StyleProp.PAUSE_BTN_OVER_SKIN:		case StyleProp.PAUSE_BTN_UP_SKIN:
				setPauseBtnStyle(styleProp);
				break;
				
			case StyleProp.PLAY_BTN_DISABLED_SKIN:	case StyleProp.PLAY_BTN_DOWN_SKIN:
			case StyleProp.PLAY_BTN_OVER_SKIN:		case StyleProp.PLAY_BTN_UP_SKIN:
				setPlayBtnStyle(styleProp);
				break;
				
			case StyleProp.STOP_BTN_DISABLED_SKIN:	case StyleProp.STOP_BTN_DOWN_SKIN:
			case StyleProp.STOP_BTN_OVER_SKIN:		case StyleProp.STOP_BTN_UP_SKIN:
				setStopBtnStyle(styleProp);
				break;
				
			case StyleProp.VOLUME_BTN_DISABLED_SKIN:	case StyleProp.VOLUME_BTN_DOWN_SKIN:
			case StyleProp.VOLUME_BTN_OVER_SKIN:		case StyleProp.VOLUME_BTN_UP_SKIN:
				setVolumeBtnStyle(styleProp);
				break;
		}
	}
	
    /**
     * 	컴퍼넌트의 기본 크기와 최소 크기를 설정한다.
     */
    override protected function measure():void {
    	super.measure();
		
    	measureWidth = isNaN(unscaledWidth) ? border.width : unscaledWidth;
    	measureHeight = isNaN(unscaledHeight) ? border.height : unscaledHeight;
    	
    	setActureSize(measureWidth, measureHeight);
    }
    
	/**
     * 	디스플레이 변경 사항에 대한 처리
     */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		setChildAlign();
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	/**
	 *	이벤트 등록
	 */
	private function configureListeners():void {
		fullScreenBtn.addEventListener(MouseEvent.CLICK, fullScreenBtn_click, false, 0, true);
		playBtn.addEventListener(MouseEvent.CLICK, playBtn_clickHandler, false, 0, true);
		pauseBtn.addEventListener(MouseEvent.CLICK, pauseBtn_clickHandler, false, 0, true);
		stopBtn.addEventListener(MouseEvent.CLICK, stopBtn_clickHandler, false, 0, true);
		timeLine.addEventListener(Event.CHANGE, timeLine_changeHandler, false, 0, true);
		volumeBtn.addEventListener(MouseEvent.CLICK, volumeBtn_clickHandler, false, 0, true);
		volumeSlider.addEventListener(Event.CHANGE, volumeSlider_changeHandler, false, 0, true);
		volumeSlider.addEventListener(Event.CLOSE, volumeSlider_closeHandler, false, 0, true);
	}
    
    /**
     * 	보더 생성
     */
    private function createBorder():DisplayObject {
		var borderClass:Class = replaceNullorUndefined(getStyle(StyleProp.BORDER_SKIN), BORDER_SKIN);
		if( borderClass ) {
			var border:DisplayObject = createSkinBy(borderClass);
			border.width = 320;
			border.height = 20;
			
			if( border is Border )
				Border(border).styleName = getCSSStyleDeclaration();
				
			return border;
		}
		return null;
    }
    
	/**
	 *  volumeSlider생성
	 */	
	private function createVolumeSlider():VSlider {
		var slider:VSlider = new VSlider();
		slider.height = 50;
		slider.value = 1;
		slider.minimum = 0;
		slider.maximum = 1;
		slider.snapInterval = 0.01;
		slider.dataTipView = false;
		slider.enabled = false;
		slider.visible = false;
		return slider;
	}
	
	/**
     * 	fullScreenBtn버튼 기본 시킨
     */
	private function setFullScreenStyle(styleProp:String):void {
		switch( styleProp ) {
			case StyleProp.FULLSCREEN_BTN_DISABLED_SKIN:
				fullScreenBtn.setStyle(StyleProp.DISABLED_SKIN,
					replaceNullorUndefined(getStyle(styleProp), FULLSCREEN_DISABLED_SKIN));
				break;
			
			case StyleProp.FULLSCREEN_BTN_DOWN_SKIN:
				fullScreenBtn.setStyle(StyleProp.DOWN_SKIN,
					replaceNullorUndefined(getStyle(styleProp), FULLSCREEN_DOWN_SKIN));
				break;
			
			case StyleProp.FULLSCREEN_BTN_OVER_SKIN:
				fullScreenBtn.setStyle(StyleProp.OVER_SKIN,
					replaceNullorUndefined(getStyle(styleProp), FULLSCREEN_OVER_SKIN));
				break;
			
			case StyleProp.FULLSCREEN_BTN_UP_SKIN:
				fullScreenBtn.setStyle(StyleProp.UP_SKIN,
					replaceNullorUndefined(getStyle(styleProp), FULLSCREEN_UP_SKIN));
				break;
		}
	}
	
	/**
     * 	자식들의 정렬을 지정
     */
	private function setChildAlign():void {
		border.width = unscaledWidth;
		
		playBtn.x = 1;
		playBtn.y = int((unscaledHeight - playBtn.height) / 2);
		
		pauseBtn.x = playBtn.width + playBtn.x;
		pauseBtn.y = int((unscaledHeight - pauseBtn.height) / 2);
		
		stopBtn.x = pauseBtn.x + pauseBtn.width;
		stopBtn.y = int((unscaledHeight - stopBtn.height) / 2);
		
		timeLine.x = stopBtn.x + stopBtn.width + 5;
		timeLine.y = int((unscaledHeight - timeLine.height) / 2);
		timeLine.width = unscaledWidth - timeLine.x - volumeBtn.width - fullScreenBtn.width - 5 - 4;
		
		fullScreenBtn.x = timeLine.x + timeLine.width + 5;
		fullScreenBtn.y = int((unscaledHeight - fullScreenBtn.height) / 2);
		
		volumeBtn.x = unscaledWidth - volumeBtn.width - 2;
		volumeBtn.y = int((unscaledHeight - volumeBtn.height) / 2);
		
		volumeSliderBorder.width = volumeSlider.width + 4;
		volumeSliderBorder.height = volumeSlider.height + 14;
		volumeSliderBorder.x = unscaledWidth - volumeSliderBorder.width;
		volumeSliderBorder.y = volumeSliderBorder.height * -1;
		
		volumeSlider.x = 2;
		volumeSlider.y = 7;
	}
	
    /**
     * 	@private
     */
	private function setDefaultStyle():void {
		setFullScreenStyle(StyleProp.FULLSCREEN_BTN_DISABLED_SKIN);
		setFullScreenStyle(StyleProp.FULLSCREEN_BTN_DOWN_SKIN);
		setFullScreenStyle(StyleProp.FULLSCREEN_BTN_OVER_SKIN);
		setFullScreenStyle(StyleProp.FULLSCREEN_BTN_UP_SKIN);
		
		setPauseBtnStyle(StyleProp.PAUSE_BTN_DISABLED_SKIN);
		setPauseBtnStyle(StyleProp.PAUSE_BTN_DOWN_SKIN);
		setPauseBtnStyle(StyleProp.PAUSE_BTN_OVER_SKIN);
		setPauseBtnStyle(StyleProp.PAUSE_BTN_UP_SKIN);
		
		setPlayBtnStyle(StyleProp.PLAY_BTN_DISABLED_SKIN);
		setPlayBtnStyle(StyleProp.PLAY_BTN_DOWN_SKIN);
		setPlayBtnStyle(StyleProp.PLAY_BTN_OVER_SKIN);
		setPlayBtnStyle(StyleProp.PLAY_BTN_UP_SKIN);
		
		setStopBtnStyle(StyleProp.STOP_BTN_DISABLED_SKIN);
		setStopBtnStyle(StyleProp.STOP_BTN_DOWN_SKIN);
		setStopBtnStyle(StyleProp.STOP_BTN_OVER_SKIN);
		setStopBtnStyle(StyleProp.STOP_BTN_UP_SKIN);
		
		timeLine.styleName = getStyle(StyleProp.TIME_LINE_STYLE_NAME);
		
		setVolumeBtnStyle(StyleProp.VOLUME_BTN_DISABLED_SKIN);
		setVolumeBtnStyle(StyleProp.VOLUME_BTN_DOWN_SKIN);
		setVolumeBtnStyle(StyleProp.VOLUME_BTN_OVER_SKIN);
		setVolumeBtnStyle(StyleProp.VOLUME_BTN_UP_SKIN);
	}
	
	/**
     * 	pauseBtn버튼 기본 시킨
     */
	private function setPauseBtnStyle(styleProp:String):void {
		switch( styleProp ) {
			case StyleProp.PAUSE_BTN_DISABLED_SKIN:
				pauseBtn.setStyle(StyleProp.DISABLED_SKIN,
					replaceNullorUndefined(getStyle(styleProp), PAUSE_DISABLED_SKIN));
				break;
			
			case StyleProp.PAUSE_BTN_DOWN_SKIN:
				pauseBtn.setStyle(StyleProp.DOWN_SKIN,
					replaceNullorUndefined(getStyle(styleProp), PAUSE_DOWN_SKIN));
				break;
			
			case StyleProp.PAUSE_BTN_OVER_SKIN:
				pauseBtn.setStyle(StyleProp.OVER_SKIN,
					replaceNullorUndefined(getStyle(styleProp), PAUSE_OVER_SKIN));
				break;
			
			case StyleProp.PAUSE_BTN_UP_SKIN:
				pauseBtn.setStyle(StyleProp.UP_SKIN,
					replaceNullorUndefined(getStyle(styleProp), PAUSE_UP_SKIN));
				break;
		}
	}
	
	/**
     * 	playBtn버튼 기본 시킨
     */
	private function setPlayBtnStyle(styleProp:String):void {
		switch( styleProp ) {
			case StyleProp.PLAY_BTN_DISABLED_SKIN:
				playBtn.setStyle(StyleProp.DISABLED_SKIN,
					replaceNullorUndefined(getStyle(styleProp), PLAY_DISABLED_SKIN));
				break;
			
			case StyleProp.PLAY_BTN_DOWN_SKIN:
				playBtn.setStyle(StyleProp.DOWN_SKIN,
					replaceNullorUndefined(getStyle(styleProp), PLAY_DOWN_SKIN));
				break;
			
			case StyleProp.PLAY_BTN_OVER_SKIN:
				playBtn.setStyle(StyleProp.OVER_SKIN,
					replaceNullorUndefined(getStyle(styleProp), PLAY_OVER_SKIN));
				break;
			
			case StyleProp.PLAY_BTN_UP_SKIN:
				playBtn.setStyle(StyleProp.UP_SKIN,
					replaceNullorUndefined(getStyle(styleProp), PLAY_UP_SKIN));
				break;
		}
	}
	
	/**
     * 	pauseBtn버튼 기본 시킨
     */
	private function setStopBtnStyle(styleProp:String):void {
		switch( styleProp ) {
			case StyleProp.STOP_BTN_DISABLED_SKIN:
				stopBtn.setStyle(StyleProp.DISABLED_SKIN,
					replaceNullorUndefined(getStyle(styleProp), STOP_DISABLED_SKIN));
				break;
			
			case StyleProp.STOP_BTN_DOWN_SKIN:
				stopBtn.setStyle(StyleProp.DOWN_SKIN,
					replaceNullorUndefined(getStyle(styleProp), STOP_DOWN_SKIN));
				break;
			
			case StyleProp.STOP_BTN_OVER_SKIN:
				stopBtn.setStyle(StyleProp.OVER_SKIN,
					replaceNullorUndefined(getStyle(styleProp), STOP_OVER_SKIN));
				break;
			
			case StyleProp.STOP_BTN_UP_SKIN:
				stopBtn.setStyle(StyleProp.UP_SKIN,
					replaceNullorUndefined(getStyle(styleProp), STOP_UP_SKIN));
				break;
		}
	}
	
	/**
     * 	volumeBtn버튼 기본 시킨
     */
	private function setVolumeBtnStyle(styleProp:String):void {
		switch( styleProp ) {
			case StyleProp.VOLUME_BTN_DISABLED_SKIN:
				volumeBtn.setStyle(StyleProp.DISABLED_SKIN,
					replaceNullorUndefined(getStyle(styleProp), VOLUME_DISABLED_SKIN));
				break;
			
			case StyleProp.VOLUME_BTN_DOWN_SKIN:
				volumeBtn.setStyle(StyleProp.DOWN_SKIN,
					replaceNullorUndefined(getStyle(styleProp), VOLUME_DOWN_SKIN));
				break;
			
			case StyleProp.VOLUME_BTN_OVER_SKIN:
				volumeBtn.setStyle(StyleProp.OVER_SKIN,
					replaceNullorUndefined(getStyle(styleProp), VOLUME_OVER_SKIN));
				break;
			
			case StyleProp.VOLUME_BTN_UP_SKIN:
				volumeBtn.setStyle(StyleProp.UP_SKIN,
					replaceNullorUndefined(getStyle(styleProp), VOLUME_UP_SKIN));
				break;
		}
	}
	
	/**
	 *	볼륨 슬라이더 열기/닫기
	 */
	private function volumeSliderVisible():void {
		volumeSlider.enabled = 
		volumeSlider.visible = 
		volumeSliderBorder.enabled =
		volumeSliderBorder.visible = !volumeSliderBorder.visible;
		
		if( volumeSliderBorder.visible )
			stage.addEventListener(MouseEvent.CLICK, stage_clickHandler, false, 0, true);
		else
			stage.removeEventListener(MouseEvent.CLICK, stage_clickHandler);
			
	}
	
	//--------------------------------------------------------------------------
	//
	//	Event handlers
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  볼륨 컨트롤 체크
	 */	
	private function enterFrameHandler(event:Event):void {
		if( volumeSliderBorder.hitTestPoint(stage.mouseX, stage.mouseY) )
			return;
		
		removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		volumeSliderVisible();
	}
	
	/**
	 *  풀스크린 
	 */	
	private function fullScreenBtn_click(event:MouseEvent):void {
		stage.displayState = StageDisplayState.FULL_SCREEN;
	}
	
	/**
	 *  일시정지
	 */	
	private function pauseBtn_clickHandler(event:MouseEvent):void {
		dispatchEvent(new VideoContollerEvent(VideoContollerEvent.PAUSE_CLICK));
	}
	
	/**
	 *  재생
	 */	
	private function playBtn_clickHandler(event:MouseEvent):void {
		timeLine.enabled = true;
		dispatchEvent(new VideoContollerEvent(VideoContollerEvent.PLAY_CLICK));
	}
	
	/**
	 *  스테이지 클릭
	 */	
	private function stage_clickHandler(event:MouseEvent):void {
		if( volumeBtn.hitTestPoint(stage.mouseX, stage.mouseY) || volumeSlider.hitTestPoint(stage.mouseX, stage.mouseY) )
			return;
		
		removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		volumeSliderVisible();
	}
	
	/**
	 *  정지
	 */	
	private function stopBtn_clickHandler(event:MouseEvent):void {
		dispatchEvent(new VideoContollerEvent(VideoContollerEvent.STOP_CLICK));
	}
	
	/**
	 *  시크
	 */
	private function timeLine_changeHandler(event:Event):void {
		_seek = timeLine.value;
		dispatchEvent(new VideoContollerEvent(VideoContollerEvent.SEEK_CHANGE));
	}
	
	/**
	 *  볼륨버튼 클릭
	 */	
	private function volumeBtn_clickHandler(event:MouseEvent):void {
		volumeSliderVisible();
	}
	
	/**
	 *  볼륨슬라이더 변경
	 */	
	private function volumeSlider_changeHandler(event:Event):void {
		volume = volumeSlider.value;
	}
	
	/**
	 *  볼륨슬라이더 클로즈
	 */	
	private function volumeSlider_closeHandler(event:Event):void {
		addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
	}
	
    //--------------------------------------------------------------------------
	//
	//	getter / setter
	//
    //--------------------------------------------------------------------------
    
	//--------------------------------------
	//	totalTime
	//--------------------------------------
	
	private var totalTimeChanged:Boolean;
	
	private var _totalTime:Number;
	
	public function set totalTime(time:Number):void {
		if( time == _totalTime )
			return;
		
		_totalTime = time;
		totalTimeChanged = true;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//	seek
	//--------------------------------------
	
	private var _seek:Number;
	
	public function get seek():Number {
		return _seek;
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
		if( value == _volume )
			return;
			
		_volume = value;
		volumeChanged = true;
		
		invalidateProperties();
	}
	
}

}