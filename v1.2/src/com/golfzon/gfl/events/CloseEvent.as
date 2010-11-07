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
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.11.12
 *	@Modify
 *	@Description
 */
public class CloseEvent extends Event
{
	//--------------------------------------------------------------------------
	//
	//	Class constants
	//
	//--------------------------------------------------------------------------
	
	public static const CLOSE:String = "close";
	
	/**
	 *	@Constructor
	 */
	public function CloseEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, detail:int=-1) {
		super(type, bubbles, cancelable);
		
		_detail = detail;
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
	 *	CloseEvent의 복사본을 생성해 반환한다.
	 */
	override public function clone():Event {
		return new CloseEvent(type, bubbles, cancelable, detail);
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
   
	//--------------------------------------
	//	detail
	//--------------------------------------
	
	private var _detail:int;
	
	public function get detail():int {
		return _detail;
	}
}

}