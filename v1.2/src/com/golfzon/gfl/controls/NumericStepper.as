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
import com.golfzon.gfl.core.BorderBasedComponent;
import com.golfzon.gfl.core.gz_internal;
import com.golfzon.gfl.events.GZMouseEvent;
import com.golfzon.gfl.skins.Border;
import com.golfzon.gfl.styles.StyleProp;

import flash.events.Event;
import flash.events.FocusEvent;
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
 *	@Author				SH Jung
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.11.09
 *	@Modify
 *	@Description
 * 	@includeExample		NumericStepperSample.as
 */
public class NumericStepper extends BorderBasedComponent
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	private var nextButtonInstance:NumericStepperButton;
	private var prevButtonInstance:NumericStepperButton;
	private var labelInstance:UITextField;
	
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
		
		if( buttonModeChanged ) {
			buttonModeChanged = false;
			nextButtonInstance.buttonMode = prevButtonInstance.buttonMode = _buttonMode;
		}
	}
	
	/**
	 * 	컴퍼넌트의 기본 크기와 최소 크기를 설정한다.
	 */
	override protected function measure():void {
		super.measure();
		
		measureWidth = isNaN(width) ? 100 : measureWidth;
		measureHeight = isNaN(height) ? 23 : measureHeight;
		
		setActualSize(unscaledWidth, unscaledHeight);
	}
	
	/**
	 * 	자식 객체 생성 및 추가
	 */
	override protected function createChildren():void {
		super.createChildren();
		
		nextButtonInstance = new NumericStepperButton();
		nextButtonInstance.direction = NumericStepperButton.NEXT;
		nextButtonInstance.styleName = getStyle(StyleProp.NEXT_BUTTON_STYLE_NAME);
		
		prevButtonInstance = new NumericStepperButton();
		prevButtonInstance.direction = NumericStepperButton.PREV;
		prevButtonInstance.styleName = getStyle(StyleProp.PREV_BUTTON_STYLE_NAME);
		
		labelInstance = new UITextField();
		labelInstance.multiline = false;
		labelInstance.restrict = "0-9 ."
		setLabelText();
		
		configureListeners();
		addChild(nextButtonInstance);
		addChild(prevButtonInstance);
		addChild(labelInstance);
	}
	
	/**
	 *	enabled에 따른 구현
	 */
	override protected function setStateToChangeEnabled():void {
		super.setStateToChangeEnabled();
		
		nextButtonInstance.enabled = enabled;
		prevButtonInstance.enabled = enabled;
		labelInstance.enabled = enabled;
	}
	
	/**
	 *	스타일 프로퍼티로 값을 설정한다.
	 */
	override public function styleChanged(styleProp:String):void {
		super.styleChanged(styleProp);
		
		switch( styleProp ) {
			case StyleProp.NEXT_BUTTON_STYLE_NAME:
				nextButtonInstance.styleName = getStyle(StyleProp.NEXT_BUTTON_STYLE_NAME);
				break;
				
			case StyleProp.PREV_BUTTON_STYLE_NAME:
				nextButtonInstance.styleName = getStyle(StyleProp.PREV_BUTTON_STYLE_NAME);
				break;
		}
	}
	
	/**
	 * 	디스플레이 변경 사항에 대한 처리
	 */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		var bt:Number = border is Border ? Border(border).borderThickness : 0;
		
		border.width = nextButtonInstance.currentSkin ? unscaledWidth - nextButtonInstance.currentSkin.width + bt : unscaledWidth;
		
		var buttonHeight:Number = Math.round((unscaledHeight+bt) / 2);
		nextButtonInstance.height = buttonHeight;
		nextButtonInstance.x = border.width - bt;
		
		prevButtonInstance.height = buttonHeight;
		prevButtonInstance.x = border.width - bt;
		prevButtonInstance.y = unscaledHeight + bt - buttonHeight;
		
		labelInstance.width = border.width - viewMetrics.left - bt*2;
		labelInstance.height = unscaledHeight;
		labelInstance.x = viewMetrics.left + bt;
		labelInstance.y = int((unscaledHeight - labelInstance.textHeight - 4)/2);
	}
	
	private var buttonModeChanged:Boolean;
	
	private var _buttonMode:Boolean;
	
	override public function set buttonMode(value:Boolean):void {
		if (value == _buttonMode)
			return;
		
		_buttonMode = value;
		buttonModeChanged = true;
		invalidateProperties();
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	/**
	 *  라벨 텍스트 
	 */	
	private function setLabelText():void {
		var value:Number = _value;
		value = value > _maximum ? _maximum : value;
		value = value < _minimum ? _minimum : value;
		labelInstance.text = value.toString();
		_value = value;
	}
	
	/**
	 * 	이벤트 리스너 등록
	 */
	private function configureListeners():void {
		addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, false, 0, true);
		addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler, false, 0, true);
		nextButtonInstance.addEventListener(MouseEvent.MOUSE_DOWN, nextButtonInstance_clickHandler, false, 0, true);
		nextButtonInstance.addEventListener(GZMouseEvent.KEEP_MOUSE_PRESS, nextButtonInstance_clickHandler, false, 0, true);
		prevButtonInstance.addEventListener(MouseEvent.MOUSE_DOWN, prevButtonInstance_clickHandler, false, 0, true);
		prevButtonInstance.addEventListener(GZMouseEvent.KEEP_MOUSE_PRESS, prevButtonInstance_clickHandler, false, 0, true);
	}
	
	private function dispatchChange():void {
		dispatchEvent(new Event(Event.CHANGE));
	}
	
	//--------------------------------------------------------------------------
	//
	//	Event handlers
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  포커스 아웃 
	 */
	override protected function focusOutHandler(event:FocusEvent):void {
		_value = Number(labelInstance.text);
		setLabelText();
	}
	
	/**
	 *  키보드 입력
	 */
	private function keyDownHandler(event:KeyboardEvent):void {
		switch( event.keyCode ){
			case Keyboard.ENTER:
				_value = Number(labelInstance.text);
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
	private function nextButtonInstance_clickHandler(event:MouseEvent):void {
		value += stepSize;
		dispatchChange();
	}
	
	/**
	 *  이전 버튼 클릭
	 */
	private function prevButtonInstance_clickHandler(event:MouseEvent):void {
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
	
	private var _maximum:Number = 100;
	
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