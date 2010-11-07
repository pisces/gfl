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

package com.golfzon.gfl.controls
{
	
import com.golfzon.gfl.controls.sliderClasses.SliderBase;
import com.golfzon.gfl.core.gz_internal;
import com.golfzon.gfl.skins.Border;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.MouseEvent;

import gs.TweenMax;

use namespace gz_internal;

//--------------------------------------
//  Style
//--------------------------------------

/**
 *	@Author				SH Jung
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.11.13
 *	@Modify
 *	@Description
 * 	@includeExample		HSliderSample.as
 */	
public class HSlider extends SliderBase
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
    //--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
    //--------------------------------------------------------------------------
	
    //--------------------------------------------------------------------------
    //  Overriden : SliderBase
    //--------------------------------------------------------------------------

	/**
     * 	보더 생성
     */
   override protected function createBorder():DisplayObject {
		var borderClass:Class = replaceNullorUndefined(getStyle(StyleProp.TRACK_SKIN), Border);
		if( borderClass ) {
			var border:DisplayObject = createSkinBy(borderClass);
			
			if( border is Border ) {
				Border(border).styleName = getCSSStyleDeclaration();
				Border(border).width = isNaN(width) ? 100 : width;
				Border(border).height = 5;
			}
			return border;
		}
		return null;
    }
    
    /**
     * 	컴퍼넌트의 기본 크기와 최소 크기를 설정한다.
     */
    override protected function measure():void {
    	super.measure();
    	
    	measureWidth = isNaN(measureWidth) ? trackInstance.width : measureWidth;
    	measureHeight = isNaN(measureHeight) ? thumbInstance.width : measureHeight;
    	
    	setActureSize(measureWidth, measureHeight);
    }
	
	/**
     * 	디스플레이 변경 사항에 대한 처리
     */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		thumbInstance.rotation = 90;
		thumbInstance.y = int((unscaledHeight - thumbInstance.width) / 2);
		
		trackInstance.y = int((unscaledHeight - trackInstance.height) / 2);
		trackInstance.width = unscaledWidth;
		
		thumbInstancePos(_value, false);
	}
	
	//--------------------------------------------------------------------------
    //  Internal
    //--------------------------------------------------------------------------

	/**
	 *	TODO : value에 따른 thumbInstance의 포지션 변화
	 */
    override protected function thumbInstancePos(value:Number, change:Boolean = true):void {
    	if( !dataTipInstance.visible && stage && _dataTipView && change ) {
    		if( stage.hasEventListener(MouseEvent.MOUSE_MOVE) )
    			dataTipInstance.visible = true;
    	}
    	
    	dataTipInstance.label = String(_value);
    	var xPos:Number = trackInstance.width * ((value - _minimum) / (_maximum - _minimum));
    	var YPos:Number = thumbInstance.y;
    	
    	TweenMax.killTweensOf(dataTipInstance);
    	TweenMax.killTweensOf(thumbInstance);
    	TweenMax.to(dataTipInstance, _speed, {x:xPos - (dataTipInstance.width / 2), y:YPos - dataTipInstance.height});
    	TweenMax.to(thumbInstance, _speed, {x:xPos + (thumbInstance.height / 2)});
    	
    	if( _liveDragging && change )
    		dispatchEvent(new Event(Event.CHANGE));
    }
    
	//--------------------------------------------------------------------------
	//
	//	Event handlers
	//
    //--------------------------------------------------------------------------
	
	/**
	 *  TODO : 마우스 위치에 따른 value계산
	 */
	override protected function stage_mouseMoveHander(event:MouseEvent):void {
		var temp:Number;
		var pos:Number = mouseX;
		pos = pos > trackInstance.width ? trackInstance.width : pos;
		pos = pos < 0 ? 0 : pos;
		
		if( pos == 0 ) {
			temp = _minimum;
		} else if( pos == trackInstance.width ) {
			temp = _maximum;
		} else {
			temp = pos / ( trackInstance.width ) * (_maximum - _minimum) + _minimum;
			temp = temp >= _value ? temp - temp % _snapInterval : (int(temp / _snapInterval) + 1) * _snapInterval;
		}
		
		value = temp;
	}
}

}