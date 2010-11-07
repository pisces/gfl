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

import com.golfzon.gfl.core.BorderBasedComponent;
import com.golfzon.gfl.events.ListEvent;
import com.golfzon.gfl.managers.PopUpManager;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.ui.Keyboard;

import gs.TweenMax;
import gs.easing.Expo;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *	아이템이 선택되면 송출한다.
 */
[Event(name="change", type="flash.events.Event")]

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  리스트 스킨<br>
 * 	@default value com.golfzon.gfl.controls.List
 */
[Style(name="listStyleName", type="String", inherit="no")]

/**
 *  오픈 시간<br>
 * 	@default value 0.4
 */
[Style(name="openDuration", type="Number", inherit="no")]

/**
 *  클로즈 시간<br>
 * 	@default value 0.4
 */
[Style(name="closeDuration", type="Number", inherit="no")]

/**
 *	페이즈가 UP 상태일 때의 스킨 스타일<br>
 *	@default value symbol "ComboBoxArrowDown_upSkin" of GZSkin.swf
 */
[Style(name="upSkin", type="Class", inherit="no")]

/**
 *	페이즈가 DISABLED 상태일 때의 스킨 스타일<br>
 *	@default value symbol "ComboBoxArrowDown_disabledSkin" of GZSkin.swf
 */
[Style(name="disabledSkin", type="Class", inherit="no")]

/**
 *	선택된 상태의 페이즈가 UP 상태일 때의 스킨 스타일<br>
 *	@default value symbol "ComboBoxArrowUp_upSkin" of GZSkin.swf
 */
[Style(name="selectedUpSkin", type="Class", inherit="no")]

/**
 *	선택된 상태의 페이즈가 DISABLED 상태일 때의 스킨 스타일<br>
 *	@default value symbol "ComboBoxArrowUp_disabledSkin" of GZSkin.swf
 */
[Style(name="selectedDisabledSkin", type="Class", inherit="no")]

/**
 *	@Author				SH Jung
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.11.04
 *	@Modify
 *	@Description
 * 	@includeExample		ComboBoxSample.as
 */
public class ComboBox extends BorderBasedComponent
{
	//--------------------------------------------------------------------------
	//
	//	Instance constants
	//
	//--------------------------------------------------------------------------
	
	[Embed(source="/assets/GZSkin.swf", symbol="ComboBoxArrowDown_disabledSkin")]
	private var BUTTON_DISABLED_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="ComboBoxArrowDown_downSkin")]
	private var BUTTON_DOWN_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="ComboBoxArrowDown_overSkin")]
	private var BUTTON_OVER_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="ComboBoxArrowDown_upSkin")]
	private var BUTTON_UP_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="ComboBoxArrowUp_disabledSkin")]
	private var BUTTON_SELECTED_DISABLED_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="ComboBoxArrowUp_downSkin")]
	private var BUTTON_SELECTED_DOWN_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="ComboBoxArrowUp_overSkin")]
	private var BUTTON_SELECTED_OVER_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="ComboBoxArrowUp_upSkin")]
	private var BUTTON_SELECTED_UP_SKIN:Class;
	
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	private var buttonInstance:Button;
	private var labelInstance:Label;
	private var listMask:Sprite;
	private var listInstance:DisplayObject;
	private var listOpened:Boolean;
	private var keyboardEditMode:Boolean;
	
	/**
	 *	@Constructor
	 */
	public function ComboBox() {
		super();
		
		width = 100;
		height = 20;
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
		
		if( dataProviderChanged ) {
			dataProviderChanged = false;
			List(listInstance).dataProvider = _dataProvider;
			List(listInstance).selectedIndex = _selectedIndex;
			setLabel();
			closeList();
		}
		
		if( labelFieldChanged ) {
			labelFieldChanged = false;
			List(listInstance).labelField = _labelField;
			setLabel();
		}
		
		if( selectedIndexChanged ) {
			List(listInstance).selectedIndex = _selectedIndex;
			setLabel();
		}
	}
	
	/**
	 * 	자식 객체 생성 및 추가
	 */
	override protected function createChildren():void {
		super.createChildren();
		
		buttonInstance = new Button();
		buttonInstance.buttonMode = true;
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
		labelInstance.buttonMode = true;
		
		listInstance = new List();
		List(listInstance).useAutoRemovement = false;
		List(listInstance).height = List(listInstance).rowHeight * _rowCount;
		List(listInstance).styleName = getStyle(StyleProp.LIST_STYLE_NAME);
		List(listInstance).selectedIndex = _selectedIndex;
		
		listMask = new Sprite();
		listMaskDraw();
		List(listInstance).mask = listMask;
		
		configureListeners();
		addChild(buttonInstance);
		addChild(labelInstance);
		addChild(listMask);
	}
	
	/**
	 *	enabled에 따른 구현
	 */
	override protected function setStateToChangeEnabled():void {
		super.setStateToChangeEnabled();
		
		buttonInstance.enabled = enabled;
		labelInstance.enabled = enabled;
		List(listInstance).enabled = enabled;
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
			
			case StyleProp.LIST_STYLE_NAME:
				List(listInstance).styleName = getStyle(StyleProp.LIST_STYLE_NAME);
				break;
		}
	}
	
	/**
	 * 	디스플레이 변경 사항에 대한 처리
	 */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		if( widthChanged ) {
			widthChanged = false;
			border.width = unscaledWidth;
			buttonInstance.x = int(unscaledWidth - buttonInstance.width - 1);
			labelInstance.width = buttonInstance.x;
			listInstance.width = unscaledWidth;
		}
		
		if( heightChanged ) {
			heightChanged = false;
			border.height = unscaledHeight;
			buttonInstance.height = int(unscaledHeight - getBorderThickness() * 2 );
			buttonInstance.y = int((unscaledHeight - buttonInstance.height) / 2);
			labelInstance.height = unscaledHeight;
		}
		
		if( rowCountChanged ) {
			rowCountChanged = false;
			listInstance.height = List(listInstance).rowHeight * _rowCount;
			listMaskDraw();
		}
	}
	
	//--------------------------------------------------------------------------
	//  Public
	//--------------------------------------------------------------------------
	
	private function slideingDown():Boolean {
		var point:Point = localToGlobal(new Point(x, y));
		return (stage.stageHeight - listInstance.height - point.y - unscaledHeight) > 0;
	}
	
	/**
	 * 	리스트 펼침
	 */
	public function openList():void {
		if( listOpened )
			return;
		
		var point:Point = localToGlobal(new Point(x, y));
		PopUpManager.addPopUp(listInstance);
		listInstance.x = point.x;
		
		stage.addEventListener(MouseEvent.CLICK, stage_clickHandler, false, 0, true);
		listOpened = true;
		buttonInstance.selected = true;
		keyboardEditMode = true;
		List(listInstance).setFocus();
		setLabel();
		
		TweenMax.killTweensOf(listInstance);
		
		if( slideingDown() ) {
			listMask.y = 0;
			listInstance.y = localToGlobal(new Point(x, y)).y + -listInstance.height - 1;
			TweenMax.to(listInstance, openDuration, {y:Math.ceil(point.y + unscaledHeight - 1), ease:Expo.easeOut});
		} else {
			listMask.y = (listInstance.height + unscaledHeight) * -1;
			listInstance.y = point.y;
			TweenMax.to(listInstance, openDuration, {y: point.y - listInstance.height, ease:Expo.easeOut});
		}
	}
	
	/**
	 * 	리스트 닫힘
	 */
	public function closeList():void {
		var point:Point = localToGlobal(new Point(x, y));
		
		if( !listOpened ) {
			listInstance.y = point.y + -listInstance.height;
			return;
		}
		
		stage.removeEventListener(MouseEvent.CLICK, stage_clickHandler);
		listOpened = false;
		buttonInstance.selected = false;
		keyboardEditMode = false;
		setFocus();
		selectedIndex = List(listInstance).selectedIndex;
		
		TweenMax.killTweensOf(listInstance);
		if( slideingDown() ) {
			TweenMax.to(listInstance, closeDuration, {y:point.y + -listInstance.height, ease:Expo.easeIn, onComplete:listClosed});			
		} else {
			TweenMax.to(listInstance, closeDuration, {y:point.y, ease:Expo.easeIn, onComplete:listClosed});
		}
		
		
		if( selectedIndexChanged ) {
			selectedIndexChanged = false;
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	/**
	 * 	이벤트 리스너 등록
	 */
	private function configureListeners():void {
		buttonInstance.addEventListener(MouseEvent.CLICK, buttonInstance_clickHandler, false, 0, true);
		labelInstance.addEventListener(MouseEvent.CLICK, labelInstance_clickHandler, false, 0, true);
		listInstance.addEventListener(ListEvent.ITEM_CHANGE, listInstance_changeHandler, false, 0, true);
		listInstance.addEventListener(MouseEvent.CLICK, listInstance_clickHandler, false, 0, true);
		addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, false, 0, true);
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
	 *  리스트 팝업 제거
	 */
	private function listClosed():void {
		PopUpManager.removePopUp(listInstance);
	}
	
	/**
	 * 	마스크 생성
	 */
	private function listMaskDraw():void {
		listMask.graphics.clear();
		listMask.graphics.beginFill(0x000000, 0);
		listMask.graphics.drawRect(0, Math.ceil(height), width, List(listInstance).height - 1);
		listMask.graphics.endFill();
	}
	
	protected function getBorderThickness():Number {
		return getStyle(StyleProp.BACKGROUND_IMAGE) ?
			0 : replaceNullorUndefined(getStyle(StyleProp.BORDER_THICKNESS), 1);
	}
	
	private function getLabelFromDataProvider():String {
		if( !_dataProvider )
			return null;
		
		return typeof _dataProvider[_selectedIndex] == "string" ?
			_dataProvider[_selectedIndex] :
			_dataProvider[_selectedIndex][labelField];
	}
	
	/**
	 * 	라벨 지정
	 */
	private function setLabel():void {
		if( !buttonInstance )
			return;
		
		var label:String;
		if( _dataProvider )
			label = typeof _dataProvider[_selectedIndex] == "string" ? _dataProvider[_selectedIndex] : _dataProvider[_selectedIndex][labelField];
		labelInstance.text = label;
	}
	
	//--------------------------------------------------------------------------
	//
	//	Event handlers
	//
	//--------------------------------------------------------------------------
	
	/**
	 * 	버튼 클릭시
	 */
	private function buttonInstance_clickHandler(event:MouseEvent):void {
		if( listOpened )	closeList();
		else				openList();
	}
	
	/**
	 *  키보드 입력
	 */	
	private function keyDownHandler(event:KeyboardEvent):void {
		if( event.keyCode != Keyboard.ENTER )
			return;
		
		if( listOpened )	closeList();
		else				openList();
	}
	
	/**
	 * 	라벨 클릭시
	 */
	private function labelInstance_clickHandler(event:MouseEvent):void {
		if( listOpened )	closeList();
		else				openList();
	}
	
	/**
	 * 	리스트 선택 변경
	 */
	private function listInstance_changeHandler(event:ListEvent):void {
		if( !buttonInstance.selected || keyboardEditMode )
			return;
		
		if( listOpened )	closeList();
		else				openList();
	}
	
	/**
	 * 	리스트 클릭
	 */
	private function listInstance_clickHandler(event:MouseEvent):void {
		if( event.target.parent is Button )
			return;
		
		keyboardEditMode = false;
		closeList();
	}
	
	/**
	 *  스테이지 클릭
	 */
	private function stage_clickHandler(event:MouseEvent):void {
		if( hitTestPoint(stage.mouseX, stage.mouseY) )
			return;
		
		keyboardEditMode = false;
		closeList();
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//	closeDuration
	//--------------------------------------
	
	public function get closeDuration():Number {
		return replaceNullorUndefined(getStyle(StyleProp.CLOSE_DURATION), 0.4);
	}
	
	//--------------------------------------
	//	dataProvider
	//--------------------------------------
	
	private var dataProviderChanged:Boolean;
	
	private var _dataProvider:Object;
	
	public function get dataProvider():Object {
		return _dataProvider;
	}
	
	public function set dataProvider(value:Object):void {
		if( _dataProvider == value ) 
			return;
		
		_dataProvider = value;
		dataProviderChanged = true;
		
		if( _dataProvider.length < 5 ) {
			rowCount = _dataProvider.length;
		}
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//	labelField
	//--------------------------------------
	
	private var labelFieldChanged:Boolean;
	
	private var _labelField:String = "label";
	
	public function get labelField():String {
		return _labelField;
	}
	
	public function set labelField(value:String):void {
		if( value == _labelField )
			return;
		
		_labelField = value;
		labelFieldChanged = true;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//	openDuration
	//--------------------------------------
	
	public function get openDuration():Number {
		return replaceNullorUndefined(getStyle(StyleProp.OPEN_DURATION), 0.4);
	}
	
	//--------------------------------------
	//	rowCount
	//--------------------------------------
	
	private var rowCountChanged:Boolean;
	
	private var _rowCount:uint = 5;
	
	public function get rowCount():uint {
		return _rowCount;
	}
	
	public function set rowCount(value:uint):void {
		if( value == _rowCount )
			return;
		
		_rowCount = value;
		rowCountChanged = true;
		
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	selectedLabel
	//--------------------------------------
	
	public function get selectedLabel():String {
		return _dataProvider[_selectedIndex] is String ? _dataProvider[_selectedIndex] : _dataProvider[_selectedIndex][labelField];
	}
	
	//--------------------------------------
	//	selectedIndex
	//--------------------------------------
	
	private var selectedIndexChanged:Boolean;
	
	private var _selectedIndex:int = 0;
	
	public function get selectedIndex():int {
		return _selectedIndex;
	}
	
	public function set selectedIndex(value:int):void {
		if( _selectedIndex == value )
			return;
		
		_selectedIndex = value;
		selectedIndexChanged = true;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//	selectedItem
	//--------------------------------------
	
	public function get selectedItem():Object {
		return List(listInstance).selectedItem;
	}
}

}