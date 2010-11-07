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
public class FaultEvent extends Event
{
	//--------------------------------------------------------------------------
	//
	//	Class constants
	//
	//--------------------------------------------------------------------------
	
	public static const FAULT:String = "fault";
	
	/**
	 *	@Contsructor
	 */
	public function FaultEvent(type:String, message:String=null, bubbles:Boolean=false, cancelable:Boolean=false) {
		super(type, bubbles, cancelable);
		
		_message = message;
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
	 *	Create a clone instance of FaultEvent.
	 */
	override public function clone():Event {
		return new FaultEvent(type, message, bubbles, cancelable);
	}

	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//	message
	//--------------------------------------
	
	private var _message:String;
	
	public function get message():String {
		return _message;
	}
}

}