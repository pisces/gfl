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

import collection.Hashtable;

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
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.ArrayUtil;
import com.golfzon.gfl.utils.BitmapDataUtil;
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
import flash.geom.Point;
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
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.09.29
 *	@Modify
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
    private var DRAG_GUIDE_SKIN:Class;
    
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
    
    protected var dragScrollSize:int;
    
    private var itemRendererShouldBeUpdate:Boolean = true;
    
    protected var itemRenderers:Array /* of object */ = [];
    
    private var dragItem:Object;
    
    private var dragGuider:DisplayObject;
    
    private var contentMask:Shape;
    private var selectionShape:ListShape;
    private var rollOverShape:ListShape;
    
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
	}
	
    //--------------------------------------------------------------------------
	//
	//	Instance methods
	//
    //--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------
    //  Overriden : ScrollControlBase
    //--------------------------------------------------------------------------
    
    /**
     * 	프로퍼티 변경 사항에 대한 처리
     */
    override protected function commitProperties():void {
    	super.commitProperties();
    	
    	if( selectedItemRendererChanged ) {
    		selectedItemRendererChanged = false;
			setFocus();
    		setSelection(true);
    	}
    }
    
    /**
     * 	자식 객체 생성 및 추가
     */
	override protected function createChildren():void {
		super.createChildren();

		contentMask = new Shape();
		selectionShape = new ListShape(this);
		rollOverShape = new ListShape(this);
		contentPane = new ComponentBase();
		contentPane.mask = contentMask;
		
    	setViewMetrics();
		addChild(contentMask);
		addChild(rollOverShape);
		addChild(selectionShape);
		addChild(contentPane);
		createDragGuider();
	}
    
    /**
     * 	상속 스타일 정의
     */
    override public function getInheritStyleTable():Hashtable {
    	var table:Hashtable = super.getInheritStyleTable();
    	table.add(StyleProp.TEXT_ROLL_OVER_COLOR, StyleProp.TEXT_ROLL_OVER_COLOR);
    	table.add(StyleProp.TEXT_SELECTED_COLOR, StyleProp.TEXT_SELECTED_COLOR);
    	return table;
    }
    
	/**
	 *	크기 변경 구현
	 */
    override protected function measure():void {
    	super.measure();
    	
    	if( sizeChanged() ) {
    		itemRendererShouldBeUpdate = true;
    		resetOrigineSize();
    	}
    }
    
	/**
	 *	타겟 스크롤
	 */
    override protected function scrollTarget():void {
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
    	drawContentMask();
	    
	    if( !dataProvider )
	    	return;
	    
	    updateItemRenderers();
	    
	    if( selectedIndexChanged ) {
	    	selectedIndexChanged = false;
	    	setSelectionByIndex();
	    } else {
			updateItemRendererProperties();
	    }
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
    
    //--------------------------------------------------------------------------
    //  Internal
    //--------------------------------------------------------------------------
    
	/**
	 *	인덱스에 따라 아이템 렌더러의 프로퍼티를 설정한다.
	 */
    protected function setItemRendererBy(index:int, renderer:IListItemRenderer):void {
    	throw new Error("이 메소드는 구현이 필요한 추상 메소드입니다.");
    }
    
    /**
     * 	스크롤 범위값을 설정한다.
     */
    protected function setScrollProperties():void {
    	throw new Error("이 메소드는 구현이 필요한 추상 메소드입니다.");
    }
    
	/**
	 *	@private
	 * 	change data for dataProvider
	 */
    protected function changeData(index:int, item1:Object, item2:Object):void {
    	_dataProvider[index + verticalLineIndex] = item1;
    	_dataProvider[_selectedIndex] = item2;
    }
    
	/**
	 *	@private
	 */
    private function configureListeners(dispatcher:IEventDispatcher):void {
    	dispatcher.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
    	dispatcher.addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler, false, 0, true);
    	dispatcher.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
    	dispatcher.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler, false, 0, true);
    	dispatcher.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler, false, 0, true);
    }
    
	/**
	 *	@private
	 */
    private function createDragGuider():void {
    	var definition:Class = replaceNullorUndefined(getStyle(StyleProp.DRAG_GUIDE_SKIN), DRAG_GUIDE_SKIN);
    	if( definition ) {
    		dragGuider = createSkinBy(definition);
    		dragGuider.visible = false;
    		addChild(dragGuider);
    	}
    }
    
	/**
	 *	@private
	 */
    private function createItemRenderers():void {
    	if( !dataProvider )
    		return;
    	
    	var i:int = 0;
    	while( itemRenderers.length < columnCount * rowCount ) {
    		var instance:IListItemRenderer = itemRenderer.newInstance();
    		configureListeners(instance);
    		instance.listOwner = this;
    		itemRenderers[itemRenderers.length] = contentPane.addChild(DisplayObject(instance));
    	}
    }
    
	/**
	 *	@private
	 */
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
    
	/**
	 *	@private
	 */
    private function drawContentMask():void {
    	if( isNaN(getContentPaneWidth()) || isNaN(getContentPaneHeight()) )
    		return;
    	
    	contentMask.graphics.clear();
    	contentMask.graphics.beginBitmapFill(new BitmapData(1, 1, false));
    	contentMask.graphics.drawRect(contentPane.x, contentPane.y, getContentPaneWidth(), getContentPaneHeight());
    	contentMask.graphics.endFill();
    }
    
	/**
	 *	@private
	 * 	롤오버 상태 그리기
	 */
    private function drawRollOverState():void {
    	if( !scrolling && !DragManager.isDragging() ) {
	    	var usable:Boolean = replaceNullorUndefined(getStyle(StyleProp.USE_ROLL_OVER), true);
			var color:uint = replaceNullorUndefined(getStyle(StyleProp.ROLL_OVER_COLOR), 0xECEEF4);
			rollOverShape.drawBy(_rollOveredItemRenderer, color, usable);
    	}
    }
    
	/**
	 *	@private
	 *	스크롤 시 선택 영역 그리기
	 */
    private function drawSelectedState(useTween:Boolean=false):void {
		var color:uint = replaceNullorUndefined(getStyle(StyleProp.SELECTION_COLOR), 0x6D84B4);
		var duration:Number = replaceNullorUndefined(getStyle(StyleProp.SELECTION_DURATION), 0.3);
		
		if( useTween )
			selectionShape.drawWithTransition(selectedItemRenderer, color, duration, selectedItemRenderer != null);
		else
			selectionShape.drawBy(selectedItemRenderer, color, selectedItemRenderer != null);
    }
    
	/**
	 *	@private
	 */
    protected function getContentPaneWidth():Number {
    	return getHScrollBarWidth() - viewMetrics.left - viewMetrics.right;
    }
    
	/**
	 *	@private
	 */
    protected function getContentPaneHeight():Number {
    	return getVScrollBarHeight() - viewMetrics.top - viewMetrics.bottom;
    }
    
	/**
	 *	@private
	 */
    private function getIndexByMousePosition():int {
    	if( rowCount > 1 )
    		return Math.floor(mouseY / rowHeight) * columnCount + Math.floor(mouseX / columnWidth);
    	return mouseX / columnWidth;
    }
    
	/**
	 *	@private
	 */
    private function removeItemRenderers():void {
    	while( itemRenderers.length > 0 ) {
    		var instance:DisplayObject = itemRenderers.shift();
    		if( instance && contentPane.contains(instance) ) {
    			removeListeners(instance);
    			contentPane.removeChild(instance);
    		}
    	}
    }
    
	/**
	 *	@private
	 */
    private function removeDragGuider():void {
    	if( dragGuider && contains(dragGuider) ) {
    		removeChild(dragGuider);
    		dragGuider = null;
    	}
    }
    
	/**
	 *	@private
	 */
    protected function removeDragScrolling():void {
		addendDelay = dragScrollSize = 0;
    	clearInterval(intervalId);
    	removeTimer();
    }
    
	/**
	 *	@private
	 */
    private function removeListeners(dispatcher:IEventDispatcher):void {
    	dispatcher.removeEventListener(MouseEvent.CLICK, clickHandler);
    	dispatcher.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
    	dispatcher.removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
    	dispatcher.removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
    }
    
	/**
	 *	@private
	 */
    private function setColumnsAndRows():void {
	    _columnCount = columnCountChanged ? columnCount : Math.ceil(getContentPaneWidth() / columnWidth);
    	_columnWidth = columnWidthChanged ? columnWidth : getContentPaneWidth() / columnCount;
	    _rowCount = rowCountChanged ? rowCount : Math.ceil(getContentPaneHeight() / rowHeight);
	    _rowHeight = rowHeightChanged ? rowHeight : getContentPaneHeight() / rowCount;
    }
    
	/**
	 *	@private
	 */
    protected function setDragGuider():void {
    	var renderer:IListItemRenderer = getItemRendererBy(getIndexByMousePosition());
    	if( renderer && renderer.data && renderer != _selectedItemRenderer ) {
    		dragGuider.width = Math.floor(renderer.width);
    		dragGuider.height = Math.floor(renderer.height);
    		dragGuider.x = Math.floor(renderer.x);
    		dragGuider.y = Math.floor(renderer.y);
    		dragGuider.visible = true;
    	} else {
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
	 *	@private
	 */
    private function setSelection(useTween:Boolean=false):void {
		if( !_dataProvider )
			return;
		
		if( _selectedItemRenderer is ISelectable )
			ISelectable(_selectedItemRenderer).selected = true;
		
		_selectedItem = _selectedItemRenderer ? IDataItemRenderer(_selectedItemRenderer).data : null;
		_selectedIndex = ArrayUtil.getItemIndex(_selectedItem, _dataProvider);
		drawSelectedState(useTween);
		dispatchEvent(new ListEvent(ListEvent.ITEM_CHANGE, _selectedItemRenderer));
    }

	/**
	 *	@private
	 */
    private function setSelectionByIndex():void {
    	var count:int = columnCount * rowCount;
		var row:int = selectedIndex / count;
		var gap:int = rowCount * row - maxVerticalScrollPosition;
		var addend:int = rowCount * row > maxVerticalScrollPosition ? gap * columnCount : 0;
		var childIndex:int = selectedIndex % count + addend;
		verticalScrollPosition = Math.min(maxVerticalScrollPosition, rowCount * row);
		scrollTarget();
		selectedItemRenderer = selectedIndex > -1 && selectedIndex < dataProvider.length ?
			contentPane.getChildAt(childIndex) : null;
    }
    
	/**
	 *	@private
	 */
    private function setViewMetrics(defaultValue:Number=0):void {
    	_viewMetrics = new EdgeMetrics(
    		replaceNullorUndefined(getStyle(StyleProp.PADDING_LEFT), defaultValue),
    		replaceNullorUndefined(getStyle(StyleProp.PADDING_TOP), defaultValue),
    		replaceNullorUndefined(getStyle(StyleProp.PADDING_RIGHT), defaultValue),
    		replaceNullorUndefined(getStyle(StyleProp.PADDING_BOTTOM), defaultValue)
    	);
    }
    
    /**
     *	@private
     */
    private function removeTimer():void {
    	if( timer ) {
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
			timer = null;
    	}
    }
    
    /**
     *	@private
     */
    private function startTimer():void {
    	removeTimer();
    		
    	timer = new Timer(timerDelay, 1);
		timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler, false, 0, true);
		timer.start();
    }
    
	/**
	 *	@private
	 */
    protected function updateContentPaneDisplay():void {
		contentPane.x = getBorderThickness() + viewMetrics.left;
		contentPane.y = getBorderThickness() + viewMetrics.top;
		contentPane.width = getContentPaneWidth();
		contentPane.height = getContentPaneHeight();
    }
    
	/**
	 *	아이템렌더러들의 프로퍼티를 설정한다.
	 */
    protected function updateItemRendererProperties():void {
    	if( _selectedItemRenderer is ISelectable )
			ISelectable(_selectedItemRenderer).selected = false;
			
    	var i:int = 0;
    	var wasNotSelectedState:Boolean = true;
    	while( i < itemRenderers.length ) {
    		var instance:IListItemRenderer = itemRenderers[i];
    		setItemRendererBy(i++, instance);
    		
    		// set up the selected item by selected item renderer.
    		if( !selectedItem && instance == _selectedItemRenderer ) {
    			wasNotSelectedState = false;
    			_selectedItem = instance.data;
    		// keep on the state for selection.
    		} else if( instance.data && instance.data == _selectedItem ) {
    			wasNotSelectedState = false;
    			_selectedItemRenderer = DisplayObject(instance);
    			drawSelectedState();
    	
		    	if( _selectedItemRenderer is ISelectable )
					ISelectable(_selectedItemRenderer).selected = true;
    		// keep on the state for roll over.
    		} else if( instance == _rollOveredItemRenderer && _rollOveredItemRenderer.hitTestPoint(stage.mouseX, stage.mouseY, true) ) {
    			if( instance.data )
					drawRollOverState();
    			else
    				rollOverShape.clear();
    		}
    	}
    	
    	if( wasNotSelectedState ) {
    		_selectedItemRenderer = null;
    		drawSelectedState();
    	}
    }
    
	/**
	 *	@private
	 */
    private function updateItemRenderers():void {
    	if( isNaN(unscaledWidth) || isNaN(unscaledHeight) )
    		return;

    	if( itemRendererShouldBeUpdate ) {
    		itemRendererShouldBeUpdate = false;
    		removeItemRenderers();
    		createItemRenderers();
    	}
    }
    
    //--------------------------------------------------------------------------
	//
	//	Event handlers
	//
    //--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------
    //  Overriden : ScrollControlBase
    //--------------------------------------------------------------------------
    
	/**
	 *	@private
	 */
    override protected function dragCompleteHandler(event:DragEvent):void {
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
    
	/**
	 *	@private
	 */
    override protected function dragDropHandler(event:DragEvent):void {
    	if( !_dropEnabled )
    		return;
    	
    	var index:int = getIndexByMousePosition();
    	var renderer:IListItemRenderer = getItemRendererBy(index);
    	
    	if( !renderer || !renderer.data )
    		return;
    	
    	var cachedData:Object = renderer.data;
    	
    	changeData(index, dragItem, cachedData);
    	
    	// change data for renderers
    	renderer.data = dragItem;
    	
    	if( _selectedItemRenderer )
    		IListItemRenderer(_selectedItemRenderer).data = cachedData;

    	_selectedItem = cachedData;
    	dragItem = null;
    }
    
	/**
	 *	@private
	 */
    override protected function dragEnterHandler(event:DragEvent):void {
		if( mouseY > unscaledHeight - rowHeight / 2 )
			setDragScrollProperties(unscaledHeight - mouseY, 1);
		else if( mouseY < rowHeight / 2 )
			setDragScrollProperties((rowHeight / 2 - mouseY) * -1, -1);
		else
			removeDragScrolling();
		
		setDragGuider();
    }
    
	/**
	 *	@private
	 */
    override protected function dragOverHandler(event:DragEvent):void {
    	dragGuider.visible = false;
		addendDelay = dragScrollSize = 0;
		removeDragScrolling();
    }
    
	/**
	 *	@private
	 */
	override protected function dragStartHandler(event:DragEvent):void {
		dragItem = _selectedItem;
		rollOverShape.clear();
	}
	
	/**
	 *	@private
	 */
	override protected function scrollBar_rollOverHandler(event:MouseEvent):void {
		if( !event.buttonDown )
			rollOverShape.clear();
	}
	
    //--------------------------------------------------------------------------
    //  Internal
    //--------------------------------------------------------------------------
    
	/**
	 *	@private
	 */
    private function clickHandler(event:MouseEvent):void {
		if( IDataItemRenderer(event.currentTarget).data )
			dispatchEvent(new ListEvent(ListEvent.ITEM_CLICK, DisplayObject(event.currentTarget)));
    }
    
	/**
	 *	@private
	 */
    protected function createDragImage(itemRenderer:DisplayObject):DisplayObject {
		var bitmapData:BitmapData = BitmapDataUtil.generate(itemRenderer);
    	var dragImage:Bitmap = new Bitmap(bitmapData);
    	var point:Point = localToGlobal(new Point(itemRenderer.x, itemRenderer.y));
		dragImage.x = point.x;
		dragImage.y = point.y;
		return dragImage;
    }
    
	/**
	 *	@private
	 */
    protected function createDragSource(itemRenderer:IListItemRenderer):Object {
		return itemRenderer.data;
    }
    
	/**
	 *	@private
	 */
    private function doubleClickHandler(event:MouseEvent):void {
		if( IDataItemRenderer(event.currentTarget).data )
			dispatchEvent(new ListEvent(ListEvent.ITEM_DOUBLE_CLICK, DisplayObject(event.currentTarget)));
    }
	
	/**
	 *  @protected
	 */	
	protected function keyDownHandler(event:KeyboardEvent):void {
		if( !_dataProvider || scrolling )
			return;
		
		switch( event.keyCode ) {
			case Keyboard.UP:
				selectedIndex = selectedIndex > 0 ? selectedIndex - 1 : selectedIndex;
				break;
				
			case Keyboard.DOWN:
				selectedIndex = selectedIndex < _dataProvider.length - 1 ? selectedIndex + 1 : selectedIndex;
				break;
		}
	}
	
	/**
	 *	@private
	 */
	private function mouseDownHandler(event:MouseEvent):void {
		var target:DisplayObject = DisplayObject(event.currentTarget);
		
		if( _dragEnabled && IDataItemRenderer(event.currentTarget).data ) {
			DragManager.doDrag(contentPane, createDragImage(target),
				createDragSource(IListItemRenderer(target)), 0, 0, dropImageScale);
			
			if( _dropEnabled )
				DragManager.acceptDragDrop(contentPane);
		}
		
		if( _selectedItemRenderer == target )
			return;
		
		if( IDataItemRenderer(event.currentTarget).data )
			selectedItemRenderer = target;
	}
	
	/**
	 *	@private
	 */
	private function rollOutHandler(event:MouseEvent):void {
		if( event.currentTarget == this ) {
			if( !event.buttonDown )	rollOverShape.clear();
		} else if( IDataItemRenderer(event.currentTarget).data ) {
			dispatchEvent(new ListEvent(ListEvent.ITEM_ROLL_OUT, DisplayObject(event.currentTarget)));
		}
	}
	
	/**
	 *	@private
	 */
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
     *	@private
     * 	flash.events.TimerEvent.TIMER_COMPLETE
     */
    private function timerCompleteHandler(event:TimerEvent):void {
    	removeTimer();
    	intervalId = setInterval(dragScroll, delay + addendDelay);
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
	
	private var _columnCount:uint = 0;
	
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
	
	private var _columnWidth:Number;
	
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
	
	private var _dataProvider:Array; /* of object, string */
	
	public function get dataProvider():Array {
		return _dataProvider;
	}
	
	public function set dataProvider(value:Array):void {
		if( value === _dataProvider )
			return;
		
		_dataProvider = value;
		itemRendererShouldBeUpdate = true;
		
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
	
	private var _horizontalLineIndex:int;
	
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
	
	private var rowCountChanged:Boolean;
	
	private var _rowCount:uint = 0;
	
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
	
	private var rowHeightChanged:Boolean;
	
	private var _rowHeight:Number;
	
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
	//	selectedItemRenderer
	//--------------------------------------
	
	private var selectedItemRendererChanged:Boolean;
	
	private var _selectedItemRenderer:DisplayObject;
	
	private function get selectedItemRenderer():DisplayObject {
		return _selectedItemRenderer;
	}
	
	private function set selectedItemRenderer(value:DisplayObject):void {
		if( value === _selectedItemRenderer )
			return;
		
		if( _selectedItemRenderer && (_selectedItemRenderer is ISelectable) )
			ISelectable(_selectedItemRenderer).selected = false;
		
		_selectedItemRenderer = value;
		selectedItemRendererChanged = true;
		
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
		
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	selectedItem
	//--------------------------------------
	
	private var _selectedItem:Object;
	
	public function get selectedItem():Object {
		return _selectedItem;
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