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
	
import com.golfzon.gfl.controls.dataGridClasses.DataGridColumn;
import com.golfzon.gfl.controls.dataGridClasses.DataGridHeader;
import com.golfzon.gfl.controls.dataGridClasses.DataGridRow;
import com.golfzon.gfl.controls.listClasses.BaseListData;
import com.golfzon.gfl.controls.listClasses.IListItemRenderer;
import com.golfzon.gfl.controls.listClasses.ListBase;
import com.golfzon.gfl.core.ScrollPolicy;
import com.golfzon.gfl.core.gz_internal;
import com.golfzon.gfl.events.DataGridEvent;
import com.golfzon.gfl.events.IndexChangedEvent;
import com.golfzon.gfl.managers.CursorManager;
import com.golfzon.gfl.styles.IStyleClient;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.UIDUtil;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.display.DisplayObject;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

use namespace gz_internal;

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *	Grid background color<br>
 * 	@default value [#F1F1F1, #FFFFFF]
 */
[Style(name="gridBackgroundColors", type="Array", inherit="no")]

/**
 *	Grid line color<br>
 * 	@default value #A9A9A9
 */
[Style(name="gridLineColor", type="uint", inherit="no")]

/**
 *	Grid line thickness<br>
 * 	@default value 1
 */
[Style(name="gridLineThickness", type="Number", inherit="no")]

/**
 *	Cursor skin for resizing<br>
 * 	@default value 1
 */
[Style(name="resizeColumnCursor", type="Number", inherit="no")]

/**
 *	Color for resize guide<br>
 * 	@default value #51391D
 */
[Style(name="resizeGuideColor", type="uint", inherit="no")]

/**
 *	Color for resize guide<br>
 * 	@default value 1
 */
[Style(name="resizeGuideBorderThickness", type="Number", inherit="no")]

/**
 *	@Author				KHKim
 *	@Version			1.0
 *	@Lanaguage			Action Script 3.0
 *	@Date				2010. 4. 14.
 *	@Modify
 *	@Description
 */
public class DataGrid extends ListBase
{
	//--------------------------------------------------------------------------
	//
	//  Instance variables
	//
	//--------------------------------------------------------------------------
	
	[Embed(source="/assets/GZSkin.swf", symbol="DataGrid_resizeColumnCursor")]
	private var resizeColumnCursorClass:Class;
	
	private var resizeTargetIndex:int = -1;
	
	private var downedMouseX:Number;
	
	private var columnResizing:Boolean;
	
	private var resizeGuidePositions:Array;
	
	private var gridBackgroundShape:Shape;
	private var gridLineShape:Shape;
	private var resizeGuideLineShape:Shape;
	
	private var resizeGuider:Sprite;
	
	private var header:DataGridHeader;
	
	/**
	 *	@Constructor
	 */
	public function DataGrid() {
		super();
		
		columnCount = 1;
		rowHeight = 25;
		horizontalScrollPolicy = ScrollPolicy.OFF;
	}
	
	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Overriden : ListBase
	//--------------------------------------------------------------------------
	
	/**
	 *	하위 객체 생성 
	 */	
	override protected function createChildren():void {
		super.createChildren();
		
		gridBackgroundShape = new Shape();
		gridLineShape = new Shape();
		resizeGuideLineShape = new Shape();
		
		resizeGuider = new Sprite();
		
		header = new DataGridHeader();
		header.width = unscaledWidth;
		header.height = _headerHeight;
		
		header.addEventListener(DataGridEvent.DATA_SORT, header_dataSortHandler, false, 0, true);
		header.addEventListener(IndexChangedEvent.CHANGE, header_indexChangeHandler, false, 0, true);
		header.addEventListener(MouseEvent.MOUSE_DOWN, header_mouseDownHandler, false, 0, true);
		header.addEventListener(MouseEvent.ROLL_OVER, header_rollOverHandler, false, 0, true);
		resizeGuider.addEventListener(MouseEvent.MOUSE_DOWN, resizeGuider_mouseDownHandler, false, 0, true);
		resizeGuider.addEventListener(MouseEvent.ROLL_OVER, resizeGuider_rollOverHandler, false, 0, true);
		resizeGuider.addEventListener(MouseEvent.ROLL_OUT, resizeGuider_rollOutHandler, false, 0, true);
		
		addChildAt(gridBackgroundShape, getChildIndex(selectionShape));
		addChildAt(header, getChildIndex(gridBackgroundShape));
		addChild(gridLineShape);
		addChild(resizeGuider);
		addChild(resizeGuideLineShape);
	}
	
	override protected function getVScrollBarHeight():Number {
		return super.getVScrollBarHeight() - _headerHeight;
	}
	
	/**
	 * 	컴퍼넌트의 기본 크기와 최소 크기를 설정한다.
	 */
	override protected function measure():void {
		super.measure();
		
		measureWidth = isNaN(measureWidth) ? 200 : measureWidth;
		measureHeight = isNaN(measureHeight) ? 150 : measureHeight;

		setActualSize(unscaledWidth, unscaledHeight);
	}
	
	/**
	 *	@realization
	 * 	스크롤 범위값을 설정한다.
	 */
	override protected function setScrollProperties():void {
		if( _dataProvider ) {
			var borderThickness:Number = getBorderThickness();
			var totalRows:int = _rowHeight * Math.round(dataProviderLength / _columnCount);
			var cw:Number = getContentPaneWidth();
			var ch:Number = getContentPaneHeight();
			setScrollBars(cw, cw, totalRows, ch + borderThickness * 2);
			getVScrollBar().lineScrollSize = _rowHeight;
			setScrollBarProperties(cw, cw, totalRows, ch + borderThickness * 2);
		}
	}
	
	/**
	 *	스타일 프로퍼티로 값을 설정한다.
	 */
	override public function styleChanged(styleProp:String):void {
		super.styleChanged(styleProp);
		
		switch( styleProp ) {
			case StyleProp.GRID_BACKGROUND_COLORS:
				drawGridBackground();
				break;
			
			case StyleProp.GRID_LINE_COLOR:
			case StyleProp.GRID_LINE_THICKNESS:
				drawGridLinesAndResizeGuide();
				break;
		}
	}
	
	override protected function updateContentPaneDisplay():void {
		super.updateContentPaneDisplay();
		
		contentPane.y = getBorderThickness() + viewMetrics.top + _headerHeight;
	}
	
	/**
	 *	디스플레이 변경사항에 대한 처리 
	 */	
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		if( columnsChanged || sizeChanged() ) {
			columnsChanged = false;
			setCalculatedColumnWidth();
		}
		
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		header.width = getContentPaneWidth();
		header.height = _headerHeight;
		header.x = getBorderThickness();
		header.y = getBorderThickness();
		
		drawGridBackground();
		drawGridLinesAndResizeGuide();
		setRows();
	}
	
	override protected function updateItemRenderers():void {
		if( invalidSize() )
			return;
		
		if( itemRendererShouldBeUpdate ) {
			itemRendererShouldBeUpdate = false;
			header.update();
			removeItemRenderers();
			createRows();
		}
	}
	
	override protected function updateScrollBarProperties():void {
		super.updateScrollBarProperties();
		
		var borderThickness:Number = getBorderThickness();
		getVScrollBar().height = unscaledHeight - getHScrollBar().height - borderThickness * 2 - _headerHeight;
		getVScrollBar().y = borderThickness + _headerHeight;
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	private function createResizeGuider():DisplayObject {
		var shape:Shape = new Shape();
		shape.graphics.beginFill(0x0, 1);
		shape.graphics.drawRect(0, 0, 5, _headerHeight);
		shape.graphics.endFill();
		return shape;
	}
	
	private function createRows():void {
		if( !_columns || !_dataProvider )
			return;
		
		var cx:Number = 0;
		var count:uint = _columns.length;
		var i:uint = 0;
		while( i < count ) {
			var column:DataGridColumn = _columns[i];
			var rw:Number = isNaN(column.width) ? calculatedColumnWidth : column.width;
			var j:uint = 0;
			while( j < _rowCount ) {
				var listData:BaseListData = new BaseListData(null, UIDUtil.createUID(), this, j, i);
				
				var row:DataGridRow = itemRenderers[j] ? itemRenderers[j] : new DataGridRow();
				row.width = getContentPaneWidth();
				row.height = _rowHeight;
				row.y = j * _rowHeight;
				row.listData = listData;
				row.data = _dataProvider[j];
				
				var renderer:IListItemRenderer = column.itemRenderer.newInstance();
				renderer.width = rw;
				renderer.height = _rowHeight;
				renderer.x = cx;
				
				if( renderer is IStyleClient )
					IStyleClient(renderer).styleName = getCSSStyleDeclaration();
				
				configureListeners(row);
				row.addChild(DisplayObject(renderer));
				
				if( !itemRenderers[j] )
					itemRenderers[itemRenderers.length] = contentPane.addChild(row);
				
				j++;
			}
			
			cx += rw;
			i++;
		}
	}
	
	private function drawGridBackground():void {
		if( !_columns )
			return;
		
		gridBackgroundShape.graphics.clear();
		
		var borderThickness:Number = getBorderThickness();
		var i:int = 0;
		while( i < _rowCount ) {
			var color:uint = gridBackgroundColors[i%2];
			var newY:Number = borderThickness + _headerHeight + (i * _rowHeight);
			var current:Number = newY + _rowHeight;
			var max:Number = unscaledHeight - borderThickness;
			var newHeight:Number = current  > max ? _rowHeight - (current - max) : _rowHeight;
			gridBackgroundShape.graphics.beginFill(color, 1);
			gridBackgroundShape.graphics.drawRect(borderThickness, newY, getContentPaneWidth(), newHeight);
			
			i++;
		}
		gridBackgroundShape.graphics.endFill();
	}
	
	private function drawGridLinesAndResizeGuide():void {
		if( !_columns )
			return;
		
		var borderThickness:Number = getBorderThickness();
		
		gridLineShape.graphics.clear();
		gridLineShape.graphics.lineStyle(gridLineThickness, gridLineColor);
		gridLineShape.graphics.moveTo(borderThickness, borderThickness + _headerHeight);
		gridLineShape.graphics.lineTo(unscaledWidth - borderThickness, borderThickness + _headerHeight);
		gridLineShape.graphics.moveTo(unscaledWidth - getVScrollBar().width - borderThickness, borderThickness);
		gridLineShape.graphics.lineTo(unscaledWidth - getVScrollBar().width - borderThickness, borderThickness + _headerHeight);
		
		resizeGuider.graphics.clear();
		resizeGuider.graphics.beginFill(0x0, 0);
		
		resizeGuidePositions = [];
		
		var cx:Number = 0;
		var count:uint = _columns.length - 1;
		var i:int = 0;
		while( i < count ) {
			var column:DataGridColumn = _columns[i];
			var rw:Number = isNaN(column.width) ? calculatedColumnWidth : column.width;
			cx += rw;
			
			gridLineShape.graphics.moveTo(borderThickness + cx, borderThickness);
			gridLineShape.graphics.lineTo(borderThickness + cx, borderThickness + getContentPaneHeight() + _headerHeight);
			
			resizeGuider.graphics.drawRect(cx - 6/2 + 1, getBorderThickness(), 6, _headerHeight);
			
			resizeGuidePositions[resizeGuidePositions.length] = cx - 6/2 + 1;
			
			i++;
		}
		
		gridLineShape.graphics.endFill();
		resizeGuider.graphics.endFill();
	}
	
	private function getItemsFromSelectedIndices():Array {
		var result:Array = [];
		var count:uint = _selectedIndices.length;
		for( var i:uint=0; i<count; i++ ) {
			result[result.length] = getItemRendererBy(_selectedIndices[i]).data;
		}
		return result;
	}
	
	private function getResizedXBy():Number {
		if( resizeTargetIndex < 0 )
			return 0;
		
		var targetPosition:Number = resizeGuidePositions[resizeTargetIndex] + 3;
		var cw1:Number = isNaN(_columns[resizeTargetIndex].width) ? calculatedColumnWidth : _columns[resizeTargetIndex].width;
		var cw2:Number = isNaN(_columns[resizeTargetIndex+1].width) ? calculatedColumnWidth : _columns[resizeTargetIndex+1].width;
		var min:Number = targetPosition - cw1 + 10;
		var max:Number = targetPosition + cw2 - 10;
		return Math.min(max, Math.max(min, mouseX));
	}
	
	private function released():void {
		stage.removeEventListener(Event.MOUSE_LEAVE, stage_mouseLeaveHandler);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
		stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
		resizeGuideLineShape.graphics.clear();
		CursorManager.removeCursor();
		resizeTargetIndex = -1;
		columnResizing = false;
	}
	
	/**
	 *	넓이가 설정된 컬럼을 제외한 나머지 컬럼의 평균 넓이 설정한다.
	 */
	private function setCalculatedColumnWidth():void {
		if( !_columns )
			return;
		
		_calculatedColumnWidth = getContentPaneWidth();
		var devide:uint = 0;
		var i:uint = 0;
		while( i < _columns.length ) {
			var column:DataGridColumn = _columns[i++];
			if( isNaN(column.width) )	devide++;
			else						_calculatedColumnWidth -= column.width;
			
		}
		_calculatedColumnWidth /= devide;
	}
	
	private function setRendererIndexInRows(origineIndex:int, newIndex:int):void {
		for each( var row:DataGridRow in itemRenderers ) {
			var children:Array = [];
			var numChildren:uint = row.numChildren;
			for( var i:uint=0; i<numChildren; i++ ) {
				var child:DisplayObject = row.getChildAt(0);
				children[children.length] = child;
				row.removeChild(child);
			}
			
			var targetRenderer1:DisplayObject = children[origineIndex];
			var targetRenderer2:DisplayObject = children[newIndex];
			children[newIndex] = targetRenderer1;
			children[origineIndex] = targetRenderer2;
			
			var cx:Number = 0;
			for( var j:uint=0; j<numChildren; j++ ) {
				var column:DataGridColumn = _columns[j];
				var rw:Number = isNaN(column.width) ? calculatedColumnWidth : column.width;
				var renderer:DisplayObject = children[j];
				if( renderer ) {
					renderer.width = rw;
					renderer.x = cx;
					row.addChild(renderer);
				}
				
				cx += rw;
			}
		}
	}
	
	private function setResizeTargetIndex():void {
		var i:uint = 0;
		for each( var pos:Number in resizeGuidePositions ) {
			if( mouseX >= pos && mouseX <= pos + 6 ) {
				resizeTargetIndex = i;
				return;
			}
			i++;
		}
	}
	
	private function setRows(updatable:Boolean=false):void {
		if( !updatable && (!sizeChanged() || !rowHeightChanged) )
			return;

		for each( var row:DataGridRow in itemRenderers ) {
			row.width = getContentPaneWidth();
			
			var cx:Number = 0;
			for( var i:uint=0; i<row.numChildren; i++ ) {
				var column:DataGridColumn = _columns[i];
				var rw:Number = isNaN(column.width) ? calculatedColumnWidth : column.width;
				var renderer:IListItemRenderer = row.getChildAt(i) as IListItemRenderer;
				if( renderer ) {
					renderer.listData.columnIndex = i;
					renderer.width = rw;
					renderer.height = _rowHeight;
					renderer.x = cx;
				}
				
				cx += rw;
			}
		}
	}
	
	private function updateGridDisplay():void {
		drawGridLinesAndResizeGuide();
		setRows(true);
		header.setRendererProperties();
	}
	
	//--------------------------------------------------------------------------
	//
	//	Event handlers
	//
	//--------------------------------------------------------------------------
	
	private function header_dataSortHandler(event:DataGridEvent):void {
		var arr:Array = _dataProvider as Array;
		var item:Object = _selectedItem;
		
		_dataProvider = arr.sortOn(_columns[event.columnIndex].dataField, event.sortOption);
		_selectedIndex = arr.indexOf(item);
		
		updateItemRendererProperties();
		setSelectionByIndex();
	}
	
	private function header_indexChangeHandler(event:IndexChangedEvent):void {
		var dragedColumn:DataGridColumn = _columns[event.origineIndex];
		var dropColumn:DataGridColumn = _columns[event.newIndex];

		_columns[event.newIndex] = dragedColumn;
		_columns[event.origineIndex] = dropColumn;
		
		drawGridLinesAndResizeGuide();
		setRendererIndexInRows(event.origineIndex, event.newIndex);
		header.setRendererProperties();
	}
	
	private function header_mouseDownHandler(event:MouseEvent):void {
		setFocus();
	}
	
	private function header_rollOverHandler(event:MouseEvent):void {
		rollOverShape.clear();
	}
	
	private function resizeGuider_mouseDownHandler(event:MouseEvent):void {
		downedMouseX = mouseX;
		columnResizing = true;
		
		setResizeTargetIndex();
		stage.addEventListener(Event.MOUSE_LEAVE, stage_mouseLeaveHandler, false, 0, true);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler, false, 0, true);
		stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler, false, 0, true);
	}
	
	private function resizeGuider_rollOutHandler(event:MouseEvent):void {
		if( !columnResizing )
			CursorManager.removeCursor();
	}
	
	private function resizeGuider_rollOverHandler(event:MouseEvent):void {
		var cursorSkinClass:Class = replaceNullorUndefined(
			getStyle(StyleProp.RESIZE_COLUMN_CURSOR), resizeColumnCursorClass);
		CursorManager.setCursor(cursorSkinClass);
	}
	
	private function stage_mouseLeaveHandler(event:Event):void {
		released();
	}
	
	private function stage_mouseMoveHandler(event:MouseEvent):void {
		var t:Number = getBorderThickness();
		var color:uint = replaceNullorUndefined(getStyle(StyleProp.RESIZE_GUIDE_COLOR), 0x51391D);
		var rt:uint = replaceNullorUndefined(getStyle(StyleProp.RESIZE_GUIDE_BORDER_THICKNESS), 1);
		var newX:Number = getResizedXBy();
			
		resizeGuideLineShape.graphics.clear();
		resizeGuideLineShape.graphics.lineStyle(rt, color);
		resizeGuideLineShape.graphics.moveTo(newX, t);
		resizeGuideLineShape.graphics.lineTo(newX, unscaledHeight - t);
		resizeGuideLineShape.graphics.endFill();
	}
	
	private function stage_mouseUpHandler(event:MouseEvent):void {
		var dx:Number = downedMouseX - getResizedXBy();
		var cw1:Number = isNaN(_columns[resizeTargetIndex].width) ? calculatedColumnWidth : _columns[resizeTargetIndex].width;
		var cw2:Number = isNaN(_columns[resizeTargetIndex+1].width) ? calculatedColumnWidth : _columns[resizeTargetIndex+1].width;
		
		_columns[resizeTargetIndex].width = cw1 - dx;
		_columns[resizeTargetIndex+1].width = cw2 + dx;
		
		setCalculatedColumnWidth();
		updateGridDisplay();
		released();
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//	calculatedColumnWidth
	//--------------------------------------
	
	private var _calculatedColumnWidth:Number;
	
	public function get calculatedColumnWidth():Number {
		return _calculatedColumnWidth;
	}
	
	//--------------------------------------
	//	columns
	//--------------------------------------
	
	private var columnsChanged:Boolean;
	
	private var _columns:Array;
	
	public function get columns():Array {
		return _columns;
	}
	
	public function set columns(value:Array):void {
		if( value == _columns )
			return;
		
		_columns = value;
		columnsChanged = true;
		itemRendererShouldBeUpdate = true;
		
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	headerHeight
	//--------------------------------------
	
	private var _headerHeight:Number = 25;
	
	public function get headerHeight():Number {
		return _headerHeight;
	}
	
	public function set headerHeight(value:Number):void {
		if( value == _headerHeight )
			return;
		
		_headerHeight = value;
		itemRendererShouldBeUpdate = true;
		
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	gridBackgroundColor
	//--------------------------------------
	
	private function get gridBackgroundColors():Array {
		return replaceNullorUndefined(getStyle(StyleProp.GRID_BACKGROUND_COLORS), [0xF1F1F1, 0xFFFFFF]);
	}
	
	//--------------------------------------
	//	gridLineColor
	//--------------------------------------
	
	private function get gridLineColor():Number {
		return replaceNullorUndefined(getStyle(StyleProp.GRID_LINE_COLOR), 0xA9A9A9);
	}
	
	//--------------------------------------
	//	gridLineThickness
	//--------------------------------------
	
	private function get gridLineThickness():Number {
		return replaceNullorUndefined(getStyle(StyleProp.GRID_LINE_THICKNESS), 1);
	}
}
	
}