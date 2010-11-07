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

package com.golfzon.gfl.chart.renderer
{

import com.golfzon.gfl.core.ComponentBase;
import com.golfzon.gfl.core.gz_internal;

import flash.display.Sprite;

use namespace gz_internal;

/**
 *	@Author				SH Jung
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.11.30
 *	@Modify
 *	@Description
 */
public class RendererBase extends ComponentBase implements IRenderer
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	@Constructor
	 */
	public function RendererBase() {
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Public
	//--------------------------------------------------------------------------
	
	/**
	 *  랜더링
	 */
	public function rendering(data:Class = null):Sprite {
		throw new Error("이 메소드는 구현이 필요한 추상 메소드입니다.");
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//	color
	//--------------------------------------
	
	gz_internal var color:uint = 0x29447E;
	
	public function set color(value:uint):void {
		if( gz_internal::color == value )
			return;
		
		gz_internal::color = value;
	}
	
	//--------------------------------------
	//	dotPitch
	//--------------------------------------
	
	gz_internal var dotPitch:Number;
	
	public function set dotPitch(value:Number):void {
		if( gz_internal::dotPitch == value )
			return;
		
		gz_internal::dotPitch = value;
	}
	
	//--------------------------------------
	//	size
	//--------------------------------------
	
	gz_internal var size:Number;
	
	public function set size(value:Number):void {
		if( gz_internal::size == value )
			return;
		
		gz_internal::size = value;
	}
	
	//--------------------------------------
	//	value
	//--------------------------------------
	
	gz_internal var value:Number;
	
	public function set value(value:Number):void {
		if( gz_internal::value == value )
			return;
		
		gz_internal::value = value;
	}
}

}