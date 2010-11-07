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

use namespace gz_internal;

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  다음 버튼 비활성화 스킨
 * 	@default value symbol "NumericStepperNext_disabledSkin" of GZSkin.swf
 */
[Style(name="nextArrowDisabledSkin", type="class", inherit="no")]

/**
 *  다음 버튼 다운 스킨
 * 	@default value symbol "NumericStepperNext_downSkin" of GZSkin.swf
 */
[Style(name="nextArrowDownSkin", type="class", inherit="no")]

/**
 *  다음 버튼 오버 스킨
 * 	@default value symbol "NumericStepperNext_overSkin" of GZSkin.swf
 */
[Style(name="nextArrowOverSkin", type="class", inherit="no")]

/**
 *  다음 버튼 업 스킨
 * 	@default value symbol "NumericStepperNext_upSkin" of GZSkin.swf
 */
[Style(name="nextArrowUpSkin", type="class", inherit="no")]

/**
 *  이전 버튼 비활성화 스킨
 * 	@default value symbol "NumericStepperPrev_disabledSkin" of GZSkin.swf
 */
[Style(name="prevArrowDisabledSkin", type="class", inherit="no")]

/**
 *  이전 버튼 다 스킨
 * 	@default value symbol "NumericStepperPrev_downSkin" of GZSkin.swf
 */
[Style(name="prevArrowDownSkin", type="class", inherit="no")]

/**
 *  이전 버튼 오버 스킨
 * 	@default value symbol "NumericStepperPrev_overSkin" of GZSkin.swf
 */
[Style(name="prevArrowOverSkin", type="class", inherit="no")]

/**
 *  이전 버튼 업 스킨
 * 	@default value symbol "NumericStepperPrev_upSkin" of GZSkin.swf
 */
[Style(name="prevArrowUpSkin", type="class", inherit="no")]

/**
 *	@Author				SH Jung
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.11.14
 *	@Modify
 *	@Description
 */
public class NumericStepperButton extends SimpleButton
{
    //--------------------------------------------------------------------------
	//
	//	Class constants
	//
    //--------------------------------------------------------------------------
    
    public static const NEXT:String = "next";
    public static const PREV:String = "down";
    
	//--------------------------------------------------------------------------
	//
	//	Instance constants
	//
    //--------------------------------------------------------------------------
    
    [Embed(source="/assets/GZSkin.swf", symbol="NumericStepperNext_disabledSkin")]
    private var NEXT_ARROW_DISABLED_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="NumericStepperNext_downSkin")]
    private var NEXT_ARROW_DOWN_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="NumericStepperNext_overSkin")]
    private var NEXT_ARROW_OVER_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="NumericStepperNext_upSkin")]
    private var NEXT_ARROW_UP_SKIN:Class;
    
	[Embed(source="/assets/GZSkin.swf", symbol="NumericStepperPrev_disabledSkin")]
    private var PREV_ARROW_DISABLED_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="NumericStepperPrev_downSkin")]
    private var PREV_ARROW_DOWN_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="NumericStepperPrev_overSkin")]
    private var PREV_ARROW_OVER_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="NumericStepperPrev_upSkin")]
    private var PREV_ARROW_UP_SKIN:Class;
    
    //--------------------------------------------------------------------------
	//
	//	Instance variables
	//
    //--------------------------------------------------------------------------
    
	/**
	 *	@Constructor
	 */
	public function NumericStepperButton() {
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
     * 	페이즈에 따라 스킨 클래스를 반환한다.
     */
     
    override protected function getSkinDefinition():Class {
    	if( _direction == NumericStepperButton.NEXT ) {
	    	if( gz_internal::phase == gz_internal::PHASE_UP )
	    		return replaceNullorUndefined(getStyle(StyleProp.UP_SKIN), NEXT_ARROW_UP_SKIN);
	    	if( gz_internal::phase == gz_internal::PHASE_OVER )
	    		return replaceNullorUndefined(getStyle(StyleProp.OVER_SKIN), NEXT_ARROW_OVER_SKIN);
	    	if( gz_internal::phase == gz_internal::PHASE_DOWN )
	    		return replaceNullorUndefined(getStyle(StyleProp.DOWN_SKIN), NEXT_ARROW_DOWN_SKIN);
	    	if( gz_internal::phase == gz_internal::PHASE_SELECTED )
	    		return replaceNullorUndefined(getStyle(StyleProp.DOWN_SKIN), NEXT_ARROW_DOWN_SKIN);
	    	return replaceNullorUndefined(getStyle(StyleProp.DISABLED_SKIN), NEXT_ARROW_DISABLED_SKIN);
    	} else {
	    	if( gz_internal::phase == gz_internal::PHASE_UP )
	    		return replaceNullorUndefined(getStyle(StyleProp.UP_SKIN), PREV_ARROW_UP_SKIN);
	    	if( gz_internal::phase == gz_internal::PHASE_OVER )
	    		return replaceNullorUndefined(getStyle(StyleProp.OVER_SKIN), PREV_ARROW_OVER_SKIN);
	    	if( gz_internal::phase == gz_internal::PHASE_DOWN )
	    		return replaceNullorUndefined(getStyle(StyleProp.DOWN_SKIN), PREV_ARROW_DOWN_SKIN);
	    	if( gz_internal::phase == gz_internal::PHASE_SELECTED )
	    		return replaceNullorUndefined(getStyle(StyleProp.DOWN_SKIN), PREV_ARROW_DOWN_SKIN);
	    	return replaceNullorUndefined(getStyle(StyleProp.DISABLED_SKIN), PREV_ARROW_DISABLED_SKIN);
    	}
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
	//	direction
	//--------------------------------------
	
	private var _direction:String;
	
	public function get direction():String {
		return _direction;
	}
	
	public function set direction(value:String):void {
		if( _direction == value )
			return;
		
		_direction = value;
	}
}

}