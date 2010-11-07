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

import flash.events.Event;
import flash.text.TextFormat;

/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
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
	public function WriteTextCommand(receiver:RichTextField, parameters:Object=null) {
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
    	
    	orgText = receiver.text;
    	textFormat = receiver.getTextFormat();
    	receiver.addEventListener(Event.CHANGE, changeHandler);
    }
	
	/**
	 *	@realization
	 */
	override public function redo():void {
		receiver.text = newText;
		receiver.setTextFormat(textFormat);
		receiver.setSelection(selectionBeginIndex, selectionBeginIndex + changedText.length);
	}
	
	/**
	 *	@realization
	 */
	override public function undo():void {
		receiver.text = orgText;
		receiver.setTextFormat(textFormat);
		receiver.setSelection(selectionBeginIndex, selectionEndIndex);
	}
    
    //--------------------------------------------------------------------------
	//
	//	Event handlers
	//
    //--------------------------------------------------------------------------
    
    private function changeHandler(event:Event):void {
    	receiver.removeEventListener(Event.CHANGE, changeHandler);
    	newText = receiver.text;
    }
}

}