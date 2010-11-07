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
	
import com.golfzon.gfl.controls.buttonClasses.SimpleButton;
import com.golfzon.gfl.core.gz_internal;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextFieldAutoSize;

use namespace gz_internal;

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  닫힘 버튼 비활성화 스킨 
 * 	@default value symbol "ComboBoxArrowUp_disabledSkin" of GZSkin.swf
 */
[Style(name="upArrowDisabledSkin", type="class", inherit="no")]

/**
 *  닫힘 버튼 다운 스킨
 * 	@default value symbol "ComboBoxArrowUp_downSkin" of GZSkin.swf
 */
[Style(name="upArrowDownSkin", type="class", inherit="no")]

/**
 *  닫힘 버튼 오버 스킨
 * 	@default value symbol "ComboBoxArrowUp_overSkin" of GZSkin.swf
 */
[Style(name="upArrowOverSkin", type="class", inherit="no")]

/**
 *  닫힘 버튼 업 스킨
 * 	@default value symbol "ComboBoxArrowUp_upSkin" of GZSkin.swf
 */
[Style(name="upArrowUpSkin", type="class", inherit="no")]

/**
 *  열림 버튼 비활성화 스킨
 * 	@default value symbol "ComboBoxArrowDown_disabledSkin" of GZSkin.swf
 */
[Style(name="downArrowdisabledSkin", type="class", inherit="no")]

/**
 *  열림 버튼 다운 스킨
 * 	@default value symbol "ComboBoxArrowDown_downSkin" of GZSkin.swf
 */
[Style(name="downArrowDownSkin", type="class", inherit="no")]

/**
 *  열림 버튼 오버 스킨
 * 	@default value symbol "ComboBoxArrowDown_overSkin" of GZSkin.swf
 */
[Style(name="downArrowOverSkin", type="class", inherit="no")]

/**
 *  열림 버튼 업 스킨
 * 	@default value symbol "ComboBoxArrowDown_upSkin" of GZSkin.swf
 */
[Style(name="downArrowUpSkin", type="class", inherit="no")]

/**
 *	@Author				SH Jung
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.11.05
 *	@Modify
 *	@Description
 */
public class ComboBoxButton extends SimpleButton
{
	//--------------------------------------------------------------------------
	//
	//	Instance constants
	//
    //--------------------------------------------------------------------------
    
    [Embed(source="/assets/GZSkin.swf", symbol="ComboBoxArrowUp_disabledSkin")]
    private var UP_ARROW_DISABLED_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="ComboBoxArrowUp_downSkin")]
    private var UP_ARROW_DOWN_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="ComboBoxArrowUp_overSkin")]
    private var UP_ARROW_OVER_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="ComboBoxArrowUp_upSkin")]
    private var UP_ARROW_UP_SKIN:Class;
    
	[Embed(source="/assets/GZSkin.swf", symbol="ComboBoxArrowDown_disabledSkin")]
    private var DOWN_ARROW_DISABLED_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="ComboBoxArrowDown_downSkin")]
    private var DOWN_ARROW_DOWN_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="ComboBoxArrowDown_overSkin")]
    private var DOWN_ARROW_OVER_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="ComboBoxArrowDown_upSkin")]
    private var DOWN_ARROW_UP_SKIN:Class;
    
    //--------------------------------------------------------------------------
	//
	//	Instance variables
	//
    //--------------------------------------------------------------------------
    
	/**
	 *	@Constructor
	 */
	public function ComboBoxButton() {
		super();
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
    		setSelection();
    	}
    }
    
    /**
     * 	컴퍼넌트의 기본 크기와 최소 크기를 설정한다.
     */
    override protected function measure():void {
    	super.measure();
    	
		if( !widthChanged )
    		measureWidth = currentSkin.width;
    		
		if( !heightChanged )
    		measureHeight = currentSkin.height;
    	
    	setActureSize(unscaledWidth, unscaledHeight);
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
    
    /**
     * 	디스플레이 변경 사항에 대한 처리
     */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
    	super.updateDisplayList(unscaledWidth, unscaledHeight);
    	
    	if( gz_internal::currentSkin ) {
	    	gz_internal::currentSkin.width = int(unscaledWidth);
	    	gz_internal::currentSkin.height = int(unscaledHeight);
    	}
    }
    
    //--------------------------------------------------------------------------
    //  Internal
    //--------------------------------------------------------------------------
        
    /**
     *	@private
     * 	해당 스킨 스타일이 있으면 지정된 스킨 클래스를 반환하고, 없으면 기본 스킨 클래스를 반환한다.
     */
    private function getStyleWith(styleProp:String, defaultDefinition:Class):Class {
    	return getStyle(styleProp) ? getStyle(styleProp) : defaultDefinition;
    }
    
    /**
     *	@private
     * 	셀렉션을 적용한다.
     */
    private function setSelection():void {
    	gz_internal::phase = "none";
    	if( _selected )	changeSkin(gz_internal::PHASE_SELECTED);
    	else			changeSkin(gz_internal::PHASE_UP);
    	dispatchEvent(new Event(Event.CHANGE));
    }
    
    /**
     *	@private
     * 	페이즈에 따라 스킨 클래스를 반환한다.
     */
     
    override protected function getSkinDefinition():Class {
    	if( selected ) {
	    	if( gz_internal::phase == gz_internal::PHASE_UP )
	    		return replaceNullorUndefined(getStyle(StyleProp.UP_ARROW_UP_SKIN), UP_ARROW_UP_SKIN);
	    	if( gz_internal::phase == gz_internal::PHASE_OVER )
	    		return replaceNullorUndefined(getStyle(StyleProp.UP_ARROW_OVER_SKIN), UP_ARROW_OVER_SKIN);
	    	if( gz_internal::phase == gz_internal::PHASE_DOWN )
	    		return replaceNullorUndefined(getStyle(StyleProp.UP_ARROW_DOWN_SKIN), UP_ARROW_DOWN_SKIN);
	    	if( gz_internal::phase == gz_internal::PHASE_SELECTED )
	    		return replaceNullorUndefined(getStyle(StyleProp.UP_ARROW_DOWN_SKIN), UP_ARROW_UP_SKIN);
	    	return replaceNullorUndefined(getStyle(StyleProp.UP_ARROW_DISABLED_SKIN), UP_ARROW_DISABLED_SKIN);
    	} else {
	    	if( gz_internal::phase == gz_internal::PHASE_UP )
	    		return replaceNullorUndefined(getStyle(StyleProp.DOWN_ARROW_UP_SKIN), DOWN_ARROW_UP_SKIN);
	    	if( gz_internal::phase == gz_internal::PHASE_OVER )
	    		return replaceNullorUndefined(getStyle(StyleProp.DOWN_ARROW_OVER_SKIN), DOWN_ARROW_OVER_SKIN);
	    	if( gz_internal::phase == gz_internal::PHASE_DOWN )
	    		return replaceNullorUndefined(getStyle(StyleProp.DOWN_ARROW_DOWN_SKIN), DOWN_ARROW_DOWN_SKIN);
	    	if( gz_internal::phase == gz_internal::PHASE_SELECTED )
	    		return replaceNullorUndefined(getStyle(StyleProp.DOWN_ARROW_DOWN_SKIN), DOWN_ARROW_UP_SKIN);
	    	return replaceNullorUndefined(getStyle(StyleProp.DOWN_ARROW_DISABLED_SKIN), DOWN_ARROW_DISABLED_SKIN);
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
     * 	flash.events.MouseEvent.MOUSE_UP
     */
    override protected function mouseUpHandler(event:MouseEvent):void {
    	selected = !selected;
		super.mouseUpHandler(event);
    }
    
    /**
     *	@private
     * 	flash.events.MouseEvent.ROLL_OVER
     */
    override protected function rollOverHandler(event:MouseEvent):void {
   		changeSkin(gz_internal::PHASE_OVER);
    	
    	event.updateAfterEvent();
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
}

}