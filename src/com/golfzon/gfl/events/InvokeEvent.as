////////////////////////////////////////////////////////////////////////////////
//
//  PISCES IS OPEN SOURCE PROVIDER
//  Copyright 2004-2009 PISCES
//  All Rights Reserved.
//
//  NOTICE: PISCES permits you to use, modify, and distribute this file
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
 *	@Date				2008.04.26
 *	@Modify				2009.02.10 by KHKim, 2009.08.18 by KHKim
 * 						2009.11.18 by KHKim
 *	@Description
 */
public class InvokeEvent extends Event
{
	//--------------------------------------------------------------------------
	//
	//	Constants
	//
	//--------------------------------------------------------------------------
	
	public static const INVOKE:String = "invoke";
	
	/**
	 *	@Contsructor
	 */
	public function InvokeEvent(type:String, status:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
		super(type, bubbles, cancelable);
		
		_status = status;
	}
	
	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Overriden : Event
	//--------------------------------------------------------------------------
	
	
	/**
	 *	Create a clone instance of InvokeEvent.
	 */
	override public function clone():Event {
		return new InvokeEvent(type, status, bubbles, cancelable);
	}

	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//	status
	//--------------------------------------
	
	private var _status:Object;
	
	public function get status():Object {
		return _status;
	}
}

}