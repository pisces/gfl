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
public class ResultEvent extends Event
{
	//----------------------------------------------------------------
	//
	//	Class constants
	//
	//----------------------------------------------------------------
	
	public static const RESULT:String = "result";
	
	/**
	 *	@Contsructor
	 */
	public function ResultEvent(type:String, result:Object=null, bubbles:Boolean=false, cancelable:Boolean=false) {
		super(type, bubbles, cancelable);
		
		_result = result;
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
	 *	Create a clone instance of ResultEvent.
	 */
	override public function clone():Event {
		return new ResultEvent(type, result, bubbles, cancelable);
	}

	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//	result
	//--------------------------------------
	
	private var _result:Object;
	
	public function get result():Object {
		return _result;
	}
}

}