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

package com.golfzon.gfl.display
{
	
import com.golfzon.gfl.utils.drawArcLine;

import flash.display.Shape;

/**
 *	@Author				KHKim
 *	@Version			1.0
 *	@Lanaguage			Action Script 3.0
 *	@Date				2010. 3. 29.
 *	@Modify
 *	@Description
 */
public class DashedShape extends Shape
{
	/**
	 *	@Constructor
	 */
	public function DashedShape() {
		super();
	}
	
	//--------------------------------------------------------------------------
	//	Public
	//--------------------------------------------------------------------------
	
	public function drawDashedCircleLine(
		radius:Number, arcAngle:Number=2, dashedLineColor:uint=0xFFFFFF,
		dashedLineThickness:Number=1, dashedLineAlpha:Number=1):void {
		for( var i:Number=0; i<360/(arcAngle*2); i++ ){
			drawArcLine(graphics, radius, i*(arcAngle*2), arcAngle, dashedLineThickness, dashedLineColor, dashedLineAlpha);
		}
	}
}
	
}