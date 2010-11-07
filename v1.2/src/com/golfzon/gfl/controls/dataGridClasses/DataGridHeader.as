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

package com.golfzon.gfl.controls.dataGridClasses
{
	
import com.golfzon.gfl.controls.DataGrid;
import com.golfzon.gfl.controls.listClasses.BaseListData;
import com.golfzon.gfl.controls.listClasses.IListItemRenderer;
import com.golfzon.gfl.core.BorderBasedComponent;
import com.golfzon.gfl.core.gz_internal;
import com.golfzon.gfl.events.DataGridEvent;
import com.golfzon.gfl.events.DragEvent;
import com.golfzon.gfl.events.IndexChangedEvent;
import com.golfzon.gfl.managers.DragManager;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.BitmapDataUtil;
import com.golfzon.gfl.utils.UIDUtil;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.GradientType;
import flash.display.Shape;
import flash.display.SpreadMethod;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.geom.Matrix;

use namespace gz_internal;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *	헤더렌더러의 인덱스가 변경되면 송출한다.
 */
[Event(name="change", type="com.golfzon.gfl.events.IndexChangedEvent")]

/**
 *	데이타 정렬 요청을 받으면 송출한다.
 */
[Event(name="dataSort", type="com.golfzon.gfl.events.DataGridEvent")]

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *	Skin for drag guider<br>
 * 	@default value ListBase_dragGuideSkin of GZSkin.swf
 */
[Style(name="dragGuideSkin", type="Class", inherit="no")]

/**
 *	Sorting arrow down skin<br>
 * 	@default value DataGrid_downArrowSkin of GZSkin.swf
 */
[Style(name="downArrowSkin", type="Class", inherit="no")]

/**
 *	Sorting arrow up skin<br>
 * 	@default value DataGrid_upArrowSkin of GZSkin.swf
 */
[Style(name="upArrowSkin", type="Class", inherit="no")]

/**
 *	Colors for header on roll over<br>
 * 	@default value [#E1E1E1, #FFFFFF]
 */
[Style(name="rollOverColors", type="Array", inherit="no")]

/**
 *	@Author				KHKim
 *	@Version			1.0
 *	@Lanaguage			Action Script 3.0
 *	@Date				2010.4.19.
 *	@Modify
 *	@Description
 */
public class DataGridHeader extends BorderBasedComponent
{
	//--------------------------------------------------------------------------
	//
	//  Instance constants
	//
	//--------------------------------------------------------------------------
	
	private const ARROW_STATE_DOWN:String = "arrowStateDown";
	private const ARROW_STATE_UP:String = "arrowStateUp";
	
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	[Embed(source="/assets/GZSkin.swf", symbol="ListBase_dragGuideSkin")]
	private var dragGuideSkinClass:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="DataGrid_downArrowSkin")]
	private var downArrowSkinClass:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="DataGrid_upArrowSkin")]
	private var upArrowSkinClass:Class;
	
	private var arrowState:String;
	
	private var dragStarted:Boolean;
	
	private var renderers:Array;
	
	private var arrow:DisplayObject;
	private var dragGuider:DisplayObject;
	private var dragInititor:DisplayObject;
	private var dragDropTarget:DisplayObject;
	
	private var rollOverShape:Shape;
	
	private var dataGrid:DataGrid;
	
	private var selectedRenderer:IListItemRenderer;
	
	/**
	 *	@Construct
	 */
	public function DataGridHeader() {
		super();
		
		setStyle(StyleProp.BORDER_SKIN, DataGridHeaderSkin);
	}
	
	//--------------------------------------------------------------------------		
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------
    
	//--------------------------------------------------------------------------
	//	Overriden : ComponentBase
	//--------------------------------------------------------------------------
	
	/**
	 * 	자식 객체 생성 및 추가
	 */
	override protected function createChildren():void {
		super.createChildren();
		
		dataGrid = parent as DataGrid;
		
		rollOverShape = new Shape();
		
		addChild(rollOverShape);
		createDragGuider();
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
		}
	}
	
	/**
	 *	디스플레이 변경사항에 대한 처리 
	 */	
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		border.width = unscaledWidth;
		border.height = unscaledHeight;
		
		setRendererProperties();
	}
	
	override protected function dragStartHandler(event:DragEvent):void {
		dragStarted = true;
	}
	
	override protected function dragEnterHandler(event:DragEvent):void {
		var instance:DisplayObject = getItemRendererByMousePosition();
		if( instance && instance !== event.dragInitiator ) {
			DragManager.showFeedback(DragManager.MOVE);
			setDragGuider(IListItemRenderer(instance));
		} else {
			DragManager.showFeedback(DragManager.REJECT);
			dragGuider.visible = false;
		}
	}
	
	override protected function dragCompleteHandler(event:DragEvent):void {
		rollOverShape.graphics.clear();
		dragGuider.visible = false;
		dragStarted = false;
		dragDropTarget = getItemRendererByMousePosition();
		
		if( dragDropTarget )
			DragManager.acceptDragDrop(dragDropTarget);
	}
	
	override protected function dragDropHandler(event:DragEvent):void {
		var origineIndex:int = renderers.indexOf(dragInititor);
		var newIndex:int = renderers.indexOf(dragDropTarget);
		
		renderers[newIndex] = dragInititor;
		renderers[origineIndex] = dragDropTarget;
		
		dragInititor = null;
		dragDropTarget = null;
		
		dispatchEvent(new IndexChangedEvent(IndexChangedEvent.CHANGE, origineIndex, newIndex));
	}
	
	//--------------------------------------------------------------------------
	//	Public
	//--------------------------------------------------------------------------
	
	/**
	 *	컬럼에 따라 헤더랜더러들의 속성을 설정한다.
	 */
	public function setRendererProperties():void {
		if( !renderers )
			return;
		
		var cx:Number = 0;
		var i:int = 0;
		while( i < renderers.length ) {
			var column:DataGridColumn = dataGrid.columns[i];
			var renderer:IListItemRenderer = renderers[i];
			renderer.listData.columnIndex = i;
			renderer.width = isNaN(column.width) ? dataGrid.calculatedColumnWidth : column.width;
			renderer.height = unscaledHeight;
			renderer.x = cx;
			cx += renderer.width;
			i++;
		}
		
		if( arrow && selectedRenderer )
			arrow.x = Math.floor(selectedRenderer.x + selectedRenderer.width - arrow.width - 5);
	}
	
	/**
	 *	헤더랜더러들을 지우고 다시 랜더링한다.
	 */
	public function update():void {
		if( canUpdate() ) {
			removeRenderers();
			createRenderers();
		}
	}
	
	//--------------------------------------------------------------------------
	//	Internal
	//--------------------------------------------------------------------------
	
	private function createDragGuider():void {
		var definition:Class = replaceNullorUndefined(getStyle(StyleProp.DRAG_GUIDE_SKIN), dragGuideSkinClass);
		if( definition ) {
			dragGuider = createSkinBy(definition);
			dragGuider.visible = false;
			addChild(dragGuider);
		}
	}
	
	private function createDragImage(target:DisplayObject):DisplayObject {
		var bitmapData:BitmapData = BitmapDataUtil.crop(this, target.x * -1, 0, target.width, target.height);
		var dragImage:Bitmap = new Bitmap(bitmapData);
		dragImage.x = stage.mouseX - target.mouseX;
		dragImage.y = stage.mouseY - target.mouseY;
		dragImage.filters = [new DropShadowFilter(3, 45, 0, 0.5, 2, 2, 1, 10)];
		return dragImage;
	}
	
	private function canUpdate():Boolean {
		return dataGrid && dataGrid.columns;
	}
	
	private function configureListeners(dispatcher:IEventDispatcher):void {
		dispatcher.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler, false, 0, true);
		dispatcher.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler, false, 0, true);
		dispatcher.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
	}
	
	private function createArrow(state:String):void {
		if( !arrow ) {
			var definition:Class = getArrowSkinClassBy(state);
			arrow = DisplayObject(new definition());
			arrow.y = Math.round((unscaledHeight - arrow.height) / 2);
			addChild(arrow);
		}
	}
	
	private function createRenderers():void {
		renderers = [];
		var cx:Number = 0;
		var i:int = 0;
		while( i < dataGrid.columns.length ) {
			var listData:BaseListData = new BaseListData(null, UIDUtil.createUID(), dataGrid, -1, i);
			var column:DataGridColumn = dataGrid.columns[i];
			var renderer:IListItemRenderer = column.headerRenderer.newInstance();
			renderer.width = isNaN(column.width) ? dataGrid.calculatedColumnWidth : column.width;
			renderer.height = unscaledHeight;
			renderer.x = cx;
			renderer.listData = listData;
			renderer.data = column.headerText;
			renderers[renderers.length] = renderer;
			configureListeners(IEventDispatcher(renderer));
			addChild(DisplayObject(renderer));
			
			cx += renderer.width;
			i++;
		}
	}
	
	private function getArrowSkinClassBy(state:String):Class {
		if( state == ARROW_STATE_DOWN )
			return replaceNullorUndefined(getStyle(StyleProp.DOWN_ARROW_SKIN), downArrowSkinClass);
		return replaceNullorUndefined(getStyle(StyleProp.UP_ARROW_SKIN), upArrowSkinClass);
	}
	
	private function getItemRendererByMousePosition():DisplayObject {
		for each( var renderer:DisplayObject in renderers ) {
			if( renderer.x < mouseX && renderer.x + renderer.width > mouseX &&
				mouseY > 0 && mouseY < unscaledHeight )
				return renderer;  
		}
		return null;
	}
	
	/**
	 *	배열의 요소가 숫자인지 판단 
	 */	
	private function isNumeric(element:*, index:int, arr:Array):Boolean {
		var column:DataGridColumn = dataGrid.columns[selectedRenderer.listData.columnIndex];
		return (element[column.dataField] is Number);
	}
	
	private function released():void {
		stage.removeEventListener(Event.MOUSE_LEAVE, stage_mouseMoveHandler);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
		stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
	}
	
	private function removeArrow():void {
		if( arrow && contains(arrow) ) {
			removeChild(arrow);
			arrow = null;
		}
	}
	
	private function removeDragGuider():void {
		if( dragGuider && contains(dragGuider) ) {
			removeChild(dragGuider);
			dragGuider = null;
		}
	}
	
	private function removeListeners(dispatcher:IEventDispatcher):void {
		dispatcher.removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
		dispatcher.removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
		dispatcher.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
	}
	
	private function removeRenderers():void {
		for each( var renderer:DisplayObject in renderers ) {
			removeListeners(renderer);
			removeChild(renderer);
		}
		renderers = null;
	}
	
	private function setDragGuider(target:IListItemRenderer):void {
		if( target && target.data ) {
			var t:Number = replaceNullorUndefined(dataGrid.getStyle(StyleProp.GRID_LINE_THICKNESS), 1);
			var targetIndex:int = renderers.indexOf(target);
			var rendererInCenter:Boolean = targetIndex > 0 && targetIndex < renderers.length - 1;
			dragGuider.width = Math.round(rendererInCenter ? target.width - t*2 : target.width);
			dragGuider.height = Math.round(target.height);
			dragGuider.x = Math.round(rendererInCenter ? target.x + t : target.x);
			dragGuider.visible = true;
			DragManager.showFeedback(DragManager.MOVE);
		} else {
			dragGuider.visible = false;
			DragManager.showFeedback(DragManager.REJECT);
		}
	}
	
	private function mouseDownHandler(event:MouseEvent):void {
		dragInititor = DisplayObject(event.currentTarget);
		stage.addEventListener(Event.MOUSE_LEAVE, stage_mouseLeaveHandler, false, 0, true);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler, false, 0, true);
		stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler, false, 0, true);
	}
	
	private function rollOverHandler(event:MouseEvent):void {
		if( event.buttonDown )
			return;
		
		var renderer:IListItemRenderer = IListItemRenderer(event.currentTarget);
		var column:DataGridColumn = dataGrid.columns[renderer.listData.columnIndex];
		if( column.sortable ) {
			var alphas:Array = [1, 1];
			var colors:Array = replaceNullorUndefined(getStyle(StyleProp.ROLL_OVER_COLORS), [0xE1E1E1, 0xFFFFFF]);
			var fillType:String = GradientType.LINEAR;
			var matrix:Matrix = new Matrix();
			var spreadMethod:String = SpreadMethod.PAD;
			var ratios:Array = [0, 255];
			
			matrix.createGradientBox(unscaledWidth, unscaledHeight, Math.PI/2, 0, 0);
			rollOverShape.graphics.beginGradientFill(fillType, colors, alphas, ratios, matrix, spreadMethod);
			rollOverShape.graphics.drawRect(renderer.x, 0, renderer.width, unscaledHeight);
			rollOverShape.graphics.endFill();
		}
	}
	
	private function rollOutHandler(event:MouseEvent):void {
		if( event.buttonDown  )
			return;
		
		rollOverShape.graphics.clear();
	}
	
	private function stage_mouseLeaveHandler(event:Event):void {
		released();
		dragInititor = null;
	}
	
	private function stage_mouseMoveHandler(event:MouseEvent):void {
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
		DragManager.doDrag(dragInititor, createDragImage(dragInititor),
			IListItemRenderer(dragInititor).data, 0, 0, 1.5, 0.7, false);
		DragManager.acceptDragDrop(this);
	}
	
	private function stage_mouseUpHandler(event:MouseEvent):void {
		released();
		
		var renderer:IListItemRenderer = getItemRendererByMousePosition() as IListItemRenderer;
		if( !renderer || dragStarted )
			return;
		
		removeArrow();
		
		var column:DataGridColumn = dataGrid.columns[renderer.listData.columnIndex];
		if( column.sortable ) {
			if( renderer === selectedRenderer )
				arrowState = (arrowState == ARROW_STATE_DOWN) ? ARROW_STATE_UP : ARROW_STATE_DOWN;
			else
				arrowState = ARROW_STATE_UP;
			
			createArrow(arrowState);
			arrow.x = Math.floor(renderer.x + renderer.width - arrow.width - 5);
			selectedRenderer = renderer;
			
			var sortType:uint = (arrowState == ARROW_STATE_DOWN) ? Array.DESCENDING : Array.CASEINSENSITIVE;
			var numericType:uint = (dataGrid.dataProvider as Array).every(isNumeric) ? Array.NUMERIC : numericType;
			
			dispatchEvent(new DataGridEvent(
				DataGridEvent.DATA_SORT, renderer.listData.columnIndex, sortType | numericType));
		}
	}
}

}