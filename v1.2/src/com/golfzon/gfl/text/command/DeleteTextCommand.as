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
public class DeleteTextCommand extends TextCommand
{
	/**
	 *	@Construcotr
	 */
	public function DeleteTextCommand(receiver:IReceiver, parameters:Object=null) {
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
		if( selectionBeginIndex == selectionEndIndex )
			textField.replaceText(selectionBeginIndex, selectionBeginIndex + 1, '');
		else
			textField.replaceText(selectionBeginIndex, selectionEndIndex, '');

		textField.setSelection(selectionBeginIndex, selectionBeginIndex);
	}
	
	/**
	 *	@realization
	 */
	override public function undo():void {
		if( selectionBeginIndex == selectionEndIndex )
			textField.replaceText(selectionBeginIndex, selectionBeginIndex, changedText);
		else
			textField.replaceText(selectionBeginIndex, selectionEndIndex - changedText.length, changedText);

		textField.setSelection(selectionBeginIndex, selectionEndIndex);
	}
}

}