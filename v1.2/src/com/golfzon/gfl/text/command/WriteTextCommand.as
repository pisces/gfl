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

import flash.events.Event;
import flash.text.TextFormat;

/**
 *	@Author				KHKim
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.10.22
 *	@Modify
 *	@Description
 */
public class WriteTextCommand extends TextCommand
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	private var orgText:String;
	private var newText:String;
	
	private var textFormat:TextFormat;
	
	/**
	 * 
	 *	@construcor
	 * 
	 */
	public function WriteTextCommand(receiver:IReceiver, parameters:Object=null) {
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
	override public function execute():void {
		super.execute();
		
		orgText = textField.text;
		textFormat = textField.getTextFormat();
		textField.addEventListener(Event.CHANGE, changeHandler);
	}
	
	/**
	 *	@realization
	 */
	override public function redo():void {
		textField.text = newText;
		textField.setTextFormat(textFormat);
		textField.setSelection(selectionBeginIndex, selectionBeginIndex + changedText.length);
	}
	
	/**
	 *	@realization
	 */
	override public function undo():void {
		textField.text = orgText;
		textField.setTextFormat(textFormat);
		textField.setSelection(selectionBeginIndex, selectionEndIndex);
	}
	
	//--------------------------------------------------------------------------
	//
	//	Event handlers
	//
	//--------------------------------------------------------------------------
	
	private function changeHandler(event:Event):void {
		textField.removeEventListener(Event.CHANGE, changeHandler);
		newText = textField.text;
	}
}

}