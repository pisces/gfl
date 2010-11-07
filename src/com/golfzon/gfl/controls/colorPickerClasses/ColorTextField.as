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

package com.golfzon.gfl.controls.colorPickerClasses
{
	
import com.golfzon.gfl.controls.TextInput;
import com.golfzon.gfl.core.ComponentBase;
import com.golfzon.gfl.styles.StyleProp;

import flash.events.Event;

/**
 *	@Author				HJ Kim
 *	@Version			1.0
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.10.21
 *	@Modify
 *	@Description
 */
public class ColorTextField extends ComponentBase implements IColorSelectableObject
{
	private var keyDownChecked:Boolean;
	
	private var textInput:TextInput;

	/**
	 * 	@Construct
	 */
	public function ColorTextField() {
		super();
	}

	//--------------------------------------------------------------------------		
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Overriden : ComponentBase
	//--------------------------------------------------------------------------	
	
	/**
	 * 	자식객체 생성
	 */
	override protected function createChildren():void {
		super.createChildren();
		
		textInput = new TextInput();
		textInput.restrict = "#0-9a-fA-F";
		textInput.maxChars = 6;
		textInput.text = "#000000";
		
		textInput.styleName = styleName;
		
		textInput.addEventListener(Event.CHANGE, changeHandler, false, 0, true);
		addChild(textInput);
	}
	
	/**
	 * 	디스플레이 변경사항에 대한 처리
	 */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		textInput.width = unscaledWidth;
		textInput.height = unscaledHeight;
	}
	
	//--------------------------------------------------------------------------
	//
	//	Event handlers
	//
	//--------------------------------------------------------------------------
	
	/**
	 * 	@private
	 */
	private function changeHandler(event:Event):void {
		keyDownChecked = true;
		textInput.text.search("#") ? textInput.maxChars = 6 : textInput.maxChars = 7;
	}

	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//	selectedColor   
	//--------------------------------------
	
	public function get selectedColor():uint {
		return parseInt(textInput.text.replace("#", ""), 16);
	}
	
	public function set selectedColor(value:uint):void {
		if( keyDownChecked ) { 
			keyDownChecked = false; 
		} else {
			var convertStr:String;
			convertStr = "000000" + value.toString(16).toUpperCase();
			convertStr = convertStr.substr(convertStr.length - 6, convertStr.length);
			textInput.text = "#" + convertStr;
			
			invalidateDisplayList();
		}
	}
}

}