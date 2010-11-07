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
	
import com.golfzon.gfl.controls.scrollBarClasses.ScrollBarBase;
import com.golfzon.gfl.controls.scrollBarClasses.ScrollBarDirection;
import com.golfzon.gfl.core.gz_internal;
import com.golfzon.gfl.nullObject.NullHScrollBar;

use namespace gz_internal;

/**
 *	@Author				KHKim
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.09.21
 *	@Modify
 *	@Description
 * 	@includeExample		HScrollBarSample.as
 */
public class HScrollBar extends ScrollBarBase
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	[Embed(source="/assets/GZSkin.swf", symbol="HScrollBar_ScrollArrowDown_disabledSkin")]
	private var HScrollBar_DOWN_ARROW_DISABLED_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="HScrollBar_ScrollArrowDown_downSkin")]
	private var HScrollBar_DOWN_ARROW_DOWN_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="HScrollBar_ScrollArrowDown_overSkin")]
	private var HScrollBar_DOWN_ARROW_OVER_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="HScrollBar_ScrollArrowDown_upSkin")]
	private var HScrollBar_DOWN_ARROW_UP_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="HScrollBar_ScrollThumb_downSkin")]
	private var HScrollBar_THUMB_DOWN_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="HScrollBar_ScrollThumb_overSkin")]
	private var HScrollBar_THUMB_OVER_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="HScrollBar_ScrollThumb_upSkin")]
	private var HScrollBar_THUMB_UP_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="HScrollBar_ScrollTrack_disabledSkin")]
	private var HScrollBar_TRACK_DISABLED_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="HScrollBar_ScrollTrack_skin")]
	private var HScrollBar_TRACK_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="HScrollBar_ScrollArrowUp_disabledSkin")]
	private var HScrollBar_UP_ARROW_DISABLED_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="HScrollBar_ScrollArrowUp_downSkin")]
	private var HScrollBar_UP_ARROW_DOWN_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="HScrollBar_ScrollArrowUp_overSkin")]
	private var HScrollBar_UP_ARROW_OVER_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="HScrollBar_ScrollArrowUp_upSkin")]
	private var HScrollBar_UP_ARROW_UP_SKIN:Class;
	
	//--------------------------------------------------------------------------
	//
	//	Class variables
	//
	//--------------------------------------------------------------------------
	
	private static var nullInstance:NullHScrollBar;
	
	/**
	 *	@Constructor
	 */
	public function HScrollBar() {
		super();
		
		_direction = ScrollBarDirection.HORIZONTAL;
		width = 120;
		
		DOWN_ARROW_DISABLED_SKIN 		= HScrollBar_DOWN_ARROW_DISABLED_SKIN;
		DOWN_ARROW_DOWN_SKIN			= HScrollBar_DOWN_ARROW_DOWN_SKIN;
		DOWN_ARROW_OVER_SKIN 			= HScrollBar_DOWN_ARROW_OVER_SKIN;
		DOWN_ARROW_UP_SKIN 				= HScrollBar_DOWN_ARROW_UP_SKIN;
		THUMB_DOWN_SKIN					= HScrollBar_THUMB_DOWN_SKIN;
		THUMB_OVER_SKIN					= HScrollBar_THUMB_OVER_SKIN;
		THUMB_UP_SKIN					= HScrollBar_THUMB_UP_SKIN;
		TRACK_DISABLED_SKIN				= HScrollBar_TRACK_DISABLED_SKIN;
		TRACK_SKIN						= HScrollBar_TRACK_SKIN;
		UP_ARROW_DISABLED_SKIN			= HScrollBar_UP_ARROW_DISABLED_SKIN;
		UP_ARROW_DOWN_SKIN				= HScrollBar_UP_ARROW_DOWN_SKIN;
		UP_ARROW_OVER_SKIN				= HScrollBar_UP_ARROW_OVER_SKIN;
		UP_ARROW_UP_SKIN				= HScrollBar_UP_ARROW_UP_SKIN;
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
	 *	새로운 NullHScrollBar 인스턴스를 생성해 반환한다.
	 */
	public static function newNull():NullHScrollBar {
		if( nullInstance )	return nullInstance;
		return new NullHScrollBar();
	}
	
	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Overriden : ScrollBarBase
	//--------------------------------------------------------------------------
	
	/**
	 * 	컴퍼넌트의 기본 크기와 최소 크기를 설정한다.
	 */
	override protected function measure():void {
		super.measure();

		arrowSize = Math.max(downArrow.width, upArrow.width);
			
		if( !heightChanged )
			measureHeight = arrowSize;
		
		setActualSize(unscaledWidth, unscaledHeight);
	}
}

}