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

package com.golfzon.gfl.controls.sliderClasses
{

import com.golfzon.gfl.controls.buttonClasses.SimpleButton;
import com.golfzon.gfl.core.gz_internal;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.events.MouseEvent;

use namespace gz_internal;
/**
 *	@Author				SH Jung
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.11.12
 *	@Modify
 *	@Description
 */	
public class SliderThumb extends SimpleButton
{
	//--------------------------------------------------------------------------
	//
	//	Instance constants
	//
    //--------------------------------------------------------------------------
    
    [Embed(source="/assets/GZSkin.swf", symbol="Slider_disabledSkin")]
    private var SLIDER_DISABLED_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="Slider_downSkin")]
    private var SLIDER_DOWN_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="Slider_overSkin")]
    private var SLIDER_OVER_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="Slider_upSkin")]
    private var SLIDER_UP_SKIN:Class;
    
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
    //--------------------------------------------------------------------------
    
	/**
	 *	@Constructor
	 */
	public function SliderThumb(){
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
    	
    	measureWidth = gz_internal::currentSkin.width;
    	measureHeight = gz_internal::currentSkin.height;
    	
    	setActureSize(measureWidth, measureHeight);
    }
    
    /**
     *	@private
     * 	페이즈에 따라 스킨 클래스를 반환한다.
     */
    override protected function getSkinDefinition():Class {
    	if( gz_internal::phase == gz_internal::PHASE_UP )
    		return replaceNullorUndefined(getStyle(StyleProp.UP_SKIN), SLIDER_UP_SKIN);
    	if( gz_internal::phase == gz_internal::PHASE_OVER )
    		return replaceNullorUndefined(getStyle(StyleProp.OVER_SKIN), SLIDER_OVER_SKIN);
    	if( gz_internal::phase == gz_internal::PHASE_DOWN )
    		return replaceNullorUndefined(getStyle(StyleProp.DOWN_SKIN), SLIDER_DOWN_SKIN);
    	return replaceNullorUndefined(getStyle(StyleProp.DISABLED_SKIN), SLIDER_DISABLED_SKIN);
    }
    
    //--------------------------------------------------------------------------
	//
	//	Event handlers
	//
    //--------------------------------------------------------------------------
    
    /**
     *	@private
     * 	flash.events.MouseEvent.ROLL_OUT
     */
	override protected function rollOutHandler(event:MouseEvent):void {
    	if( !event.buttonDown ) {
	    	changeSkin(PHASE_UP);
	    }
    }
}

}