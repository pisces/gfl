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

package com.golfzon.gfl.controls
{

import com.golfzon.gfl.core.BorderBasedComponent;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.events.Event;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *	텍스트가 변경되었을 때 송출한다.
 */
[Event(name="change", type="flash.events.Event")]

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *	@Include the external file to define background styles.
 */
include "../styles/metadata/BackgroundStyles.as";

/**
 *	@Author				KHKim
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.10.26
 *	@Modify
 *	@Description
 * 	@includeExample		TextInputSample.as
 */
public class TextInput extends BorderBasedComponent
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	private var textField:UITextField;
	
	/**
	 *	@Constructor
	 */
	public function TextInput() {
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Overriden : BorderBasedComponent
	//--------------------------------------------------------------------------
	
	/**
	 * 	프로퍼티 변경 사항에 대한 처리
	 */
	override protected function commitProperties():void {
		super.commitProperties();
		
		if( alwaysShowSelectionChanged ) {
			alwaysShowSelectionChanged = false;
			textField.alwaysShowSelection = _alwaysShowSelection;
		}
		
		if( displayAsPasswordChanged ) {
			displayAsPasswordChanged = false;
			textField.displayAsPassword = _displayAsPassword;
		}
		
		if( maxCharsChanged ) {
			maxCharsChanged = false;
			textField.maxChars = _maxChars;
		}
		
		if( restrictChanged ) {
			restrictChanged = false;
			textField.restrict = _restrict;
		}
		
		if( htmlTextChanged ) {
			htmlTextChanged = false;
			textField.htmlText = _htmlText ? _htmlText : "";
		}
		
		if( textChanged ) {
			textChanged = false;
			textField.text = _text ? _text : "";
		}
	}
	
	/**
	 * 	자식 객체 생성 및 추가
	 */
	override protected function createChildren():void {
		super.createChildren();
		
		textField = new UITextField();
		textField.editable = true;
		textField.multiline = false;

		configureListeners();
		addChild(textField);
	}
	
	override public function setFocus():void {
		textField.setFocus();
	}
	
	/**
	 * 	디스플레이 변경 사항에 대한 처리
	 */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		var borderThickness:Number = replaceNullorUndefined(getStyle(StyleProp.BORDER_THICKNESS), 1);
		textField.width = unscaledWidth - viewMetrics.left - viewMetrics.right - borderThickness * 2;
		textField.height = textField.measuredHeight;
		textField.x = borderThickness + viewMetrics.left;
		textField.y = Math.round((unscaledHeight - textField.height) / 2);
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	private function configureListeners():void {
		textField.addEventListener(Event.CHANGE, textField_changeHandler, false, 0, true);
	}
	
	//--------------------------------------------------------------------------
	//
	//	Event handlers
	//
	//--------------------------------------------------------------------------
	
	private function textField_changeHandler(event:Event):void {
		_text = textField.text;
		dispatchEvent(event.clone());
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//  alwaysShowSelection
	//--------------------------------------
	
	private var alwaysShowSelectionChanged:Boolean;
	
	private var _alwaysShowSelection:Boolean;
	
	public function get alwaysShowSelection():Boolean {
		return _alwaysShowSelection;
	}
	
	public function set alwaysShowSelection(value:Boolean):void {
		if( value == _alwaysShowSelection )
			return;
		
		_alwaysShowSelection = value;
		alwaysShowSelectionChanged = true;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//  displayAsPassword
	//--------------------------------------
	
	private var displayAsPasswordChanged:Boolean;
	
	private var _displayAsPassword:Boolean;
	
	public function get displayAsPassword():Boolean {
		return _displayAsPassword;
	}
	
	public function set displayAsPassword(value:Boolean):void {
		if( value == _displayAsPassword )
			return;
		
		_displayAsPassword = value;
		displayAsPasswordChanged = true;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//  maxChars
	//--------------------------------------
	
	private var maxCharsChanged:Boolean;
	
	private var _maxChars:int = 0;
	
	public function get maxChars():int {
		return _maxChars;
	}
	
	public function set maxChars(value:int):void {
		if( value == _maxChars )
			return;
		
		_maxChars = value;
		maxCharsChanged = true;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//  restrict
	//--------------------------------------
	
	private var restrictChanged:Boolean;
	
	private var _restrict:String;
	
	public function get restrict():String {
		return _restrict;
	}
	
	public function set restrict(value:String):void {
		if( value == _restrict )
			return;
		
		_restrict = value;
		restrictChanged = true;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//	htmlText
	//--------------------------------------
	
	private var htmlTextChanged:Boolean;
	
	private var _htmlText:String;
	
	public function get htmlText():String {
		return _htmlText ? _htmlText : "";
	}
	
	public function set htmlText(value:String):void {
		if( value == _htmlText )
			return;
		
		_htmlText = value;
		htmlTextChanged = true;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//  text
	//--------------------------------------
	
	private var textChanged:Boolean;
	
	private var _text:String;
	
	public function get text():String {
		return _text ? _text : "";
	}
	
	public function set text(value:String):void {
		if( value == _text )
			return;
		
		_text = value;
		textChanged = true;
		
		invalidateProperties();
	}
}

}