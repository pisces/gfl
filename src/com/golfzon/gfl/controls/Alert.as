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

import com.golfzon.gfl.containers.Panel;
import com.golfzon.gfl.core.ComponentBase;
import com.golfzon.gfl.events.CloseEvent;
import com.golfzon.gfl.managers.PopUpManager;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.events.MouseEvent;
import flash.text.TextFieldAutoSize;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *	Alert 인스턴스가 닫힐 때 송출한다.
 */
[Event(name="close", type="com.golfzon.gfl.events.CloseEvent")]

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *	버튼의 스타일명<br>
 * 	@default value none
 */
[Style(name="buttonStyleName", type="String", inherit="no")]

/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.11.12
 *	@Modify
 *	@Description
 * 	@includeExample		AlertSample.as
 */
public class Alert extends Panel
{
	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------

	/**
	 *  Value that enables a Yes button on the Alert control when passed
	 *  as the <code>flags</code> parameter of the <code>show()</code> method.
	 *  You can use the | operator to combine this bitflag
	 *  with the <code>OK</code>, <code>CANCEL</code>,
	 *  <code>NO</code>, and <code>NONMODAL</code> flags.
	 */
	public static const YES:uint = 0x0001;
	
	/**
	 *  Value that enables a No button on the Alert control when passed
	 *  as the <code>flags</code> parameter of the <code>show()</code> method.
	 *  You can use the | operator to combine this bitflag
	 *  with the <code>OK</code>, <code>CANCEL</code>,
	 *  <code>YES</code>, and <code>NONMODAL</code> flags.
	 */
	public static const NO:uint = 0x0002;
	
	/**
	 *  Value that enables an OK button on the Alert control when passed
	 *  as the <code>flags</code> parameter of the <code>show()</code> method.
	 *  You can use the | operator to combine this bitflag
	 *  with the <code>CANCEL</code>, <code>YES</code>,
	 *  <code>NO</code>, and <code>NONMODAL</code> flags.
	 */
	public static const OK:uint = 0x0004;
	
	/**
	 *  Value that enables a Cancel button on the Alert control when passed
	 *  as the <code>flags</code> parameter of the <code>show()</code> method.
	 *  You can use the | operator to combine this bitflag
	 *  with the <code>OK</code>, <code>YES</code>,
	 *  <code>NO</code>, and <code>NONMODAL</code> flags.
	 */
	public static const CANCEL:uint= 0x0008;

	/**
	 *  Value that makes an Alert nonmodal when passed as the
	 *  <code>flags</code> parameter of the <code>show()</code> method.
	 *  You can use the | operator to combine this bitflag
	 *  with the <code>OK</code>, <code>CANCEL</code>,
	 *  <code>YES</code>, and <code>NO</code> flags.
	 */
	public static const NONMODAL:uint = 0x8000;
	
	//--------------------------------------------------------------------------
	//
	//	Class variables
	//
	//--------------------------------------------------------------------------
	
	public static var buttonWidth:Number = 80;
	public static var buttonHeight:Number = 20;
	
	public static var okLabel:String = "확인";
	public static var cancelLabel:String = "취소";
	public static var yesLabel:String = "예";
	public static var noLabel:String = "아니오";
	
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	private var buttons:Array /* object */ = [];
	
	private var textField:UITextField;
	
	private var buttonContainer:ComponentBase;
	
	/**
	 *	@Constructor
	 */
	public function Alert() {
		super();
		
		minWidth = 250;
		minHeight = 50;
		
		setStyle(StyleProp.BORDER_THICKNESS, 1);
		setStyle(StyleProp.DROP_SHADOW_ENABLED, true);
		setStyle(StyleProp.PADDING_LEFT, 10);
		setStyle(StyleProp.PADDING_TOP, 10);
		setStyle(StyleProp.PADDING_RIGHT, 10);
		setStyle(StyleProp.PADDING_BOTTOM, 10);
	}
	
	//--------------------------------------------------------------------------
	//
	//	Class methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Public
	//--------------------------------------------------------------------------
	
	public static function show(
		text:String="", title:String="", flags:uint=0x4,
		closeHandler:Function=null, iconClass:Class=null):Alert {
		var alert:Alert = new Alert();
		alert.flags = flags;
		alert.title = title;
		alert.text = text;
		
		PopUpManager.addPopUp(alert, true);
		PopUpManager.centerPopUp(alert);
		
		if( closeHandler != null )
			alert.addEventListener(CloseEvent.CLOSE, closeHandler);
		
		if( iconClass )
			alert.setStyle(StyleProp.TITLE_ICON, iconClass);
			
		alert.invalidateDisplayList();

		return alert;
	}
	
	//--------------------------------------------------------------------------
	//
	//	Instnace methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Overriden : Panel
	//--------------------------------------------------------------------------
	
	/**
	 * 	프로퍼티 변경 사항에 대한 처리
	 */
	override protected function commitProperties():void {
		super.commitProperties();
		
		if( buttonModeChanged ) {
			buttonModeChanged = false;
			for each( var button:Button in buttons ) {
				button.buttonMode = buttonMode;
			}
		}
		
		if( flagsChanged ) {
			flagsChanged = false;
			removeButtons();
			createButtons();
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
		
		textField = new UITextField();
		textField.autoSize = TextFieldAutoSize.LEFT;
		textField.editable = false;
		textField.text = text;
		
		buttonContainer = new ComponentBase();
		
		addChild(textField);
		addChild(buttonContainer);
	}
	
	/**
	 * 	컴퍼넌트의 기본 크기와 최소 크기를 설정한다.
	 */
	override protected function measure():void {
		var borderThickness:Number = getBorderThickness();
		var verticalGap:Number = replaceNullorUndefined(getStyle(StyleProp.VERTICAL_GAP), 10);
		var bw:Number = Alert.buttonWidth * buttons.length + ((buttons.length - 1) * 5);
		var aw:Number = Math.max(bw, textField.measuredWidth);
		var w:Number = aw + viewMetrics.left + viewMetrics.right + borderThickness * 2;
		var h:Number = headerHeight + textField.measuredHeight + viewMetrics.top + viewMetrics.bottom + borderThickness * 2 + Alert.buttonHeight + verticalGap;
		textField.width = textField.measuredWidth;
		textField.height = textField.measuredHeight;
		measureWidth = w;
		measureHeight = h;
		
		setActureSize(unscaledWidth, unscaledHeight);
		updateContentPaneChildProperties();
	}
	
	/**
	 *	스타일 프로퍼티로 값을 설정한다.
	 */
	override public function styleChanged(styleProp:String):void {
		super.styleChanged(styleProp);

		switch( styleProp ) {
			case StyleProp.BUTTON_STYLE_NAME:
				for each( var button:Button in buttons ) {
					button.styleName = getStyle(styleProp);
				}
				break;
	 	}
	}
	
	/**
	 * 	디스플레이 변경 사항에 대한 처리
	 */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		var borderThickness:Number = getBorderThickness();
		buttonContainer.width = Alert.buttonWidth * buttons.length + ((buttons.length - 1) * 5);
		buttonContainer.height = Alert.buttonHeight;
		buttonContainer.x = Math.floor(((unscaledWidth - viewMetrics.left - viewMetrics.right - borderThickness * 2) - buttonContainer.width) / 2);

		var i:uint = 0;
		for each( var button:Button in buttons ) {
			button.x = i * Alert.buttonWidth + (i * 5);
			i++;
		}
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	/**
	 * 	@private
	 */
	private function createButton(label:String):Button {
		var button:Button = new Button();
		button.buttonMode = buttonMode;
		button.label = label;
		button.width = Alert.buttonWidth;
		button.height = Alert.buttonHeight;
		button.styleName = getStyle(StyleProp.BUTTON_STYLE_NAME);
		button.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		return Button(buttonContainer.addChild(button));
	}
	
	/**
	 * 	@private
	 */
	private function createButtons():void {
		if( flags & Alert.OK )
			buttons[buttons.length] = createButton(Alert.okLabel);
		
		if( flags & Alert.CANCEL )
			buttons[buttons.length] =  createButton(Alert.cancelLabel);
		
		if( flags & Alert.YES )
			buttons[buttons.length] =  createButton(Alert.yesLabel);
		
		if( flags & Alert.NO )
			buttons[buttons.length] =  createButton(Alert.noLabel);
	}
	
	/**
	 * 	@private
	 */
	private function getDetailBy(label:String):int {
		if( label == Alert.okLabel )		return 0x0004;
		if( label == Alert.cancelLabel )	return 0x0008;
		if( label == Alert.yesLabel )		return 0x0001;
		if( label == Alert.noLabel )		return 0x0002;
		return 0;
	}
	
	/**
	 * 	@private
	 */
	private function removeButtons():void {
		for each( var button:Button in buttons ) {
			buttonContainer.removeChild(button);
		}
		buttons = [];
	}
	
	//--------------------------------------------------------------------------
	//
	//	Event handlers
	//
	//--------------------------------------------------------------------------
	
	/**
	 * 	@private
	 */
	private function clickHandler(event:MouseEvent):void {
		var label:String = Button(event.currentTarget).label;
		PopUpManager.removePopUp(this);
		dispatchEvent(new CloseEvent(CloseEvent.CLOSE, false, false, getDetailBy(label)));
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//  buttonMode
	//--------------------------------------
	
	private var buttonModeChanged:Boolean;
	
	private var _buttonMode:Boolean = true;
	
	override public function get buttonMode():Boolean {
		return _buttonMode;
	}
	
	override public function set buttonMode(value:Boolean):void {
		if( value == _buttonMode )
			return;
		
		_buttonMode = value;
		buttonModeChanged = true;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//  flags
	//--------------------------------------
	
	private var flagsChanged:Boolean;
	
	private var _flags:uint;
	
	public function get flags():uint {
		return _flags;
	}
	
	public function set flags(value:uint):void {
		if( value == _flags )
			return;
		
		_flags = value;
		flagsChanged = true;
		
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