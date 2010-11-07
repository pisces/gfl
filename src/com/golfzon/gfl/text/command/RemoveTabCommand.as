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

package com.golfzon.gfl.text.command
{

import com.golfzon.gfl.command.IReceiver;

/**
 *	@Author				KHKim
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.10.22
 *	@Modify
 *	@Description
 */
public class RemoveTabCommand extends TextCommand
{
	/**
	 *	@Construcotr
	 */
	public function RemoveTabCommand(receiver:IReceiver, parameters:Object=null) {
		super(receiver, parameters);
	}
	
	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Overriden : TextCommand
	//--------------------------------------------------------------------------
	
	/**
	 * 
	 *	@realization
	 * 
	 */
	override public function redo():void {
		var selectionBeginIndex:int = parameters.selectionBeginIndex;
		var selectionEndIndex:int = parameters.selectionEndIndex;
		var selectionBeginLineIndex:int = parameters.selectionBeginLineIndex;
		var selectionEndLineIndex:int = parameters.selectionEndLineIndex;
		
		textField.removeTab(selectionBeginIndex, selectionEndIndex,
			selectionBeginLineIndex, selectionEndLineIndex);
		textField.setSelection(selectionBeginIndex, selectionBeginIndex);
	}
	
	/**
	 * 
	 *	@realization
	 * 
	 */
	override public function undo():void {
		textField.insertTab(selectionBeginIndex, selectionEndIndex,
			selectionBeginLineIndex, selectionEndLineIndex);
		textField.setSelection(selectionBeginIndex, selectionEndIndex);
	}
}

}