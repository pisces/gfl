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

package com.golfzon.gfl.styles
{

import com.golfzon.gfl.collection.Hashtable;

import flash.events.IEventDispatcher;

/**
 *	@Author				KHKim
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.08.20
 *	@Modify
 *	@Description
 */
public interface IStyleClient extends IEventDispatcher
{
	function getCSSStyleDeclaration():CSSStyleDeclaration;
	function setCSSStyleDeclaration(declaration:CSSStyleDeclaration):void;
	function getInheritStyleTable():Hashtable;
	function getStyle(styleProp:String):*;
	function setStyle(styleProp:String, value:*):void;
	function registerInstance():void;
	function styleChanged(styleProp:String):void;
	
	function get styleName():Object;
	function set styleName(value:Object):void;
}

}