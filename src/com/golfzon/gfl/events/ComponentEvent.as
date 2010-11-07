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
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.08.20
 *	@Modify
 *	@Description
 */
public class ComponentEvent extends Event
{
	//--------------------------------------------------------------------------
	//
	//	Class constants
	//
	//--------------------------------------------------------------------------
	
	public static const CREATION_COMPLETE:String = "creationComplete";
	public static const CSS_INITIALIZED:String = "cssInitialized";
	public static const RESIZE:String = "resize";
	
	/**
	 *	@Constructor
	 */
	public function ComponentEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
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
	 *	ComponentEvent의 복사본을 생성해 반환한다.
	 */
	override public function clone():Event {
		return new ComponentEvent(type, bubbles, cancelable);
	}
}

}