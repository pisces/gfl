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

import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

use namespace gz_internal;

/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.10.05
 *	@Modify
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
			var totalColumns:int = columnWidth * Math.round(dataProviderLength / rowCount);
			var cw:Number = getContentPaneWidth();
			var ch:Number = getContentPaneHeight();
			setScrollBars(totalColumns, cw + getBorderThickness() * 2, ch, ch);
			getHScrollBar().lineScrollSize = columnWidth;
			setScrollBarProperties(totalColumns, cw + getBorderThickness() * 2, ch, ch);
		}
	}
	
	/**
	 *	@private
	 * 	change data for dataProvider
	 */
	override protected function changeData(index:int, item1:Object, item2:Object):void {
		dataProvider[index + horizontalLineIndex] = item1;
		dataProvider[selectedIndex] = item2;
	}
	
	/**
	 *	@private
	 */
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
		
		setActureSize(unscaledWidth, unscaledHeight);
	}
	
	/**
	 *	인덱스에 따라 해당 아이템 데이타를 반환한다.
	 */
	override protected function getDataBy(index:int):Object {
		return dataProvider ? dataProvider[index + horizontalLineIndex] : null;
	}
	
	/**
	 *	인덱스로 렌더러의 x, y 좌표를 설정한다.
	 */
	override protected function setItemPositionBy(item:IListItemRenderer, index:int):void {
		item.x = Math.floor(index / rowCount) * columnWidth;
	}
	
	/**
	 *	@private
	 */
	override protected function setSelection(useTween:Boolean=false):void {
		if( !dataProvider )
			return;

		if( _selectedItemRenderer is ISelectable )
			ISelectable(_selectedItemRenderer).selected = true;
		
		_selectedItem = _selectedItemRenderer ? IDataItemRenderer(_selectedItemRenderer).data : null;
		
		if( !selectedIndexChanged )
			_selectedIndex = horizontalScrollPosition + getIndexByMousePosition();
			
		drawSelectedState(useTween);
		dispatchEvent(new ListEvent(ListEvent.ITEM_CHANGE, _selectedItemRenderer));
	}

	/**
	 *	@private
	 */
	override protected function setSelectionByIndex():void {
		var column:int = _selectedIndex / columnCount;
		horizontalScrollPosition = Math.min(maxHorizontalScrollPosition, column * columnCount);
		_selectedItem = dataProvider[_selectedIndex];
		
		scrollTarget();
	}
	
	/**
	 *	@private
	 */
	override protected function updateItemRendererProperties():void {
		if( _selectedItemRenderer is ISelectable )
			ISelectable(_selectedItemRenderer).selected = false;
			
		var i:uint = 0;
		var length:int = itemRenderers.length;
		var gap:int = horizontalLineIndex - origineHorizontalIndex;
		var hasSelectedItemRenderer:Boolean;

		loop:
			do {
				if( i < length ) {
					var newIndex:int;
					var renderer:IListItemRenderer;
					
					if( i < Math.abs(gap) ) {
						if( gap > -1 ) {
							newIndex = gap > length ? i : length - gap + i;
							renderer = itemRenderers.shift();
							itemRenderers[itemRenderers.length] = renderer;
						} else {
							newIndex = Math.abs(Math.abs(gap) - i - 1);
							renderer = itemRenderers.pop();
							itemRenderers = [renderer].concat(itemRenderers);
						}
						renderer.data = getDataBy(newIndex);

					} else {
						newIndex = gap > -1 ? i - gap : i;
						renderer = itemRenderers[newIndex];
					}
					
					setItemPositionBy(renderer, newIndex);
					
					if( renderer.data && renderer.data === selectedItem ) {
						hasSelectedItemRenderer = true;
						_selectedItemRenderer = renderer;
						
						if( renderer === _selectedItemRenderer && (_selectedItemRenderer is ISelectable) )
							ISelectable(_selectedItemRenderer).selected = true;
					}
					
				} else {
					break loop;
				}
				
				i++;
				
			} while(true);
		
		if( !hasSelectedItemRenderer )
			_selectedItemRenderer = null;

		drawSelectedState();
	}
	
	//--------------------------------------------------------------------------
	//
	//	Event handlers
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  @private
	 */	
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
	
	/**
	 *	@private
	 */
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