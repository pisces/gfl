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
 *	@Date				2009.10.22
 *	@Modify
 *	@Description
 */
public class RichTextFieldEvent extends Event
{
	/**
	 *	Change constant.
	 */
	public static const TEXT_CHANGE:String = "textChange";
	
	/**
	 *	@Constructor
	 */
	public function RichTextFieldEvent(
		type:String, undo:Boolean=false, redo:Boolean=false, bubbles:Boolean=false, cancelable:Boolean=false) {
		super(type, bubbles, cancelable);
		
		_undo = undo;
		_redo = redo;
	}

	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//  Overriden : Event
	//--------------------------------------------------------------------------
	
	override public function clone():Event {
		return new RichTextFieldEvent(type, undo, redo, bubbles, cancelable);
	}

	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------

	//--------------------------------------
	//  undo
	//--------------------------------------
	
	private var _undo:Boolean;
	
	public function get undo():Boolean {
		return _undo;
	}
	
	//--------------------------------------
	//  redo
	//--------------------------------------
	
	private var _redo:Boolean;
	
	public function get redo():Boolean {
		return _redo;
	}
}

}