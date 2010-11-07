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
	
import com.golfzon.gfl.collection.Hashtable;
import com.golfzon.gfl.core.ComponentBase;
import com.golfzon.gfl.core.gz_internal;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.events.Event;
import flash.events.MouseEvent;

use namespace gz_internal;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *	Selection이 변경 되었을때 송출 한다.
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
 *	페이즈가 UP 상태일 때의 스킨 스타일<br>
 *	@default value symbol "RadioButton_upSkin" of GZSkin.swf
 */
[Style(name="upSkin", type="Class", inherit="no")]

/**
 *	페이즈가 OVER 상태일 때의 스킨 스타일<br>
 *	@default value symbol "RadioButton_overSkin" of GZSkin.swf
 */
[Style(name="overSkin", type="Class", inherit="no")]

/**
 *	페이즈가 DOWN 상태일 때의 스킨 스타일<br>
 *	@default value symbol "RadioButton_downSkin" of GZSkin.swf
 */
[Style(name="downSkin", type="Class", inherit="no")]

/**
 *	페이즈가 DISABLED 상태일 때의 스킨 스타일<br>
 *	@default value symbol "RadioButton_disabledSkin" of GZSkin.swf
 */
[Style(name="disabledSkin", type="Class", inherit="no")]

/**
 *	선택된 상태의 페이즈가 UP 상태일 때의 스킨 스타일<br>
 *	@default value symbol "RadioButton_selectedUpSkin" of GZSkin.swf
 */
[Style(name="selectedUpSkin", type="Class", inherit="no")]

/**
 *	선택된 상태의 페이즈가 OVER 상태일 때의 스킨 스타일<br>
 *	@default value symbol "RadioButton_selectedOverSkin" of GZSkin.swf
 */
[Style(name="selectedOverSkin", type="Class", inherit="no")]

/**
 *	선택된 상태의 페이즈가 DOWN 상태일 때의 스킨 스타일<br>
 *	@default value symbol "RadioButton_selectedDownSkin" of GZSkin.swf
 */
[Style(name="selectedDownSkin", type="Class", inherit="no")]

/**
 *	선택된 상태의 페이즈가 DISABLED 상태일 때의 스킨 스타일<br>
 *	@default value symbol "RadioButton_selectedDisabledSkin" of GZSkin.swf
 */
[Style(name="selectedDisabledSkin", type="Class", inherit="no")]

/**
 *	@Author				SH Jung
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.11.03
 *	@Modify
 *	@Description
 * 	@includeExample		RadioButtonSample.as
 */
public class RadioButton extends ComponentBase
{
	//--------------------------------------------------------------------------
	//
	//	Instance constants
	//
	//--------------------------------------------------------------------------
	
	[Embed(source="/assets/GZSkin.swf", symbol="RadioButton_disabledSkin")]
	private var BUTTON_DISABLED_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="RadioButton_downSkin")]
	private var BUTTON_DOWN_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="RadioButton_overSkin")]
	private var BUTTON_OVER_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="RadioButton_upSkin")]
	private var BUTTON_UP_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="RadioButton_selectedDisabledSkin")]
	private var BUTTON_SELECTED_DISABLED_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="RadioButton_selectedDownSkin")]
	private var BUTTON_SELECTED_DOWN_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="RadioButton_selectedOverSkin")]
	private var BUTTON_SELECTED_OVER_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="RadioButton_selectedUpSkin")]
	private var BUTTON_SELECTED_UP_SKIN:Class;
	
	
	//--------------------------------------------------------------------------
	//
	//	Class variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	라디오버튼그룹 해쉬맵
	 */
	private static var buttonGroupTable:Hashtable = new Hashtable();
	
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	버튼 인스턴스
	 */
	private var buttonInstance:Button;
	
	/**
	 *	라벨 인스턴스
	 */
	private var labelInstance:Label;
	
	/**
	 *	@Constructor
	 */
	public function RadioButton() {
		super();
		
		buttonMode = true;
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
		
		if( groupChanged ) {
			groupChanged = false;
			groupEntry();
		}
		
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
		
		buttonInstance = new Button();
		buttonInstance.mouseChildren = false;
		buttonInstance.mouseEnabled = false;
		buttonInstance.toggle = true;
		buttonInstance.setStyle(StyleProp.DISABLED_SKIN, getButtonStyle(StyleProp.DISABLED_SKIN));
		buttonInstance.setStyle(StyleProp.DOWN_SKIN, getButtonStyle(StyleProp.DOWN_SKIN));
		buttonInstance.setStyle(StyleProp.OVER_SKIN, getButtonStyle(StyleProp.OVER_SKIN));
		buttonInstance.setStyle(StyleProp.UP_SKIN, getButtonStyle(StyleProp.UP_SKIN));
		buttonInstance.setStyle(StyleProp.SELECTED_DISABLED_SKIN, getButtonStyle(StyleProp.SELECTED_DISABLED_SKIN));
		buttonInstance.setStyle(StyleProp.SELECTED_DOWN_SKIN, getButtonStyle(StyleProp.SELECTED_DOWN_SKIN));
		buttonInstance.setStyle(StyleProp.SELECTED_OVER_SKIN, getButtonStyle(StyleProp.SELECTED_OVER_SKIN));
		buttonInstance.setStyle(StyleProp.SELECTED_UP_SKIN, getButtonStyle(StyleProp.SELECTED_UP_SKIN));
		
		labelInstance = new Label();
		labelInstance.mouseChildren = false;
		labelInstance.mouseEnabled = false;
		labelInstance.text = label;
		
		if( !group )	createGroup();
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
		
		setActualSize(unscaledWidth, unscaledHeight);
	}
	
	/**
	 *	enabled에 따른 구현
	 */
	override protected function setStateToChangeEnabled():void {
		super.setStateToChangeEnabled();
		
		buttonInstance.enabled = enabled;
		if( enabled )	labelInstance.setStyle(StyleProp.COLOR, replaceNullorUndefined(getStyle(StyleProp.COLOR), 0x333333));
		else			labelInstance.setStyle(StyleProp.COLOR, replaceNullorUndefined(getStyle(StyleProp.DISABLED_COLOR), 0xDDDDDD));
	}
	
	/**
	 *	스타일 프로퍼티로 값을 설정한다.
	 */
	override public function styleChanged(styleProp:String):void {
		super.styleChanged(styleProp);
		
		switch( styleProp ) {
			case StyleProp.DISABLED_SKIN:
			case StyleProp.DOWN_SKIN:
			case StyleProp.OVER_SKIN:
			case StyleProp.UP_SKIN:
			case StyleProp.SELECTED_DISABLED_SKIN:
			case StyleProp.SELECTED_OVER_SKIN:
			case StyleProp.SELECTED_DOWN_SKIN:
			case StyleProp.SELECTED_UP_SKIN:
				buttonInstance.setStyle(styleProp, getButtonStyle(styleProp));
				break;
	 	}
	}
	
	/**
	 * 	디스플레이 변경 사항에 대한 처리
	 */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		if( selectedChanged ) {
			selectedChanged = false;
			buttonInstance.selected = _selected;
		}
		
		labelInstance.width = unscaledWidth - buttonInstance.width - replaceNullorUndefined(getStyle(StyleProp.TEXT_INDENT), 0);
		labelInstance.x = int(buttonInstance.width + replaceNullorUndefined(getStyle(StyleProp.TEXT_INDENT), 0));
		labelInstance.y = int((buttonInstance.height - labelInstance.textHeight)/2);
	}
	
	override protected function removeFromStageHandler(event:Event):void {
		super.removeFromStageHandler(event);
		
		if( _group )
			buttonGroupTable.remove(_group.name);
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	/**
	 *  이벤트 리스너 등록
	 */
	private function configureListeners():void {
		addEventListener(MouseEvent.CLICK, mouseClickHandler, false, 0, true);
		addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler, false, 0, true);
		addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler, false, 0, true);
		addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
	}
	
	/**
	 *  버튼 스킨 반환
	 */
	private function getButtonStyle(styleProp:String):* {
		if( styleProp == StyleProp.DISABLED_SKIN )				return replaceNullorUndefined(getStyle(StyleProp.DISABLED_SKIN), BUTTON_DISABLED_SKIN);
		if( styleProp == StyleProp.DOWN_SKIN )					return replaceNullorUndefined(getStyle(StyleProp.DOWN_SKIN), BUTTON_DOWN_SKIN);
		if( styleProp == StyleProp.OVER_SKIN )					return replaceNullorUndefined(getStyle(StyleProp.OVER_SKIN), BUTTON_OVER_SKIN);
		if( styleProp == StyleProp.UP_SKIN )					return replaceNullorUndefined(getStyle(StyleProp.UP_SKIN), BUTTON_UP_SKIN);
		if( styleProp == StyleProp.SELECTED_DISABLED_SKIN )		return replaceNullorUndefined(getStyle(StyleProp.SELECTED_DISABLED_SKIN), BUTTON_SELECTED_DISABLED_SKIN);
		if( styleProp == StyleProp.SELECTED_DOWN_SKIN )			return replaceNullorUndefined(getStyle(StyleProp.SELECTED_DOWN_SKIN), BUTTON_SELECTED_DOWN_SKIN);
		if( styleProp == StyleProp.SELECTED_OVER_SKIN )			return replaceNullorUndefined(getStyle(StyleProp.SELECTED_OVER_SKIN), BUTTON_SELECTED_OVER_SKIN);
		if( styleProp == StyleProp.SELECTED_UP_SKIN )			return replaceNullorUndefined(getStyle(StyleProp.SELECTED_UP_SKIN), BUTTON_SELECTED_UP_SKIN);
	}
	
	/**
	 * 	라디오버튼그룹에 등록한다.
	 */
	private function groupEntry():void {
		if( !buttonGroupTable.contains(_group.name) )
			buttonGroupTable.add(_group.name, _group);
		
		buttonGroupTable.getValue(_group.name).addButton(this);
	}
	
	/**
	 * 	라디오버튼그룹을 생성한다.
	 */
	private function createGroup():void {
		group = new RadioButtonGroup();
		group.name = "radioGroup";
	}
	
	//--------------------------------------------------------------------------
	//
	//	Event handlers
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  마우스 클릭
	 */
	private function mouseClickHandler(event:MouseEvent):void {
		if( buttonInstance.selected )	buttonInstance.setStyle(StyleProp.SELECTED_UP_SKIN, getButtonStyle(StyleProp.SELECTED_UP_SKIN));
		else							buttonInstance.setStyle(StyleProp.UP_SKIN, getButtonStyle(StyleProp.UP_SKIN));
		
		labelInstance.setStyle(StyleProp.COLOR, getStyle(StyleProp.COLOR));
		
		selected = !_selected;
		dispatchEvent(new Event(Event.CHANGE));
	}
	
	/**
	 *  마우스 오버
	 */
	private function mouseOverHandler(event:MouseEvent):void {
		if( buttonInstance.selected )	buttonInstance.setStyle(StyleProp.SELECTED_UP_SKIN, getButtonStyle(StyleProp.SELECTED_OVER_SKIN));
		else							buttonInstance.setStyle(StyleProp.UP_SKIN, getButtonStyle(StyleProp.OVER_SKIN));
		
		labelInstance.setStyle(StyleProp.COLOR, getStyle(StyleProp.TEXT_ROLL_OVER_COLOR));
	}
	
	/**
	 *  마우스 아웃
	 */
	private function mouseOutHandler(event:MouseEvent):void {
		if( buttonInstance.selected )	buttonInstance.setStyle(StyleProp.SELECTED_UP_SKIN, getButtonStyle(StyleProp.SELECTED_UP_SKIN));
		else							buttonInstance.setStyle(StyleProp.UP_SKIN, getButtonStyle(StyleProp.UP_SKIN));
		
		labelInstance.setStyle(StyleProp.COLOR, getStyle(StyleProp.COLOR));
	}
	
	/**
	 *  마우스 다운
	 */
	private function mouseDownHandler(event:MouseEvent):void {
		if( buttonInstance.selected )	buttonInstance.setStyle(StyleProp.SELECTED_UP_SKIN, getButtonStyle(StyleProp.SELECTED_DOWN_SKIN));
		else							buttonInstance.setStyle(StyleProp.UP_SKIN, getButtonStyle(StyleProp.DOWN_SKIN));
		
		labelInstance.setStyle(StyleProp.COLOR, getStyle(StyleProp.TEXT_SELECTED_COLOR));
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
	
	private var _label:String = "radioButton";
	
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
	private var selectedChanged:Boolean;
	
	private var _selected:Boolean;
	
	public function get selected():Boolean {
		return _selected;
	}
	
	public function set selected(value:Boolean):void {
		if( _selected == value )
			return;
		
		_selected = value;
		selectedChanged = true;
		
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	value
	//--------------------------------------
	
	private var _value:String;
	
	public function get value():String {
		return _value;
	}
	
	public function set value(value:String):void {
		_value = value;
	}
	
	//--------------------------------------
	//	group
	//--------------------------------------
	private var groupChanged:Boolean;
	
	private var _group:RadioButtonGroup;
	
	public function get group():RadioButtonGroup {
		return _group;
	}
	
	public function set group(value:RadioButtonGroup):void {
		if( _group === value )
			return;
		
		if( _group ) _group.removeButton(this);
		_group = value;
		groupChanged = true;
		
		invalidateProperties();
	}
}

}