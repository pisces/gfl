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

package com.golfzon.gfl.video.controllerClasses
{

import com.golfzon.gfl.core.IDisplayObject;

/**
 *	@Author				SH Jung
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.11.17
 *	@Modify
 *	@Description
 */
public interface IVideoController
{
	function buffering(loaded:Number, total:Number):void;
	function currentTime(time:Number):void;
	function reSet():void;
	
	function get seek():Number;
	function set totalTime(time:Number):void;
	function get volume():Number;
	function set volume(value:Number):void;
}

}