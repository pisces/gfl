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

import com.golfzon.gfl.controls.VSlider;
import com.golfzon.gfl.core.BorderBasedComponent;
import com.golfzon.gfl.events.SliderEvent;
import com.golfzon.gfl.styles.StyleProp;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *	슬라이더의 내부에서 value 변경되면 송출한다.
 */
[Event(name="change", type="com.golfzon.gfl.events.SliderEvent")]

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *	슬라이더의 스타일명
 *	@default value none
 */
[Style(name="sliderStyleName", type="String", inherit="no")]

/**
 *	@Author				KHKim
 *	@Version			1.0
 *	@Lanaguage			Action Script 3.0
 *	@Date				2010.03.16
 *	@Modify
 *	@Description
 */
public class VideoVolumeBar extends BorderBasedComponent
{
	//--------------------------------------------------------------------------
	//
	//	Instance constants
	//
	//--------------------------------------------------------------------------
	
	private const SLIDER_STYLE_NAME:String = "sliderStyleName";
	
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	[Embed(source="/assets/GZSkin.swf", symbol="VideoController_borderSkin")]
	private var borderSkin:Class;
	
	private var slider:VSlider;
	
	/**
	 *	@Constructor
	 */
	public function VideoVolumeBar() {
		super();
		
		width = 18;
		height = 70;
				
		setStyle(StyleProp.BORDER_SKIN, borderSkin);
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
	 * 	프로퍼티 변경 사항에 대한 처리
	 */
	override protected function commitProperties():void {
		super.commitProperties();
		
		if( valueChanged ) {
			valueChanged = false;
			slider.value = _value;
		}
	}
	
	/**
	 * 	자식 객체 생성 및 추가
	 */
	override protected function createChildren():void {
		super.createChildren();
		
		slider = new VSlider();
		slider.buttonMode = true;
		slider.dataTipFormatFunction = convertToPercentage;
		slider.snapInterval = 1;
		slider.tickInterval = 0;
		slider.value = _value;
		slider.styleName = getStyle(SLIDER_STYLE_NAME);
		
		slider.addEventListener(SliderEvent.CHANGE, slider_changeHandler, false, 0, true);
		addChild(slider);
	}
	
	/**
	 *	enabled에 따른 구현
	 */
	override protected function setStateToChangeEnabled():void {
		super.setStateToChangeEnabled();
		
		slider.enabled = enabled;
	}
	
	/**
	 *	스타일 프로퍼티로 값을 설정한다.
	 */
	override public function styleChanged(styleProp:String):void {
		super.styleChanged(styleProp);
		
		switch( styleProp ) {
			case SLIDER_STYLE_NAME:
				slider.styleName = getStyle(SLIDER_STYLE_NAME);
				break;
		}
	}
	
	/**
	 * 	디스플레이 변경사항에 대한 처리
	 */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		slider.width = unscaledWidth;
		slider.height = unscaledHeight - 10;
		slider.y = 5;
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	private function convertToPercentage(value:Number):String {
		return value.toString() + "%";
	}
	
	//--------------------------------------------------------------------------
	//
	//	Event handlers
	//
	//--------------------------------------------------------------------------
	
	private function slider_changeHandler(event:SliderEvent):void {
		_value = slider.value;
		dispatchEvent(event.clone());
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//	value
	//--------------------------------------
	
	private var valueChanged:Boolean;
	
	private var _value:Number = 0;
	
	public function get value():Number {
		return _value;
	}
	
	public function set value(v:Number):void {
		if( v == _value ) 
			return;
		
		_value = v;
		valueChanged = true;
		
		invalidateDisplayList();
	}
}

}