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

package com.golfzon.gfl.controls.buttonClasses
{
	
import com.golfzon.gfl.core.gz_internal;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.events.Event;
import flash.events.MouseEvent;

use namespace gz_internal;

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  체크박스 비활성화 스킨
 * 	@default value symbol "CheckBox_disabledSkin" of GZSkin.swf
 */
[Style(name="checkboxDisabledSkin", type="class", inherit="no")]

/**
 *  체크박스 다운 스킨
 * 	@default value symbol "CheckBox_downSkin" of GZSkin.swf
 */
[Style(name="checkboxDownSkin", type="class", inherit="no")]
    
/**
 *  체크박스 오버 스킨
 * 	@default value symbol "CheckBox_overSkin" of GZSkin.swf
 */
[Style(name="checkboxOverSkin", type="class", inherit="no")]
    
/**
 *  체크박스 선택 스킨
 * 	@default value symbol "CheckBox_selectedSkin" of GZSkin.swf
 */
[Style(name="checkboxSelectedSkin", type="class", inherit="no")]

/**
 *  체크박스 선택 비활성화 스킨
 * 	@default value symbol "CheckBox_selectedDisabledSKin" of GZSkin.swf
 */
[Style(name="checkboxSelectedDisabledSkin", type="class", inherit="no")]

/**
 *  체크박스 업 스킨
 * 	@default value symbol "CheckBox_upSkin" of GZSkin.swf
 */
[Style(name="checkboxUpSkin", type="class", inherit="no")]

/**
 *  라디오버튼 비활성화 스킨
 * 	@default value symbol "RadioButton_disabledSkin" of GZSkin.swf
 */
[Style(name="radiobuttonDisabledSkin", type="class", inherit="no")]

/**
 *  라디오버튼 다운 스킨
 * 	@default value symbol "RadioButton_downSkin" of GZSkin.swf
 */
[Style(name="radiobuttonDownSkin", type="class", inherit="no")]

/**
 *  라디오버튼 오버 스킨
 * 	@default value symbol "RadioButton_overSkin" of GZSkin.swf
 */
[Style(name="radiobuttonOverSkin", type="class", inherit="no")]

/**
 *  라디오버튼 선택 스킨
 * 	@default value symbol "RadioButton_selectedSkin" of GZSkin.swf
 */
[Style(name="radiobuttonSelectedSkin", type="class", inherit="no")]

/**
 *  라디오버튼 선택 비활성화 스킨
 * 	@default value symbol "RadioButton_selectedDisabledSKin" of GZSkin.swf
 */
[Style(name="radiobuttonSelected_disabledSkin", type="class", inherit="no")]

/**
 *  라디오버튼 업 스킨
 * 	@default value symbol "RadioButton_upSkin" of GZSkin.swf
 */
[Style(name="radiobuttonUpSkin", type="class", inherit="no")]

/**
 *	@Author				SH Jung
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.11.02
 *	@Modify
 *	@Description
 */
public class CheckButton extends SimpleButton
{
	//--------------------------------------------------------------------------
	//
	//	Instance constants
	//
    //--------------------------------------------------------------------------
    
    [Embed(source="/assets/GZSkin.swf", symbol="CheckBox_disabledSkin")]
    private var CHECKBOX_DISABLED_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="CheckBox_downSkin")]
    private var CHECKBOX_DOWN_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="CheckBox_overSkin")]
    private var CHECKBOX_OVER_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="CheckBox_selectedSkin")]
    private var CHECKBOX_SELECTED_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="CheckBox_selectedDisabledSKin")]
    private var CHECKBOX_SELECTED_DISABLED_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="CheckBox_upSkin")]
    private var CHECKBOX_UP_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="RadioButton_disabledSkin")]
    private var RADIOBUTTON_DISABLED_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="RadioButton_downSkin")]
    private var RADIOBUTTON_DOWN_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="RadioButton_overSkin")]
    private var RADIOBUTTON_OVER_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="RadioButton_selectedSkin")]
    private var RADIOBUTTON_SELECTED_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="RadioButton_selectedDisabledSKin")]
    private var RADIOBUTTON_SELECTED_DISABLED_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="RadioButton_upSkin")]
    private var RADIOBUTTON_UP_SKIN:Class;
    
    //--------------------------------------------------------------------------
	//
	//	Instance variables
	//
    //--------------------------------------------------------------------------
    
	/**
	 *	@Constructor
	 */
	public function CheckButton() {
		super();
	}
	
	/**
	 *	Phase 상태 지정
	 */
	public function setPhase(value:String):void {
		if( value == gz_internal::phase )
			return;
		
		gz_internal::phase = value;
		
		changeSkin(gz_internal::phase);
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
     *	페이즈에 따른 텍스트의 색상을 설정하는 구현이 추가됐음.
     */
	override protected function changeSkin(newPhase:String, allowChange:Boolean=false):void {
		if( allowPhaseChange && !selected || gz_internal::PHASE_SELECTED == newPhase || gz_internal::PHASE_DISABLED == newPhase ) {
	    	super.changeSkin(newPhase, true);
		}
    }
    
    /**
     * 	프로퍼티 변경 사항에 대한 처리
     */
    override protected function commitProperties():void {
    	super.commitProperties();
    	
    	if( selectionChanged ) {
    		selectionChanged = false;
    		setSelection();
    	}
    }
    
    /**
     * 	컴퍼넌트의 기본 크기와 최소 크기를 설정한다.
     */
    override protected function measure():void {
    	super.measure();
    	
		if( !widthChanged ) {
    		measureWidth = gz_internal::currentSkin.width;
  		}
    	
		if( !heightChanged )
    		measureHeight = gz_internal::currentSkin.height;
    	
    	setActureSize(unscaledWidth, unscaledHeight);
    }
    
    /**
     *	enabled에 따른 구현
     */
	override protected function setEnabledState():void {
		gz_internal::phase = "none";
		
		super.setEnabledState();
	}
	
    /**
     *	스타일 프로퍼티로 값을 설정한다.
     */
    override public function styleChanged(styleProp:String):void {
    	super.styleChanged(styleProp);
    	
    	switch( styleProp ) {
    		case StyleProp.PADDING_LEFT:	case StyleProp.PADDING_TOP:
    		case StyleProp.PADDING_RIGHT:	case StyleProp.PADDING_BOTTOM:
    			invalidateDisplayList();
    			break;
     	}
    }
    
    //--------------------------------------------------------------------------
    //  Internal
    //--------------------------------------------------------------------------
    
    /**
     *	@private
     * 	셀렉션을 적용한다.
     */
    private function setSelection():void {
    	if( selected )	changeSkin(gz_internal::PHASE_SELECTED);
    	else			changeSkin(gz_internal::PHASE_UP);
    	dispatchEvent(new Event(Event.CHANGE));
    }
    
    /**
     *	@private
     * 	페이즈에 따라 스킨 클래스를 반환한다.
     */
    override protected function getSkinDefinition():Class {
    	if( _radioMode ) {
	    	if( gz_internal::phase == gz_internal::PHASE_UP && enabled )
	    		return replaceNullorUndefined(getStyle(StyleProp.UP_SKIN), RADIOBUTTON_UP_SKIN);
	    	if( gz_internal::phase == gz_internal::PHASE_OVER && enabled )
	    		return replaceNullorUndefined(getStyle(StyleProp.OVER_SKIN), RADIOBUTTON_OVER_SKIN);
	    	if( gz_internal::phase == gz_internal::PHASE_DOWN && enabled )
	    		return replaceNullorUndefined(getStyle(StyleProp.DOWN_SKIN), RADIOBUTTON_DOWN_SKIN);
	    	if( gz_internal::phase == gz_internal::PHASE_SELECTED && enabled )
	    		return replaceNullorUndefined(getStyle(StyleProp.SELECTED_SKIN), RADIOBUTTON_SELECTED_SKIN);
	    	if( gz_internal::phase == gz_internal::PHASE_SELECTED && !enabled )
	    		return replaceNullorUndefined(getStyle(StyleProp.SELECTED_SKIN), RADIOBUTTON_SELECTED_DISABLED_SKIN);
	    	if( gz_internal::phase == gz_internal::PHASE_DISABLED && _selected )
	    		return replaceNullorUndefined(getStyle(StyleProp.SELECTED_SKIN), RADIOBUTTON_SELECTED_DISABLED_SKIN);
	    	return replaceNullorUndefined(getStyle(StyleProp.DISABLED_SKIN), RADIOBUTTON_DISABLED_SKIN);
    	} else {
	    	if( gz_internal::phase == gz_internal::PHASE_UP )
	    		return replaceNullorUndefined(getStyle(StyleProp.UP_SKIN), CHECKBOX_UP_SKIN);
	    	if( gz_internal::phase == gz_internal::PHASE_OVER )
	    		return replaceNullorUndefined(getStyle(StyleProp.OVER_SKIN), CHECKBOX_OVER_SKIN);
	    	if( gz_internal::phase == gz_internal::PHASE_DOWN )
	    		return replaceNullorUndefined(getStyle(StyleProp.DOWN_SKIN), CHECKBOX_DOWN_SKIN);
	    	if( gz_internal::phase == gz_internal::PHASE_SELECTED )
	    		return replaceNullorUndefined(getStyle(StyleProp.SELECTED_SKIN), CHECKBOX_SELECTED_SKIN);
	    	if( gz_internal::phase == gz_internal::PHASE_DISABLED && _selected )
	    		return replaceNullorUndefined(getStyle(StyleProp.SELECTED_SKIN), CHECKBOX_SELECTED_DISABLED_SKIN);
	    	return replaceNullorUndefined(getStyle(StyleProp.DISABLED_SKIN), CHECKBOX_DISABLED_SKIN);
    	}
    }
    
    //--------------------------------------------------------------------------
	//
	//	Event handlers
	//
    //--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------
    //  Overriden : SimpleButton
    //--------------------------------------------------------------------------
    
    /**
     *	@private
     * 	flash.events.MouseEvent.MOUSE_DOWN
     */
    override protected function mouseDownHandler(event:MouseEvent):void {
    	if( !selected )
    		super.mouseDownHandler(event);
    }
    
    /**
     *	@private
     * 	flash.events.MouseEvent.MOUSE_UP
     */
    override protected function mouseUpHandler(event:MouseEvent):void {
    	if( _radioMode && selected )
    		return;
    	
    	selected = !selected;
		super.mouseUpHandler(event);
    }
    
    /**
     *	@private
     * 	flash.events.MouseEvent.ROLL_OVER
     */
    override protected function rollOverHandler(event:MouseEvent):void {
    	if( !selected )
			super.rollOverHandler(event);
    }
    
    /**
     *	@private
     * 	flash.events.MouseEvent.ROLL_OUT
     */
    override protected function rollOutHandler(event:MouseEvent):void {
    	if( !selected )
			super.rollOutHandler(event);
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
	//	selected
	//--------------------------------------
	
	private var selectionChanged:Boolean;
	
	private var _selected:Boolean;
	
	public function get selected():Boolean {
		return _selected;
	}
	
	public function set selected(value:Boolean):void {
		if( _selected == value )
			return;
		
		_selected = value;
		selectionChanged = true;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//	radioMode
	//--------------------------------------
	
	private var _radioMode:Boolean = false;
	
	public function get radioMode():Boolean {
		return _radioMode;
	}
	
	public function set radioMode(value:Boolean):void {
		if( _radioMode == value )
			return;
		
		_radioMode = value;
	}
}

}