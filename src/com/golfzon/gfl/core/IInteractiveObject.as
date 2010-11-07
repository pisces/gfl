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

/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.08.25
 *	@Modify
 *	@Description
 */
public interface IInteractiveObject
{
	function get doubleClickEnabled():Boolean;
	function set doubleClickEnabled(value:Boolean):void;
	
	function get enabled():Boolean;
	function set enabled(value:Boolean):void;
}

}