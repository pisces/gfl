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
import com.golfzon.gfl.core.IInteractiveObject;
import com.golfzon.gfl.video.IVideoPlayer;

/**
 *	@Author				SH Jung
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.11.17
 *	@Modify				2010.03.11 by KHKim	/ 2010.08.10 rrobbie
 *	@Description
 */
public interface IVideoController extends IDisplayObject, IInteractiveObject
{
	function buffering(current:Number, total:Number):void;
	function reset():void;
	function setState(state:String):void;
	function updateTimeSeek(time:Number, duration:Number):void;
	
	function get player():IVideoPlayer;
	function set player(value:IVideoPlayer):void;
	
	function get seek():Number;
	function set seek(value:Number):void;
	
	function get volume():Number;
	function set volume(value:Number):void;
}

}