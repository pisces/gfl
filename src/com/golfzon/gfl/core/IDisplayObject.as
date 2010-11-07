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

package com.golfzon.gfl.core
{

import flash.display.DisplayObjectContainer;

/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.08.20
 *	@Modify
 *	@Description
 */
public interface IDisplayObject
{
	function get width():Number;
	function set width(value:Number):void;
	
	function get height():Number;
	function set height(value:Number):void;
	
	function get x():Number;
	function set x(value:Number):void;
	
	function get y():Number;
	function set y(value:Number):void;
}

}