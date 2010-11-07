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
 
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.geom.Matrix;

/**
 *	@Author				KHKim
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.08.18
 *	@Modify
 *	@Description
 */
public class BitmapDataUtil
{
	/**
	 *	@Constructor
	 * 	Does not allowed to construct a instance.
	 */
	public function BitmapDataUtil() {
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
	 *	DisplayObject 객체를 원하는 좌표와 크기에 의해 비트맵으로 반환한다.
	 */
	public static function crop(
		displayer:DisplayObject, dx:Number, dy:Number, w:Number, h:Number,
		transparent:Boolean=true, color:uint=0xFFFFFFFF):BitmapData {
		var bitmapData:BitmapData = new BitmapData(w, h, transparent, color);
		var matrix:Matrix = new Matrix();
		matrix.translate(dx, dy);
		bitmapData.draw(displayer, matrix, null, null, null, true);
		return bitmapData;
	}
	
	/**
	 *	DisplayObject 객체를 원하는 크기에 의해 비트맵으로 반환한다.
	 */
	public static function generateByManual(
		displayer:DisplayObject, width:Number, height:Number,
		transparent:Boolean=true, color:uint=0xFFFFFFFF):BitmapData {
		var bitmapData:BitmapData = new BitmapData(width, height, transparent, color);
		bitmapData.draw(displayer, null, null, null, null, true);
		return bitmapData;
	}
	
	/**
	 *	DisplayObject 객체를  비트맵으로 반환한다.
	 */
	public static function generate(
		displayer:DisplayObject, transparent:Boolean=true, color:uint=0xFFFFFFFF):BitmapData {
		var bitmapData:BitmapData = new BitmapData(displayer.width, displayer.height, transparent, color);
		bitmapData.draw(displayer, null, null, null, null, true);
		return bitmapData;
	}

	/**
	 *	DisplayObject 객체를 원하는 크기의 비율계를 적용하여  비트맵으로 반환한다.
	 */
	public static function scale(
		displayer:DisplayObject, scaleX:Number, scaleY:Number,
		transparent:Boolean=true, color:uint=0xFFFFFFFF):BitmapData {
		var sx:Number = scaleX/100;
		var sy:Number = scaleY/100;
		var bitmapData:BitmapData = new BitmapData(displayer.width*sx, displayer.height*sy, transparent, color);
		var matrix:Matrix = new Matrix();
		matrix.scale(sx, sy);
		bitmapData.draw(displayer, matrix, null, null, null, true);
		return bitmapData;
	}
}

}