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

package com.golfzon.gfl.core
{

import com.golfzon.gfl.controls.listClasses.BaseListData;
import com.golfzon.gfl.controls.listClasses.IListItemRenderer;
import com.golfzon.gfl.controls.listClasses.ListBase;
import com.golfzon.gfl.events.TextEvent;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Shape;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.geom.Point;

import gs.TweenMax;
import gs.easing.Expo;

use namespace gz_internal;

/**
 *	@Author				KHKim
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.08.20
 *	@Modify
 *	@Description
 * 	@includeExample		ContainerSample.as
 */
public class Container extends ScrollControlBase implements IListItemRenderer
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	protected var largestChildPoint:Point = new Point;
	
	protected var contentMask:Shape;
	
	protected var contentPane:ComponentBase;
	
	/**
	 *	@Constructor
	 */
	public function Container() {
		super();
		
		setStyle(StyleProp.BORDER_THICKNESS, 0);
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

		if( dataChanged ) {
			dataChanged = false;
			setDataChangeState();
		}
	}
	
	/**
	 * 	자식 객체 생성 및 추가
	 */
	override protected function createChildren():void {
		super.createChildren();

		contentMask = new Shape();
		
		contentPane = new ComponentBase();
		contentPane.mask = contentMask;
		
		setViewMetrics();
		rawChildren.addChild(contentMask);
		rawChildren.addChild(contentPane);
	}
	
	/**
	 *	스타일 프로퍼티로 값을 설정한다.
	 */
	override public function styleChanged(styleProp:String):void {
		super.styleChanged(styleProp);

		switch( styleProp ) {
			case StyleProp.PADDING_LEFT: case StyleProp.PADDING_TOP:
			case StyleProp.PADDING_RIGHT: case StyleProp.PADDING_BOTTOM:
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
		
		updateChildDisplay();
	}
	
	/**
	 *	자식 객체를 추가한다.
	 */
	override public function addChild(child:DisplayObject):DisplayObject {
		if( pushChildToReservedChildList(child, -1) ) 
			return child;
		if( useSuperClassMethod(child) )
			return super.addChild(child);
		return setContentPaneChild(contentPane.addChild(child));
	}
	
	/**
	 *	자식 객체를 특정 인덱스에 추가한다.
	 */
	override public function addChildAt(child:DisplayObject, index:int):DisplayObject {
		if( pushChildToReservedChildList(child, index) ) 
			return child;
		if( useSuperClassMethod(child) )
			return super.addChildAt(child, index);
		return setContentPaneChild(contentPane.addChildAt(child, index));
	}
	
	/**
	 *	특정 인덱스에 위치한 자식 객체를 반환한다.
	 */
	override public function getChildAt(index:int):DisplayObject {
		return contentPane.getChildAt(index);
	}
	
	/**
	 *	객체의 이름을 이용해  자식 객체를 찾아 반환한다.
	 */
	override public function getChildByName(name:String):DisplayObject {
		return contentPane.getChildByName(name);
	}
	
	/**
	 *	자식 객체의 인덱스를 반환한다.
	 */
	override public function getChildIndex(child:DisplayObject):int {
		return contentPane.getChildIndex(child);
	}
	
	/**
	 *	자식 객체를 제거한다.
	 */
	override public function removeChild(child:DisplayObject):DisplayObject {
		if( !initialized )	return null;
		if( useSuperClassMethod(child) )
			return super.removeChild(child);
		
		var _child:DisplayObject = contentPane.removeChild(child);
		removeListeners(_child);
		updateLargestChildPoint();
		return _child;
	}
	
	/**
	 *	특정 인덱스에 위치한 자식 객체를 제거한다.
	 */
	override public function removeChildAt(index:int):DisplayObject {
		if( !initialized )	return null;
		if( useSuperClassMethod(getChildAt(index)) )
			return super.removeChildAt(index);
			
		var _child:DisplayObject = contentPane.removeChildAt(index);
		removeListeners(_child);
		updateLargestChildPoint();
		return _child;
	}
	
	/**
	 *	타겟 스크롤
	 */
	override protected function scrollTarget():void {
		var borderThickness:Number = getBorderThickness();
		var addendX:Number = borderThickness + viewMetrics.left;
		var addendY:Number = borderThickness + viewMetrics.top;
		var scrollMaxAreaH:Number = Math.max(0, largestChildPoint.x - getContentPaneWidth());
		var scrollMaxAreaV:Number = Math.max(0, largestChildPoint.y - getContentPaneHeight());
		var newX:Number = maxHorizontalScrollPosition > 0 ?
			(horizontalScrollPosition * scrollMaxAreaH / maxHorizontalScrollPosition - addendX) * -1 :
			addendX;
		var newY:Number = maxVerticalScrollPosition > 0 ?
			(verticalScrollPosition * scrollMaxAreaV / maxVerticalScrollPosition - addendY) * -1 :
			addendY;
		
		if( useScrollTween ) {
			TweenMax.to(contentPane, 0.5, {x:newX, y:newY, ease:Expo.easeOut});
		} else {
			contentPane.x = newX;
			contentPane.y = newY;
		}
	}
	
	/**
	 *	자식 객체의 인덱스를 바꾼다.
	 */
	override public function setChildIndex(child:DisplayObject, index:int):void {
		if( !initialized )	return;
		if( useSuperClassMethod(child) )
			return super.setChildIndex(child, index);
		contentPane.setChildIndex(child, index);
	}
	
	//--------------------------------------
	//	numChildren
	//--------------------------------------
	
	override public function get numChildren():int {
		if( !contentPane )	return 0;
		return contentPane.numChildren;
	}
	
	//--------------------------------------------------------------------------
	//  Public
	//--------------------------------------------------------------------------
	
	public function getChildren():Array {
		var children:Array = [];
		for( var i:int=0; i<numChildren; i++ ) {
			children[children.length] = getChildAt(i);
		}
		return children;
	}
	
	public function setLargestChildPoint(point:Point):void {
		largestChildPoint = point;
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	protected function compareLargestChildPoint(target:DisplayObject):void {
		largestChildPoint.x = !target || isNaN(target.width) ?
			Math.max(largestChildPoint.x, 0) :
			Math.max(target.x + target.width, largestChildPoint.x);
		largestChildPoint.y = !target || isNaN(target.height) ?
			Math.max(largestChildPoint.y, 0) :
			Math.max(target.y + target.height, largestChildPoint.y);
	}
	
	private function configureListeners(dispatcher:IEventDispatcher):void {
		dispatcher.addEventListener("widthChanged", child_propertyChangeHandler, false, 0, true);
		dispatcher.addEventListener("heightChanged", child_propertyChangeHandler, false, 0, true);
		dispatcher.addEventListener("xChanged", child_propertyChangeHandler, false, 0, true);
		dispatcher.addEventListener("yChanged", child_propertyChangeHandler, false, 0, true);
	}
	
	private function removeListeners(dispatcher:IEventDispatcher):void {
		dispatcher.removeEventListener("widthChanged", child_propertyChangeHandler);
		dispatcher.removeEventListener("heightChanged", child_propertyChangeHandler);
		dispatcher.removeEventListener("xChanged", child_propertyChangeHandler);
		dispatcher.removeEventListener("yChanged", child_propertyChangeHandler);
	}
	
	protected function drawContentMask():void {
		if( isNaN(getContentPaneWidth()) || isNaN(getContentPaneHeight()) )
			return;
		
		var borderThickness:Number = getBorderThickness();
		contentMask.graphics.clear();
		contentMask.graphics.beginBitmapFill(new BitmapData(1, 1, false, 0x000000));
		contentMask.graphics.drawRect(contentPane.x, contentPane.y, getContentPaneWidth(), getContentPaneHeight());
		contentMask.graphics.endFill();
	}
	
	protected function getContentPaneWidth():Number {
		return getHScrollBarWidth() - viewMetrics.left - viewMetrics.right;
	}
	
	protected function getContentPaneHeight():Number {
		return getVScrollBarHeight() - viewMetrics.top - viewMetrics.bottom;
	}
	
	private function setContentPaneChild(target:DisplayObject):DisplayObject {
		compareLargestChildPoint(target);
		
		if( target is IUITextFieldClient )
			IUITextFieldClient(target).getTextField().addEventListener(
				TextEvent.TEXT_FORMAT_CHANGED, textFormatChangedHandler, false, 0, true);
		
		invalidateDisplayList();
		configureListeners(target);
		return target;
	}
	
	/**
	 *	TODO : data 변경에 대한 구현
	 */
	protected function setDataChangeState():void {
	}
	
	private function updateLargestChildPoint():void {
		largestChildPoint.x = largestChildPoint.y = 0;
		for each( var child:DisplayObject in getChildren() ) {
			compareLargestChildPoint(child);
		}
	}
	
	protected function setViewMetrics(defaultValue:Number=0):void {
		_viewMetrics = new EdgeMetrics(
			replaceNullorUndefined(getStyle(StyleProp.PADDING_LEFT), defaultValue),
			replaceNullorUndefined(getStyle(StyleProp.PADDING_TOP), defaultValue),
			replaceNullorUndefined(getStyle(StyleProp.PADDING_RIGHT), defaultValue),
			replaceNullorUndefined(getStyle(StyleProp.PADDING_BOTTOM), defaultValue)
		);
	}
	
	protected function updateChildDisplay():void {
		if( invalidSize() )
			return;
		
		var borderThickness:Number = getBorderThickness();
		var w:Number = Math.max(0, unscaledWidth - borderThickness * 2);
		var h:Number = Math.max(0, unscaledHeight - borderThickness * 2);
		
		setScrollBars(largestChildPoint.x, w, largestChildPoint.y, h);
		getHScrollBar().lineScrollSize = Math.max(lineScrollSize, largestChildPoint.x / getContentPaneWidth() + lineScrollSize);
		getVScrollBar().lineScrollSize = Math.max(lineScrollSize, largestChildPoint.y / getContentPaneHeight() + lineScrollSize)
		setScrollBarProperties(largestChildPoint.x, getContentPaneWidth(), largestChildPoint.y, getContentPaneHeight());
		
		contentPane.width = Math.max(getContentPaneWidth(), largestChildPoint.x);
		contentPane.height = Math.max(getContentPaneHeight(), largestChildPoint.y);
		contentPane.x = borderThickness + viewMetrics.left;
		contentPane.y = borderThickness + viewMetrics.top;
		
		drawContentMask();
	}
	
	protected function useSuperClassMethod(object:DisplayObject):Boolean {
		return object == rawChildren || object == modalRect;
	}
	
	//--------------------------------------------------------------------------
	//
	//	Event handlers
	//
	//--------------------------------------------------------------------------
	
	protected function child_propertyChangeHandler(event:Event):void {
		updateLargestChildPoint();
		updateChildDisplay();
		
		horizontalScrollPosition = verticalScrollPosition = 0;
	}
	
	private function textFormatChangedHandler(event:TextEvent):void {
		compareLargestChildPoint(DisplayObject(event.currentTarget).parent);
		invalidateDisplayList();
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//	data
	//--------------------------------------
	
	private var dataChanged:Boolean;
	
	private var _data:Object;
	
	public function get data():Object {
		return _data;
	}
	
	public function set data(value:Object):void {
		if( value === _data )
			return;
		
		_data = value;
		dataChanged = true;
		
		invalidateProperties();
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	lineScrollSize
	//--------------------------------------
	
	private var _lineScrollSize:Number = 20;
	
	public function get lineScrollSize():Number {
		return _lineScrollSize;
	}
	
	public function set lineScrollSize(value:Number):void {
		if( value == _lineScrollSize )
			return;
		
		_lineScrollSize = value;
		
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	listData
	//--------------------------------------
	
	public function get listData():BaseListData {
		return null;
	}
	
	public function set listData(value:BaseListData):void {
	}
	
	//--------------------------------------
	//  useScrollTween
	//--------------------------------------
	
	protected var _useScrollTween:Boolean;
	
	public function get useScrollTween():Boolean {
		return _useScrollTween;
	}
	
	public function set useScrollTween(value:Boolean):void {
		_useScrollTween = value;
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