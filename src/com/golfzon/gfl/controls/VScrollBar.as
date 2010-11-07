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
import com.golfzon.gfl.nullObject.NullVScrollBar;

import flash.events.MouseEvent;

use namespace gz_internal;

/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.09.22
 *	@Modify
 *	@Description
 * 	@includeExample		VScrollBarSample.as
 */
public class VScrollBar extends ScrollBarBase
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	[Embed(source="/assets/GZSkin.swf", symbol="VScrollBar_ScrollArrowDown_disabledSkin")]
	private var VScrollBar_DOWN_ARROW_DISABLED_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="VScrollBar_ScrollArrowDown_downSkin")]
	private var VScrollBar_DOWN_ARROW_DOWN_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="VScrollBar_ScrollArrowDown_overSkin")]
	private var VScrollBar_DOWN_ARROW_OVER_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="VScrollBar_ScrollArrowDown_upSkin")]
	private var VScrollBar_DOWN_ARROW_UP_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="VScrollBar_ScrollThumb_downSkin")]
	private var VScrollBar_THUMB_DOWN_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="VScrollBar_ScrollThumb_overSkin")]
	private var VScrollBar_THUMB_OVER_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="VScrollBar_ScrollThumb_upSkin")]
	private var VScrollBar_THUMB_UP_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="VScrollBar_ScrollTrack_disabledSkin")]
	private var VScrollBar_TRACK_DISABLED_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="VScrollBar_ScrollTrack_skin")]
	private var VScrollBar_TRACK_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="VScrollBar_ScrollArrowUp_disabledSkin")]
	private var VScrollBar_UP_ARROW_DISABLED_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="VScrollBar_ScrollArrowUp_downSkin")]
	private var VScrollBar_UP_ARROW_DOWN_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="VScrollBar_ScrollArrowUp_overSkin")]
	private var VScrollBar_UP_ARROW_OVER_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="VScrollBar_ScrollArrowUp_upSkin")]
	private var VScrollBar_UP_ARROW_UP_SKIN:Class;
	
	//--------------------------------------------------------------------------
	//
	//	Class variables
	//
	//--------------------------------------------------------------------------
	
	private static var nullInstance:NullVScrollBar;
	
	/**
	 *	@Constructor
	 */
	public function VScrollBar() {
		super();
		
		_direction = ScrollBarDirection.VERTICAL;
		height = 200;
		
		DOWN_ARROW_DISABLED_SKIN		= VScrollBar_DOWN_ARROW_DISABLED_SKIN;
		DOWN_ARROW_DOWN_SKIN			= VScrollBar_DOWN_ARROW_DOWN_SKIN;
		DOWN_ARROW_OVER_SKIN			= VScrollBar_DOWN_ARROW_OVER_SKIN;
		DOWN_ARROW_UP_SKIN				= VScrollBar_DOWN_ARROW_UP_SKIN;
		THUMB_DOWN_SKIN					= VScrollBar_THUMB_DOWN_SKIN;
		THUMB_OVER_SKIN					= VScrollBar_THUMB_OVER_SKIN;
		THUMB_UP_SKIN					= VScrollBar_THUMB_UP_SKIN;
		TRACK_DISABLED_SKIN				= VScrollBar_TRACK_DISABLED_SKIN;
		TRACK_SKIN						= VScrollBar_TRACK_SKIN;
		UP_ARROW_DISABLED_SKIN			= VScrollBar_UP_ARROW_DISABLED_SKIN;
		UP_ARROW_DOWN_SKIN				= VScrollBar_UP_ARROW_DOWN_SKIN;
		UP_ARROW_OVER_SKIN				= VScrollBar_UP_ARROW_OVER_SKIN;
		UP_ARROW_UP_SKIN				= VScrollBar_UP_ARROW_UP_SKIN;
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
	 *	새로운 NullVScrollBar 인스턴스를 생성해 반환한다.
	 */
	public static function newNull():NullVScrollBar {
		if( nullInstance )	return nullInstance;
		return new NullVScrollBar();
	}
	
	/**
	 * 	컴퍼넌트의 기본 크기와 최소 크기를 설정한다.
	 */
	override protected function measure():void {
		super.measure();

		arrowSize = Math.max(downArrow.height, upArrow.height);
			
		if( !widthChanged )
			measureWidth = arrowSize;
		
		setActureSize(unscaledWidth, unscaledHeight);
	}
}

}