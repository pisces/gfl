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

package com.golfzon.gfl.skins
{
	
import com.golfzon.gfl.collection.Hashtable;
import com.golfzon.gfl.events.ComponentEvent;
import com.golfzon.gfl.events.StyleEvent;
import com.golfzon.gfl.styles.CSSStyleDeclaration;
import com.golfzon.gfl.styles.GStyleManager;
import com.golfzon.gfl.styles.IStyleClient;
import com.golfzon.gfl.utils.isNothing;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *	초기화가 진행될 때 송출한다.
 */
[Event(name="init", type="flash.events.Event")]

/**
 *	생성이 완료되면 송출한다.
 */
[Event(name="creationComplete", type="com.golfzon.events.ComponentEvent")]

/**
 *	@Author				KHKim
 *	@Version			1.0
 *	@Lanaguage			Action Script 3.0
 *	@Date				2010.03.11
 *	@Modify
 *	@Description
 * 	@includeExample
 */
public class ProgrammaticSkin extends Sprite
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	protected var origineWidth:Number;
	protected var origineHeight:Number;
	
	/**
	 *	객체 생성 및 추가 완료에 대한 부울값
	 */
	protected var creationComplete:Boolean;
	
	/**
	 *	초기화 여부
	 */
	protected var initialized:Boolean;
	
	/**
	 *	@Constructor
	 */
	public function ProgrammaticSkin() {
		initialize();
		configureListeners();
	}
	
	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Overriden : Sprite
	//--------------------------------------------------------------------------
	
	override public function localToGlobal(point:Point):Point {
		var newPoint:Point = new Point(point.x, point.y);
		var parent:DisplayObject = this.parent;

		loop:
		do {
			if( parent ) {
				newPoint.x += parent.x;
				newPoint.y += parent.y;
			} else {
				break loop;
			}
			parent = parent.parent;
			
		} while(true);

		return newPoint;
	}
	
	//--------------------------------------
	//	width
	//--------------------------------------
	
	private var _width:Number;
	
	protected var widthChanged:Boolean;
	
	override public function get width():Number {
		return _width;
	}
	
	override public function set width(value:Number):void {
		if( value == _width )
			return;
			
		origineWidth = _width;
		_width = value;
		widthChanged = true;
		
		setUnscaledWidth();
		invalidateDisplayList();
		dispatchEvent(new Event("widthChanged"));
	}
	
	//--------------------------------------
	//	height
	//--------------------------------------
	
	private var _height:Number;
	
	protected var heightChanged:Boolean;
	
	override public function get height():Number {
		return _height;
	}
	
	override public function set height(value:Number):void {
		if( value == _height )
			return;
		
		origineHeight = _height;
		_height = value;
		heightChanged = true;
		
		setUnscaledHeight();
		invalidateDisplayList();
		dispatchEvent(new Event("heightChanged"));
	}
	
	//--------------------------------------------------------------------------
	//  Public
	//--------------------------------------------------------------------------
	
	/**
	 *	초기화
	 */
	public function initialize():void {
		focusRect = tabEnabled = tabChildren = false;
		dispatchEvent(new Event(Event.INIT));
	}
	
	/**
	 *	초기화가 완료되었는지를 확인하고 updateDisplayList 메서드를 호출한다.
	 */
	public function invalidateDisplayList():void {
		if( creationComplete ) {
			measure();
			updateDisplayList(unscaledWidth, unscaledHeight);
		}
	}
	
	/**
	 *	invalidateDisplayList 를 체크하지 않고 넓이와 높이를 변경한다.
	 */
	public function setActualSize(w:Number, h:Number):void {
		if( _width == w && _height == h )
			return;
		
		origineWidth = _width;
		origineHeight = _height;
		_width = w;
		_height = h;
	}
	
	/**
	 *	width, height를 설정한다.
	 */
	public function setSize(width:Number, height:Number):void {
		this.width = width;
		this.height = height;
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	/**
	 * 	TODO : 자식 객체 생성 및 추가
	 */
	protected function createChildren():void {
	}
	
	/**
	 * 	TODO : 컴퍼넌트의 기본 크기와 최소 크기를 설정한다.
	 */
	protected function measure():void {
		measureWidth = _width;
		measureHeight = _height;
		
		if( !isNaN(_percentWidth) ) {
			origineWidth = _width;
			measureWidth = (_percentWidth * parent.width) / 100;
		}
		
		if( !isNaN(_percentHeight) ) {
			origineHeight = _height;
			measureHeight = (_percentHeight * parent.height) / 100;
		}
		
		setActualSize(unscaledWidth, unscaledHeight);
	}
	
	/**
	 * 	TODO : 디스플레이 변경 사항에 대한 처리
	 */
	protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
	}
	
	private function configureListeners():void {
		addEventListener(Event.ADDED, addedHandler, false, 0, true);
	}
	
	protected function createSkinBy(definition:Class):DisplayObject {
		return GStyleManager.createSkin(definition);
	}
	
	private function dispatchCreationComplete():void {
		if( creationComplete )
			dispatchEvent(new ComponentEvent(ComponentEvent.CREATION_COMPLETE));
	}
	
	protected function invalidSize():Boolean {
		return isNaN(unscaledWidth) || unscaledWidth < 1 || isNaN(unscaledHeight) || unscaledHeight < 1;
	}
	
	/**
	 *	스테이지에 추가됐을 때에 대한 셋팅
	 */
	protected function setAddedState():void {
		initialized = true;
		createChildren();
		measure();
		updateDisplayList(unscaledWidth, unscaledHeight);
		creationComplete = true;
		dispatchCreationComplete();
	}
	
	private function setUnscaledWidth():void {
		origineWidth = _unscaledWidth;
		var w:Number = widthChanged ? _width : _measureWidth;
		_unscaledWidth = isNaN(_minWidth) ? w : Math.max(_minWidth, w);
	}
	
	private function setUnscaledHeight():void {
		origineHeight = _unscaledHeight;
		var h:Number = heightChanged ? _height : _measureHeight;
		_unscaledHeight = isNaN(_minHeight) ? h : Math.max(_minHeight, h);
	}
	
	protected function sizeChanged():Boolean {
		return unscaledWidth != origineWidth || unscaledHeight != origineHeight;
	}
	
	//--------------------------------------------------------------------------
	//
	//	Event handlers
	//
	//--------------------------------------------------------------------------
	
	protected function addedHandler(event:Event):void {
		removeEventListener(Event.ADDED, addedHandler);
		setAddedState();
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//	measureWidth
	//--------------------------------------
	
	private var _measureWidth:Number;
	
	public function get measureWidth():Number {
		return _measureWidth;
	}
	
	public function set measureWidth(value:Number):void {
		if( value == _measureWidth )
			return;
		
		_measureWidth = value;
		
		setUnscaledWidth();
	}
	
	//--------------------------------------
	//	measureHeight
	//--------------------------------------
	
	private var _measureHeight:Number;
	
	public function get measureHeight():Number {
		return _measureHeight;
	}
	
	public function set measureHeight(value:Number):void {
		if( value == _measureHeight )
			return;
		
		_measureHeight = value;
		
		setUnscaledHeight();
	}
	
	//--------------------------------------
	//	minWidth
	//--------------------------------------
	
	private var _minWidth:Number;
	
	public function get minWidth():Number {
		return _minWidth;
	}
	
	public function set minWidth(value:Number):void {
		if( value == _minWidth )
			return;
		
		_minWidth = value;
		
		setUnscaledWidth();
	}
	
	//--------------------------------------
	//	minHeight
	//--------------------------------------
	
	private var _minHeight:Number;
	
	public function get minHeight():Number {
		return _minHeight;
	}
	
	public function set minHeight(value:Number):void {
		if( value == _minHeight )
			return;
		
		_minHeight = value;
		
		setUnscaledHeight();
	}
	
	//--------------------------------------
	//	percentWidth
	//--------------------------------------
	
	private var _percentWidth:Number;
	
	public function get percentWidth():Number {
		return _percentWidth;
	}
	
	public function set percentWidth(value:Number):void {
		if( value == _percentWidth )
			return;
		
		_percentWidth = value;
		
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	percentHeight
	//--------------------------------------
	
	private var _percentHeight:Number;
	
	public function get percentHeight():Number {
		return _percentHeight;
	}
	
	public function set percentHeight(value:Number):void {
		if( value == _percentHeight )
			return;
		
		_percentHeight = value;
		
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	unscaledWidth
	//--------------------------------------
	
	private var _unscaledWidth:Number;
	
	public function get unscaledWidth():Number {
		return _unscaledWidth;
	}
	
	//--------------------------------------
	//	unscaledHeight
	//--------------------------------------
	
	private var _unscaledHeight:Number;
	
	public function get unscaledHeight():Number {
		return _unscaledHeight;
	}
}

}