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
 *	@Date				2010. 4. 19.
 *	@Modify
 *	@Description
 */
public class DataGridEvent extends Event
{
	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------
	
	public static const DATA_SORT:String = "dataSort";
	
	/**
	 *	@Constructor
	 */
	public function DataGridEvent(type:String, columnIndex:int, sortOption:uint, bubbles:Boolean=false, cancelable:Boolean=false) {
		super(type, bubbles, cancelable);
		
		_columnIndex = columnIndex;
		_sortOption = sortOption;
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
		return new DataGridEvent(type, _columnIndex, _sortOption, bubbles, cancelable);
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//	columnIndex
	//--------------------------------------
	
	private var _columnIndex:int;
	
	public function get columnIndex():int {
		return _columnIndex;
	}
	
	//--------------------------------------
	//	sortOption
	//--------------------------------------
	
	private var _sortOption:uint;
	
	public function get sortOption():uint {
		return _sortOption;
	}
}
	
}