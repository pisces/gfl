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
public class HSlider extends SliderBase
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	[Embed(source="/assets/GZSkin.swf", symbol="HSlider_trackSkin")]
	private var trackSkinClass:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="HSlider_trackDisabledSkin")]
	private var trackDisabledSkinClass:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="HSlider_thumbUpSkin")]
	private var thumbUpSkinClass:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="HSlider_thumbOverSkin")]
	private var thumbOverSkinClass:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="HSlider_thumbDownSkin")]
	private var thumbDownSkinClass:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="HSlider_thumbDisabledSkin")]
	private var thumbDisabledSkinClass:Class;
	
	/**
	 *	@Constructor
	 */
	public function HSlider() {
		super();
		
		_direction = SliderDirection.HORIZONTAL;
		width = 100;
		height = 60;
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