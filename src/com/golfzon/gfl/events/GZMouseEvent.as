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
	
import flash.display.InteractiveObject;
import flash.events.MouseEvent;

/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.08.20
 *	@Modify
 *	@Description
 */
public class GZMouseEvent extends MouseEvent
{
    //--------------------------------------------------------------------------
	//
	//	Class constants
	//
    //--------------------------------------------------------------------------
	
	public static const KEEP_MOUSE_PRESS:String = "mousePress";
	
	/**
	 *	@Constructor
	 */
	public function GZMouseEvent(
		type:String, bubbles:Boolean=true, cancelable:Boolean=false,
		localX:Number=NaN, localY:Number=NaN, relatedObject:InteractiveObject=null,
		ctrlKey:Boolean=false, altKey:Boolean=false, shiftKey:Boolean=false, buttonDown:Boolean=false, delta:int=0) {
		super(type, bubbles, cancelable, localX, localY, relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta);
	}
}

}