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
import com.golfzon.gfl.managers.CursorManager;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.MouseEvent;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *	색선택이 변경되었을시 발송한다.
 */
[Event(name="change", type="flash.events.Event")]
 
//--------------------------------------
//  Style
//--------------------------------------

/**
 * 	스와치 패널의 외각선 색
 */
[Style(name="borderColor", type="String", inherit="no")]

/**
 * 	오버 색
 */
[Style(name="rollOverColor", type="String", inherit="no")]

/**
 * 	셀렉션 색
 */
[Style(name="selectionColor", type="String", inherit="no")]

/**
 * 	스와치 패널의 선 굵기
 */
[Style(name="borderThickness", type="String", inherit="no")]

/**
 * 	스포이드 커서
 */
[Style(name="spuitCursor", type="String", inherit="no")]

/**
 *	@Author				HJ Kim
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.10.06
 *	@Modify
 *	@Description
 */
public class SwatchPanel extends ComponentBase implements IColorSelectableObject
{
	[Embed(source="/assets/GZSkin.swf", symbol="ColorPicker_spuitCursor")]
	private static var SPUIT_CURSOR:Class;
	
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------

	/**
	 *	색 리스트
	 */
	private var colorList:ComponentBase;
	
	/**
	 *	오버된곳에서의 외각선 출력
	 */
	private var overedBox:ComponentBase;
	
	/**
	 * 	선택된 곳에서의 외각선 출력 
	 */	
	private var selectionBox:ComponentBase;
	
	/**
	 *	@Constructor
	 */
	public function SwatchPanel(){
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
	 * 	자식 객체 생성 및 추가
	 */
	override protected function createChildren():void {
		super.createChildren();
	
		colorList = new ComponentBase();
		
		overedBox = new ComponentBase();
		overedBox.visible = false;
		overedBox.mouseEnabled = false;
		overedBox.mouseChildren = false;
	
		selectionBox = new ComponentBase();
		selectionBox.mouseEnabled = false;
		selectionBox.mouseChildren = false;
		
		configureListeners();
		
		addChild(colorList);
		addChild(overedBox);
		addChild(selectionBox);	
	}
	
	/**
	 * 	컴퍼넌트의 기본 크기와 최소 크기를 설정한다.
	 */
	override protected function measure():void {
		super.measure();
	
		measureWidth = isNaN(measureWidth) ? 130 : measureWidth;
		measureHeight = isNaN(measureHeight) ? 50 : measureHeight;
	
		setActualSize(unscaledWidth, unscaledHeight);
	}

	/**
	 * 스타일 변경
	 */
   	override public function styleChanged(styleProp:String):void {
		super.styleChanged(styleProp);
		switch( styleProp ) {
			case StyleProp.BORDER_THICKNESS :	case StyleProp.BORDER_COLOR :
				invalidateDisplayList();
				break;
		}
	}
	
	/**
	 * 디스플레이 변경사항에 대한 처리
	 */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		if ( dataProvider.length < 1 && creationComplete) 
			return;

		columnCount = Math.floor(unscaledWidth / getSumBorderColunmWidth());
		
		rowCount = 	Math.ceil(dataProvider.length  / columnCount);
		
		colorList.width = getSumBorderColunmWidth() * columnCount;
		colorList.height = getSumBorderRowHeight() * rowCount;
		
		colorList.graphics.clear();
		colorList.graphics.lineStyle(1, borderColor, 1);
		colorList.graphics.drawRect(0, 0, colorList.width, colorList.height);
		
		setPixels();
		
		drawOutLineBox(overedBox, overOutLineColor);
		drawOutLineBox(selectionBox, selectOutLineColor);
		
		moveSelectionBoxFromColor();
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	private function drawOutLineBox(target:ComponentBase, color:uint):void {
		target.width = getSumBorderColunmWidth();
		target.height = getSumBorderRowHeight();
		
		target.graphics.clear();
		target.graphics.lineStyle(1, color, 1);
		target.graphics.drawRect(-borderThickness, -borderThickness, target.width, target.height);
	}
	
	/**
	 *	마우스의 인식 범위 체크
	 */
	private function colorListGoOutChcek(x:int, y:int):Boolean {
		return x > borderThickness && x < getSumBorderColunmWidth() * columnCount &&
				y > borderThickness && y < getSumBorderRowHeight() * rowCount;
	}
	
	private function configureListeners():void {
		addEventListener(Event.REMOVED_FROM_STAGE, removedCursor, false, 0, true);

		colorList.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler, false, 0, true);
		colorList.addEventListener(MouseEvent.ROLL_OUT, mouseRollOut, false, 0, true);
		colorList.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
		
		overedBox.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
	}
	
	/**
	 *	마우스의 위치에 따라서 배열 위치 반환
	 */  
	private function getArrayAddress(x:int, y:int ):int {
		var yLocation:int = Math.floor(getMoveSelectionY(y) / getSumBorderRowHeight()) * columnCount; 
		var xLocation:int = Math.floor(getMoveSelectionX(x) / getSumBorderColunmWidth());
		return yLocation + xLocation;
	} 

	private function getMoveSelectionX(mouseX:int):int {
		return int(mouseX / getSumBorderColunmWidth()) * getSumBorderColunmWidth() + borderThickness;
	}
	
	private function getMoveSelectionY(mouseY:int):int {
		return int(mouseY / getSumBorderRowHeight()) * getSumBorderRowHeight() + borderThickness;
	}
	
	/**
	 *	border와 합한 넓이를 반환
	 */
	private function getSumBorderColunmWidth():int {
		return borderThickness * 2 + columnWidth ;  
	}
	
	/**
	 *	border와 합한 높이를 반환
	 */
	private function getSumBorderRowHeight():int {
		return  borderThickness * 2 + rowHeight ;  
	}

	/**
	 *	@선택박스 이동
	 */
	private function selectionMove(valueX:int, valueY:int):void {
		overedBox.x = valueX + colorList.x ;
		overedBox.y = valueY + colorList.y ;
	}
	
	/**
	 *	선택 박스 이동 
	 */	
	private function moveSelectionBoxFromColor():void {
		for ( var i:Number = 0; i < dataProvider.length; i++ ) {
			if( selectedColor == dataProvider[i] ) {
				var x:Number = i % columnCount;
				var y:Number = Math.floor(i / columnCount);
				selectionBox.x = x * getSumBorderColunmWidth() + borderThickness + colorList.x;
				selectionBox.y = y * getSumBorderRowHeight() + borderThickness + colorList.y;
				selectionBox.visible = true;
				return;
			}
		}
		selectionBox.visible = false;
	}

	/**
	 *	@색 리스트 생성
	 */
	private function setPixels():void {
		var fillStartX:int = 0;
		var fillStartY:int = 0;
		for( var i:int; i < columnCount * rowCount; i++) {
			if( dataProvider[i] == null ) break;
			
			colorList.graphics.beginFill(dataProvider[i]);
			colorList.graphics.lineStyle(borderThickness, borderColor);
			colorList.graphics.drawRect(fillStartX, fillStartY, getSumBorderColunmWidth(), getSumBorderRowHeight());
			colorList.graphics.endFill();

			if( dataProvider[i] == borderColor ) {
				colorList.graphics.beginFill(dataProvider[i]);
				colorList.graphics.lineStyle(borderThickness, 0xCCCCCC);
				colorList.graphics.drawRect(fillStartX + 1, fillStartY + 1, getSumBorderColunmWidth() - 2, getSumBorderRowHeight() - 2);
				colorList.graphics.endFill();
			}
		
			fillStartX += getSumBorderColunmWidth() ;
			if( i % columnCount == columnCount-1) { 
				fillStartX = 0;
				fillStartY += getSumBorderRowHeight();
			}
		}
	}

	//--------------------------------------------------------------------------
	//
	//	 Event Handlers
	//
	//--------------------------------------------------------------------------	
	
	private function mouseDownHandler(event:MouseEvent):void {
		var color:uint = dataProvider[getArrayAddress(overedBox.x, overedBox.y)];
		selectedColor = color;		
		dispatchEvent(new Event(Event.CHANGE));
	}
	
	private function moveHandler(event:MouseEvent):void {
		if( !colorListGoOutChcek(event.localX, event.localY) ) {
			overedBox.visible = false;
			CursorManager.removeCursor();
			return;
		}
		
		CursorManager.setCursor(spuitCursor, 0, -15);
		overedBox.visible = true;
		
		var color:uint = dataProvider[getArrayAddress(event.localX, event.localY)];
		
		if( dataProvider[getArrayAddress(event.localX, event.localY)] != undefined ) {
			selectionMove(getMoveSelectionX(event.localX), getMoveSelectionY(event.localY));
		}
	}
	
	private function mouseRollOut(event:MouseEvent):void {
		CursorManager.removeCursor();
	}
	
	private function removedCursor(event:Event):void {
		CursorManager.removeCursor();
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//	selectedColor
	//--------------------------------------
	
	private var _selectedColor:uint = 0x0;
	
	public function get selectedColor():uint {
		return _selectedColor;
	}
	
	public function set selectedColor(value:uint):void {
		if( value == _selectedColor )
			return;
		
		_selectedColor = value;
		
		moveSelectionBoxFromColor();		
	}
	
	//--------------------------------------
	//	_columnWidth
	//--------------------------------------
	private var _columnWidth:int = 10;
	
	public function get columnWidth():uint {
		return _columnWidth;
	}
	
	public function set columnWidth(value:uint):void {
		if( value == _columnWidth )
			return;
		
		_columnWidth = value;
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	_rowHeight
	//--------------------------------------
	private var _rowHeight:int = 10;
	
	public function get rowHeight():uint {
		return _rowHeight;
	}
	
	public function set rowHeight(value:uint):void {
		if( value == _rowHeight )
			return;
		
		_rowHeight = value;
		invalidateDisplayList();
	}
	//--------------------------------------
	//	columnCount
	//--------------------------------------
	
	private var _columnCount:int = 16;
	
	public function get columnCount():uint {
		return _columnCount;
	}
	
	public function set columnCount(value:uint):void {
		if( value == _columnCount )
			return;
			
		_columnCount = value;
	}
	
	//--------------------------------------
	//	rowCount
	//--------------------------------------
	private var _rowCount:int = 5;
	
	public function get rowCount():uint {
		return _rowCount;
	}
	
	public function set rowCount(value:uint):void {
		if( value == _rowCount )
			return;
			
		_rowCount = value;
	}
	
	//--------------------------------------
	//	dataProvider
	//--------------------------------------
	
	private var _dataProvider:Array = [
						0x000000, 0x00007f, 0x0000ff, 0x007f00, 0x007f7f, 0x007fff, 0x00ff00, 0x00ff7f, 
 						0x00ffff, 0x7f0000, 0x7f007f, 0x7f00ff, 0x7f7f00, 0x7f7f7f, 0x7f7fff, 0x7fff00, 
 						0x7fff7f, 0x7fffff, 0xff0000, 0xff007f, 0xff00ff, 0xff7f00, 0xff7f7f, 0xff7fff, 
 						0xffff00, 0xffff7f, 0xffffff, 
					];

  	public function get dataProvider():Array {
		return _dataProvider;
	}
	
	public function set dataProvider(value:Array):void {
		if( value === _dataProvider )
			return;
		
		_dataProvider = value;
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//  borderThickness
	//--------------------------------------
	
	private function get borderThickness():int {
		return replaceNullorUndefined(getStyle(StyleProp.BORDER_THICKNESS), 1);
	}
	
	//--------------------------------------
	//  borderColor
	//--------------------------------------
	
	private function get borderColor():int {
		return replaceNullorUndefined(getStyle(StyleProp.BORDER_COLOR), 0xCCCCCC);
	}
	
	//--------------------------------------
	//  overOutLineColor
	//--------------------------------------
	
	private function get overOutLineColor():int {
		return replaceNullorUndefined(getStyle(StyleProp.SELECTION_COLOR), 0x999999);
	}
	
	//--------------------------------------
	//  selectOutLineColor
	//--------------------------------------
	
	private function get selectOutLineColor():int {
		return replaceNullorUndefined(getStyle(StyleProp.ROLL_OVER_COLOR), 0x333333);
	}
	
	private function get spuitCursor():Class {
		return replaceNullorUndefined(getStyle(StyleProp.SPUIT_CURSOR), SPUIT_CURSOR);
	}

}
}