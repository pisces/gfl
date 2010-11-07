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
 * 	@includeExample		HSliderSample.as
 */	
public class HSlider extends SliderBase
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	@Constructor
	 */
	public function HSlider(){
		super();
		
		width = 100;
		height = 15;
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
		
		if( trackHighlight ) {
			trackHighlightMask.x = trackHighlight.x = trackInstance.x;
			trackHighlightMask.y = trackHighlight.y = trackInstance.y;
		}
		
		thumbInstancePos(_value, false);
	}
	
	//--------------------------------------------------------------------------
	//  Overriden : SliderBase
	//--------------------------------------------------------------------------

	/**
	 * 	트렉 생성
	 */
   override protected function createTrack():DisplayObject {
		var trackClass:Class = replaceNullorUndefined(getStyle(StyleProp.TRACK_SKIN), Border);
		if( trackClass ) {
			var track:DisplayObject = createSkinBy(trackClass);
			
			if( track is Border ) {
				Border(track).styleName = getCSSStyleDeclaration();
				Border(track).width = isNaN(width) ? 100 : width;
				Border(track).height = 5;
			}
			return track;
		}
		return null;
	}
	
	/**
	 * 	하이라이트 생성
	 */
   override protected function createHighlight():DisplayObject {
		var highlightClass:Class = replaceNullorUndefined(getStyle(StyleProp.TRACK_HIGHLIGHT_SKIN), Sprite);
		if( highlightClass ) {
			var highlight:DisplayObject = createSkinBy(highlightClass);
			Sprite(highlight).mouseChildren = false;
			Sprite(highlight).mouseEnabled = false;
			
			if( !getStyle(StyleProp.TRACK_HIGHLIGHT_SKIN) ) {
				Sprite(highlight).graphics.beginFill(getStyle(StyleProp.TRACK_HIGHLIGHT_COLOR));
				Sprite(highlight).graphics.drawRect(1, 1, isNaN(width) ? 100 - 2: width - 2, 5 - 2);
				Sprite(highlight).graphics.endFill();
			}
			return highlight;
		}
		return null;
	}
	
	/**
	 * 	트렉 마스크 생성
	 */
	override protected function createHighlightMask():Sprite {
		var mask:Sprite = new Sprite();
		mask.graphics.beginFill(0x000000);
		mask.graphics.drawRect(0, 0, isNaN(width) ? 100 : width, isNaN(height) ? 100 : height);
		mask.graphics.endFill();
		mask.mouseChildren = false;
		mask.mouseEnabled = false;
		return mask;
	}
	
	/**
	 *	value에 따른 thumbInstance의 포지션 변화
	 */
	override protected function thumbInstancePos(value:Number, change:Boolean = true):void {
		super.thumbInstancePos(value, change);
		
		var xPos:Number = trackInstance.width * ((value - _minimum) / (_maximum - _minimum));
		var YPos:Number = thumbInstance.y;
		
		TweenMax.killTweensOf(thumbInstance);
		TweenMax.to(thumbInstance, _speed, {x:xPos + (thumbInstance.height / 2)});
		
		if( trackHighlight ) {
			TweenMax.killTweensOf(trackHighlightMask);
			TweenMax.to(trackHighlightMask, _speed, {width:xPos});
		}
		
		if( _liveDragging && change )
			dispatchEvent(new Event(Event.CHANGE));
	}
	
	//--------------------------------------------------------------------------
	//
	//	Event handlers
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  마우스 위치에 따른 value계산
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