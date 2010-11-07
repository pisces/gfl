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

package com.golfzon.gfl.collection
{

/**
 *	@Author				KHKim
 *	@Version			1.0
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.05.06
 *	@Modify
 *	@Description
 */
public interface Iterator
{
	function hasNext():Boolean;
	
	function next():*;
	
	function hasPrev():Boolean;
	
	function prev():*;
	
	function reset():void;
}

}