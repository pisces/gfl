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
	
import com.golfzon.gfl.controls.sliderClasses.SliderBase;
import com.golfzon.gfl.controls.sliderClasses.SliderDirection;
import com.golfzon.gfl.core.gz_internal;
import com.golfzon.gfl.utils.MathUtil;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.geom.Point;

use namespace gz_internal;

/**
 *	@Author				KHKim
 *	@Version			1.0
 *	@Lanaguage			Action Script 3.0
 *	@Date				2010.03.16
 *	@Modify
 *	@Description
 */
public class VideoSeekBar extends SliderBase
{
	//--------------------------------------------------------------------------
	//
	//	Instance constants
	//
	//--------------------------------------------------------------------------
	
	private const HIGHLIGHT_SKIN_STYLE_PROP:String = "highlightSkin";
	private const LOAD_PROGRESS_SKIN_STYLE_PROP:String = "loadProgressSkin";
	
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	[Embed(source="/assets/GZSkin.swf", symbol="BaseSeekBar_thumbUpSkin")]
	private var thumbUpSkinClass:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="BaseSeekBar_thumbOverSkin")]
	private var thumbOverSkinClass:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="BaseSeekBar_thumbDownSkin")]
	private var thumbDownSkinClass:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="BaseSeekBar_thumbDisabledSkin")]
	private var thumbDisabledSkinClass:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="BaseSeekBar_highlightSkin")]
	private var highlightSkinClass:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="BaseSeekBar_loadProgressSkin")]
	private var loadProgressSkinClass:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="BaseSeekBar_trackSkin")]
	private var trackSkinClass:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="BaseSeekBar_trackDisabledSkin")]
	private var trackDisabledSkinClass:Class;
	
	protected var highlight:DisplayObject;	
	protected var loadProgressBar:DisplayObject;
	
	/**
	 *	@Constructor
	 */
	public function VideoSeekBar() {
		super();
		
		_direction = SliderDirection.HORIZONTAL;
		width = 200;
		height = 20;
		tickInterval = 0.1;
		dataTipFormatFunction = convertToTime;
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
	 *	@realization
	 */
	override protected function setDefaultSkins():void {
		trackSkin = trackSkinClass;
		trackDisabledSkin = trackDisabledSkinClass;
		thumbUpSkin = thumbUpSkinClass;
		thumbOverSkin = thumbOverSkinClass;
		thumbDownSkin = thumbDownSkinClass;
		thumbDisabledSkin = thumbDisabledSkinClass;
	}
	
	/**
	 * 	자식 객체 생성 및 추가
	 */
	override protected function createChildren():void {
		super.createChildren();

		loadProgressBar = createSkinObject(LOAD_PROGRESS_SKIN_STYLE_PROP, loadProgressSkinClass);
		highlight = createSkinObject(HIGHLIGHT_SKIN_STYLE_PROP, highlightSkinClass);
		
		highlight.width = loadProgressBar.width = 0;

		thumb.addEventListener("xChanged", thumb_xChangeHandler, false, 0, true);
	}
	
	/**
	 *	스타일 프로퍼티로 값을 설정한다.
	 */
	override public function styleChanged(styleProp:String):void {
		super.styleChanged(styleProp);
		
		switch( styleProp ) {
			case HIGHLIGHT_SKIN_STYLE_PROP:
				removeSkinObject(highlight);
				highlight = createSkinObject(styleProp);
				break;
				
			case LOAD_PROGRESS_SKIN_STYLE_PROP:
				removeSkinObject(loadProgressBar);
				loadProgressBar = createSkinObject(styleProp);
				break;
		}
	}
	
	/**
	 * 	디스플레이 변경 사항에 대한 처리
	 */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		if( highlight ) {
			highlight.x = track.x;
			highlight.y = track.y;
		}
		
		if( loadProgressBar ) {
			loadProgressBar.x = track.x;
			loadProgressBar.y = track.y;
		}
	}
	
	override protected function moveToolTip():void {
		if( toolTipInstance ) {
			var point:Point = localToGlobal(new Point(x + thumb.x + thumb.width/2 + 5, thumb.y - toolTipInstance.height - 5));
			toolTipInstance.x = point.x;
			toolTipInstance.y = point.y;
		}
	}
	
	//--------------------------------------------------------------------------
	//  Public
	//--------------------------------------------------------------------------
	
	/**
	 * 	진행률을 표시한다.
	 */
	public function setProgress(current:Number, total:Number):void {
		if( loadProgressBar )
			loadProgressBar.width = track.width * (1 * current / total);
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	private function convertToTime(value:Number):String {
		return MathUtil.decimalToSexagesimal(value);
	}
	
	private function createSkinObject(styleProp:String, defaultDefinition:Class=null):DisplayObject {
		var Definition:Class = replaceNullorUndefined(getStyle(styleProp), defaultDefinition);
		if( Definition ) {
			var object:DisplayObject = DisplayObject(new Definition());
			addChild(object);
			setChildIndex(thumb, numChildren - 1);
			return object;
		}
		return null;
	}
	
	private function removeSkinObject(object:DisplayObject):void {
		if( object && contains(object) )
			removeChild(object);
	}
	
	//--------------------------------------------------------------------------
	//
	//	Event handlers
	//
	//--------------------------------------------------------------------------

	private function thumb_xChangeHandler(event:Event):void {
		highlight.width = thumb.x - thumb.width/2;
	}
}

}