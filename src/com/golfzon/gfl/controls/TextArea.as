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

import com.golfzon.gfl.core.EdgeMetrics;
import com.golfzon.gfl.core.ScrollControlBase;
import com.golfzon.gfl.core.ScrollPolicy;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.events.Event;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *	텍스트가 변경되었을 때 송출한다.
 */
[Event(name="change", type="flash.events.Event")]

/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.10.17
 *	@Modify
 *	@Description
 * 	@includeExample		TextAreaSample.as
 */
public class TextArea extends ScrollControlBase
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
	public function TextArea() {
		super();
		
		horizontalScrollPolicy = ScrollPolicy.OFF;
	}
	
	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Overriden : ScrollControlBase
	//--------------------------------------------------------------------------
	
	/**
	 * 	프로퍼티 변경 사항에 대한 처리
	 */
	override protected function commitProperties():void {
		super.commitProperties();
		
		if( editableChanged ) {
			editableChanged = false;
			textField.editable = editable;
		}
		
		if( maxCharsChanged ) {
			maxCharsChanged = false;
			textField.maxChars = maxChars;
		}
		
		if( restrictChanged ) {
			restrictChanged = false;
			textField.restrict = restrict;
		}
		
		if( selectableChanged ) {
			selectableChanged = false;
			textField.selectable = selectable;
		}
		
		if( htmlTextChanged ) {
			htmlTextChanged = false;
			textField.htmlText = htmlText;
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
		textField.multiline = textField.wordWrap = textField.useRichTextClipboard = true;
		textField.editable = editable;
		textField.maxChars = maxChars;
		textField.restrict = restrict;
		textField.selectable = selectable;
		textField.text = text;
		
		setViewMetrics();
		configureListeners();
		addChild(textField);
	}
	
	/**
	 * 	TextField 인스턴스를 스크롤한다.
	 */
	override protected function scrollTarget():void {
		textField.scrollV = verticalScrollPosition + 1;
	}
	
	/**
	 * 	포커스를 설정한다.
	 */
	override public function setFocus():void {
		stage.focus = textField;
	}
	
	/**
	 *	스타일 프로퍼티로 값을 설정한다.
	 */
	override public function styleChanged(styleProp:String):void {
		super.styleChanged(styleProp);

		switch( styleProp ) {
			case StyleProp.PADDING_LEFT: case StyleProp.PADDING_TOP:
			case StyleProp.PADDING_RIGHT: case StyleProp.PADDING_BOTTOM:
				setViewMetrics();
				invalidateDisplayList();
				break;
	 	}
	}
	
	/**
	 * 	디스플레이 변경 사항에 대한 처리
	 */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		var borderThickness:Number = getBorderThickness();
		var tw:Number = getActureWidth();
		var th:Number = getActureHeight();
		var addend:Number = textField.measuredHeight > th ? 14 : 0;
		tw -= addend;

		textField.width = tw;
		textField.height = th;
		textField.x = viewMetrics.left + borderThickness;
		textField.y = viewMetrics.top + borderThickness;

		setScrollBars(textField.measuredWidth, tw, textField.measuredHeight, th);
		getVScrollBar().lineScrollSize = textField.getLineMetrics(0).height;
		setScrollBarProperties(tw, tw, textField.measuredHeight, th);
	}
	
	//--------------------------------------------------------------------------
	//  Public
	//--------------------------------------------------------------------------
	
	/**
	 *	선택된 텍스트를 복사하여 클립보드에 저장한다.
	 */
	public function copy():void {
		textField.copy();
	}
	
	/**
	 *	선택된 텍스트에 잘라내기를 실행하여 클립보드에 저장한다.
	 */
	public function cut():void {
		textField.cut();
	}
	
	/**
	 *	클립보드에 저장된 텍스트를 붙여넣기 한다.
	 */
	public function paste():void {
		textField.paste();
	}
	
	/**
	 *	선택된 텍스트를 지운다.
	 */
	public function remove():void {
		textField.remove();
	}
	
	/**
	 *	모든 텍스트를 선택한다.
	 */
	public function selectAll():void {
		textField.selectAll();
	}
	
	/**
	 *	다시 실행
	 */
	public function redo():void {
		if( textField.isEmptyRedoBuffer() )
			throw new Error("redo를 실행할 리스트가 없습니다.");
		textField.redo();
	}
	
	/**
	 *	실행 취소
	 */
	public function undo():void {
		if( textField.isEmptyUndoBuffer() )
			throw new Error("undo를 실행할 리스트가 없습니다.");
		textField.undo();
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	/**
	 *	@private
	 */
	private function configureListeners():void {
		textField.addEventListener(Event.CHANGE, textField_changeHandler, false, 0, true);
		textField.addEventListener(Event.SCROLL, textField_scrollHandler, false, 0, true);
	}
	
	/**
	 *	@private
	 */
	private function getActureWidth():Number {
		if( !unscaledWidth ) {
			measureWidth = textField.measuredWidth + viewMetrics.left + viewMetrics.right + getBorderThickness() * 2;
			setActureSize(measureWidth, unscaledHeight);
			return measureWidth;
		}
		return unscaledWidth - viewMetrics.left - viewMetrics.right - getBorderThickness() * 2;
	}
	
	/**
	 *	@private
	 */
	private function getActureHeight():Number {
		if( !unscaledHeight ) {
			measureHeight = textField.measuredHeight + viewMetrics.top + viewMetrics.bottom + getBorderThickness() * 2;
			setActureSize(unscaledWidth, measureHeight);
			return measureHeight;
		}
		return unscaledHeight - viewMetrics.top - viewMetrics.bottom - getBorderThickness() * 2;
	}
	
	/**
	 * 	@private
	 */
	private function getTextFieldAutoSize():String {
		return textField.measuredHeight > getValidTextHeight() ? TextFieldAutoSize.LEFT : TextFieldAutoSize.NONE;
	}
	
	/**
	 *	@private
	 */
	private function getValidTextHeight():Number {
		return unscaledHeight - viewMetrics.top - viewMetrics.bottom - getBorderThickness() * 2;
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
	 *	@private
	 */
	private function textField_changeHandler(event:Event):void {
		_text = textField.text;
		
		invalidateDisplayList();
		dispatchEvent(event.clone());
	}
	
	/**
	 *	@private
	 */
	private function textField_scrollHandler(event:Event):void {
		verticalScrollPosition = 0;
		verticalScrollPosition = textField.scrollV - 1;
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//  editable
	//--------------------------------------
	
	private var editableChanged:Boolean;
	
	private var _editable:Boolean = true;
	
	public function get editable():Boolean {
		return _editable;
	}
	
	public function set editable(value:Boolean):void {
		if( value == _editable )
			return;
		
		_editable = value;
		editableChanged = true;
		
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
	//  selectable
	//--------------------------------------
	
	private var selectableChanged:Boolean;
	
	private var _selectable:Boolean = true;
	
	public function get selectable():Boolean {
		return _selectable;
	}
	
	public function set selectable(value:Boolean):void {
		if( value == _selectable )
			return;
		
		_selectable = value;
		selectableChanged = true;
		
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
	
	//--------------------------------------
	//  viewMetrics
	//--------------------------------------
	
	private var _viewMetrics:EdgeMetrics;
	
	public function get viewMetrics():EdgeMetrics {
		return _viewMetrics;
	}
	
	//--------------------------------------
	//  useScrollTween
	//--------------------------------------
	
	private var _useScrollTween:Boolean = true;
	
	public function get useScrollTween():Boolean {
		return _useScrollTween;
	}
	
	public function set useScrollTween(value:Boolean):void {
		_useScrollTween = value;
	}
	
	//--------------------------------------
	//  textFormat
	//--------------------------------------
	
	public function set textFormat(value:TextFormat):void {
		if( value == value ) {
			textField.setTextFormat(value);
		}
	}
}

}