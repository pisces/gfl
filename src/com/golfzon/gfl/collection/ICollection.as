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
 *	@Author				KH Kim
 *	@Version			1.0
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.05.06
 *	@Modify
 *	@Description
 */
public interface ICollection
{
	function clear():void;
	
	function add(item:*):Boolean;
	
	function remove(item:*):Boolean;
	
	function contains(item:*):Boolean;
	
	function getItemAt(idx:int):*;
	
	function getItemIndex(item:*):int;
	
	function get isEmpty():Boolean;
	
	function get length():int;
}

}