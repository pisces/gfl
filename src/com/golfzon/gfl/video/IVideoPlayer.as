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

package com.golfzon.gfl.video
{

import com.golfzon.gfl.core.IDisplayObject;
import com.golfzon.gfl.video.controllerClasses.IVideoController;

/**
 *	@Author				KHKim
 *	@Version			1.0
 *	@Lanaguage			Action Script 3.0
 *	@Date				2010.03.16
 *	@Modify
 *	@Description
 */
public interface IVideoPlayer extends IDisplayObject
{
	function pause():Boolean;
	function play():Boolean;
	function seek(offset:Number):Boolean;
	function stop():Boolean;
	function setDisplayState(state:String):void;
	
	function get controller():IVideoController;
	function set controller(value:IVideoController):void;
	
	function get currentState():String;
	
	function get time():Number;
	
	function get volume():Number;
	function set volume(value:Number):void;
	
	function get mode():int;
	function set mode(value:int):void;		
}

}