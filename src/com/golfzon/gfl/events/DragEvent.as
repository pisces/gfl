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
 *	@Date				2009.11.13
 *	@Modify
 *	@Description
 */
public class DragEvent extends Event
{
    //--------------------------------------------------------------------------
	//
	//	Class constants
	//
    //--------------------------------------------------------------------------
	
	public static const DRAG_COMPLETE:String = "dragComplete";
	public static const DRAG_ENTER:String = "dragEnter";
	public static const DRAG_DROP:String = "dragDrop";
	public static const DRAG_OVER:String = "dragOver";
	public static const DRAG_START:String = "dragStart";
	
	/**
	 *	@Constructor
	 */
	public function DragEvent(
		type:String, dragInitiator:DisplayObject, dragImage:DisplayObject,
		dragSource:Object=null, bubbles:Boolean=true, cancelable:Boolean=false) {
		super(type, bubbles, cancelable);
		
		_dragInitiator = dragInitiator;
		_dragImage = dragImage;
		_dragSource = dragSource;
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
     *	DragEvent의 복사본을 생성해 반환한다.
     */
    override public function clone():Event {
    	return new DragEvent(type, dragInitiator, dragImage, dragSource, bubbles, cancelable);
    }
	
    //--------------------------------------------------------------------------
	//
	//	getter / setter
	//
    //--------------------------------------------------------------------------
   
	//--------------------------------------
	//	dragInitiator
	//--------------------------------------
	
	private var _dragInitiator:DisplayObject;
	
	public function get dragInitiator():DisplayObject {
		return _dragInitiator;
	}
   
	//--------------------------------------
	//	dragImage
	//--------------------------------------
	
	private var _dragImage:DisplayObject;
	
	public function get dragImage():DisplayObject {
		return _dragImage;
	}
   
	//--------------------------------------
	//	dragSource
	//--------------------------------------
	
	private var _dragSource:Object;
	
	public function get dragSource():Object {
		return _dragSource;
	}
}

}