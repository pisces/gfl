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

import com.golfzon.gfl.command.ICommand;

/**
 *	@Author				KH Kim
 *	@Version			1.0
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.03.07
 *	@Modify
 *	@Description
 */
public class CommandEvent extends Event
{
	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------

	public static const EMPTY_REDO_BUFFER:String = "emptyRedoBuffer";
	public static const EMPTY_UNDO_BUFFER:String = "emptyUndoBuffer";
	public static const REDO:String = "redo";
	public static const UNDO:String = "undo";
	
	/**
	 *	@Constructor
	 */
	public function CommandEvent(type:String, commandInstance:ICommand, bubbles:Boolean=false, cancelable:Boolean=false) {
		super(type, bubbles, cancelable);
		_commandInstance = commandInstance;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Instance methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Overriden : Event
	//--------------------------------------------------------------------------

	override public function clone():Event {
		return new CommandEvent(type, commandInstance, bubbles, cancelable);
	}
	
	//----------------------------------------------------------------
	//
	//	getter / setter
	//
	//----------------------------------------------------------------
	
	//--------------------------------------
	//  commandInstance
	//--------------------------------------
	
	private var _commandInstance:ICommand;
	
	/**
	 *	Gain the executed instance of ICommand.
	 */
	public function get commandInstance():ICommand {
		return _commandInstance;
	}
}

}