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
import com.golfzon.gfl.core.IUITextFieldClient;
import com.golfzon.gfl.core.gz_internal;
import com.golfzon.gfl.events.TextEvent;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.display.BitmapData;
import flash.display.Shape;
import flash.events.MouseEvent;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

use namespace gz_internal;

//--------------------------------------
//  Styles
//--------------------------------------

/**
 * 
 *	@Include the external file to define padding styles.
 *
 */
include "../styles/metadata/PaddingStyles.as";

/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.10.04
 *	@Modify
 *	@Description
 * 	@includeExample		LabelSample.as
 */
public class Label extends ComponentBase implements IUITextFieldClient
{
    //--------------------------------------------------------------------------
	//
	//	Instance variables
	//
    //--------------------------------------------------------------------------
    
	gz_internal var textField:UITextField;
	
	private var replaced:Boolean;
    
    private var maskShape:Shape;
	
	/**
	 *	@Constructor
	 */
	public function Label() {
		super();
		
		configureListeners();
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
     * 	프로퍼티 변경 사항에 대한 처리
     */
    override protected function commitProperties():void {
    	super.commitProperties();
    	
    	if( selectableChanged ) {
    		selectableChanged = false
    		textField.selectable = selectable;
    	}
    	
    	if( textChanged ) {
    		textChanged = false;
    		textField.htmlText = text;
    	}
    }
    
    /**
     * 	자식 객체 생성 및 추가
     */
    override protected function createChildren():void {
    	maskShape = new Shape();
    	
    	textField = new UITextField();
    	textField.multiline = textField.selectable = textField.editable = false;
    	textField.text = text;
    	
    	mask = maskShape;
    	
    	addChild(maskShape);
    	textField.addEventListener(
    		TextEvent.TEXT_FORMAT_CHANGED, textFormatChangedHandler, false, 0, true);
    	addChild(textField);
		setViewMetrics();
    }
    
    /**
     *	스타일 프로퍼티로 값을 설정한다.
     */
    override public function styleChanged(styleProp:String):void {
    	super.styleChanged(styleProp);
    	
    	switch( styleProp ) {
    		case StyleProp.PADDING_LEFT:	case StyleProp.PADDING_TOP:
    		case StyleProp.PADDING_RIGHT:	case StyleProp.PADDING_BOTTOM:
    			setViewMetrics();
    			invalidateDisplayList();
    			break;
    			
    		case StyleProp.TEXT_ALIGN:
				setLabelTextFormat();
    			invalidateDisplayList();
	    		break;
     	}

    }
    
    /**
     * 	컴퍼넌트의 기본 크기와 최소 크기를 설정한다.
     */
    override protected function measure():void {
    	super.measure();
    	
    	textField.autoSize = widthChanged || heightChanged ? TextFieldAutoSize.NONE : TextFieldAutoSize.LEFT;
    	
    	if( !widthChanged )
    		measureWidth = textField.measuredWidth + viewMetrics.left + viewMetrics.right;
    	
    	if( !heightChanged )
    		measureHeight = textField.measuredHeight + viewMetrics.top + viewMetrics.bottom;
    	
    	setActureSize(unscaledWidth, unscaledHeight);
    }
    
    /**
     * 	디스플레이 변경 사항에 대한 처리
     */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
	    textField.width = unscaledWidth - viewMetrics.left - viewMetrics.right;
	    textField.height = textField.measuredHeight;
	    textField.x = viewMetrics.left;
	    textField.y = int((unscaledHeight - textField.height) / 2);
	    
		drawMaskShape();
    	replaceText();
    }
    
    //--------------------------------------------------------------------------
    //  Public
    //--------------------------------------------------------------------------
    
    /**
     *	UITextField 인스턴스를 반환한다.
     */
    public function getTextField():UITextField {
    	return textField;
    }
    
    /**
     *	TextField 인스턴스의 TextFormat을 반환한다.
     */
    public function getTextFormat():TextFormat {
    	if( !textField )
    		return null;
    	return textField.getTextFormat();
    }
    
    //--------------------------------------------------------------------------
    //  Internal
    //--------------------------------------------------------------------------
    
	/**
	 *	@private
	 */
    private function configureListeners():void {
    	addEventListener(MouseEvent.ROLL_OUT, rollOutHandler, false, 0, true);
    	addEventListener(MouseEvent.ROLL_OVER, rollOverHandler, false, 0, true);
    }
    
	/**
	 *	@private
	 */
    private function drawMaskShape():void {
    	if( isNaN(width) || isNaN(height) )
    		return;
    	
    	maskShape.graphics.clear();
    	maskShape.graphics.beginBitmapFill(new BitmapData(1, 1, false));
    	maskShape.graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
    	maskShape.graphics.endFill();
    }
    
    /**
     *	@private
     */
	private function replaceText():void {
		if( !textField.getCharBoundaries(0) )
			return;
		
		if( textField.textWidth > textField.width - 2 ) {
			var charWidth:Number = textField.getCharBoundaries(0).width;
			var lp:Number = Number(textField.getTextFormat().letterSpacing);
			var px:Number = textField.x + textField.width - (charWidth*2) - lp;
			var charIndex:int = textField.getCharIndexAtPoint(px, 10);
			replaced = charIndex > -1;
			
			if( replaced ) {
				textField.replaceText(charIndex, textField.htmlText.length-1, "...");
				textField.setTextFormat(textField.getTextFormat(0));
			}
		}
	}
    
	/**
	 *	@private
	 */
    private function setLabelTextFormat():void {
		var align:String = replaceNullorUndefined(getStyle(StyleProp.TEXT_ALIGN), "left");
		var format:TextFormat = getTextFormat();
		
		if( format ) {
			format.align = align;
			textField.setTextFormat(format);
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
     *	@private
     */
    private function rollOutHandler(event:MouseEvent):void {
    	tooltip = null;
    }
    
    /**
     *	@private
     */
    private function rollOverHandler(event:MouseEvent):void {
    	if( replaced && !event.buttonDown )
    		tooltip = text;
    }
    
    /**
     *	@private
     */
    private function textFormatChangedHandler(event:TextEvent):void {
    	invalidateDisplayList();
    }
    
    //--------------------------------------------------------------------------
	//
	//	getter / setter
	//
    //--------------------------------------------------------------------------
	
	//--------------------------------------
	//	label
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
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	selectable
	//--------------------------------------
	
	private var selectableChanged:Boolean;
	
	private var _selectable:Boolean;
	
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
	//  textWidth
	//--------------------------------------
	
	public function get textWidth():Number {
		return textField ? textField.textWidth : NaN;
	}
	
	//--------------------------------------
	//  textHeight
	//--------------------------------------
	
	public function get textHeight():Number {
		return textField ? textField.textHeight : NaN;
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