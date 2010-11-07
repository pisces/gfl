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
import flash.display.Sprite;
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
 * 	@includeExample		VSliderSample.as
 */	
public class VSlider extends SliderBase
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
    //--------------------------------------------------------------------------
    
	/**
	 *	@Constructor
	 */
	public function VSlider(){
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
    //--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------
    //  Overriden : SliderBase
    //--------------------------------------------------------------------------

    /**
     * 	컴퍼넌트의 기본 크기와 최소 크기를 설정한다.
     */
    override protected function measure():void {
    	super.measure();
    	
    	measureWidth = isNaN(measureWidth) ? thumbInstance.gz_internal::currentSkin.width : measureWidth;
    	measureHeight = isNaN(measureHeight) ? trackInstance.height : measureHeight;
    	
    	setActureSize(measureWidth, measureHeight);
    }
	
	/**
     * 	디스플레이 변경 사항에 대한 처리
     */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		thumbInstance.x = int((unscaledWidth - thumbInstance.width) / 2); 
		
		trackInstance.x = int((unscaledWidth - trackInstance.width) / 2);
		trackInstance.height = unscaledHeight;
		
		thumbInstancePos(_value, false);
	}
	
	//--------------------------------------------------------------------------
    //  Internal
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
				Border(border).width = 5;
				Border(border).height = isNaN(height) ? 100 : height;
			}
			return border;
		}
		return null;
    }
    
	/**
	 *	TODO : value에 따른 thumbInstance의 포지션 변화
	 */
    override protected function thumbInstancePos(value:Number, change:Boolean = true):void {
    	if( !dataTipInstance.visible && stage && _dataTipView && change ) {
    		if( stage.hasEventListener(MouseEvent.MOUSE_MOVE) )
    			dataTipInstance.visible = true;
    	}
    	
    	dataTipInstance.label = String(_value);
    	var xPos:Number = dataTipInstance.width * -1 + thumbInstance.x;
    	var YPos:Number = trackInstance.height - (trackInstance.height * ((value - _minimum) / (_maximum - _minimum)));
    	
    	TweenMax.killTweensOf(dataTipInstance);
    	TweenMax.killTweensOf(thumbInstance);
    	TweenMax.to(dataTipInstance, _speed, {x:xPos, y:YPos - (dataTipInstance.height / 2)});
    	TweenMax.to(thumbInstance, _speed, {y:YPos - (thumbInstance.height / 2)});
    	
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
		var pos:Number = mouseY;
		pos = pos > trackInstance.height ? trackInstance.height : pos;
		pos = pos < 0 ? 0 : pos;
		pos = trackInstance.height - pos;
		
		if( pos == 0 ) {
			temp = _minimum;
		} else if( pos == trackInstance.height ) {
			temp = _maximum;
		} else {
			temp = pos / ( trackInstance.height ) * (_maximum - _minimum) + _minimum;
			temp = temp >= _value ? temp - temp % _snapInterval : (int(temp / _snapInterval) + 1) * _snapInterval;
		}
		
		value = temp;
	}
}

}