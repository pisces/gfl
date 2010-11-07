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
	
import flash.display.Graphics;

/**
 *	@Author				KHKim
 *	@Version			1.0
 *	@Lanaguage			Action Script 3.0
 *	@Date				2010. 3. 29.
 *	@Modify
 *	@Description
 */
public function drawArcLine(
	graphics:Graphics, radius:Number, startAngle:Number,
	arcAngle:Number, lineThickness:Number, lineColor:uint, alpha:Number=1):void {
	var yRadius:Number = radius;
	var segAngle:Number, theta:Number, angle:Number, angleMid:Number, segs:Number, bx:Number, by:Number, cx:Number, cy:Number;
	
	segs = Math.ceil(Math.abs(arcAngle)/45);
	segAngle = arcAngle/segs;
	
	theta = -(segAngle/180)*Math.PI;
	angle = -(startAngle/180)*Math.PI;
	
	angleMid = angle-(theta/2);
	bx = Math.cos(angle)*radius;
	by = Math.sin(angle)*yRadius;
	
	with( graphics ){
		lineStyle(lineThickness, lineColor, alpha);
		moveTo(bx, by);
	}
	
	if( segs > 0 ) {
		for (var i:int = 0; i<segs; i++) { 
			angle += theta;
			angleMid = angle-(theta/2);
			bx = Math.cos(angle)*radius;
			by = Math.sin(angle)*yRadius;
			cx = Math.cos(angleMid)*(radius/Math.cos(theta/2));
			cy = Math.sin(angleMid)*(yRadius/Math.cos(theta/2));
			graphics.curveTo(cx, cy, bx, by);
		}
	}
}

}