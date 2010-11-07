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

import com.golfzon.gfl.controls.buttonClasses.ComboBoxButton;
import com.golfzon.gfl.core.ComponentBase;
import com.golfzon.gfl.events.ListEvent;
import com.golfzon.gfl.skins.Border;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.ui.Keyboard;

import gs.TweenMax;
import gs.easing.Expo;

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  화살표 스킨<br>
 * 	@default value none
 */
[Style(name="comboboxArrowButtonStyleName", type="String", inherit="no")]

/**
 *  보더 스킨<br>
 * 	@default value com.golfzon.gfl.skins.Border
 */
[Style(name="borderSkin", type="Class", inherit="no")]

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
 *	@Author				SH Jung
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.11.04
 *	@Modify
 *	@Description
 * 	@includeExample		ComboBoxSample.as
 */
public class ComboBox extends ComponentBase
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
    //--------------------------------------------------------------------------
    
    private var border:DisplayObject;
    private var buttonInstance:ComboBoxButton;
    private var labelInstance:Label;
    private var listMask:Sprite;
    private var listInstance:List;
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
    
    /**
     * 	리스트 펼침
     */
    public function openList():void {
    	if( listOpened )
    		return;
    	
    	stage.addEventListener(MouseEvent.CLICK, stage_clickHandler, false, 0, true);
    	listOpened = true;
    	buttonInstance.selected = true;
    	keyboardEditMode = true;
    	listInstance.setFocus();
    	setLabel();
    	
    	TweenMax.killTweensOf(listInstance);
    	TweenMax.to(listInstance, openDuration, {y:unscaledHeight, ease:Expo.easeOut});
    }
    
    /**
     * 	리스트 닫힘
     */
    public function closeList():void {
    	if( !listOpened ) {
    		listInstance.y = -listInstance.height;
    		return;
    	}
    	
    	stage.removeEventListener(MouseEvent.CLICK, stage_clickHandler);
    	listOpened = false;
    	buttonInstance.selected = false;
    	keyboardEditMode = false;
		setFocus();
		selectedIndex = listInstance.selectedIndex;
		
    	TweenMax.killTweensOf(listInstance);
    	TweenMax.to(listInstance, closeDuration, {y:-listInstance.height, ease:Expo.easeIn});
    	
    	if( selectedIndexChanged ) {
    		selectedIndexChanged = false;
    		dispatchEvent(new Event(Event.CHANGE));
    	}
    }
    
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
    		listInstance.dataProvider = _dataProvider;
    		listInstance.selectedIndex = _selectedIndex;
    		setLabel();
    		closeList();
    	}
    	
    	if( labelFieldChanged ) {
    		labelFieldChanged = false;
    		listInstance.labelField = _labelField;
    		setLabel();
    	}
    	
    	if( selectedIndexChanged ) {
    		listInstance.selectedIndex = _selectedIndex;
    		setLabel();
    	}
    }
    
    /**
     * 	자식 객체 생성 및 추가
     */
    override protected function createChildren():void {
    	border = createBorder();
    	
    	buttonInstance = new ComboBoxButton();
    	buttonInstance.styleName = getStyle(StyleProp.COMBOBOX_ARROW_BUTTON_STYLE_NAME);
    	
    	labelInstance = new Label();
    	labelInstance.mouseEnabled = labelInstance.selectable = false;
    	
    	listMask = new Sprite();
    	listMaskDraw();
		
    	listInstance = new List();
    	listInstance.y = -listInstance.height + 1;
    	listInstance.height = _listHeight;
    	listInstance.mask = listMask;
    	listInstance.styleName = getStyle(StyleProp.LIST_STYLE_NAME);
    	
    	configureListeners();
    	addChild(border);
    	addChild(buttonInstance);
    	addChild(labelInstance);
    	addChild(listMask);
    	addChild(listInstance);
    }
    
    /**
     *	enabled에 따른 구현
     */
	override protected function setEnabledState():void {
		super.setEnabledState();
		
		buttonInstance.enabled = enabled;
		labelInstance.enabled = enabled;
		listInstance.enabled = enabled;
	}
	
    /**
     *	스타일 프로퍼티로 값을 설정한다.
     */
    override public function styleChanged(styleProp:String):void {
    	super.styleChanged(styleProp);
    	
    	switch( styleProp ) {
    		case StyleProp.COMBOBOX_ARROW_BUTTON_STYLE_NAME:
    			buttonInstance.styleName = getStyle(StyleProp.COMBOBOX_ARROW_BUTTON_STYLE_NAME);
    			break;
    		
    		case StyleProp.LIST_STYLE_NAME:
    			listInstance.styleName = getStyle(StyleProp.LIST_STYLE_NAME);
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
    	
    	if( listHeightChanged ) {
    		listHeightChanged = false;
	    	listInstance.height = _listHeight;
	    	listInstance.y = -listInstance.height + 1;
    		listMaskDraw();
    	}
    }
    
	//--------------------------------------------------------------------------
    //  Internal
    //--------------------------------------------------------------------------
    
    /**
     * 	보더 생성
     */
    private function createBorder():DisplayObject {
		var borderClass:Class = replaceNullorUndefined(getStyle(StyleProp.BORDER_SKIN), Border);
		if( borderClass ) {
			var border:DisplayObject = createSkinBy(borderClass);
			border.width = unscaledWidth;
			border.height = unscaledHeight;
			
			if( border is Border )
				Border(border).styleName = getCSSStyleDeclaration();
				
			return border;
		}
		return null;
    }
    
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
     * 	마스크 생성
     */
    private function listMaskDraw():void {
    	listMask.graphics.clear();
		listMask.graphics.beginFill(0x000000, 0);
		listMask.graphics.drawRect(0, height + 1, width, _listHeight);
		listMask.graphics.endFill();
    }
    
	/**
	 *	@private
	 */
    protected function getBorderThickness():Number {
    	return getStyle(StyleProp.BACKGROUND_IMAGE) ?
			0 : replaceNullorUndefined(getStyle(StyleProp.BORDER_THICKNESS), 1);
    }
    
    /**
     * 	@private
     */
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
	//	dataProvider
	//--------------------------------------
	
	private var dataProviderChanged:Boolean;
	
	private var _dataProvider:Array;
	
	public function get dataProvider():Array {
		return _dataProvider;
	}
	
	public function set dataProvider(value:Array):void {
		if( _dataProvider == value ) 
			return;
		
		_dataProvider = value;
		dataProviderChanged = true;
		
		invalidateProperties();
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
	//	listHeight
	//--------------------------------------
	
	private var listHeightChanged:Boolean;
	
	private var _listHeight:Number = 100;
	
	public function get listHeight():Number {
		return _listHeight;
	}
	
	public function set listHeight(value:Number):void {
		if( value == _listHeight )
			return;
		
		_listHeight = value;
		listHeightChanged = true;
		
		invalidateDisplayList();
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
	//	closeDuration
	//--------------------------------------
	
	public function get closeDuration():Number {
		return replaceNullorUndefined(getStyle(StyleProp.CLOSE_DURATION), 0.4);
	}
}

}