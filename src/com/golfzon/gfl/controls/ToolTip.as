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
  	
import com.golfzon.gfl.core.Container;
import com.golfzon.gfl.core.IUITextFieldClient;
import com.golfzon.gfl.core.ScrollPolicy;
import com.golfzon.gfl.events.TextEvent;
import com.golfzon.gfl.styles.StyleProp;

import flash.text.TextFieldAutoSize;

//--------------------------------------
//  Styles
//--------------------------------------

/**
 * 
 *	Duration for transition of showing<br>
 * 	default : 0.8
 * 
 */
[Style(name="showDuration", type="Number", inherit="no")]

/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.08.20
 *	@Modify
 *	@Description
 */
public class ToolTip extends Container implements IUITextFieldClient
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
	public function ToolTip() {
		super();
		
		horizontalScrollPolicy = verticalScrollPolicy = ScrollPolicy.OFF;
	}
	
    //--------------------------------------------------------------------------
	//
	//	Class methods
	//
    //--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------
    //  Public
    //--------------------------------------------------------------------------
    
    public static function create(text:String):ToolTip {
    	var instance:ToolTip = new ToolTip();
    	instance.text = text;
    	return instance;
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
    	textField.selectable = false;
    	textField.text = text;
    	
    	textField.addEventListener(
    		TextEvent.TEXT_FORMAT_CHANGED, textFormatChangedHandler, false, 0, true);
    	addChild(textField);
    }
    
    /**
     * 	컴퍼넌트의 기본 크기와 최소 크기를 설정한다.
     */
    override protected function measure():void {
    	super.measure();

    	if( !widthChanged )
    		measureWidth = textField.measuredWidth + viewMetrics.left + viewMetrics.right;
    	
    	if( !heightChanged )
    		measureHeight = textField.measuredHeight + viewMetrics.top + viewMetrics.bottom;
    		
    	setActureSize(unscaledWidth, unscaledHeight);
    }
    
    /**
     *	스타일 프로퍼티로 값을 설정한다.
     */
    override public function styleChanged(styleProp:String):void {
    	super.styleChanged(styleProp);

    	switch( styleProp ) {
    		case StyleProp.PADDING_LEFT: case StyleProp.PADDING_TOP:
    		case StyleProp.PADDING_RIGHT: case StyleProp.PADDING_BOTTOM:
    			invalidateDisplayList();
    			break;
     	}
    }
    
    /**
     * 	디스플레이 변경 사항에 대한 처리
     */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
    	super.updateDisplayList(unscaledWidth, unscaledHeight);
    	
    	textField.x = viewMetrics.left;
    	textField.y = viewMetrics.right;
    }
    
    //--------------------------------------------------------------------------
    //	Public
    //--------------------------------------------------------------------------
    
    /**
     *	UITextField 인스턴스를 반환한다.
     */
    public function getTextField():UITextField {
    	return textField;
    }
    
    //--------------------------------------------------------------------------
	//
	//	Event handlers
	//
    //--------------------------------------------------------------------------
	
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
	//	text
	//--------------------------------------
	
	private var textChanged:Boolean;
	
	private var _text:String;
	
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