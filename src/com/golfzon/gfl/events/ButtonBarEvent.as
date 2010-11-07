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

package com.golfzon.gfl.events
{
	
import flash.events.Event;

/**
 *	@Author				SH Jung
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.10.27
 *	@Modify
 *	@Description
 */
public class ButtonBarEvent extends Event
{
	//--------------------------------------------------------------------------
	//
	//	Class constants
	//
	//--------------------------------------------------------------------------
	
	public static const BUTTON_CLICK:String = "buttonClick";
	public static const BUTTON_ROLL_OVER:String = "buttonRollOver";
	
	/**
	 *	@Constructor
	 */
	public function ButtonBarEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false) {
		super(type, bubbles, cancelable);
	}
}
}