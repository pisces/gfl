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
	 
import com.golfzon.gfl.text.RichTextField;

/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
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
	public function DeleteTextCommand(receiver:RichTextField, parameters:Object=null) {
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
			receiver.replaceText(selectionBeginIndex, selectionBeginIndex + 1, '');
		else
			receiver.replaceText(selectionBeginIndex, selectionEndIndex, '');

		receiver.setSelection(selectionBeginIndex, selectionBeginIndex);
	}
	
	/**
	 *	@realization
	 */
	override public function undo():void {
		if( selectionBeginIndex == selectionEndIndex )
			receiver.replaceText(selectionBeginIndex, selectionBeginIndex, changedText);
		else
			receiver.replaceText(selectionBeginIndex, selectionEndIndex - changedText.length, changedText);

		receiver.setSelection(selectionBeginIndex, selectionEndIndex);
	}
}

}