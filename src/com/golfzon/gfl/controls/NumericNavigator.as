////////////////////////////////////////////////////////////////////////////////
//
//  PISCES
//  Copyright(c) PISCES.CO.,LTD.
//  All Rights Reserved.
//
//  NOTICE: PISCES permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.golfzon.gfl.controls
{

import com.adobe.utils.ObjectUtil;
import com.golfzon.gfl.controls.numericNavigatorClasses.NumericNavigatorColumn;
import com.golfzon.gfl.core.ComponentBase;
import com.golfzon.gfl.core.ISelectable;
import com.golfzon.gfl.styles.CSSStyleDeclaration;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.events.MouseEvent;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *	페이지가 선택되면 송출한다.
 */
[Event(name="change", type="flash.events.Event")]

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *	컬럼 스타일명<br>
 *	@default value none
 */
[Style(name="columnStyleName", type="String", inherit="no")]

/**
 *	처음으로 가기 버튼 스타일명<br>
 *	@default value none
 */
[Style(name="firstButtonStyleName", type="String", inherit="no")]

/**
 *	이전으로 가기 버튼 스타일명<br>
 *	@default value none
 */
[Style(name="prevButtonStyleName", type="String", inherit="no")]

/**
 *	다음으로 가기 버튼 스타일명<br>
 *	@default value none
 */
[Style(name="nextButtonStyleName", type="String", inherit="no")]

/**
 *	끝으로 가기 버튼 스타일명<br>
 *	@default value none
 */
[Style(name="lastButtonStyleName", type="String", inherit="no")]

/**
 *	@Author				KHKim
 *	@Version			1.0
 *	@Lanaguage			Action Script 3.0
 *	@Date				2010. 4. 29.
 *	@Modify
 *	@Description
 */
public class NumericNavigator extends ComponentBase
{
	//--------------------------------------------------------------------------
	//
	//  Instance variables
	//
	//--------------------------------------------------------------------------
	
	[Embed(source="/assets/GZSkin.swf", symbol="NumericNavigator_firstButton_upSkin")]
	private var firstButtonUpSkinClass:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="NumericNavigator_firstButton_overSkin")]
	private var firstButtonOverSkinClass:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="NumericNavigator_prevButton_upSkin")]
	private var prevButtonUpSkinClass:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="NumericNavigator_prevButton_overSkin")]
	private var prevButtonOverSkinClass:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="NumericNavigator_nextButton_upSkin")]
	private var nextButtonUpSkinClass:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="NumericNavigator_nextButton_overSkin")]
	private var nextButtonOverSkinClass:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="NumericNavigator_lastButton_upSkin")]
	private var lastButtonUpSkinClass:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="NumericNavigator_lastButton_overSkin")]
	private var lastButtonOverSkinClass:Class;
	
	private var pageSetListUpdatable:Boolean;
	
	private var columns:Vector.<NumericNavigatorColumn>;
	
	private var pageSetList:Vector.<Vector.<uint>>;
	
	private var selectedColumn:NumericNavigatorColumn;
	
	private var columnContainer:ComponentBase;
	
	private var firstButton:Button;
	private var prevButton:Button;
	private var nextButton:Button;
	private var lastButton:Button;
	
	/**
	 *	@Constructor
	 */
	public function NumericNavigator() {
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
		
		if( pageSetIndexChanged ) {
			pageSetIndexChanged = false;
			setButtonVisibility();
			updateColumns();
			setSelection();
			alignButtons();
		}
		
		if( pageSetListUpdatable ) {
			pageSetListUpdatable = false;
			setPageSetList();
			setButtonVisibility();
			
			if( _totalCount < 1 )
				removeColumns();
			else
				updateColumns();
			
			alignButtons();
		}
		
		if( selectedIndexChanged ) {
			selectedIndexChanged = false;
			setSelection();
		}
		
		if( selectedPageNumChanged ) {
			selectedPageNumChanged = false;
			_selectedIndex = _selectedPageNum % _rowCount - 1;
			_pageSetIndex = -1;
			pageSetIndex = uint(_selectedPageNum / _viewCount);
		}
	}
	
	/**
	 * 	자식 객체 생성 및 추가
	 */
	override protected function createChildren():void {
		columnContainer = new ComponentBase();
		
		addChild(columnContainer);
		
		firstButton = createButton(StyleProp.FIRST_BUTTON_STYLE_NAME, getFirstButtonStyle);
		prevButton = createButton(StyleProp.PREV_BUTTON_STYLE_NAME, getPrevButtonStyle);
		nextButton = createButton(StyleProp.NEXT_BUTTON_STYLE_NAME, getNextButtonStyle);
		lastButton = createButton(StyleProp.LAST_BUTTON_STYLE_NAME, getLastButtonStyle);
	}
	
	/**
	 * 	컴퍼넌트의 기본 크기와 최소 크기를 설정한다.
	 */
	override protected function measure():void {
		super.measure();
		
		measureWidth = isNaN(measureWidth) ? 500 : measureWidth;
		measureHeight = isNaN(measureHeight) ? 20 : measureHeight;
		
		setActualSize(unscaledWidth, unscaledHeight);
	}
	
	/**
	 *	스타일 프로퍼티로 값을 설정한다.
	 */
	override public function styleChanged(styleProp:String):void {
		super.styleChanged(styleProp);
		
		switch( styleProp ) {
			case StyleProp.COLUMN_STYLE_NAME:
				for each( var column:NumericNavigatorColumn in columns ) {
					column.styleName = getStyle(styleProp);
				}
				break;
			
			case StyleProp.FIRST_BUTTON_STYLE_NAME:
				firstButton.styleName = getStyle(styleProp);
				break;
			
			case StyleProp.PREV_BUTTON_STYLE_NAME:
				prevButton.styleName = getStyle(styleProp);
				break;
			
			case StyleProp.NEXT_BUTTON_STYLE_NAME:
				nextButton.styleName = getStyle(styleProp);
				break;
					
			case StyleProp.LAST_BUTTON_STYLE_NAME:
				lastButton.styleName = getStyle(styleProp);
				break;
		}
	}
	
	/**
	 * 	디스플레이 변경 사항에 대한 처리
	 */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		firstButton.width = prevButton.width = nextButton.width = lastButton.width = _buttonWidth;
		firstButton.height = prevButton.height = nextButton.height = lastButton.height = _buttonHeight;
		
		setUpColumns();
		alignButtons();
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	private function alignButtons():void {
		if( columns ) {
			prevButton.x = Math.round(columnContainer.x - prevButton.width - _buttonGap);
			firstButton.x = Math.round(prevButton.x - firstButton.width - _buttonGap);
			nextButton.x = Math.round(columnContainer.x + columnContainer.width + _buttonGap);
			lastButton.x = Math.round(nextButton.x + nextButton.width + _buttonGap);
			firstButton.y = prevButton.y = nextButton.y = lastButton.y = Math.round((unscaledHeight - _buttonHeight)/2);
		}
	}
	
	private function configureListeners(dispatcher:IEventDispatcher):void {
		dispatcher.addEventListener(MouseEvent.CLICK, column_clickHandler, false, 0, true);
	}
	
	private function dispatchChange():void {
		dispatchEvent(new Event(Event.CHANGE));
	}
	
	private function createAndSetUpColumns():void {
		if( invalidPropertiesToUpdateItems() )
			return;
		
		_columnListWidth = 0;
		columns = new Vector.<NumericNavigatorColumn>;
		
		var pageSet:Vector.<uint> = pageSetList[_pageSetIndex];
		var count:uint = pageSet.length;
		for( var i:uint=0; i<count; i++ ) {
			var column:NumericNavigatorColumn = new NumericNavigatorColumn();
			column.buttonMode = true;
			column.height = unscaledHeight;
			column.x = _columnListWidth;
			column.text = pageSet[i].toString();
			column.styleName = replaceNullorUndefined(getStyle(StyleProp.COLUMN_STYLE_NAME), getColumnStyle());
			columns[columns.length] = column;
			configureListeners(column);
			columnContainer.addChild(column);
			
			_columnListWidth += column.width;
		}
		
		columnContainer.width = _columnListWidth;
		columnContainer.height = unscaledHeight;
		columnContainer.x = getColumnContainerX();
	}
	
	private function createButton(styleProp:String, getDefaultStyleFunction:Function):Button {
		var button:Button = new Button();
		button.buttonMode = true;
		button.width = _buttonWidth;
		button.height = _buttonHeight;
		button.visible = false;
		button.styleName = replaceNullorUndefined(getStyle(styleProp), getDefaultStyleFunction());
		button.addEventListener(MouseEvent.CLICK, button_clickHandler, false, 0, true);
		return Button(addChild(button));
	}
	
	private function getColumnStyle():CSSStyleDeclaration {
		var textStyle:CSSStyleDeclaration = new CSSStyleDeclaration();
		textStyle.setStyle(StyleProp.COLOR, 0x666666);
		textStyle.setStyle(StyleProp.FONT_WEIGHT, "bold");
		textStyle.setStyle(StyleProp.TEXT_ALIGN, "center");
		
		var textRollOverStyle:CSSStyleDeclaration = new CSSStyleDeclaration();
		textRollOverStyle.setStyle(StyleProp.COLOR, 0x666666);
		textRollOverStyle.setStyle(StyleProp.FONT_WEIGHT, "bold");
		textRollOverStyle.setStyle(StyleProp.TEXT_ALIGN, "center");
		
		var textSelectionStyle:CSSStyleDeclaration = new CSSStyleDeclaration();
		textSelectionStyle.setStyle(StyleProp.COLOR, 0xE7291D);
		textSelectionStyle.setStyle(StyleProp.FONT_WEIGHT, "bold");
		textSelectionStyle.setStyle(StyleProp.TEXT_ALIGN, "center");
		
		var style:CSSStyleDeclaration = new CSSStyleDeclaration();
		style.setStyle(StyleProp.TEXT_STYLE_NAME, textStyle);
		style.setStyle(StyleProp.TEXT_ROLL_OVER_STYLE_NAME, textRollOverStyle);
		style.setStyle(StyleProp.TEXT_SELECTION_STYLE_NAME, textSelectionStyle);
		
		return style;
	}
	
	private function getColumnContainerX():Number {
		var a:Number = (uint(firstButton.visible) + uint(prevButton.visible)) * (_buttonWidth + _buttonGap);
		var b:Number = (uint(nextButton.visible) + uint(lastButton.visible)) * (_buttonWidth + _buttonGap);
		return (unscaledWidth - (_columnListWidth - a + b))/2;
	}
	
	private function getFirstButtonStyle():CSSStyleDeclaration {
		var de:CSSStyleDeclaration = new CSSStyleDeclaration();
		de.setStyle(StyleProp.UP_SKIN, firstButtonUpSkinClass);
		de.setStyle(StyleProp.OVER_SKIN, firstButtonOverSkinClass);
		de.setStyle(StyleProp.DOWN_SKIN, firstButtonOverSkinClass);
		de.setStyle(StyleProp.DISABLED_SKIN, firstButtonUpSkinClass);
		return de;
	}
	
	private function getPrevButtonStyle():CSSStyleDeclaration {
		var de:CSSStyleDeclaration = new CSSStyleDeclaration();
		de.setStyle(StyleProp.UP_SKIN, prevButtonUpSkinClass);
		de.setStyle(StyleProp.OVER_SKIN, prevButtonOverSkinClass);
		de.setStyle(StyleProp.DOWN_SKIN, prevButtonOverSkinClass);
		de.setStyle(StyleProp.DISABLED_SKIN, prevButtonUpSkinClass);
		return de;
	}
	
	private function getNextButtonStyle():CSSStyleDeclaration {
		var de:CSSStyleDeclaration = new CSSStyleDeclaration();
		de.setStyle(StyleProp.UP_SKIN, nextButtonUpSkinClass);
		de.setStyle(StyleProp.OVER_SKIN, nextButtonOverSkinClass);
		de.setStyle(StyleProp.DOWN_SKIN, nextButtonOverSkinClass);
		de.setStyle(StyleProp.DISABLED_SKIN, nextButtonUpSkinClass);
		return de;
	}
	
	private function getLastButtonStyle():CSSStyleDeclaration {
		var de:CSSStyleDeclaration = new CSSStyleDeclaration();
		de.setStyle(StyleProp.UP_SKIN, lastButtonUpSkinClass);
		de.setStyle(StyleProp.OVER_SKIN, lastButtonOverSkinClass);
		de.setStyle(StyleProp.DOWN_SKIN, lastButtonOverSkinClass);
		de.setStyle(StyleProp.DISABLED_SKIN, lastButtonUpSkinClass);
		return de;
	}
	
	private function invalidPropertiesToUpdateItems():Boolean {
		return !pageSetList || pageSetList.length < 1 ||
			_pageSetIndex < 0 || _pageSetIndex >= pageSetList.length;
	}
	
	private function invalidSelectedIndex():Boolean {
		return _selectedIndex < 0 || _selectedIndex >= columns.length;
	}
	
	private function removeColumns():void {
		for each( var column:NumericNavigatorColumn in columns ) {
			removeListeners(column);
			columnContainer.removeChild(column);
		}
		columns = null;
	}
	
	private function removeListeners(dispatcher:IEventDispatcher):void {
		dispatcher.removeEventListener(MouseEvent.CLICK, column_clickHandler);
	}
	
	private function setButtonVisibility():void {
		firstButton.visible = prevButton.visible = pageSetList && _pageSetIndex > 0;
		nextButton.visible = lastButton.visible =
			pageSetList && pageSetList.length > 0 && _pageSetIndex < pageSetList.length - 1;
	}
	
	private function setPageSetList():void {
		_pageSetIndex = 0;
		_selectedIndex = -1;
		_selectedPageNum = -1;
		selectedColumn = null;
		pageSetList = new Vector.<Vector.<uint>>;
		var pages:Vector.<uint>;
		for( var i:uint=0; i<_totalCount; i++ ) {
			var pageIndex:uint = uint(i/_rowCount);
			
			if( pageIndex%_viewCount == 0 ) {
				var pageSetIndex:uint = uint(pageIndex/_viewCount);
				
				if( pageSetIndex == pageSetList.length ) {
					pages = new Vector.<uint>;
					pageSetList[pageSetList.length] = pages;
				} else {
					pages = pageSetList[pageSetIndex];
				}
			}
			
			if( i%_rowCount == 0 )
				pages[pages.length] = pageIndex + 1;
		}
	}
	
	private function setSelection():void {
		if( _totalCount < 1 )
			return;
		
		if( invalidSelectedIndex() ) {
			if( selectedColumn ) {
				selectedColumn.selected = false;
				selectedColumn = null;
				_selectedPageNum = -1;
			}
		} else {
			if( selectedColumn )
				selectedColumn.selected = false;
			
			selectedColumn = columns[_selectedIndex];
			selectedColumn.selected = true;
			_selectedPageNum = _pageSetIndex * _viewCount + (_selectedIndex + 1);
		}
	}
	
	private function setUpColumns():void {
		if( !columns )
			return;
		
		_columnListWidth = 0;
		
		var pageSet:Vector.<uint> = pageSetList[_pageSetIndex];
		var count:uint = columns.length;
		for( var i:uint=0; i<count; i++ ) {
			var column:NumericNavigatorColumn = columns[i];
			column.height = unscaledHeight;
			column.text = pageSet[i].toString();
			column.x = _columnListWidth;
			_columnListWidth += column.width;
		}
		
		columnContainer.width = _columnListWidth;
		columnContainer.height = unscaledHeight;
		columnContainer.x = getColumnContainerX();
	}
	
	private function shouldNotChangeColumns():Boolean {
		return columns && pageSetList[_pageSetIndex].length == columns.length;
	}
	
	private function updateColumns():void {
		if( shouldNotChangeColumns() ) {
			setUpColumns();
		} else {
			removeColumns();
			createAndSetUpColumns();
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//	Event handlers
	//
	//--------------------------------------------------------------------------
	
	private function button_clickHandler(event:MouseEvent):void {
		switch( event.currentTarget ) {
			case firstButton:
				_selectedIndex = 0;
				pageSetIndex = 0;
				break;
			
			case prevButton:
				_selectedIndex = 0;
				pageSetIndex--;
				break;
			
			case nextButton:
				_selectedIndex = 0;
				pageSetIndex++;
				break;
			
			case lastButton:
				var pageList:Vector.<uint> = pageSetList[pageSetList.length-1];
				_selectedIndex = pageList[pageList.length-1] % _viewCount - 1;
				pageSetIndex = pageSetList.length - 1;
				break;
		}
		
		dispatchChange();
	}
	
	private function column_clickHandler(event:MouseEvent):void {
		if( event.currentTarget === selectedColumn )
			return;
		
		if( selectedColumn )
			selectedColumn.selected = false;
		
		selectedColumn = NumericNavigatorColumn(event.currentTarget);
		selectedColumn.selected = true;
		_selectedIndex = columns.indexOf(selectedColumn);
		_selectedPageNum = _pageSetIndex * _viewCount + (_selectedIndex + 1);
		
		dispatchChange();
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//	buttonWidth
	//--------------------------------------
	
	private var _buttonWidth:Number = 20;
	
	public function get buttonWidth():Number {
		return _buttonWidth;
	}
	
	public function set buttonWidth(value:Number):void {
		if( value == _buttonWidth )
			return;
		
		_buttonWidth = value;
		
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	buttonHeight
	//--------------------------------------
	
	private var _buttonHeight:Number = 20;
	
	public function get buttonHeight():Number {
		return _buttonHeight;
	}
	
	public function set buttonHeight(value:Number):void {
		if( value == _buttonHeight )
			return;
		
		_buttonHeight = value;
		
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	buttonGap
	//--------------------------------------
	
	private var _buttonGap:Number = 0;
	
	public function get buttonGap():Number {
		return _buttonGap;
	}
	
	public function set buttonGap(value:Number):void {
		if( value == _buttonGap )
			return;
		
		_buttonGap = value;
		
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	columnListWidth
	//--------------------------------------
	
	private var _columnListWidth:Number;
	
	public function get columnListWidth():Number {
		return _columnListWidth;
	}
	
	//--------------------------------------
	//	rowCount
	//--------------------------------------
	
	private var _rowCount:uint = 10;
	
	public function get rowCount():uint {
		return _rowCount;
	}
	
	public function set rowCount(value:uint):void {
		if( value == _rowCount )
			return;
		
		_rowCount = value;
		pageSetListUpdatable = true;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//	pageSetIndex
	//--------------------------------------
	
	private var pageSetIndexChanged:Boolean;
	
	private var _pageSetIndex:int = -1;
	
	public function get pageSetIndex():int {
		return _pageSetIndex;
	}
	
	public function set pageSetIndex(value:int):void {
		if( value == _pageSetIndex )
			return;
		
		_pageSetIndex = value;
		pageSetIndexChanged = true;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//	selectedIndex
	//--------------------------------------
	
	private var selectedIndexChanged:Boolean;
	
	private var _selectedIndex:int = -1;
	
	public function get selectedIndex():int {
		return _selectedIndex;
	}
	
	public function set selectedIndex(value:int):void {
		if( value == _selectedIndex )
			return;
		
		_selectedIndex = value;
		selectedIndexChanged = true;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//	selectedPageNum
	//--------------------------------------
	
	private var selectedPageNumChanged:Boolean;
	
	private var _selectedPageNum:int = -1;
	
	public function get selectedPageNum():int {
		return _selectedPageNum;
	}
	
	public function set selectedPageNum(value:int):void {
		if( value == _selectedPageNum )
			return;
		
		_selectedPageNum = value;
		selectedPageNumChanged = true;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//	totalCount
	//--------------------------------------
	
	private var _totalCount:uint;
	
	public function get totalCount():uint {
		return _totalCount;
	}
	
	public function set totalCount(value:uint):void {
		if( value == _totalCount )
			return;
		
		_totalCount = value;
		pageSetListUpdatable = true;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//	viewCount
	//--------------------------------------
	
	private var _viewCount:uint = 10;
	
	public function get viewCount():uint {
		return _viewCount;
	}
	
	public function set viewCount(value:uint):void {
		if( value == _viewCount )
			return;
		
		_viewCount = value;
		pageSetListUpdatable = true;
		
		invalidateProperties();
	}
}
	
}