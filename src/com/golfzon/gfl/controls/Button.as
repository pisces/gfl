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
	
import com.golfzon.gfl.controls.buttonClasses.SimpleButton;
import com.golfzon.gfl.core.LabelPlacement;
import com.golfzon.gfl.core.gz_internal;
import com.golfzon.gfl.skins.blueTheme.ButtonDisabledSkin;
import com.golfzon.gfl.skins.blueTheme.ButtonDownSkin;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextFieldAutoSize;

use namespace gz_internal;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *	토글 상태일 때 선택 상태가 변경되면 송출한다.
 */
[Event(name="change", type="flash.events.Event")]

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *	@Include the external file to define padding styles.
 */
include "../styles/metadata/PaddingStyles.as";

/**
 *	페이즈가 UP 상태일 때의 아이콘 스타일<br>
 *	@default value none
 */
[Style(name="upIcon", type="Class", inherit="no")]

/**
 *	페이즈가 OVER 상태일 때의 아이콘 스타일<br>
 *	@default value none
 */
[Style(name="overIcon", type="Class", inherit="no")]

/**
 *	페이즈가 DOWN 상태일 때의 아이콘 스타일<br>
 *	@default value none
 */
[Style(name="downIcon", type="Class", inherit="no")]

/**
 *	페이즈가 DISABLED 상태일 때의 아이콘 스타일<br>
 *	@default value none
 */
[Style(name="disabledIcon", type="Class", inherit="no")]

/**
 *	선택된 상태의 페이즈가 UP 상태일 때의 아이콘 스타일<br>
 *	@default value none
 */
[Style(name="selectedUpIcon", type="Class", inherit="no")]

/**
 *	선택된 상태의 페이즈가 OVER 상태일 때의 아이콘 스타일<br>
 *	@default value none
 */
[Style(name="selectedOverIcon", type="Class", inherit="no")]

/**
 *	선택된 상태의 페이즈가 DOWN 상태일 때의 아이콘 스타일<br>
 *	@default value none
 */
[Style(name="selectedDownIcon", type="Class", inherit="no")]

/**
 *	선택된 상태의 페이즈가 DISABLED 상태일 때의 아이콘 스타일
 *	@default value none
 */
[Style(name="selectedDisabledIcon", type="Class", inherit="no")]

/**
 *	선택된 상태의 페이즈가 UP 상태일 때의 스킨 스타일<br>
 *	@default value com.golfzon.gfl.skins.blueTheme.ButtonUpSkin
 */
[Style(name="selectedUpSkin", type="Class", inherit="no")]

/**
 *	선택된 상태의 페이즈가 OVER 상태일 때의 스킨 스타일<br>
 *	@default value com.golfzon.gfl.skins.blueTheme.ButtonOverSkin
 */
[Style(name="selectedOverSkin", type="Class", inherit="no")]

/**
 *	선택된 상태의 페이즈가 DOWN 상태일 때의 스킨 스타일<br>
 *	@default value com.golfzon.gfl.skins.blueTheme.ButtonDownSkin
 */
[Style(name="selectedDownSkin", type="Class", inherit="no")]

/**
 *	선택된 상태의 페이즈가 DISABLED 상태일 때의 스킨 스타일<br>
 *	@default value com.golfzon.gfl.skins.blueTheme.ButtonDisabledSkin
 */
[Style(name="selectedDisabledSkin", type="Class", inherit="no")]

/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.08.25
 *	@Modify
 *	@Description
 * 	@includeExample		ButtonSample.as
 */
public class Button extends SimpleButton
{
    //--------------------------------------------------------------------------
	//
	//	Instance variables
	//
    //--------------------------------------------------------------------------
    
    /**
     *	현재의 아이콘 객체
     */
    private var currentIcon:DisplayObject;
    
    /**
     *	라벨 인스턴스
     */
    private var labelInstance:UITextField;
    
	/**
	 *	@Constructor
	 */
	public function Button() {
		super();
		
		minWidth = minHeight = 0;
		
		addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
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
		if( allowPhaseChange ) {
	    	super.changeSkin(newPhase, allowChange);
	    	
	    	labelInstance.setStyle(StyleProp.COLOR, getTextColor());
	    	updateIcon();
		}
    }
    
    /**
     * 	프로퍼티 변경 사항에 대한 처리
     */
    override protected function commitProperties():void {
    	super.commitProperties();
    	
    	if( labelChanged ) {
    		labelChanged = false;
    		labelInstance.text = label;
    	}
    	
    	if( selectionChanged ) {
    		selectionChanged = false;
    		setSelection();
    	}
    	
    	if( toggleChanged ) {
    		toggleChanged = false;
    		setSelection();
    	}
    }
    
    /**
     * 	자식 객체 생성 및 추가
     */
    override protected function createChildren():void {
    	super.createChildren();
    	
    	labelInstance = new UITextField();
    	labelInstance.autoSize = TextFieldAutoSize.LEFT;
    	labelInstance.mouseEnabled = labelInstance.selectable = false;
    	
    	labelInstance.setStyle(StyleProp.COLOR, getTextColor());
    	addChild(labelInstance);
	    createIcon();
    }
    
    /**
     * 	페이즈에 따라 스킨 클래스를 반환한다.
     */
    override protected function getSkinDefinition():Class {
    	if( !toggle || !selected )
    		return super.getSkinDefinition();
    	if( phase == PHASE_UP )
    		return replaceNullorUndefined(getStyle(StyleProp.SELECTED_UP_SKIN), ButtonDownSkin);
    	if( phase == PHASE_OVER )
    		return replaceNullorUndefined(getStyle(StyleProp.SELECTED_OVER_SKIN), ButtonDownSkin);
    	if( phase == PHASE_DOWN )
    		return replaceNullorUndefined(getStyle(StyleProp.SELECTED_DOWN_SKIN), ButtonDownSkin);
    	return replaceNullorUndefined(getStyle(StyleProp.SELECTED_DISABLED_SKIN), ButtonDisabledSkin);
    }
    
    /**
     * 	컴퍼넌트의 기본 크기와 최소 크기를 설정한다.
     */
    override protected function measure():void {
    	super.measure();

		if( !widthChanged && _label )
    		measureWidth = getTextWidth();
    		
		if( !heightChanged && _label )
    		measureHeight = getTextHeight();

    	setActureSize(unscaledWidth, unscaledHeight);
    }
	
    /**
     *	enabled에 따른 구현
     */
	override protected function setEnabledState():void {
		super.setEnabledState();
		
		labelInstance.enabled = enabled;
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
    			
    		case StyleProp.UP_ICON:
    		case StyleProp.SELECTED_UP_ICON:
    			updateIconBy(PHASE_UP);
    			break;
    			
    		case StyleProp.OVER_ICON:
    		case StyleProp.SELECTED_OVER_ICON:
    			updateIconBy(PHASE_OVER);
    			break;
    			
    		case StyleProp.DOWN_ICON:
			case StyleProp.SELECTED_DOWN_ICON:
    			updateIconBy(PHASE_DOWN);
    			break;
    			
    		case StyleProp.DISABLED_ICON:
    		case StyleProp.SELECTED_DISABLED_ICON:
    			updateIconBy(PHASE_DISABLED);
    			break;
    			
	    	case StyleProp.SELECTED_UP_SKIN:
	    		changeSkin(phase, phase == PHASE_UP);
	    		break;
	    		
	    	case StyleProp.SELECTED_OVER_SKIN:
	    		changeSkin(phase, phase == PHASE_OVER);
	    		break;
	    		
	    	case StyleProp.SELECTED_DOWN_SKIN:
	    		changeSkin(phase, phase == PHASE_DOWN);
	    		break;
	    		
	    	case StyleProp.SELECTED_DISABLED_SKIN:
	    		changeSkin(phase, phase == PHASE_DISABLED);
	    		break;
     	}
    }
    
    /**
     * 	디스플레이 변경 사항에 대한 처리
     */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
    	super.updateDisplayList(unscaledWidth, unscaledHeight);
    	
    	currentSkin.width = unscaledWidth;
    	currentSkin.height = unscaledHeight;
    	
		labelInstance.x = getLabelPositionX();
		labelInstance.y = Math.floor((unscaledHeight - labelInstance.measuredHeight) / 2);
		
		if( currentIcon ) {
			currentIcon.x = labelInstance.x - currentIcon.width;
			currentIcon.y = Math.floor((unscaledHeight - currentIcon.height) / 2);
		}
    }
    
    //--------------------------------------------------------------------------
    //  Internal
    //--------------------------------------------------------------------------
    
    /**
     *	@private
     * 	페이즈에 따라 해당 아이콘을 생성하고 스테이지에 추가한다.
     */
    private function createIcon():void {
    	var definition:Class = getIconDefinition();
    	if( definition && validLabel() ) {
    		currentIcon = createSkinBy(definition);
    		addChild(currentIcon);
    	}
    }
    
    /**
     *	@private
     * 	페이즈에 따라 아이콘 클래스를 반환한다.
     */
    protected function getIconDefinition():Class {
    	var selected:Boolean = toggle && this.selected;
    	var styleProp:String;
    	if( phase == PHASE_UP )
    		styleProp = selected ? StyleProp.SELECTED_UP_ICON : StyleProp.UP_ICON;
    	else if( phase == PHASE_OVER )
    		styleProp = selected ? StyleProp.SELECTED_OVER_ICON : StyleProp.OVER_ICON;
    	else if( phase == PHASE_DOWN )
    		styleProp = selected ? StyleProp.SELECTED_DOWN_ICON : StyleProp.DOWN_ICON;
    	else
    		styleProp = selected ? StyleProp.SELECTED_DISABLED_ICON : StyleProp.DISABLED_ICON;
    		
    	return replaceNullorUndefined(getStyle(styleProp), null);
    }
    
    /**
     * 	레이블의 x좌표 위치
     */
    private function getLabelPositionX():Number {
    	var pl:Number = replaceNullorUndefined(getStyle(StyleProp.PADDING_LEFT), 0);
    	var pr:Number = replaceNullorUndefined(getStyle(StyleProp.PADDING_RIGHT), 0);
    	var iconWidth:Number = currentIcon ? currentIcon.width : 0;
    	if( labelPlacement == LabelPlacement.LEFT )
    		return pl + iconWidth / 2;
    	if( labelPlacement == LabelPlacement.RIGHT )
    		return unscaledWidth - labelInstance.textWidth - 4 - pr;
    	return Math.floor((unscaledWidth - labelInstance.measuredWidth) / 2 + iconWidth / 2);
    }
    
    /**
     *	@private
     * 	해당 스킨 스타일이 있으면 지정된 스킨 클래스를 반환하고, 없으면 기본 스킨 클래스를 반환한다.
     */
    private function getStyleWith(styleProp:String, defaultDefinition:Class):Class {
    	return getStyle(styleProp) ? getStyle(styleProp) : defaultDefinition;
    }
    
    /**
     *	@private
     *	페이즈에 따른 텍스트의 색상을 반환한다.
     */
    private function getTextColor():uint {
    	if( toggle && selected )
    		return replaceNullorUndefined(getStyle(StyleProp.TEXT_SELECTED_COLOR), 0x333333);
    	if( phase == PHASE_OVER )
    		return replaceNullorUndefined(getStyle(StyleProp.TEXT_ROLL_OVER_COLOR), 0xFFFFFF);
    	if( phase == PHASE_DOWN )
    		return replaceNullorUndefined(getStyle(StyleProp.TEXT_SELECTED_COLOR), 0x333333);
    	return replaceNullorUndefined(getStyle(StyleProp.COLOR), 0xFFFFFF);
    }
    
    /**
     *	@private
     */
    private function getTextWidth():Number {
    	var pl:Number = replaceNullorUndefined(getStyle(StyleProp.PADDING_LEFT), 5);
    	var pr:Number = replaceNullorUndefined(getStyle(StyleProp.PADDING_RIGHT), 5);
    	var cw:Number = currentSkin ? currentSkin.width : 0;
    	return validLabel() ? pl + pr + labelInstance.measuredWidth : Math.max(cw, minWidth);
    }
    
    /**
     *	@private
     */
    private function getTextHeight():Number {
    	var pt:Number = replaceNullorUndefined(getStyle(StyleProp.PADDING_TOP), 5);
    	var pb:Number = replaceNullorUndefined(getStyle(StyleProp.PADDING_BOTTOM), 5);
    	var ch:Number = currentSkin ? currentSkin.height : 0;
    	return validLabel() ? pt + pb + labelInstance.measuredHeight : Math.max(ch, minHeight);
    }
    
    /**
     *	@private
     */
    private function validLabel():Boolean {
    	return labelInstance && labelInstance.text && labelInstance.text.length > 0;
    }
    
    /**
     *	@private
     * 	현재 아이콘을 제거한다.
     */
    private function removeIcon():void {
    	if( currentIcon && contains(currentIcon) ) {
    		removeChild(currentIcon);
    		currentIcon = null;
    	}
    }
    
    /**
     *	@private
     * 	토글모드일 때 셀렉션을 적용한다.
     */
    private function setSelection():void {
    	if( toggle )
    		changeSkin(phase, true);
    }
    
    /**
     *	@private
     */
    private function updateIcon():void {
    	removeIcon();
    	createIcon();
    	
		labelInstance.x = getLabelPositionX();
		
		if( currentIcon ) {
			currentIcon.x = labelInstance.x - currentIcon.width;
			currentIcon.y = Math.floor((unscaledHeight - currentIcon.height) / 2);
		}
    }
    
    /**
     *	@private
     */
    private function updateIconBy(phase:String):void {
    	if( this.phase == phase )
    		updateIcon();
    }
    
    //--------------------------------------------------------------------------
	//
	//	Event handlers
	//
    //--------------------------------------------------------------------------
    
    /**
     *	@private
     * 	flash.events.MouseEvent.CLICK
     */
    private function clickHandler(event:MouseEvent):void {
    	if( toggle ) {
    		selected = !selected;
    		dispatchEvent(new Event(Event.CHANGE));
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
	//	label
	//--------------------------------------
	
	private var labelChanged:Boolean;
	
	private var _label:String;
	
	public function get label():String {
		return _label ? _label : "";
	}
	
	public function set label(value:String):void {
		if( value == _label )
			return;
		
		_label = value;
		labelChanged = true;
		
		invalidateProperties();
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	labelPlacement
	//--------------------------------------
	
	private var _labelPlacement:String = LabelPlacement.CENTER;
	
	public function get labelPlacement():String {
		return _labelPlacement;
	}
	
	public function set labelPlacement(value:String):void {
		if( value == _labelPlacement )
			return;
		
		_labelPlacement = value;

		invalidateDisplayList();
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
		if( value == _selected )
			return;
		
		_selected = value;
		selectionChanged = true;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//	toggle
	//--------------------------------------
	
	private var toggleChanged:Boolean;
	
	private var _toggle:Boolean;
	
	public function get toggle():Boolean {
		return _toggle;
	}
	
	public function set toggle(value:Boolean):void {
		if( value == _toggle )
			return;
		
		_toggle = value;
		toggleChanged = true;
		
		invalidateProperties();
	}
}

}