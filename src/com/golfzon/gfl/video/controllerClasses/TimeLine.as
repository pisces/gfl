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
	
import com.golfzon.gfl.controls.HSlider;
import com.golfzon.gfl.core.gz_internal;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

import gs.TweenMax;

use namespace gz_internal;
//--------------------------------------
//  Style
//--------------------------------------

/**
 *  썸 스킨
 * 	@default value com.golfzon.gfl.controls.sliderClasses.SliderThumb
 */
[Style(name="thumbStyleName", type="String", inherit="no")]

/**
 *  트렉 스킨
 * 	@default value com.golfzon.gfl.skins.Border
 */
[Style(name="trackStyleName", type="String", inherit="no")]

/**
 *	@Author				SH Jung
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.11.19
 *	@Modify
 *	@Description
 */	
public class TimeLine extends HSlider
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	private var bufferTrack:Sprite;
	
	/**
	 *	@Constructor
	 */
	public function TimeLine(){
		super();
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
		super.createChildren();
		
		bufferTrack = createBufferTrack();
		addChildAt(bufferTrack, getChildIndex(thumbInstance));
	}
	
	/**
	 * 	디스플레이 변경 사항에 대한 처리
	 */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		bufferTrack.x = trackInstance.x + 1;
		bufferTrack.y = trackInstance.y + 1;
	}
	
	//--------------------------------------------------------------------------
	//  Overriden : HSlider
	//--------------------------------------------------------------------------
	
	/**
	 *	value에 따른 thumbInstance의 포지션 변화
	 */
	override protected function thumbInstancePos(value:Number, change:Boolean = true):void {
		super.thumbInstancePos(value, change);
		
		var xPos:Number = trackInstance.width * ((value - _minimum) / (_maximum - _minimum));
		var YPos:Number = thumbInstance.y;
		
		TweenMax.killTweensOf(thumbInstance);
		TweenMax.to(thumbInstance, _speed, {x:xPos + (thumbInstance.height / 2)});
		
		if( _liveDragging && change )
			dispatchEvent(new Event(Event.CHANGE));
	}
	
	//--------------------------------------------------------------------------
	//  Public
	//--------------------------------------------------------------------------
	
	/**
	 *  버퍼링
	 */
	public function buffering(loaded:Number, total:Number):void {
		if( loaded == total && trackInstance.width == bufferTrack.width + 2 )
			return;
		
		var lp:Number = loaded / total
		bufferTrack.graphics.clear();
		bufferTrack.graphics.beginFill(0x637BAD);
		bufferTrack.graphics.drawRect(0, 0, (trackInstance.width - 2) * lp, 3);
		bufferTrack.graphics.endFill();
	}
	
	/**
	 *  단순히 thumb의 위치만 변경 (EVENT발생 안함) 
	 */
	public function currentTime(value:Number):void {
		thumbInstancePos(value, false);
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	/**
	 *	버퍼 트렉을 생성 한다.
	 */
	private function createBufferTrack():Sprite {
		var track:Sprite = new Sprite();
		track.mouseChildren = false;
		track.mouseEnabled = false;
		return track;
	}
}

}