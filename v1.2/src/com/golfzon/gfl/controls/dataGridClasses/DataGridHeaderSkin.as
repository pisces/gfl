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

package com.golfzon.gfl.controls.dataGridClasses
{
	
import com.golfzon.gfl.core.ComponentBase;
import com.golfzon.gfl.skins.ProgrammaticSkin;

import flash.display.GradientType;
import flash.display.SpreadMethod;
import flash.geom.Matrix;

/**
 *	@Author				KHKim
 *	@Version			1.0
 *	@Lanaguage			Action Script 3.0
 *	@Date				2010. 4. 15.
 *	@Modify
 *	@Description
 */
public class DataGridHeaderSkin extends ProgrammaticSkin
{
	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//
	//  Class variables
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//
	//  Instance constants
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//
	//  Instance variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	@Constructor
	 */
	public function DataGridHeaderSkin() {
		super();
	}
	
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		if( invalidSize() )
			return;
		
		var alphas:Array = [1, 1];
		var colors:Array = [0xFFFFFF, 0xE1E1E1];
		var fillType:String = GradientType.LINEAR;
		var matrix:Matrix = new Matrix();
		var spreadMethod:String = SpreadMethod.PAD;
		var ratios:Array = [0, 255];
		
		graphics.clear();
		matrix.createGradientBox(unscaledWidth, unscaledHeight, Math.PI/2, 0, 0);
		graphics.beginGradientFill(fillType, colors, alphas, ratios, matrix, spreadMethod);
		graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
		graphics.endFill();
	}
}
	
}