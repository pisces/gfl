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

import com.golfzon.gfl.command.AbstractCommand;
import com.golfzon.gfl.command.IReceiver;
import com.golfzon.gfl.text.RichTextField;

/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.10.22
 *	@Modify
 *	@Description
 */
public class TextCommand extends AbstractCommand
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	protected var selectionBeginIndex:int;
	protected var selectionEndIndex:int;
	protected var selectionBeginLineIndex:int;
	protected var selectionEndLineIndex:int;

	protected var changedText:String;
	protected var changedType:String;
	protected var origineText:String;
	protected var selectedText:String;
	
	protected var textField:RichTextField;
	
	/**
	 *	@Construcotr
	 */
	public function TextCommand(receiver:IReceiver, parameters:Object=null) {
		super(receiver, parameters);
		
		textField = RichTextField(receiver);
	}
	
	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Overriden : Command
	//--------------------------------------------------------------------------

	/**
	 *	@realization
	 */
	override public function execute():void {
		changedText = textField.changedText;
		changedType = textField.changedType;
		origineText = textField.origineText;
		selectedText = textField.selectedText;
		selectionBeginIndex = textField.selectionBeginIndex;
		selectionEndIndex = textField.selectionEndIndex;
		selectionBeginLineIndex = textField.selectionBeginLineIndex;
		selectionEndLineIndex = textField.selectionEndLineIndex;

		if( changedText )
			changedText = changedText.replace(/\r/g, '\n');
		
		if( origineText )
			origineText = origineText.replace(/\r/g, '\n');
	}
}

}