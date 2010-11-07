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

import com.golfzon.gfl.controls.listClasses.IListItemRenderer;
import com.golfzon.gfl.controls.listClasses.ListBase;
import com.golfzon.gfl.core.IDataItemRenderer;
import com.golfzon.gfl.core.ISelectable;
import com.golfzon.gfl.core.ScrollPolicy;
import com.golfzon.gfl.core.gz_internal;
import com.golfzon.gfl.events.DragEvent;
import com.golfzon.gfl.events.ListEvent;

import flash.display.DisplayObject;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

use namespace gz_internal;

/**
 *	@Author				KHKim
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.10.05
 *	@Modify				2010.04.20 by KHKim
 *	@Description
 * 	@includeExample		HorizontalListSample.as
 */
public class HorizontalList extends ListBase
{
	/**
	 *	@Constructor
	 */
	public function HorizontalList() {
		super();
		
		columnCount = 5;
		rowCount = 1;
		verticalScrollPolicy = ScrollPolicy.OFF;
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
	 *	@realization
	 * 	스크롤 범위값을 설정한다.
	 */
	override protected function setScrollProperties():void {
		if( dataProvider ) {
			var totalColumns:int = columnWidth * Math.ceil(dataProviderLength / rowCount);
			var cw:Number = getContentPaneWidth();
			var ch:Number = getContentPaneHeight();
			setScrollBars(totalColumns, cw + getBorderThickness() * 2, ch, ch);
			getHScrollBar().lineScrollSize = columnWidth;
			setScrollBarProperties(totalColumns, cw + getBorderThickness() * 2, ch, ch);
		}
	}
	
	override protected function dragScroll():void {
		var newPosition:Number = horizontalScrollPosition + dragScrollSize;
		if( newPosition > maxHorizontalScrollPosition || newPosition < 0 ) {
			removeDragScrolling();
		} else {
			horizontalScrollPosition = newPosition;
			scrollTarget();
			setDragGuider();
		}
	}
	
	/**
	 * 	컴퍼넌트의 기본 크기와 최소 크기를 설정한다.
	 */
	override protected function measure():void {
		super.measure();
		
		measureWidth = isNaN(measureWidth) ? 350 : measureWidth;
		measureHeight = isNaN(measureHeight) ? 100 : measureHeight;
		
		setActualSize(unscaledWidth, unscaledHeight);
	}
	
	/**
	 *	인덱스에 따라 해당 아이템 데이타를 반환한다.
	 */
	override protected function getDataBy(index:int):Object {
		return _dataProvider ? _dataProvider[index + horizontalLineIndex] : null;
	}
	
	/**
	 *	인덱스로 렌더러의 x, y 좌표를 설정한다.
	 */
	override protected function setItemPositionBy(item:IListItemRenderer, index:int):void {
		item.x = Math.floor(index / rowCount) * columnWidth;
	}
	
	override protected function setSelection(useTween:Boolean=false):void {
		if( !_dataProvider )
			return;
		
		if( _selectedItemRenderer is ISelectable )
			ISelectable(_selectedItemRenderer).selected = true;
		
		_selectedItem = _selectedItemRenderer ? IDataItemRenderer(_selectedItemRenderer).data : null;

		if( !selectedIndexChanged )
			_selectedIndex = horizontalScrollPosition + getIndexByMousePosition();
		
		if( _allowMultipleSelection && _selectedIndices.indexOf(_selectedIndex) < 0 ) {
			if( _selectedItem )
				_selectedItems.push(_selectedItem);
			_selectedIndices.push(_selectedIndex);
		}
		
		drawSelectedState(useTween);
	}

	override protected function setSelectionByIndex():void {
		var column:int = _selectedIndex / columnCount;
		horizontalScrollPosition = Math.min(maxHorizontalScrollPosition, column * columnCount);
		_selectedItem = dataProvider[_selectedIndex];
		
		scrollTarget();
	}
	
	override protected function updateItemRendererProperties():void {
		if( _selectedItemRenderer is ISelectable )
			ISelectable(_selectedItemRenderer).selected = false;
		
		var gap:int = _horizontalLineIndex - origineHorizontalIndex;
		var hasSelectedItemRenderer:Boolean;
		var count:int = itemRenderers.length;
		
		for( var i:uint=0; i<count; i++ ) {
			var newIndex:int;
			var renderer:IListItemRenderer;
			if( gap > 0 ) {
				if( i < gap ) { 
					renderer = itemRenderers.shift();
					itemRenderers.push(renderer);
					newIndex = gap > _rowCount * _columnCount ? i : i + (_rowCount * _columnCount) - gap ;
				} else {
					newIndex = i - gap;
					renderer = itemRenderers[newIndex];
				}
			} else {
				if( Math.abs(gap) > (_rowCount * _columnCount) || i >= (_rowCount * _columnCount) + gap ) {
					newIndex = (_rowCount * _columnCount) - i - 1;
					renderer = itemRenderers.pop();
					itemRenderers = [renderer].concat(itemRenderers);
				} else {
					newIndex = i - gap;
					renderer = itemRenderers[i];
				}
			}
			
			renderer.listData.rowIndex = uint(i / _columnCount);
			renderer.listData.columnIndex = i % _columnCount;
			renderer.data = getDataBy(newIndex);
			
			setItemPositionBy(renderer, newIndex);
			
			if( renderer.data && renderer.data === _selectedItem ) {
				hasSelectedItemRenderer = true;
				_selectedItemRenderer = renderer as DisplayObject;
				
				if( renderer === _selectedItemRenderer && (_selectedItemRenderer is ISelectable) )
					ISelectable(_selectedItemRenderer).selected = true;
			}
		}
		
		if( !hasSelectedItemRenderer )
			_selectedItemRenderer = null;
		
		instanceSelected();
		drawSelectedState();
	}
	
	//--------------------------------------------------------------------------
	//
	//	Event handlers
	//
	//--------------------------------------------------------------------------
	
	override protected function keyDownHandler(event:KeyboardEvent):void {
		if( !dataProvider || scrolling )
			return;
		
		var selectedIndexChanged:Boolean = true;
		switch( event.keyCode ) {
			case Keyboard.LEFT:
				_selectedIndex = _selectedIndex > 0 ? _selectedIndex - 1 : _selectedIndex;
				break;
				
			case Keyboard.RIGHT:
				_selectedIndex = _selectedIndex < dataProviderLength - 1 ? _selectedIndex + 1 : _selectedIndex;
				break;
			
			default:
				selectedIndexChanged = false;
				break;
		}
		
		if( selectedIndexChanged ) {
			setSelectionByIndex();
			dispatchItemChanged();
		}
	}
	
	override protected function dragEnterHandler(event:DragEvent):void {
		if( mouseX > unscaledWidth - columnWidth / 2 )
			setDragScrollProperties(unscaledWidth - mouseX, 1);
		else if( mouseX < columnWidth / 2 )
			setDragScrollProperties((columnWidth / 2 - mouseX) * -1, -1);
		else
			removeDragScrolling();
		
		setDragGuider();
	}
}

}