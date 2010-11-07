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
 *	@Author				KHKim
 *	@Version			1.2 beta
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
		
	/**
	 *	10진법의 자연수를 60진법으로 변환 한다.
	 */
	public static function decimalToSexagesimal(value:uint):String {
		var min:String = String(uint(value / 60));
		var sec:String = String(uint(value % 60));
		
		if( min.length == 1 )	min = "0" + min;
		if( sec.length == 1 )	sec = "0" + sec;
		if( uint(min) > 59 )	min = decimalToSexagesimal(uint(min));
		
		return min + ":" + sec;
	}
	
	/**
	 *	val1가 val2의 몇 승인지 반환한다.
	 */
	public static function log2(val1:Number, val2:Number):uint {
		var v:Number = val1;
		var n:uint = 0;
		while (v >= val2)
		{
			v /= 2;
			n++;
		}
		return n;
	}
	
	public static function random(max:int):int {
		return Math.floor(Math.random()*10000)%max + 1;
	}
	
	public static function radians(degrees:Number):Number {
		return degrees * Math.PI/180;
	}

	public static function degrees(radians:Number):Number {
		return radians * 180/Math.PI;
	}
	
	public static function meterToKilomter(value:Number):Number {
		return value * 0.001;
	}
	
	public static function meterToMile(value:Number):Number {
		return value * 0.000621;
	}
	
	public static function cutSecondPosOfPrime(value:Number):Number {
		var split:Array = value.toString().split(".");
		return split.length > 1 ? Number(split[0] + "." + split[1].substr(0, 2)) : split[0];
	}
}

}