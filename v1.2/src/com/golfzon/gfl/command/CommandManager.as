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

package com.golfzon.gfl.command
{

import flash.events.EventDispatcher;

import com.golfzon.gfl.command.ICommand;
import com.golfzon.gfl.command.IInvoker;
import com.golfzon.gfl.events.CommandEvent;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *	dispatch when redo buffer is empty.
 */
[Event(name="emptyRedoBuffer", type="com.golfzon.gfl.events.CommandEvent")]

/**
 *	dispatch when undo buffer is empty.
 */
[Event(name="emptyUndoBuffer", type="com.golfzon.gfl.events.CommandEvent")]

/**
 *	dispatch when execute the redo method.
 */
[Event(name="redo", type="com.golfzon.gfl.events.CommandEvent")]

/**
 *	dispatch when execute the undo method.
 */
[Event(name="undo", type="com.golfzon.gfl.events.CommandEvent")]

/**
 *	@Author				KHKim
 *	@Version			1.0
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.03.07
 *	@Modify
 *	@Description
 */
public class CommandManager extends EventDispatcher implements IInvoker
{
	//--------------------------------------------------------------------------
	//
	//  Class variables
	//
	//--------------------------------------------------------------------------

	/**
	 *	undo buffer.
	 */
	private var undoBuffer:Array = [];
	
	/**
	 *	redo buffer.
	 */
	private var redoBuffer:Array = [];
	
	/**
	 *	@Constructor
	 */
	public function CommandManager() {
	}
	
	//--------------------------------------------------------------------------
	//
	//  Instance methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Public
	//--------------------------------------------------------------------------
	
	/**
	 *	Clears the undo buffer and redo buffer.
	 */
	public function clear():void {
		undoBuffer = [];
		redoBuffer = [];
	}
	
	/**
	 *	Wheather undo buffer is not empty.
	 */
	public function isEmptyUndoBuffer():Boolean {
		return undoBuffer.length < 1;
	}
	
	/**
	 *	Wheather redo buffer is not empty.
	 */
	public function isEmptyRedoBuffer():Boolean {
		return redoBuffer.length < 1;
	}
	
	/**
	 *	Run with command instance of ICommand.
	 */
	public function run(command:ICommand):void {
		redoBuffer = [];
		command.execute();
		undoBuffer.push(command);
	}
	
	/**
	 *	Redo and dispatch command event.
	 */
	public function redo():void {
		if( isEmptyRedoBuffer() ) {
			dispatchEvent(new CommandEvent(CommandEvent.EMPTY_REDO_BUFFER, null));
		} else {
			var command:ICommand = ICommand(redoBuffer.pop());
			command.redo();
			undoBuffer.push(command);
			dispatchEvent(new CommandEvent(CommandEvent.REDO, command));
		}
	}
	
	/**
	 *	Undo and dispatch command event.
	 */
	public function undo():void {
		if( isEmptyUndoBuffer() ) {
			dispatchEvent(new CommandEvent(CommandEvent.EMPTY_UNDO_BUFFER, null));
		} else {
			var command:ICommand = ICommand(undoBuffer.pop());
			command.undo();
			redoBuffer.push(command);
			dispatchEvent(new CommandEvent(CommandEvent.UNDO, command));
		}
	}
}

}