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
	
import com.golfzon.gfl.controls.buttonClasses.CheckButton;
import com.golfzon.gfl.core.ComponentBase;
import com.golfzon.gfl.core.gz_internal;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.events.Event;
import flash.events.MouseEvent;

use namespace gz_internal;

/**
 *	@Author				SH Jung
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.11.02
 *	@Modify
 *	@Description
 * 	@includeExample		CheckBoxSample.as
 */
public class CheckBox extends ComponentBase
{
    //--------------------------------------------------------------------------
	//
	//	Instance variables
	//
    //--------------------------------------------------------------------------
    
    /**
     *	버튼 인스턴스
     */
    private var buttonInstance:CheckButton;
    
    /**
     *	라벨 인스턴스
     */
    private var labelInstance:Label;
    
	/**
	 *	@Constructor
	 */
	public function CheckBox() {
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
     * 	프로퍼티 변경 사항에 대한 처리
     */
    override protected function commitProperties():void {
    	super.commitProperties();
    	
    	if( labelChanged ) {
    		labelChanged = false;
    		labelInstance.text = label;
    	}
    }
    
    /**
     * 	자식 객체 생성 및 추가
     */
    override protected function createChildren():void {
    	super.createChildren();
    	
    	buttonInstance = new CheckButton();
    	buttonInstance.selected = _selected;
    	buttonInstance.styleName = getStyle(StyleProp.BUTTON_STYLE_NAME);
    	
    	labelInstance = new Label();
    	labelInstance.text = label;
    	
    	configureListeners();
    	addChild(buttonInstance);
    	addChild(labelInstance);
    	
    }
    
    /**
     * 	컴퍼넌트의 기본 크기와 최소 크기를 설정한다.
     */
    override protected function measure():void {
    	super.measure();
    	
		if( !widthChanged )
    		measureWidth = buttonInstance.width + labelInstance.width + replaceNullorUndefined(getStyle(StyleProp.TEXT_INDENT), 0);
    	
		if( !heightChanged )
    		measureHeight = buttonInstance.height > labelInstance.height ? buttonInstance.height : labelInstance.height;
    	
    	setActureSize(unscaledWidth, unscaledHeight);
    }
	
    /**
     *	enabled에 따른 구현
     */
	override protected function setEnabledState():void {
		super.setEnabledState();
		
		buttonInstance.enabled = enabled;
		labelInstance.enabled = enabled;
	}
    
    /**
     *	스타일 프로퍼티로 값을 설정한다.
     */
    override public function styleChanged(styleProp:String):void {
    	super.styleChanged(styleProp);
    	
    	switch( styleProp ) {
    		case StyleProp.BUTTON_STYLE_NAME:
    			buttonInstance.styleName = getStyle(StyleProp.BUTTON_STYLE_NAME);
    			break;
     	}
    }
    
    /**
     * 	디스플레이 변경 사항에 대한 처리
     */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
    	super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		labelInstance.width = unscaledWidth - buttonInstance.width - replaceNullorUndefined(getStyle(StyleProp.TEXT_INDENT), 0);
		labelInstance.x = int(buttonInstance.width + replaceNullorUndefined(getStyle(StyleProp.TEXT_INDENT), 0));
		labelInstance.y = int((buttonInstance.height - labelInstance.textHeight - 4)/2);
    }
    
    //--------------------------------------------------------------------------
    //  Internal
    //--------------------------------------------------------------------------
    
    /**
     *  이벤트 리스너 등록
     */
    private function configureListeners():void {
		addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true);
		addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler, false, 0, true);
		addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler, false, 0, true);
		addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
    	buttonInstance.addEventListener(Event.CHANGE, buttonInstance_changeHandler, false, 0, true);
    }
    
    /**
     *	@private
     *	페이즈에 따른 텍스트의 색상을 반환한다.
     */
    private function getTextColor():uint {
    	if( buttonInstance.gz_internal::phase == buttonInstance.gz_internal::PHASE_OVER )
    		return replaceNullorUndefined(getStyle(StyleProp.TEXT_ROLL_OVER_COLOR), 0x666666);
    	if( buttonInstance.gz_internal::phase == buttonInstance.gz_internal::PHASE_DOWN )
    		return replaceNullorUndefined(getStyle(StyleProp.TEXT_SELECTED_COLOR), 0x000000);
    	return replaceNullorUndefined(getStyle(StyleProp.COLOR), 0x333333);
    }
    
    //--------------------------------------------------------------------------
	//
	//	Event handlers
	//
    //--------------------------------------------------------------------------
	
	/**
	 *  마우스 업
	 */
	private function mouseUpHandler(event:MouseEvent):void {
		if( event.target is UITextField ) {
			buttonInstance.selected = !buttonInstance.selected;
		}
		buttonInstance.setPhase(buttonInstance.gz_internal::PHASE_UP);
		labelInstance.setStyle(StyleProp.COLOR, getTextColor());
	}
	
	/**
	 *  마우스 오버
	 */
	private function mouseOverHandler(event:MouseEvent):void {
		if( buttonInstance.selected )
			return;
		
		buttonInstance.setPhase(buttonInstance.gz_internal::PHASE_OVER);
		labelInstance.setStyle(StyleProp.COLOR, getTextColor());
	}
	
	/**
	 *  마우스 아웃
	 */
	private function mouseOutHandler(event:MouseEvent):void {
		if( buttonInstance.selected )
			return;
		
		buttonInstance.setPhase(buttonInstance.gz_internal::PHASE_UP);
		labelInstance.setStyle(StyleProp.COLOR, getTextColor());
	}
	
	/**
	 *  마우스 다운
	 */
	private function mouseDownHandler(event:MouseEvent):void {
		if( buttonInstance.selected )
			return;
		
		buttonInstance.setPhase(buttonInstance.gz_internal::PHASE_DOWN);
		labelInstance.setStyle(StyleProp.COLOR, getTextColor());
	}
	
	/**
	 *  버튼 selected 변경 시 
	 */	
	private function buttonInstance_changeHandler(event:Event):void {
		dispatchEvent(event.clone());
	}
    
    //--------------------------------------------------------------------------
	//
	//	getter / setter
	//
    //--------------------------------------------------------------------------
	
	//--------------------------------------
	//	allowPhaseChange
	//--------------------------------------
	
	private var _allowPhaseChange:Boolean = true;
	
	public function get allowPhaseChange():Boolean {
		return _allowPhaseChange;
	}
	
	public function set allowPhaseChange(value:Boolean):void {
		_allowPhaseChange = value;
	}
	
	//--------------------------------------
	//	label
	//--------------------------------------
	
	private var labelChanged:Boolean;
	
	private var _label:String;
	
	public function get label():String {
		return _label ? _label : "";
	}
	
	public function set label(value:String):void {
		if( _label == value )
			return;
		
		_label = value;
		labelChanged = true;
		
		invalidateProperties();
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	selected
	//--------------------------------------
	
	private var _selected:Boolean;
	
	public function get selected():Boolean {
		return buttonInstance.selected;
	}
	
	public function set selected(value:Boolean):void {
		if( !buttonInstance ) {
			_selected = value;
			return;
		}
		
		buttonInstance.selected = value;
	}
}

}