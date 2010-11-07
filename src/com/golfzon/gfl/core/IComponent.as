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

import com.golfzon.gfl.managers.SystemManager;

import flash.display.InteractiveObject;

/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.08.20
 *	@Modify
 *	@Description
 */
public interface IComponent extends IDisplayObject, IIdetifierManageObject
{
	function initialize():void;
	function invalidateProperties():void;
	function invalidateDisplayList():void;
	function setActureSize(w:Number, h:Number):void;
	function getFocus():InteractiveObject
	function setFocus():void;
	
	function get percentWidth():Number;
	function set percentWidth(value:Number):void;
	
	function get percentHeight():Number;
	function set percentHeight(value:Number):void;
	
	function get systemManager():SystemManager;
	function set systemManager(value:SystemManager):void;
	
	function get tooltip():String;
	function set tooltip(value:String):void;
}

}