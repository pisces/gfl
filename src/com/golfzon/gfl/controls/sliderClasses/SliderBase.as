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

package com.golfzon.gfl.controls.sliderClasses
{
	
import com.golfzon.gfl.core.ComponentBase;
import com.golfzon.gfl.core.gz_internal;
import com.golfzon.gfl.styles.StyleProp;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

use namespace gz_internal;


//--------------------------------------
//  Events
//--------------------------------------

/**
 *	내부에서 value가 변경되었을 때 송출한다.
 */
[Event(name="change", type="flash.events.Event")]

/**
 *	슬라이드가 중지되었을 때 송출한다.
 */
[Event(name="close", type="flash.events.Event")]


//--------------------------------------
//  Style
//--------------------------------------

/**
 *  썸 스킨
 * 	@default value com.golfzon.gfl.controls.sliderClasses.SliderThumb
 */
[Style(name="thumbStyleName", type="String", inherit="no")]

/**
 *  트렉 색상
 * 	@default value 0x666666
 */
[Style(name="trackHighlightColor", type="uint", inherit="no")]

/**
 *  트렉 하이라이트 스킨
 * 	@default value com.golfzon.gfl.skins.Border
 */
[Style(name="trackHighlightSkin", type="String", inherit="no")]

/**
 *  트렉 스킨
 * 	@default value com.golfzon.gfl.skins.Border
 */
[Style(name="trackStyleName", type="String", inherit="no")]

/**
 *  트렉 하이라이트
 * 	@default value false
 */
[Style(name="showTrackHighlight", type="Boolean", inherit="no")]


/**
 *	@Author				SH Jung
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.11.12
 *	@Modify
 *	@Description
 */	
public class SliderBase extends ComponentBase
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	private var thumbInstanceDowned:Boolean;
	protected var thumbInstance:SliderThumb;
	protected var trackInstance:DisplayObject;
	protected var trackHighlight:DisplayObject;
	protected var trackHighlightMask:Sprite;
	
	/**
	 *	@Constructor
	 */
	public function SliderBase(){
		super();
		
		setStyle(StyleProp.TRACK_HIGHLIGHT_COLOR, 0x666666);
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
	 * 	자식 객체 생성 및 추가
	 */
	override protected function createChildren():void {
		trackInstance = createTrack();
		addChild(trackInstance);
		
		if( getStyle(StyleProp.SHOW_TRACK_HIGHLIGHT) ) {
			trackHighlightMask = createHighlightMask();
			addChild(trackHighlightMask);
			
			trackHighlight = createHighlight();
			trackHighlight.mask = trackHighlightMask;
			addChild(trackHighlight);
		}
		
		thumbInstance = new SliderThumb();
		thumbInstance.styleName = getStyle(StyleProp.THUMB_STYLE_NAME);
		addChild(thumbInstance);
		
		configureListeners();
		
		if( isNaN(_value) )
			value = _minimum;
	}
	
	/**
	 * 	프로퍼티 변경 사항에 대한 처리
	 */
	override protected function commitProperties():void {
		super.commitProperties();
		
		if( valueChanged ) {
			valueChanged = false;
			_value = _value > _maximum ? _maximum : _value;
			_value = _value < _minimum ? _minimum : _value;
			thumbInstancePos(_value);
		}
		
		if( maximumChanged ) {
			maximumChanged = false;
			value = _value > _maximum ? _maximum : _value;
		}
		
		if( minimumChanged ) {
			minimumChanged = false;
			value = _value < _minimum ? _minimum : _value;
		}
	}
	
	/**
	 *	스타일 프로퍼티로 값을 설정한다.
	 */
	override public function styleChanged(styleProp:String):void {
		super.styleChanged(styleProp);
		
		switch( styleProp ) {
			case StyleProp.THUMB_STYLE_NAME:
					thumbInstance.styleName = getStyle(StyleProp.THUMB_STYLE_NAME);
				break;
				
			case StyleProp.SHOW_TRACK_HIGHLIGHT:	case StyleProp.TRACK_HIGHLIGHT_COLOR:
			case StyleProp.TRACK_HIGHLIGHT_SKIN:
					if( getStyle(StyleProp.SHOW_TRACK_HIGHLIGHT) )	{
						if( trackHighlightMask != null )	removeChild(trackHighlightMask);
						if( trackHighlight != null )		removeChild(trackHighlight);
						
						trackHighlightMask = createHighlightMask();
						trackHighlight = createHighlight();
						trackHighlight.mask = trackHighlightMask;
						
						addChildAt(trackHighlightMask, numChildren - 1);
						addChildAt(trackHighlight, numChildren - 1);
					} else {
						trackHighlightMask.visible = false;
						trackHighlight.visible = false;
					}
				break;
		}
	}
	
	/**
	 *	enabled 속성이 변경되었을 때 호출되며, mouseEnabled, mouseChildren이 변경된다.
	 */
	override protected function setStateToChangeEnabled():void {
		super.setStateToChangeEnabled();
		
		thumbInstance.enabled = enabled;
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	/**
	 * 	트렉 생성
	 */
	protected function createTrack():DisplayObject {
		throw new Error("이 메소드는 구현이 필요한 추상 메소드입니다.");
	}
	
	/**
	 * 	하이라이트 생성
	 */
	protected function createHighlight():DisplayObject {
		throw new Error("이 메소드는 구현이 필요한 추상 메소드입니다.");
	}
	
	/**
	 * 	트렉 마스크 생성
	 */
	protected function createHighlightMask():Sprite {
		throw new Error("이 메소드는 구현이 필요한 추상 메소드입니다.");
	}
	
	/**
	 *	이벤트 등록
	 */
	private function configureListeners():void {
		trackInstance.addEventListener(MouseEvent.CLICK, trackInstance_clickHandler, false, 0, true);
		thumbInstance.addEventListener(MouseEvent.MOUSE_DOWN, thumbInstance_mouseDownHandler, false, 0, true);
		thumbInstance.addEventListener(MouseEvent.MOUSE_UP, thumbInstance_mouseUpHandler, false, 0, true);
	}
	
	/**
	 *	TODO : value에 따른 thumbInstance의 포지션 변화
	 */
	protected function thumbInstancePos(value:Number, change:Boolean = true):void {
		if( _dataTipView && stage && change && thumbInstanceDowned )
			tooltip = _value.toString();
	}
	
	/**
	 *	슬라이드 중지
	 */
	private function stopSlide():void {
		thumbInstanceDowned = false;
		tooltip = null;
		
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHander);
		stage.removeEventListener(Event.MOUSE_LEAVE, stage_mouseLeaveHandler);
		stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
		
		dispatchEvent(new Event(Event.CHANGE));
		dispatchEvent(new Event(Event.CLOSE));
	}
	//--------------------------------------------------------------------------
	//
	//	Event handlers
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  @MouseEvent.CLICK
	 */
	private function trackInstance_clickHandler(event:MouseEvent):void {
		stage_mouseMoveHander(event);
		stopSlide();
	}
	
	/**
	 *  @MouseEvent.MOUSE_DOWN
	 */
	private function thumbInstance_mouseDownHandler(event:MouseEvent):void {
		thumbInstanceDowned = true;
		
		stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHander, false, 0, true);
		stage.addEventListener(Event.MOUSE_LEAVE, stage_mouseLeaveHandler, false, 0, true);
		stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler, false, 0, true);
	}
	
	/**
	 *  TODO : 마우스 위치에 따른 value계산
	 */
	protected function stage_mouseMoveHander(event:MouseEvent):void {
		throw new Error("이 메소드는 구현이 필요한 추상 메소드입니다.");
	}
	
	/**
	 *  @MouseEvent.MOUSE_UP
	 */
	private function thumbInstance_mouseUpHandler(event:MouseEvent):void {
		stopSlide();
	}
	
	/**
	 *  @Event.MOUSE_LEAVE
	 */
	private function stage_mouseLeaveHandler(event:Event):void {
		stopSlide();
	}
	
	/**
	 *  @MouseEvent.MOUSE_UP
	 */
	private function stage_mouseUpHandler(event:MouseEvent):void {
		stopSlide();
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//	dataTipView
	//--------------------------------------
	
	protected var _dataTipView:Boolean = true;
	
	public function get dataTipView():Boolean {
		return _dataTipView;
	}
	
	public function set dataTipView(value:Boolean):void {
		if( value == _dataTipView )
			return;
		
		_dataTipView = value;
	}
	
	//--------------------------------------
	//	liveDragging
	//--------------------------------------
	
	protected var _liveDragging:Boolean = true;
	
	public function get liveDragging():Boolean {
		return _liveDragging;
	}
	
	public function set liveDragging(value:Boolean):void {
		if( _maximum == value )
			return;
		
		_liveDragging = value;
	}
	
	//--------------------------------------
	//	maximum
	//--------------------------------------
	
	private var maximumChanged:Boolean;
	
	protected var _maximum:Number = 50;
	
	public function get maximum():Number {
		return _maximum;
	}
	
	public function set maximum(value:Number):void {
		if( _maximum == value )
			return;
		
		_maximum = value;
		maximumChanged = true;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//	minimum
	//--------------------------------------
	
	private var minimumChanged:Boolean;
	
	protected var _minimum:Number = 0;
	
	public function get minimum():Number {
		return _minimum;
	}
	
	public function set minimum(value:Number):void {
		if( _minimum == value )
			return;
		
		_minimum = value;
		minimumChanged = true;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//	speed
	//--------------------------------------
	
	protected var _speed:Number = 0;
	
	public function get speed():Number {
		return _speed;
	}
	
	public function set speed(value:Number):void {
		if( _speed == value )
			return;
		
		_speed = value;
	}
	
	//--------------------------------------
	//	snapInterval
	//--------------------------------------
	
	protected var _snapInterval:Number = 1;
	
	public function get snapInterval():Number {
		return _snapInterval;
	}
	
	public function set snapInterval(value:Number):void {
		if( value == _snapInterval )
			return;
		
		_snapInterval = value;
	}
	
	//--------------------------------------
	//	value
	//--------------------------------------
	
	private var valueChanged:Boolean;
	
	protected var _value:Number;
	
	public function get value():Number {
		return _value;
	}
	
	public function set value(value:Number):void {
		_value = value;
		valueChanged = true;
		
		invalidateProperties();
	}
}

}