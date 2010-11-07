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
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.10.22
 *	@Modify
 *	@Description
 */
public class InsertTabCommand extends TextCommand
{
	/**
	 *	@Construcotr
	 */
	public function InsertTabCommand(receiver:IReceiver, parameters:Object=null) {
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
	 *	@realization
	 */
	override public function redo():void {
		var selectionBeginIndex:int = parameters.selectionBeginIndex;
		var selectionEndIndex:int = parameters.selectionEndIndex;
		var selectionBeginLineIndex:int = parameters.selectionBeginLineIndex;
		var selectionEndLineIndex:int = parameters.selectionEndLineIndex;
		var selectedText:String = parameters.selectedText;
		
		if( origineText ) {
			textField.replaceText(selectionBeginIndex, selectionEndIndex, '');
			textField.setSelection(selectionBeginIndex, selectionBeginIndex);
		} else if( selectedText.length < 1 ) {
			textField.replaceText(selectionBeginIndex, selectionEndIndex, '\t');
			textField.setSelection(selectionBeginIndex + 1, selectionBeginIndex + 1);
		} else {
			textField.insertTab(selectionBeginIndex, selectionEndIndex,
				selectionBeginLineIndex, selectionEndLineIndex);
			textField.setSelection(selectionBeginIndex, selectionBeginIndex);
		}
	}
	
	/**
	 *	@realization
	 */
	override public function undo():void {
		if( origineText ) {
			textField.replaceText(selectionBeginIndex, selectionBeginIndex, origineText);
		} else if( selectedText.length < 1 ) {
			textField.replaceText(selectionBeginIndex - 1, selectionEndIndex, '');
		} else {
			textField.removeTab(selectionBeginIndex, selectionEndIndex,
				selectionBeginLineIndex, selectionEndLineIndex);
		}
		textField.setSelection(parameters.selectionBeginIndex, parameters.selectionEndIndex);
	}
}

}