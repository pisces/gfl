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

package com.golfzon.gfl.chart.helper
{

import com.golfzon.gfl.controls.UITextField;
import com.golfzon.gfl.core.ComponentBase;
import com.golfzon.gfl.skins.Border;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.display.DisplayObject;
import flash.text.TextFieldAutoSize;

/**
 *	@Author				SH Jung
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.11.12
 *	@Modify
 *	@Description
 */	
public class DataTip extends ComponentBase
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	private var borderInstance:DisplayObject;
	private var labelInstance:UITextField;
	
	/**
	 *	@Constructor
	 */
	public function DataTip(){
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Overriden : ComponentBase
	//--------------------------------------------------------------------------
	
	/**
	 * 	자식 객체 생성 및 추가
	 */
	override protected function createChildren():void {
		borderInstance = createBorder();
		
		labelInstance = new UITextField();
		labelInstance.autoSize = TextFieldAutoSize.LEFT;
		labelInstance.mouseEnabled = labelInstance.selectable = false;
		
		addChild(borderInstance);
		addChild(labelInstance);
	}
	
	/**
	 * 	컴퍼넌트의 기본 크기와 최소 크기를 설정한다.
	 */
	override protected function measure():void {
		super.measure();
		
		measureWidth = borderInstance.width;
		measureHeight = borderInstance.height;
		
		setActureSize(measureWidth, measureHeight);
	}
	
	/**
	 * 	프로퍼티 변경 사항에 대한 처리
	 */
	override protected function commitProperties():void {
		super.commitProperties();
	}
	
	/**
	 * 	디스플레이 변경 사항에 대한 처리
	 */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		if( labelChanged ) {
			labelChanged = false;
			labelInstance.htmlText = _label;
		}
		
		borderInstance.width = labelInstance.textWidth + 4;
		borderInstance.height = labelInstance.textHeight + 4;
		
		measure();
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
			
			if( border is Border ) {
				Border(border).styleName = getCSSStyleDeclaration();
			}
			return border;
		}
		return null;
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//	label
	//--------------------------------------
	
	protected var labelChanged:Boolean;
	
	protected var _label:String;
	
	public function get label():String {
		return _label;
	}
	
	public function set label(value:String):void {
		if( value == _label )
			return;
		
		_label = value;
		labelChanged = true;
		
		invalidateDisplayList();
	}
}

}