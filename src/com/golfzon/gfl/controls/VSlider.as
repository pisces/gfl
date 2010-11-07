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
import com.golfzon.gfl.controls.sliderClasses.SliderDirection;
import com.golfzon.gfl.core.gz_internal;

import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

use namespace gz_internal;

/**
 *	@Author				KHKim
 *	@Version			1.0
 *	@Lanaguage			Action Script 3.0
 *	@Date				2010.03.15
 *	@Modify
 *	@Description
 * 	@includeExample
 */	
public class VSlider extends SliderBase
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	[Embed(source="/assets/GZSkin.swf", symbol="VSlider_trackSkin")]
	private var trackSkinClass:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="VSlider_trackDisabledSkin")]
	private var trackDisabledSkinClass:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="VSlider_thumbUpSkin")]
	private var thumbUpSkinClass:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="VSlider_thumbOverSkin")]
	private var thumbOverSkinClass:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="VSlider_thumbDownSkin")]
	private var thumbDownSkinClass:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="VSlider_thumbDisabledSkin")]
	private var thumbDisabledSkinClass:Class;
	
	/**
	 *	@Constructor
	 */
	public function VSlider() {
		super();
		
		_direction = SliderDirection.VERTICAL;
		width = 60;
		height = 100;
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
}

}