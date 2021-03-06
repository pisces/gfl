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

package com.golfzon.gfl.controls.listClasses
{

import com.adobe.utils.ObjectUtil;
import com.golfzon.gfl.collection.Hashtable;
import com.golfzon.gfl.core.ClassFactory;
import com.golfzon.gfl.core.ComponentBase;
import com.golfzon.gfl.core.EdgeMetrics;
import com.golfzon.gfl.core.IDataItemRenderer;
import com.golfzon.gfl.core.ISelectable;
import com.golfzon.gfl.core.ScrollControlBase;
import com.golfzon.gfl.core.gz_internal;
import com.golfzon.gfl.events.DragEvent;
import com.golfzon.gfl.events.ListEvent;
import com.golfzon.gfl.managers.DragManager;
import com.golfzon.gfl.styles.IStyleClient;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.BitmapDataUtil;
import com.golfzon.gfl.utils.UIDUtil;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Shape;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.filters.DropShadowFilter;
import flash.ui.Keyboard;
import flash.utils.Timer;
import flash.utils.clearInterval;
import flash.utils.setInterval;

use namespace gz_internal;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *	아이템 선택이 변경되었을 때 발송한다.
 */
[Event(name="itemChange", type="com.golfzon.gfl.events.ListEvent")]

/**
 *	아이템이 클릭 되었을 때 발송한다.
 */
[Event(name="itemClick", type="com.golfzon.gfl.events.ListEvent")]

/**
 *	아이템이 더블 클릭 되었을 때 발송한다.
 */
[Event(name="itemDoubleClick", type="com.golfzon.gfl.events.ListEvent")]

/**
 *	아이템이 롤아웃 되었을 때 발송한다.
 */
[Event(name="itemRollOut", type="com.golfzon.gfl.events.ListEvent")]

/**
 *	아이템이 롤오버 되었을 때 발송한다.
 */
[Event(name="itemRollOver", type="com.golfzon.gfl.events.ListEvent")]

/**
 *	아이템이 드래그 드랍되어 다른 아이템과 교체되었을 때 발송한다.
 */
[Event(name="itemSwap", type="com.golfzon.gfl.events.ListEvent")]

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *	Skin for drag guider<br>
 * 	@default value ListBase_dragGuideSkin of GZSkin.swf
 */
[Style(name="dragGuideSkin", type="Class", inherit="no")]

/**
 *	Duration for transition of selection state<br>
 * 	@default value 0.3
 */
[Style(name="selectionDuration", type="Number", inherit="no")]

/**
 *	Color for text of selection state<br>
 * 	@default value 0xFFFFFF
 */
[Style(name="textSelctedColor", type="uint", inherit="no")]

/**
 *	@Author				KHKim
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.09.29
 *	@Modify				2010.04.10 by KHKim
 *	@Description		Abstract Class
 */
public class ListBase extends ScrollControlBase
{
	//--------------------------------------------------------------------------
	//
	//	Instance constants
	//
	//--------------------------------------------------------------------------
	
	[Embed(source="/assets/GZSkin.swf", symbol="ListBase_dragGuideSkin")]
	private var dragGuideSkinClass:Class;
	
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	드래그 스크롤 인터벌 딜레이
	 */
	gz_internal var delay:uint = 50;
	
	/**
	 *	타이머 딜레이
	 */
	gz_internal var timerDelay:uint = 300;
	
	gz_internal var contentPane:ComponentBase;
	
	private var addendDelay:uint;
	private var intervalId:uint;
	
	protected var dataProviderLength:int;
	protected var dragScrollSize:int;
	protected var origineHorizontalIndex:int;
	protected var origineVerticalIndex:int;
	
	protected var itemRendererShouldBeUpdate:Boolean = true;
	private var multipleSelecting:Boolean;
	
	protected var itemRenderers:Array /* of object */ = [];
	
	private var dragItem:Object;
	
	private var dragTarget:DisplayObject;
	private var dragGuider:DisplayObject;
	
	private var contentMask:Shape;
	private var dragGuiderMask:Shape;
	
	protected var selectionShape:ListShape;
	protected var rollOverShape:ListShape;
	
	private var timer:Timer;
	
	/**
	 *	@Constructor
	 */
	public function ListBase() {
		super();
		
		doubleClickEnabled = true;
		minWidth = minHeight = 30;
		
		addEventListener(MouseEvent.ROLL_OUT, rollOutHandler, false, 0, true);
		addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, false, 0, true);
		setViewMetrics();
	}
	
	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Overriden : ScrollControlBase
	//--------------------------------------------------------------------------
	
	override protected function addedToStageHandler(event:Event):void {
		super.addedToStageHandler(event);
		
		stage.addEventListener(Event.MOUSE_LEAVE, stage_mouseLeaveHandler, false, 0, true);
	}
	
	/**
	 * 	프로퍼티 변경 사항에 대한 처리
	 */
	override protected function commitProperties():void {
		super.commitProperties();
		
		if( dataProviderChanged ) {
			dataProviderChanged = false;
			_horizontalLineIndex = _verticalLineIndex = 0;
			horizontalScrollPosition = verticalScrollPosition = 0;
			
			setScrollProperties();
			updateItemRendererProperties();
		}
		
		if( selectedItemRendererChanged ) {
			selectedItemRendererChanged = false;
			setSelection(true);
		}
	}
	
	/**
	 * 	자식 객체 생성 및 추가
	 */
	override protected function createChildren():void {
		super.createChildren();

		contentMask = new Shape();
		dragGuiderMask = new Shape();
		selectionShape = new ListShape(this);
		rollOverShape = new ListShape(this);
		contentPane = new ComponentBase();
		contentPane.mask = contentMask;

		addChild(contentMask);
		addChild(dragGuiderMask);
		addChild(selectionShape);
		addChild(rollOverShape);
		addChild(contentPane);
		createDragGuider();
	}
	
	/**
	 *	크기 변경 구현
	 */
	override protected function measure():void {
		super.measure();
		
		if( sizeChanged() ) {
			itemRendererShouldBeUpdate = true;
			resetToOrigineSize();
		}
	}
	
	/**
	 *	타겟 스크롤
	 */
	override protected function scrollTarget():void {
		origineHorizontalIndex = _horizontalLineIndex;
		origineVerticalIndex = _verticalLineIndex;
		_horizontalLineIndex = horizontalScrollPosition;
		_verticalLineIndex = verticalScrollPosition;

		updateItemRendererProperties();
	}
	
	/**
	 *	스타일 프로퍼티로 값을 설정한다.
	 */
	override public function styleChanged(styleProp:String):void {
		super.styleChanged(styleProp);

		switch( styleProp ) {
			case StyleProp.DRAG_GUIDE_SKIN:
				removeDragGuider();
				createDragGuider();
				break;
			
			case StyleProp.PADDING_LEFT:	case StyleProp.PADDING_TOP:
			case StyleProp.PADDING_RIGHT:	case StyleProp.PADDING_BOTTOM:
				setViewMetrics();
				invalidateDisplayList();
				break;
			
			case StyleProp.TEXT_ROLL_OVER_COLOR:
			case StyleProp.TEXT_ROLL_OVER_STYLE_NAME:
			case StyleProp.TEXT_SELECTED_COLOR:
			case StyleProp.TEXT_SELECTION_STYLE_NAME:
				for each (var renderer:IListItemRenderer in itemRenderers) {
					if (renderer is IStyleClient)
						IStyleClient(renderer).setStyle(styleProp, getStyle(styleProp));
				}
				break;
	 	}
	}
	
	/**
	 * 	디스플레이 변경 사항에 대한 처리
	 */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		setColumnsAndRows();
		setScrollProperties();
		setColumnsAndRows();
		updateContentPaneDisplay();
		drawMask(contentMask);
		drawMask(dragGuiderMask);
		
		if( !_dataProvider )
			return;

		updateItemRenderers();
		
		if( selectedIndexChanged ) {
			setSelectionByIndex();
			selectedIndexChanged = false;
		}
	}
	
	override public function set width(value:Number):void {
		if( value == super.width )
			return;
		
		if( rowHeightChanged )
			itemRendererShouldBeUpdate = true;
		
		super.width = value;
	}
	
	override public function set height(value:Number):void {
		if( value == super.height )
			return;
		
		if( rowHeightChanged )
			itemRendererShouldBeUpdate = true;
		
		super.height = value;
	}
	
	//--------------------------------------------------------------------------
	//	Public
	//--------------------------------------------------------------------------
	
	/**
	 *	해당 인덱스의 아이템렌더러 객체를 반환한다.
	 */
	public function getItemRendererBy(index:int):IListItemRenderer {
		return itemRenderers[index];
	}
	
	/**
	 *	아이템렌더러 객체의 인덱스를 반환한다.
	 */
	public function getItemRendererIndex(renderer:DisplayObject):int {
		if( !contentPane.contains(renderer) )
			return -1;
		return contentPane.getChildIndex(renderer);
	}
	
	/**
	 *	디스플레이 변경을 하지 않고 dataProvider를 업데이트한다.
	 */
	public function updateDataProvider(value:Object):void {
		_dataProvider = value;
		dataProviderLength = getDataProviderLength();
		
		if( _selectedItem && _selectedIndex < dataProviderLength )
			_selectedItem = _dataProvider[_selectedIndex];
		
		var i:uint = 0;
		while( i < itemRenderers.length ) {
			var instance:IListItemRenderer = itemRenderers[i];
			setItemRendererBy(instance, i++);
 		}
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	/**
	 * 	스크롤 범위값을 설정한다.
	 */
	protected function setScrollProperties():void {
		throw new Error("이 메소드는 구현이 필요한 추상 메소드입니다.");
	}
	
	private function alignItemRenderers():void {
		if( !_dataProvider )
			return;
		
		var i:int = 0;
		while( i < itemRenderers.length ) {
			var instance:IListItemRenderer = itemRenderers[i];
			setItemRendererBy(instance, i++);
		}
	}
	
	/**
	 * 	change data for dataProvider
	 */
	protected function changeData(item1:Object, item2:Object):void {
		var dp:Array = _dataProvider as Array;
		if( dp ) {
			var i1:int = dp.indexOf(item1);
			var i2:int = dp.indexOf(item2);
			_dataProvider[i1] = item2;
			_dataProvider[i2] = item1;
		}
	}
	
	protected function configureListeners(dispatcher:IEventDispatcher):void {
		dispatcher.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		dispatcher.addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler, false, 0, true);
		dispatcher.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
		dispatcher.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler, false, 0, true);
		dispatcher.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler, false, 0, true);
	}
	
	private function createDragGuider():void {
		var definition:Class = replaceNullorUndefined(getStyle(StyleProp.DRAG_GUIDE_SKIN), dragGuideSkinClass);
		if( definition ) {
			dragGuider = createSkinBy(definition);
			dragGuider.visible = false;
			dragGuider.mask = dragGuiderMask;
			addChild(dragGuider);
		}
	}
	
	protected function createDragImage(itemRenderer:DisplayObject):DisplayObject {
		var bitmapData:BitmapData = BitmapDataUtil.generate(itemRenderer, false);

		var dragImage:Bitmap = new Bitmap(bitmapData);
		dragImage.x = stage.mouseX - itemRenderer.mouseX;
		dragImage.y = stage.mouseY - itemRenderer.mouseY;
		dragImage.filters = [new DropShadowFilter(3, 45, 0, 0.5, 2, 2, 1, 10)];
		return dragImage;
	}
	
	protected function createDragSource(itemRenderer:IListItemRenderer):Object {
		return itemRenderer.data;
	}
	
	private function createItemRenderers():void {
		if( !_dataProvider )
			return;
		
		var i:int = 0;
		while( itemRenderers.length < columnCount * rowCount ) {
			var listData:BaseListData = new BaseListData(
				null, UIDUtil.createUID(), this, uint(i / _columnCount), i % _columnCount);
			
			var instance:IListItemRenderer = itemRenderer.newInstance();
			instance.listData = listData;
			
			if (instance is IStyleClient)
				IStyleClient(instance).getCSSStyleDeclaration().merge(getCSSStyleDeclaration());
			
			configureListeners(instance);
			setItemRendererBy(instance, i++);
			itemRenderers[itemRenderers.length] = contentPane.addChild(DisplayObject(instance));
		}
	}
	
	protected function dispatchItemChanged():void {
		dispatchEvent(new ListEvent(ListEvent.ITEM_CHANGE, _selectedItemRenderer));
	}
	
	protected function dragScroll():void {
		var newPosition:Number = verticalScrollPosition + dragScrollSize;
		if( newPosition > maxVerticalScrollPosition || newPosition < 0 ) {
			removeDragScrolling();
		} else {
			verticalScrollPosition = newPosition;
			scrollTarget();
			setDragGuider();
		}
	}
	
	private function drawMask(target:Shape):void {
		if( isNaN(getContentPaneWidth()) || isNaN(getContentPaneHeight()) )
			return;
		
		target.graphics.clear();
		target.graphics.beginBitmapFill(new BitmapData(1, 1, false));
		target.graphics.drawRect(contentPane.x, contentPane.y, getContentPaneWidth(), getContentPaneHeight());
		target.graphics.endFill();
	}
	
	/**
	 * 	롤오버 상태 그리기
	 */
	private function drawRollOverState():void {
		if( !scrolling && !DragManager.isDragging() ) {
			var usable:Boolean = replaceNullorUndefined(getStyle(StyleProp.USE_ROLL_OVER), true);
			var color:uint = replaceNullorUndefined(getStyle(StyleProp.ROLL_OVER_COLOR), 0xF8D888);
			rollOverShape.drawBy(_rollOveredItemRenderer, color, usable);
		}
	}
	
	/**
	 *	스크롤 시 선택 영역 그리기
	 */
	protected function drawSelectedState(useTween:Boolean=false):void {
		if( !selectionShape )
			return;
		
		var color:uint = replaceNullorUndefined(getStyle(StyleProp.SELECTION_COLOR), 0x51391D);
		var duration:Number = replaceNullorUndefined(getStyle(StyleProp.SELECTION_DURATION), 0.3);
		if( _allowMultipleSelection ) {
			if( useTween && _selectedIndices.length < 2 )
				selectionShape.multiDrawWithTransition(color, duration);
			else
				selectionShape.multiDraw(color);
		} else {
			if( useTween )
				selectionShape.drawWithTransition(_selectedItemRenderer, color, duration, _selectedItemRenderer != null);
			else
				selectionShape.drawBy(_selectedItemRenderer, color, _selectedItemRenderer != null);
		}
	}
	
	protected function getContentPaneWidth():Number {
		return getHScrollBarWidth() - viewMetrics.left - viewMetrics.right;
	}
	
	protected function getContentPaneHeight():Number {
		return getVScrollBarHeight() - viewMetrics.top - viewMetrics.bottom;
	}
	
	/**
	 *	인덱스에 따라 해당 아이템 데이타를 반환한다.
	 */
	protected function getDataBy(index:int):Object {
		return _dataProvider && getDataProviderLength() > 0?
			_dataProvider[index + _verticalLineIndex * _columnCount]:
			null;
	}
	
	private function getDataProviderLength():int {
		if( typeof _dataProvider == "xml" )
			return _dataProvider.length();
		if( _dataProvider is Array )
			return _dataProvider.length;
		return -1;
	}
	
	protected function getIndexByMousePosition():int {
		if( rowCount > 1 )
			return Math.floor(contentPane.mouseY / _rowHeight) * columnCount + Math.floor(contentPane.mouseX / columnWidth);
		return contentPane.mouseX / columnWidth;
	}
	
	/**
	 *	선택된곳 셀렉티드 변경 
	 */	
	protected function instanceSelected():void {
		if( !_allowMultipleSelection )
			return;
		
		var count:int = _selectedIndices.length;
		var indexArray:Array = [];
		var rendererCount:int = itemRenderers.length;
		indexArray = indexArray.concat(_selectedIndices);
		
		for( var rowVal:int=0; rowVal < rendererCount; rowVal++) {
			var renderer:IListItemRenderer = itemRenderers[rowVal] as IListItemRenderer;
			ISelectable(renderer).selected = false;
			for( var i:int=0; i<count; i++ ) {
				if( renderer.data === _dataProvider[indexArray[i]] ) {
					ISelectable(renderer).selected = true;
					break;
				}
			}
		}
	}
	
	protected function removeItemRenderers():void {
		while( itemRenderers.length > 0 ) {
			var instance:DisplayObject = itemRenderers.shift();
			if( instance && contentPane.contains(instance) ) {
				removeListeners(instance);
				contentPane.removeChild(instance);
			}
		}
	}
	
	private function removeDragGuider():void {
		if( dragGuider && contains(dragGuider) ) {
			removeChild(dragGuider);
			dragGuider = null;
		}
	}
	
	protected function removeDragScrolling():void {
		addendDelay = dragScrollSize = 0;
		clearInterval(intervalId);
		removeTimer();
	}
	
	private function removeListeners(dispatcher:IEventDispatcher):void {
		dispatcher.removeEventListener(MouseEvent.CLICK, clickHandler);
		dispatcher.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		dispatcher.removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
		dispatcher.removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
	}
	
	protected function resetMultiSelection():void {
		_selectedIndices = [];
		instanceSelected();
	}
	
	private function setColumnsAndRows():void {
		_columnCount = columnCountChanged ? columnCount : Math.ceil(getContentPaneWidth() / columnWidth);
		_columnWidth = columnWidthChanged ? columnWidth : getContentPaneWidth() / columnCount;
		_rowCount = rowCountChanged ? rowCount : Math.ceil(getContentPaneHeight() / rowHeight);
		_rowHeight = rowHeightChanged ? rowHeight : getContentPaneHeight() / rowCount;
	}
	
	private function selectionCancelable():Boolean {
		return !multipleSelecting && !_allowMultipleSelection &&
			_selectedItemRenderer && (_selectedItemRenderer is ISelectable);
	}
	
	protected function setDragGuider():void {
		var renderer:IListItemRenderer = getItemRendererBy(getIndexByMousePosition());
		if( renderer && renderer.data && renderer != _selectedItemRenderer ) {
			if( dragGuider ) {
				dragGuider.width = Math.floor(renderer.width);
				dragGuider.height = Math.floor(renderer.height);
				dragGuider.x = Math.floor(contentPane.x + renderer.x);
				dragGuider.y = Math.floor(contentPane.y + renderer.y);
				dragGuider.visible = true;
			}
			
			DragManager.showFeedback(DragManager.MOVE);
		} else {
			if( dragGuider )
				dragGuider.visible = false;
				
			DragManager.showFeedback(DragManager.REJECT);
		}
	}
	
	/**
	 *	드래그 스크롤을 하기 위한 프로퍼티를 설정한다.
	 */
	protected function setDragScrollProperties(addendDelay:Number, dragScrollSize:Number):void {
		this.addendDelay = addendDelay;
		this.dragScrollSize = dragScrollSize;
		
		clearInterval(intervalId);
		startTimer();
	}
	
	/**
	 *	인덱스로 렌더러의 x, y 좌표를 설정한다.
	 */
	protected function setItemPositionBy(item:IListItemRenderer, index:int):void {
		item.x = uint(index % _columnCount * _columnWidth);
		item.y = uint(Math.floor(index / _columnCount) * _rowHeight);
	}
	
	/**
	 *	인덱스에 따라 아이템 렌더러의 프로퍼티를 설정한다.
	 */
	private function setItemRendererBy(renderer:IListItemRenderer, index:int):void {
		if( renderer ) {
			renderer.width = _columnWidth;
			renderer.height = _rowHeight;
			renderer.data = getDataBy(index);
			DisplayObject(renderer).visible = renderer.data != null;
			
			setItemPositionBy(renderer, index);
		}
	}
	
	protected function setSelection(useTween:Boolean=false):void {
		if( !_dataProvider || !_selectable )
			return;

		if( _selectedItemRenderer is ISelectable )
			ISelectable(_selectedItemRenderer).selected = true;
		
		_selectedItem = _selectedItemRenderer ? IDataItemRenderer(_selectedItemRenderer).data : null;
		
		if( !selectedIndexChanged )
			_selectedIndex = (verticalScrollPosition * _columnCount) + getIndexByMousePosition();

		if( _allowMultipleSelection && _selectedIndices.indexOf(_selectedIndex) < 0 ) {
			if( _selectedItem )
				_selectedItems.push(_selectedItem);
			_selectedIndices.push(_selectedIndex);
		}

		drawSelectedState(useTween);
	}

	protected function setSelectionByIndex():void {
		var count:int = columnCount * rowCount;
		var row:int = selectedIndex / count;
		verticalScrollPosition = Math.min(maxVerticalScrollPosition, rowCount * row);
		_selectedItem = _dataProvider[_selectedIndex];
		
		scrollTarget();
	}
	
	private function setViewMetrics(defaultValue:Number=0):void {
		_viewMetrics = new EdgeMetrics(
			replaceNullorUndefined(getStyle(StyleProp.PADDING_LEFT), defaultValue),
			replaceNullorUndefined(getStyle(StyleProp.PADDING_TOP), defaultValue),
			replaceNullorUndefined(getStyle(StyleProp.PADDING_RIGHT), defaultValue),
			replaceNullorUndefined(getStyle(StyleProp.PADDING_BOTTOM), defaultValue)
		);
	}
	
	private function removeTimer():void {
		if( timer ) {
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
			timer = null;
		}
	}
	
	private function startTimer():void {
		removeTimer();
			
		timer = new Timer(timerDelay, 1);
		timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler, false, 0, true);
		timer.start();
	}
	
	protected function updateContentPaneDisplay():void {
		contentPane.x = getBorderThickness() + viewMetrics.left;
		contentPane.y = getBorderThickness() + viewMetrics.top;
		contentPane.width = getContentPaneWidth();
		contentPane.height = getContentPaneHeight();
	}
	
	protected function updateItemRendererProperties():void {
		if( _selectedItemRenderer is ISelectable )
			ISelectable(_selectedItemRenderer).selected = false;

		var gap:int = _verticalLineIndex - origineVerticalIndex;
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
			DisplayObject(renderer).visible = renderer.data != null;

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
	
	protected function updateItemRenderers():void {
		if( invalidSize() )
			return;

		if( itemRendererShouldBeUpdate ) {
			itemRendererShouldBeUpdate = false;
			removeItemRenderers();
			createItemRenderers();
		} else {
			alignItemRenderers();
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//	Event handlers
	//
	//--------------------------------------------------------------------------
	
	override protected function dragCompleteHandler(event:DragEvent):void {
		if( event.dragInitiator != contentPane )
			return;
		
		if( dragGuider )
			dragGuider.visible = false;
			
		removeDragScrolling();
		
		if( _dropEnabled ) {
			var target:IListItemRenderer = getItemRendererBy(getIndexByMousePosition());
			if( target && target.data && target != _selectedItemRenderer )
				DragManager.acceptDragDrop(DisplayObject(target));
			else
				DragManager.acceptDragDrop(null);
		}
	}
	
	override protected function dragDropHandler(event:DragEvent):void {
		if( !_dropEnabled || event.dragInitiator != contentPane )
			return;
		
		var index:int = getIndexByMousePosition();
		var renderer:IListItemRenderer = getItemRendererBy(index);
		
		if( !renderer || !renderer.data )
			return;
		
		changeData(dragItem, renderer.data);
		updateItemRendererProperties();
		dispatchEvent(new ListEvent(ListEvent.ITEM_SWAP, dragTarget));
	}
	
	override protected function dragEnterHandler(event:DragEvent):void {
		if( event.dragInitiator != contentPane )
			return;
		
		if( contentPane.mouseY > contentPane.height - _rowHeight / 2 )
			setDragScrollProperties(contentPane.height - contentPane.mouseY, 1);
		else if( contentPane.mouseY < _rowHeight / 2 )
			setDragScrollProperties((_rowHeight / 2 - contentPane.mouseY) * -1, -1);
		else
			removeDragScrolling();
		
		setDragGuider();
	}
	
	override protected function dragOverHandler(event:DragEvent):void {
		if( event.dragInitiator != contentPane )
			return;
		
		if( dragGuider )
			dragGuider.visible = false;
			
		addendDelay = dragScrollSize = 0;
		removeDragScrolling();
	}
	
	override protected function dragStartHandler(event:DragEvent):void {
		if( event.dragInitiator != contentPane )
			return;
		
		rollOverShape.clear();
	}
	
	override protected function scrollBar_rollOverHandler(event:MouseEvent):void {
		if( !event.buttonDown )
			rollOverShape.clear();
	}
	
	private function clickHandler(event:MouseEvent):void {
		if( IDataItemRenderer(event.currentTarget).data )
			dispatchEvent(new ListEvent(ListEvent.ITEM_CLICK, DisplayObject(event.currentTarget)));
	}
	
	private function doubleClickHandler(event:MouseEvent):void {
		if( IDataItemRenderer(event.currentTarget).data )
			dispatchEvent(new ListEvent(ListEvent.ITEM_DOUBLE_CLICK, DisplayObject(event.currentTarget)));
	}
	
	protected function keyDownHandler(event:KeyboardEvent):void {
		if( !_dataProvider || scrolling )
			return;
		
		var selectedIndexChanged:Boolean = true;
		switch( event.keyCode ) {
			case Keyboard.UP:
				_selectedIndex = _selectedIndex > 0 ? _selectedIndex - 1 : _selectedIndex;
				break;
				
			case Keyboard.DOWN:
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
	
	private function mouseDownHandler(event:MouseEvent):void {
		if( !_selectable )
			return;
		
		setFocus();
		rollOverShape.clear();
		
		var target:DisplayObject = DisplayObject(event.currentTarget);
		if( _dragEnabled && IDataItemRenderer(target).data ) {
			dragItem = IDataItemRenderer(target).data;
			dragTarget = target;
			
			DragManager.doDrag(contentPane, createDragImage(target),
				createDragSource(IListItemRenderer(target)), 0, 0, dropImageScale, 0.7);
			
			if( _dropEnabled )
				DragManager.acceptDragDrop(contentPane);
		}
		
		if( target !== _selectedItemRenderer ) {
			multipleSelecting = event.ctrlKey && _allowMultipleSelection;

			if( IDataItemRenderer(target).data ) {
				if( !multipleSelecting )
					resetMultiSelection();
				
				selectedItemRenderer = target;
				dispatchEvent(new ListEvent(ListEvent.ITEM_CHANGE, _selectedItemRenderer));
			}
		}
	}
	
	private function rollOutHandler(event:MouseEvent):void {
		if( event.currentTarget === this ) {
			if( !event.buttonDown )	rollOverShape.clear();
		} else if( IDataItemRenderer(event.currentTarget).data ) {
			dispatchEvent(new ListEvent(ListEvent.ITEM_ROLL_OUT, DisplayObject(event.currentTarget)));
		}
	}
	
	private function rollOverHandler(event:MouseEvent):void {
		if( event.buttonDown || scrolling )
			return;

		_rollOveredItemRenderer = DisplayObject(event.currentTarget);

		if( IDataItemRenderer(_rollOveredItemRenderer).data ) {
			drawRollOverState();
			dispatchEvent(new ListEvent(ListEvent.ITEM_ROLL_OVER, _rollOveredItemRenderer));
		} else {
			rollOverShape.clear();
		}
	}
	
	/**
	 * 	flash.events.TimerEvent.TIMER_COMPLETE
	 */
	private function timerCompleteHandler(event:TimerEvent):void {
		removeTimer();
		intervalId = setInterval(dragScroll, delay + addendDelay);
	}
	
	private function stage_mouseLeaveHandler(event:Event):void {
		rollOverShape.clear();
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//	columnCount
	//--------------------------------------
	
	private var columnCountChanged:Boolean;
	
	protected var _columnCount:uint = 0;
	
	public function get columnCount():uint {
		return _columnCount;
	}
	
	public function set columnCount(value:uint):void {
		if( value == _columnCount )
			return;
		
		_columnCount = value;
		columnCountChanged = true;
		columnWidthChanged = false;
		itemRendererShouldBeUpdate = true;
		
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	columnWidth
	//--------------------------------------
	
	private var columnWidthChanged:Boolean;
	
	protected var _columnWidth:Number;
	
	public function get columnWidth():Number {
		return _columnWidth;
	}
	
	public function set columnWidth(value:Number):void {
		if( value == _columnCount )
			return;
		
		_columnWidth = value;
		columnCountChanged = false;
		columnWidthChanged = true;
		itemRendererShouldBeUpdate = true;
		
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	dataField
	//--------------------------------------
	
	private var _dataField:String = "data";
	
	public function get dataField():String {
		return _dataField;
	}
	
	public function set dataField(value:String):void {
		_dataField = value;
	}
	
	//--------------------------------------
	//	dataProvider
	//--------------------------------------
	
	private var dataProviderChanged:Boolean;
	
	protected var _dataProvider:Object; /* of object, string */
	
	public function get dataProvider():Object {
		return _dataProvider;
	}
	
	public function set dataProvider(value:Object):void {
		if( value === _dataProvider )
			return;

		_dataProvider = value;
		dataProviderChanged = true;
		dataProviderLength = getDataProviderLength();
		
		invalidateProperties();
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	dragEnabled
	//--------------------------------------
	
	private var _dragEnabled:Boolean = false;
	
	public function get dragEnabled():Boolean {
		return _dragEnabled;
	}
	
	public function set dragEnabled(value:Boolean):void {
		_dragEnabled = value;
	}
	
	//--------------------------------------
	//	dropEnabled
	//--------------------------------------
	
	private var _dropEnabled:Boolean = false;
	
	public function get dropEnabled():Boolean {
		return _dropEnabled;
	}
	
	public function set dropEnabled(value:Boolean):void {
		_dropEnabled = value;
	}
	
	//--------------------------------------
	//	dropImageScale
	//--------------------------------------
	
	private var _dropImageScale:Number = 1.5;
	
	public function get dropImageScale():Number {
		return _dropImageScale;
	}
	
	public function set dropImageScale(value:Number):void {
		_dropImageScale = value;
	}
	
	//--------------------------------------
	//	horizontalLineIndex
	//--------------------------------------
	
	protected var _horizontalLineIndex:int;
	
	public function get horizontalLineIndex():int {
		return _horizontalLineIndex;
	}
	
	//--------------------------------------
	//	itemRenderer
	//--------------------------------------
	
	private var _itemRenderer:ClassFactory = new ClassFactory(ListItemRenderer);
	
	public function get itemRenderer():ClassFactory {
		return _itemRenderer;
	}
	
	public function set itemRenderer(value:ClassFactory):void {
		if( value === _itemRenderer )
			return;
		
		_itemRenderer = value;
		itemRendererShouldBeUpdate = true;

		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	labelField
	//--------------------------------------
	
	private var _labelField:String = "label";
	
	public function get labelField():String {
		return _labelField;
	}
	
	public function set labelField(value:String):void {
		if( value == _labelField )
			return;
		
		_labelField = value;
		
		dispatchEvent(new Event("labelFieldChanged"));
	}
	
	//--------------------------------------
	//	rowCount
	//--------------------------------------
	
	protected var rowCountChanged:Boolean;
	
	protected var _rowCount:uint = 0;
	
	public function get rowCount():uint {
		return _rowCount;
	}
	
	public function set rowCount(value:uint):void {
		if( value == _rowCount )
			return;
		
		_rowCount = value;
		rowCountChanged = true;
		rowHeightChanged = false;
		itemRendererShouldBeUpdate = true;
		
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	rowHeight
	//--------------------------------------
	
	protected var rowHeightChanged:Boolean;
	
	protected var _rowHeight:Number;
	
	public function get rowHeight():Number {
		return _rowHeight;
	}
	
	public function set rowHeight(value:Number):void {
		if( value == _rowHeight )
			return;
		
		_rowHeight = value;
		rowCountChanged = false;
		rowHeightChanged = true;
		itemRendererShouldBeUpdate = true;
		
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	rollOveredItemRenderer
	//--------------------------------------
	
	private var _rollOveredItemRenderer:DisplayObject;
	
	private function get rollOveredItemRenderer():DisplayObject {
		return _rollOveredItemRenderer;
	}
	
	//--------------------------------------
	//	selectable
	//--------------------------------------
	
	protected var _selectable:Boolean = true;
	
	public function get selectable():Boolean {
		return _selectable;
	}
	
	public function set selectable(value:Boolean):void {
		if( value == _selectable )
			return;
		
		_selectable = value;
	}
	
	//--------------------------------------
	//	selectedItemRenderer
	//--------------------------------------
	
	private var selectedItemRendererChanged:Boolean;
	
	protected var _selectedItemRenderer:DisplayObject;
	
	private function get selectedItemRenderer():DisplayObject {
		return _selectedItemRenderer;
	}
	
	private function set selectedItemRenderer(value:DisplayObject):void {
		if( value === _selectedItemRenderer )
			return;
		
		if( selectionCancelable() )
			ISelectable(_selectedItemRenderer).selected = multipleSelecting = false;
		
		_selectedItemRenderer = value;
		selectedItemRendererChanged = true;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//	selectedIndex
	//--------------------------------------
	
	protected var selectedIndexChanged:Boolean;
	
	protected var _selectedIndex:int = -1;
	
	public function get selectedIndex():int {
		return _selectedIndex;
	}
	
	public function set selectedIndex(value:int):void {
		if( value == _selectedIndex )
			return;
		
		_selectedIndex = value;
		selectedIndexChanged = true;
		
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	selectedItem
	//--------------------------------------
	
	protected var _selectedItem:Object;
	
	public function get selectedItem():Object {
		return _selectedItem;
	}
	
	//--------------------------------------
	//	selectedItems
	//--------------------------------------
	
	protected var _selectedItems:Array = [];
	
	public function get selectedItems():Array {
		return _selectedItems;
	}
	
	//--------------------------------------
	//	selectedIndices
	//--------------------------------------
	
	protected var _selectedIndices:Array = [];
	
	public function get selectedIndices():Array {
		return _selectedIndices;
	}
	
	public function set selectedIndices(value:Array):void {
		if( value === _selectedIndices )
			return;
		
		_selectedIndices = value;
		selectedIndexChanged = true;
		invalidateProperties();
	}
	
	//--------------------------------------
	//	allowMultipleSelection
	//--------------------------------------
	
	protected var _allowMultipleSelection:Boolean;
	
	public function get allowMultipleSelection():Boolean {
		return _allowMultipleSelection;
	}
	
	public function set allowMultipleSelection(value:Boolean):void {
		if( value == _allowMultipleSelection )
			return;
		
		_allowMultipleSelection = value;
	}
	
	//--------------------------------------
	//	verticalLineIndex
	//--------------------------------------
	
	private var _verticalLineIndex:int;
	
	public function get verticalLineIndex():int {
		return _verticalLineIndex;
	}
	
	//--------------------------------------
	//  viewMetrics
	//--------------------------------------
	
	private var _viewMetrics:EdgeMetrics;
	
	public function get viewMetrics():EdgeMetrics {
		return _viewMetrics;
	}
}

}