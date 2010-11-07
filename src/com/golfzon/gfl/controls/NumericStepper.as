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

import com.golfzon.gfl.controls.buttonClasses.NumericStepperButton;
import com.golfzon.gfl.core.ComponentBase;
import com.golfzon.gfl.core.gz_internal;
import com.golfzon.gfl.events.GZMouseEvent;
import com.golfzon.gfl.skins.Border;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.ui.Keyboard;

use namespace gz_internal;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *	내부에서 value가 변경되었을 때 송출한다.
 */
[Event(name="change", type="flash.events.Event")]

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  다음 버튼 스킨
 *	@default value com.golfzon.gfl.controls.buttonClasses.NumericStepperButton
 */
[Style(name="nextButtonStyleName", type="String", inherit="no")]

/**
 *  이전 버튼 스킨
 *	@default value com.golfzon.gfl.controls.buttonClasses.NumericStepperButton
 */
[Style(name="prevButtonStyleName", type="String", inherit="no")]

/**
 *  보더 스킨
 * 	@default value com.golfzon.gfl.skins.Border
 */
[Style(name="borderSkin", type="class", inherit="no")]

/**
 *	@Author				SH Jung
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.11.09
 *	@Modify
 *	@Description
 * 	@includeExample		NumericStepperSample.as
 */
public class NumericStepper extends ComponentBase
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
    //--------------------------------------------------------------------------
    
    private var border:DisplayObject;
    private var nextButton:NumericStepperButton;
    private var prevButton:NumericStepperButton;
    private var label:UITextField;
    
	/**
	 *	@Constructor
	 */
	public function NumericStepper() {
		super();
	}
	
    //--------------------------------------------------------------------------
    //  Overriden : ComponentBase
    //--------------------------------------------------------------------------
    
    /**
     * 	프로퍼티 변경 사항에 대한 처리
     */
    override protected function commitProperties():void {
    	super.commitProperties();
    	
    	if( valueChanged ) {
    		valueChanged = false;
    		setLabelText();
    	}
    	
    	if( maximumChanged ) {
    		maximumChanged = false;
    		setLabelText();
    	}
    	
    	if( minimumChanged ) {
    		minimumChanged = false;
    		setLabelText();
    	}
    }
    
    /**
     * 	컴퍼넌트의 기본 크기와 최소 크기를 설정한다.
     */
	override protected function measure():void {
		super.measure();
    	
		measureWidth = isNaN(width) ? 100 : measureWidth;
    	measureHeight = isNaN(height) ? 22 : measureHeight;
    	
    	setActureSize(unscaledWidth, unscaledHeight);
	}
    
    /**
     * 	자식 객체 생성 및 추가
     */
    override protected function createChildren():void {
    	border = createBorder();
    	
    	nextButton = new NumericStepperButton();
    	nextButton.direction = NumericStepperButton.NEXT;
    	nextButton.styleName = getStyle(StyleProp.NEXT_BUTTON_STYLE_NAME);
    	
    	prevButton = new NumericStepperButton();
    	prevButton.direction = NumericStepperButton.PREV;
    	prevButton.styleName = getStyle(StyleProp.PREV_BUTTON_STYLE_NAME);
    	
    	label = new UITextField();
    	label.multiline = false;
    	label.restrict = "0-9 ."
    	setLabelText();
    	
    	configureListeners();
    	addChild(border);
    	addChild(nextButton);
    	addChild(prevButton);
    	addChild(label);
    }
    
    /**
     *	enabled에 따른 구현
     */
	override protected function setEnabledState():void {
		super.setEnabledState();
		
		nextButton.enabled = enabled;
		prevButton.enabled = enabled;
		label.enabled = enabled;
	}
    
    /**
     *	스타일 프로퍼티로 값을 설정한다.
     */
    override public function styleChanged(styleProp:String):void {
    	super.styleChanged(styleProp);
    	
    	switch( styleProp ) {
    		case StyleProp.NEXT_BUTTON_STYLE_NAME:
    			nextButton.styleName = getStyle(StyleProp.NEXT_BUTTON_STYLE_NAME);
    			break;
    			
    		case StyleProp.PREV_BUTTON_STYLE_NAME:
    			nextButton.styleName = getStyle(StyleProp.PREV_BUTTON_STYLE_NAME);
    			break;
    	}
    }
    
    /**
     * 	디스플레이 변경 사항에 대한 처리
     */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		border.width = unscaledWidth - nextButton.currentSkin.width + 1;
		border.height = unscaledHeight;
		
		nextButton.height = unscaledHeight / 2;
		nextButton.x = border.width - 1;
		
		prevButton.height = unscaledHeight / 2;
		prevButton.x = border.width - 1;
		prevButton.y = nextButton.height;
		
		label.width = border.width;
		label.y = int((unscaledHeight - label.textHeight - 4)/2);
    }
    
	//--------------------------------------------------------------------------
    //  Internal
    //--------------------------------------------------------------------------
    
    /**
     * 	보더 생성
     */
    private function createBorder():DisplayObject {
		var borderClass:Class = replaceNullorUndefined(getStyle(StyleProp.BORDER_SKIN), Border);
		if( borderClass ) {
			var border:DisplayObject = createSkinBy(borderClass);
			border.width = isNaN(width) ? 100 : measureWidth;
			border.height = isNaN(height) ? 22 : measureHeight;
			
			if( border is Border )
				Border(border).styleName = getCSSStyleDeclaration();
				
			return border;
		}
		return null;
    }
    
    /**
     *  라벨 텍스트 
     */    
	private function setLabelText():void {
		var value:Number = _value;
		value = value > _maximum ? _maximum : value;
		value = value < _minimum ? _minimum : value;
		label.text = value.toString();
		_value = value;
	}
    
    /**
     * 	이벤트 리스너 등록
     */
    private function configureListeners():void {
    	addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, false, 0, true);
    	addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler, false, 0, true);
    	nextButton.addEventListener(MouseEvent.MOUSE_DOWN, nextButton_clickHandler, false, 0, true);
    	nextButton.addEventListener(GZMouseEvent.KEEP_MOUSE_PRESS, nextButton_clickHandler, false, 0, true);
    	prevButton.addEventListener(MouseEvent.MOUSE_DOWN, prevButton_clickHandler, false, 0, true);
    	prevButton.addEventListener(GZMouseEvent.KEEP_MOUSE_PRESS, prevButton_clickHandler, false, 0, true);
    }
    
    /**
     * 	@private
     */
    private function dispatchChange():void {
    	dispatchEvent(new Event(Event.CHANGE));
    }
    
	//--------------------------------------------------------------------------
	//
	//	Event handlers
	//
    //--------------------------------------------------------------------------
	
    /**
     *  키보드 입력
     */
    private function keyDownHandler(event:KeyboardEvent):void {
    	switch( event.keyCode ){
    		case Keyboard.ENTER:
		    	_value = Number(label.text);
		    	setLabelText();
		    	setFocus();
    			break;
    		
    		case Keyboard.UP:
	    		value += stepSize;
	    		dispatchChange();
    			break;
    			
    		case Keyboard.DOWN:
	    		value -= stepSize;
	    		dispatchChange();
    			break;
    	}
    }
    
    /**
     *  마우스 휠 
     */
    private function mouseWheelHandler(event:MouseEvent):void {
    	if( event.delta > 0 ) {
    		value += stepSize;
    		dispatchChange();
    	} else {
    		value -= stepSize;
    		dispatchChange();
    	}
    }
    
    /**
     *  다음 버튼 클릭
     */
    private function nextButton_clickHandler(event:MouseEvent):void {
    	value += stepSize;
		dispatchChange();
    }
    
    /**
     *  이전 버튼 클릭
     */
    private function prevButton_clickHandler(event:MouseEvent):void {
    	value -= stepSize;
		dispatchChange();
    }
    
    //--------------------------------------------------------------------------
	//
	//	getter / setter
	//
    //--------------------------------------------------------------------------
	
	//--------------------------------------
	//	value
	//--------------------------------------
	
	private var valueChanged:Boolean;
	
	private var _value:Number = 0;
	
	public function get value():Number {
		return _value;
	}
	
	public function set value(value:Number):void {
		if( _value == value )
			return;
		
		_value = value;
		valueChanged = true;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//	maximum
	//--------------------------------------
	
	private var maximumChanged:Boolean;
	
	private var _maximum:Number = 0;
	
	public function get maximum():Number {
		return _maximum;
	}
	
	public function set maximum(value:Number):void {
		if( _maximum == value )
			return;
		
		_maximum = value;
		maximumChanged = true;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//	minimum
	//--------------------------------------
	
	private var minimumChanged:Boolean;
	
	private var _minimum:Number = 0;
	
	public function get minimum():Number {
		return _minimum;
	}
	
	public function set minimum(value:Number):void {
		if( _minimum == value )
			return;
		
		_minimum = value;
		minimumChanged = true;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//	stepSize
	//--------------------------------------
	
	private var _stepSize:Number = 1;
	
	public function get stepSize():Number {
		return _stepSize;
	}
	
	public function set stepSize(value:Number):void {
		if( _stepSize == value )
			return;
		
		_stepSize = value;
	}
}

}