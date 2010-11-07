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
 *	@Date				2010. 4. 21.
 *	@Modify
 *	@Description
 */
public class IndexChangedEvent extends Event
{
	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------
	
	public static const CHANGE:String = "change";
	
	public static const TAB_INDEX_CHANGE:String = "tabIndexChange";
	
	//--------------------------------------------------------------------------
	//
	//  Class variables
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//
	//  Instance constants
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//
	//  Instance variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	@Constructor
	 */
	public function IndexChangedEvent(
		type:String, origineIndex:int, newIndex:int, bubbles:Boolean=false, cancelable:Boolean=false) {
		super(type, bubbles, cancelable);
		
		_origineIndex = origineIndex;
		_newIndex = newIndex;
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
	 *	DataGridEvent의 복사본을 생성해 반환한다.
	 */
	override public function clone():Event {
		return new IndexChangedEvent(type, _origineIndex, _newIndex, bubbles, cancelable);
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//	origineIndex
	//--------------------------------------
	
	private var _origineIndex:int;
	
	public function get origineIndex():int {
		return _origineIndex;
	}
	
	//--------------------------------------
	//	newIndex
	//--------------------------------------
	
	private var _newIndex:int;
	
	public function get newIndex():int {
		return _newIndex;
	}
}
	
}