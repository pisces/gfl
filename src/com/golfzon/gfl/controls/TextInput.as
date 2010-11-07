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

import com.golfzon.gfl.core.ComponentBase;
import com.golfzon.gfl.core.EdgeMetrics;
import com.golfzon.gfl.core.IInteractiveObject;
import com.golfzon.gfl.skins.Border;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.display.DisplayObject;
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
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.10.26
 *	@Modify
 *	@Description
 * 	@includeExample		TextInputSample.as
 */
public class TextInput extends ComponentBase
{
    //--------------------------------------------------------------------------
	//
	//	Instance variables
	//
    //--------------------------------------------------------------------------
    
    private var border:DisplayObject;
    
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
    //  Overriden : TextInput
    //--------------------------------------------------------------------------
    
    /**
     * 	프로퍼티 변경 사항에 대한 처리
     */
    override protected function commitProperties():void {
    	super.commitProperties();
    	
    	if( displayAsPasswordChanged ) {
    		displayAsPasswordChanged = false;
    		textField.displayAsPassword = displayAsPassword;
    	}
    	
    	if( maxCharsChanged ) {
    		maxCharsChanged = false;
    		textField.maxChars = maxChars;
    	}
    	
    	if( restrictChanged ) {
    		restrictChanged = false;
    		textField.restrict = restrict;
    	}
    	
    	if( textChanged ) {
    		textChanged = false;
    		textField.text = text;
    	}
    }
    
    /**
     * 	자식 객체 생성 및 추가
     */
    override protected function createChildren():void {
    	super.createChildren();
		
		border = createBorder();
    	
    	textField = new UITextField();
    	textField.editable = true;
    	textField.multiline = false;
    	textField.displayAsPassword = displayAsPassword;
    	textField.maxChars = maxChars;
    	textField.restrict = restrict;
    	textField.text = text;

		setViewMetrics();
    	configureListeners();
    	addChild(border);
    	addChild(textField);
    }
    
    override public function setFocus():void {
    	textField.setFocus();
    }
    
    /**
     *	스타일 프로퍼티로 값을 설정한다.
     */
    override public function styleChanged(styleProp:String):void {
    	super.styleChanged(styleProp);

    	switch( styleProp ) {
    		case StyleProp.PADDING_LEFT: case StyleProp.PADDING_RIGHT:
				setViewMetrics();
				invalidateDisplayList();
    			break;
    			
    		case StyleProp.BORDER_SKIN:
    			removeBorder();
    			border = createBorder();
    			break;
    			
    		case StyleProp.BACKGROUND_ALPHA: case StyleProp.BACKGROUND_COLOR:
    		case StyleProp.BACKGROUND_IMAGE: case StyleProp.BORDER_COLOR:
    		case StyleProp.BORDER_THICKNESS: case StyleProp.CORNER_RADIUS:
    			if( border is Border ) {
    				Border(border).setStyle(styleProp, getStyle(styleProp));
    				invalidateDisplayList();
    			}
    			break;
     	}
    }
    
    /**
     * 	디스플레이 변경 사항에 대한 처리
     */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
    	border.width = unscaledWidth;
    	border.height = unscaledHeight;
    	
    	var borderThickness:Number = replaceNullorUndefined(getStyle(StyleProp.BORDER_THICKNESS), 1);
    	textField.width = unscaledWidth - viewMetrics.left - viewMetrics.right - borderThickness * 2;
    	textField.height = textField.measuredHeight;
    	textField.x = borderThickness + viewMetrics.left;
    	textField.y = Math.round((unscaledHeight - textField.height) / 2);
    }
    
    //--------------------------------------------------------------------------
    //  Internal
    //--------------------------------------------------------------------------
    
    /**
     * 	@private
     */
    private function configureListeners():void {
    	textField.addEventListener(Event.CHANGE, textField_changeHandler, false, 0, true);
    }
    
    /**
     * 	@private
     */
    private function createBorder():DisplayObject {
		var borderClass:Class = replaceNullorUndefined(getStyle(StyleProp.BORDER_SKIN), Border);
		if( borderClass ) {
			var border:DisplayObject = createSkinBy(borderClass);
			border.width = unscaledWidth;
			border.height = unscaledHeight;
			
			if( border is IInteractiveObject )
				IInteractiveObject(border).enabled = enabled;
				
			addChildAt(border, 0);
			
			if( border is Border )
				Border(border).styleName = getCSSStyleDeclaration();
			
			return border;
		}
		return null;
    }
    
    /**
     * 	@private
     */
    private function removeBorder():void {
    	if( border && contains(border) ) {
    		removeChild(border);
    		border = null;
    	}
    }
    
	/**
	 *	@private
	 */
    private function setViewMetrics(defaultValue:Number=0):void {
    	_viewMetrics = new EdgeMetrics(
    		replaceNullorUndefined(getStyle(StyleProp.PADDING_LEFT), defaultValue),
    		replaceNullorUndefined(getStyle(StyleProp.PADDING_TOP), defaultValue),
    		replaceNullorUndefined(getStyle(StyleProp.PADDING_RIGHT), defaultValue),
    		replaceNullorUndefined(getStyle(StyleProp.PADDING_BOTTOM), defaultValue)
    	);
    }
    
    //--------------------------------------------------------------------------
	//
	//	Event handlers
	//
    //--------------------------------------------------------------------------
    
    /**
     * 	@private
     */
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
	
	//--------------------------------------
	//  viewMetrics
	//--------------------------------------
	
	private var _viewMetrics:EdgeMetrics;
	
	public function get viewMetrics():EdgeMetrics {
		return _viewMetrics;
	}
}

}