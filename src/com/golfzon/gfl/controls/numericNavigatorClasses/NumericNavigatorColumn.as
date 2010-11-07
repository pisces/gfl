////////////////////////////////////////////////////////////////////////////////
//
//  PISCES
//  Copyright(c) PISCES.CO.,LTD.
//  All Rights Reserved.
//
//  NOTICE: PISCES permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.golfzon.gfl.controls.numericNavigatorClasses
{
	
import com.golfzon.gfl.controls.UITextField;
import com.golfzon.gfl.core.ComponentBase;
import com.golfzon.gfl.core.ISelectable;
import com.golfzon.gfl.styles.StyleProp;

import flash.events.MouseEvent;

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *	보통 상태일 때의 레이블 스타일명<br>
 *	@default value none
 */
[Style(name="textStyleName", type="String", inherit="no")]

/**
 *	롤오버 상태일 때의 레이블 스타일명<br>
 *	@default value none
 */
[Style(name="textRollOverStyleName", type="String", inherit="no")]

/**
 *	선택 상태일 때의 레이블 스타일명<br>
 *	@default value none
 */
[Style(name="textSelectionStyleName", type="String", inherit="no")]

/**
 *	@Author				KHKim
 *	@Version			1.0
 *	@Lanaguage			Action Script 3.0
 *	@Date				2010. 4. 29.
 *	@Modify
 *	@Description
 */
public class NumericNavigatorColumn extends ComponentBase implements ISelectable
{
	//--------------------------------------------------------------------------
	//
	//  Instance variables
	//
	//--------------------------------------------------------------------------
	
	private var label:UITextField;
	
	/**
	 *	@Constructor
	 */
	public function NumericNavigatorColumn() {
		super();
		
		addEventListener(MouseEvent.ROLL_OVER, rollOverHandler, false, 0, true);
		addEventListener(MouseEvent.ROLL_OUT, rollOutHandler, false, 0, true);
	}
	
	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Overriden : SimpleButton
	//--------------------------------------------------------------------------
	
	/**
	 * 	프로퍼티 변경 사항에 대한 처리
	 */
	override protected function commitProperties():void {
		super.commitProperties();
		
		if( selectionChanged ) {
			selectionChanged = false;
			label.styleName = _selected?
				getStyle(StyleProp.TEXT_SELECTION_STYLE_NAME):
				getStyle(StyleProp.TEXT_STYLE_NAME);
		}
		
		if( textChanged ) {
			textChanged = false;
			label.text = _text;
		}
	}
	
	/**
	 * 	자식 객체 생성 및 추가
	 */
	override protected function createChildren():void {
		label = new UITextField();
		label.mouseEnabled = false;
		label.selectable = false;
		label.text = _text;
		label.styleName = getStyle(StyleProp.TEXT_STYLE_NAME);
		addChild(label);
	}
	
	/**
	 * 	컴퍼넌트의 기본 크기와 최소 크기를 설정한다.
	 */
	override protected function measure():void {
		super.measure();
		
		measureWidth = label.measuredWidth + 4;
		
		setActualSize(unscaledWidth, unscaledHeight);
	}
	
	/**
	 * 	디스플레이 변경 사항에 대한 처리
	 */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		if( !invalidSize() ) {
			label.width = unscaledWidth;
			label.height = label.measuredHeight;
			label.y = (unscaledHeight - label.height)/2;
			
			drawBackground();
		}
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	private function drawBackground():void {
		graphics.clear();
		graphics.beginFill(0x0, 0);
		graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
		graphics.endFill();
	}
	
	//--------------------------------------------------------------------------
	//
	//	Event handlers
	//
	//--------------------------------------------------------------------------
	
	private function rollOverHandler(event:MouseEvent):void {
		if( !_selected )
			label.styleName = getStyle(StyleProp.TEXT_ROLL_OVER_STYLE_NAME);
	}
	
	private function rollOutHandler(event:MouseEvent):void {
		if( !_selected )
			label.styleName = getStyle(StyleProp.TEXT_STYLE_NAME);
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//	selected
	//--------------------------------------
	
	private var selectionChanged:Boolean;
	
	private var _selected:Boolean;
	
	public function get selected():Boolean {
		return _selected;
	}
	
	public function set selected(value:Boolean):void {
		if( value == _selected )
			return;
		
		_selected = value;
		selectionChanged = true;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//	text
	//--------------------------------------
	
	private var textChanged:Boolean;
	
	private var _text:String = "";
	
	public function get text():String {
		return _text;
	}
	
	public function set text(value:String):void {
		if( value == _text )
			return;
		
		_text = value;
		textChanged = true;
		
		invalidateProperties();
		invalidateDisplayList();
	}
}
	
}