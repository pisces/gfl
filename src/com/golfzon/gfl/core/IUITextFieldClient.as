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

import com.golfzon.gfl.controls.UITextField;

import flash.events.IEventDispatcher;

/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.10.20
 *	@Modify
 *	@Description
 */
public interface IUITextFieldClient extends IEventDispatcher
{
	function getTextField():UITextField;
	
	function get textWidth():Number;
	
	function get textHeight():Number;
}

}