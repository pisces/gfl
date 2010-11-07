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

package com.golfzon.gfl.controls.listClasses
{
	
import com.golfzon.gfl.core.IDisplayObject;

import flash.display.DisplayObject;
	
/**
 *	@Author				KHKim
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.10.01
 *	@Modify
 *	@Description
 */
public interface IListShape extends IDisplayObject
{
	function clear():void;
	
	function drawBy(dependentTarget:DisplayObject, color:uint, usable:Boolean=true):void;

	function drawWithTransition(dependentTarget:DisplayObject, color:uint, duration:Number, usable:Boolean=true):void;
}

}