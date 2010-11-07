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
 *	@Author				KHKim
 *	@Version			1.0
 *	@Lanaguage			Action Script 3.0
 *	@Date				2010.03.15
 *	@Modify
 *	@Description
 */
public class SliderEvent extends Event
{
	//--------------------------------------------------------------------------
	//
	//	Class constants
	//
	//--------------------------------------------------------------------------
	
	public static const CHANGE:String = "change";
	public static const THUMB_DRAG:String = "thumbDrag";
	public static const THUMB_PRESS:String = "thumbPress";
	public static const THUMB_RELEASE:String = "thumbRelease";
	
	/**
	 *	@Constructor
	 */
	public function SliderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
		super(type, bubbles, cancelable);
	}
	
	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Overriden : Event
	//--------------------------------------------------------------------------
	
	/**
	 *	SliderEvent의 복사본을 생성해 반환한다.
	 */
	override public function clone():Event {
		return new SliderEvent(type, bubbles, cancelable);
	}
}

}