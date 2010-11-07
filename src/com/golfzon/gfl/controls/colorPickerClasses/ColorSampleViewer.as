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

package com.golfzon.gfl.controls.colorPickerClasses
{
	
import com.golfzon.gfl.core.ComponentBase;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.display.DisplayObject;
import flash.events.MouseEvent;

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *	샘플뷰어 UP스킨<br>
 * 	@default value ColorPicker_upSkin of GZSkin.swf
 */
[Style(name="sampleViewerUpSkin", type="class", inherit="no")]

/**
 *	샘플뷰어 DOWN스킨<br>
 * 	@default value ColorPicker_downSkin of GZSkin.swf
 */
[Style(name="sampleViewerDownSkin", type="class", inherit="no")]

/**
 *	샘플뷰어 OVER 스킨<br>
 * 	@default value ColorPicker_overSkin of GZSkin.swf
 */
[Style(name="sampleViewerOverSkin", type="class", inherit="no")]

/**
 *	샘플뷰어 Disable스킨<br>
 * 	@default value ColorPicker_disabledSkin of GZSkin.swf
 */
[Style(name="sampleViewerDisabledSkin", type="class", inherit="no")]

/**
 *	@Author				HJ Kim
 *	@Version			1.0
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.10.21
 *	@Modify
 *	@Description
 */
public class ColorSampleViewer extends ComponentBase implements IColorSelectableObject
{
	[Embed(source="/assets/GZSkin.swf", symbol="ColorPicker_upSkin")]
	private var SAMPLE_VIEWER_UP_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="ColorPicker_overSkin")]
	private var SAMPLE_VIEWER_OVER_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="ColorPicker_downSkin")]
	private var SAMPLE_VIEWER_DOWN_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="ColorPicker_disabledSkin")]
	private var SAMPLE_VIEWER_DISABLED_SKIN:Class;
	
	/**
     *	샘플뷰어의 상태
     */
	private const PHASE_UP:String = "phaseUp";
    private const PHASE_OVER:String = "phaseOver";
    private const PHASE_DOWN:String = "phaseDown";
    private const PHASE_DISABLED:String = "phaseDisabled";
	
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
    //--------------------------------------------------------------------------
	
	private var fillBox:ComponentBase;
	
	private var currentSkin:DisplayObject;
	
	private var phase:String = PHASE_UP;
	
	/**
	 * 	Construct
	 */
	public function ColorSampleViewer() {
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
	 * 	자식 객체 생성및 추가
	 */
	override protected function createChildren():void {
		super.createChildren();
		
		fillBox = new ComponentBase();
		fillBox.addEventListener(MouseEvent.ROLL_OVER, mouseOverHandler, false, 0, true);
		fillBox.addEventListener(MouseEvent.ROLL_OUT, mouseOutHandler, false, 0, true);
		fillBox.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
		fillBox.addEventListener(MouseEvent.MOUSE_UP, mouseOverHandler, false, 0, true);

		addChild(fillBox);
		createSkin();
	}
	
	/**
     *	enabled 속성 변경에 대한 처리
     */
    override protected function setEnabledState():void {
    	super.setEnabledState();
    	if( enabled )
    		return;
    		
		phase = PHASE_DISABLED;
		fillBox.removeChild(currentSkin);
		createSkin();
    }
	
	/**
	 * 	스타일이 변경되었을때 실행
	 */
	override public function styleChanged(styleProp:String):void {
		super.styleChanged(styleProp);
		
		switch( styleProp ) {
			case StyleProp.SAMPLE_VIEWER_DISABLED_SKIN :	case StyleProp.SAMPLE_VIEWER_DOWN_SKIN :
			case StyleProp.SAMPLE_VIEWER_OVER_SKIN :	case StyleProp.SAMPLE_VIEWER_UP_SKIN :
				fillBox.removeChild(currentSkin);
    			createSkin();
				break;
		}
	}
	
	/**
	 * 	디스플레이 변경사항에 대한 처리
	 */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
				
		if( currentSkin ) {
	    	currentSkin.width = unscaledWidth;
	    	currentSkin.height = unscaledHeight;
    	}
		
		fillBox.x = fillBox.y = 0;
		fillBox.width = unscaledWidth ;
		fillBox.height = unscaledHeight ;
		
		fillColor();
	}
	
	//--------------------------------------------------------------------------
    //  internal
    //--------------------------------------------------------------------------
    
    /**
     *	@private
     */
    private function createSkin():void {
    	currentSkin = createSkinBy(getSkinClass());
    	fillBox.addChildAt(currentSkin, 0);
    	invalidateDisplayList();
    }
    
    /**
     *	@private
     */ 
    private function getSkinClass():Class {
    	switch( phase ) {
    		case PHASE_UP : 
				return replaceNullorUndefined(getStyle(StyleProp.SAMPLE_VIEWER_UP_SKIN), SAMPLE_VIEWER_UP_SKIN);
			case PHASE_DOWN : 	
    			return replaceNullorUndefined(getStyle(StyleProp.SAMPLE_VIEWER_DOWN_SKIN), SAMPLE_VIEWER_DOWN_SKIN);
    		case PHASE_OVER : 	
    			return replaceNullorUndefined(getStyle(StyleProp.SAMPLE_VIEWER_OVER_SKIN), SAMPLE_VIEWER_OVER_SKIN);
    		default	:
    			return replaceNullorUndefined(getStyle(StyleProp.SAMPLE_VIEWER_DISABLED_SKIN), SAMPLE_VIEWER_DISABLED_SKIN);
    	}
    }
    
    /**
     *	@private
     */
    private function fillColor():void {
    	fillBox.graphics.clear();
     	fillBox.graphics.beginFill(selectedColor);
	    fillBox.graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
    	fillBox.graphics.endFill(); 
    }
    
   	/**
     *	@private
     */
    private function changeSkin(value:String):void {
    	if( !enabled || phase == value ) 
    		return;
    	phase = value;
    	fillBox.removeChild(currentSkin);
    	createSkin();
    }
    //--------------------------------------------------------------------------
	//
	//	Event handlers
	//
    //--------------------------------------------------------------------------
    
    private function mouseOverHandler(event:MouseEvent):void {
		changeSkin(PHASE_OVER);
	   	event.updateAfterEvent();
    }
    
    private function mouseOutHandler(event:MouseEvent):void {
    	changeSkin(PHASE_UP);
    	event.updateAfterEvent();
    }
    
    private function mouseDownHandler(event:MouseEvent):void {
    	changeSkin(PHASE_DOWN);
    	event.updateAfterEvent();
    }
    
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
    //--------------------------------------------------------------------------
	
	//--------------------------------------
	//	selectedColor
	//--------------------------------------
	
	private var _selectedColor:uint = 0xFFFFFF;
	
	public function get selectedColor():uint {
		return _selectedColor;
	}
	
	public function set selectedColor(value:uint):void {
		if( value == _selectedColor )
			return;
		
		_selectedColor = value;
		
		invalidateDisplayList();
	}
}
}