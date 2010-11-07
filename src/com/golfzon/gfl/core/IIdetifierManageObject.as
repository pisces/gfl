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

import flash.display.InteractiveObject;

/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.12.11
 *	@Modify
 *	@Description
 */
public interface IIdetifierManageObject extends IDisplayObject
{
	function get id():String;
	function set id(value:String):void;
	
	function get instanceName():String;
	
	function get uid():String;
}

}