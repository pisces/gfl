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
public class TextCommand extends Command
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
	
	protected var parameters:Object;
	
	/**
	 *	receiver is instance of TextArea.
	 */
	protected var receiver:RichTextField;
	
	/**
	 *	@Construcotr
	 */
	public function TextCommand(receiver:RichTextField, parameters:Object=null) {
		this.receiver = receiver;
		this.parameters = parameters;
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
		changedText = receiver.changedText;
		changedType = receiver.changedType;
		origineText = receiver.origineText;
		selectedText = receiver.selectedText;
		selectionBeginIndex = receiver.selectionBeginIndex;
		selectionEndIndex = receiver.selectionEndIndex;
		selectionBeginLineIndex = receiver.selectionBeginLineIndex;
		selectionEndLineIndex = receiver.selectionEndLineIndex;

		if( changedText )
			changedText = changedText.replace(/\r/g, '\n');
		
		if( origineText )
			origineText = origineText.replace(/\r/g, '\n');
	}
}

}