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
	
import flash.display.DisplayObject;
import flash.events.Event;

/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.09.29
 *	@Modify
 *	@Description
 */
public class ListEvent extends Event
{
    //--------------------------------------------------------------------------
	//
	//	Class constants
	//
    //--------------------------------------------------------------------------
	
	public static const ITEM_CHANGE:String = "itemChange";
	public static const ITEM_CLICK:String = "itemClick";
	public static const ITEM_DOUBLE_CLICK:String = "itemDoubleClick";
	public static const ITEM_ROLL_OUT:String = "itemRollOver";
	public static const ITEM_ROLL_OVER:String = "itemRollOver";
	
	/**
	 *	@Constructor
	 */
	public function ListEvent(
		type:String, itemRenderer:DisplayObject, bubbles:Boolean=true, cancelable:Boolean=false) {
		super(type, bubbles, cancelable);
		
		_itemRenderer = itemRenderer;
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
     *	ListEvent의 복사본을 생성해 반환한다.
     */
    override public function clone():Event {
    	return new ListEvent(type, itemRenderer, bubbles, cancelable);
    }
	
    //--------------------------------------------------------------------------
	//
	//	getter / setter
	//
    //--------------------------------------------------------------------------
   
	//--------------------------------------
	//	itemRenderer
	//--------------------------------------
	
	private var _itemRenderer:DisplayObject;
	
	public function get itemRenderer():DisplayObject {
		return _itemRenderer;
	}
}

}