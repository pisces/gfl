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

package com.golfzon.gfl.utils
{
	
/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.08.27
 *	@Modify
 *	@Description
 */
public class MathUtil
{
	/**
	 *	@Constructor
	 * 	Does not allowed to construct a instance.
	 */
	public function MathUtil() {
	   throw new Error("Error: Instantiation failed: This class cannot instancing!");
	}
	
	//--------------------------------------------------------------------------
	//
	//	Class methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Public
	//--------------------------------------------------------------------------
	
	public static function random(max:int):int {
		return Math.floor(Math.random()*10000)%max + 1;
	}
	
	public static function radians(degrees:Number):Number {
		return degrees * Math.PI/180;
	}

	public static function degrees(radians:Number):Number {
		return radians * 180/Math.PI;
	}
		
	
}

}