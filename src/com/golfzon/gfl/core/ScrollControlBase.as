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

import com.golfzon.gfl.controls.HScrollBar;
import com.golfzon.gfl.controls.VScrollBar;
import com.golfzon.gfl.controls.scrollBarClasses.ScrollBarBase;
import com.golfzon.gfl.controls.scrollBarClasses.ScrollBarDirection;
import com.golfzon.gfl.events.ScrollEvent;
import com.golfzon.gfl.skins.Border;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.display.DisplayObject;
import flash.display.Shape;
import flash.events.FocusEvent;
import flash.events.IEventDispatcher;
import flash.events.MouseEvent;

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *	@Include the external file to define background styles.
 */
include "../styles/metadata/BackgroundStyles.as";

/**
 * 
 *	@Include the external file to define padding styles.
 *
 */
include "../styles/metadata/PaddingStyles.as";

/**
 *	horizontalScrollBar의 스타일명
 */
[Style(name="horizontalScrollBarStyleName", type="String", inherit="no")]

/**
 *	verticalScrollBar의 스타일명
 */
[Style(name="verticalScrollBarStyleName", type="String", inherit="no")]

/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.09.24
 *	@Modify
 *	@Description		Abstract Class
 */
public class ScrollControlBase extends ComponentBase
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	protected var border:DisplayObject;
	
	protected var modalRect:Shape;
	
	protected var rawChildren:ComponentBase;
	
	private var horizontalScrollBar:HScrollBar;
	private var verticalScrollBar:VScrollBar;
	
	/**
	 *	@Constructor
	 */
	public function ScrollControlBase() {
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
	 * 	프로퍼티 변경 사항에 대한 처리
	 */
	override protected function commitProperties():void {
		super.commitProperties();
		
		if( horizontalScrollPositionChanged ) {
			horizontalScrollPositionChanged = false;
			getHScrollBar().scrollPosition = horizontalScrollPosition;
		}
		
		if( verticalScrollPositionChanged ) {
			verticalScrollPositionChanged = false;
			getVScrollBar().scrollPosition = verticalScrollPosition;
		}
		
		if( wheelEnabledChanged ) {
			wheelEnabledChanged = false;
			getVScrollBar().wheelEnabled = wheelEnabled;
		}
	}
	
	/**
	 * 	자식 객체 생성 및 추가
	 */
	override protected function createChildren():void {
		modalRect = new Shape();
		modalRect.visible = !enabled;
		
		rawChildren = new ComponentBase();
		addChild(rawChildren);
		
		border = createBorder();
		
		addChild(modalRect);
	}
	
	/**
	 *	enabled에 따른 구현
	 */
	override protected function setStateToChangeEnabled():void {
		super.setStateToChangeEnabled();
		
		getHScrollBar().enabled = getVScrollBar().enabled = enabled;
		modalRect.visible = !enabled;
	}
	
	/**
	 *	스타일 프로퍼티로 값을 설정한다.
	 */
	override public function styleChanged(styleProp:String):void {
		super.styleChanged(styleProp);

		switch( styleProp ) {
			case StyleProp.HORIZONTAL_SCROLL_BAR_STYLE_NAME:
				getHScrollBar().styleName = getStyle(StyleProp.HORIZONTAL_SCROLL_BAR_STYLE_NAME);
				break;
			
			case StyleProp.VERTICAL_SCROLL_BAR_STYLE_NAME:
				getVScrollBar().styleName = getStyle(StyleProp.VERTICAL_SCROLL_BAR_STYLE_NAME);
				break;
				
			case StyleProp.BORDER_SKIN:
				removeBorder();
				border = createBorder();
				break;
				
			case StyleProp.BACKGROUND_ALPHA: case StyleProp.BACKGROUND_COLOR:
			case StyleProp.BACKGROUND_IMAGE: case StyleProp.BORDER_COLOR:
			case StyleProp.BORDER_THICKNESS: case StyleProp.CORNER_RADIUS:
				if( border is Border ) {
					Border(border).setStyle(styleProp, getStyle(styleProp));
					invalidateDisplayList();
				}
				break;
	 	}
	}
	
	/**
	 * 	디스플레이 변경 사항에 대한 처리
	 */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		if( isNaN(unscaledWidth) || isNaN(unscaledHeight) )
			return;
		
		if( border ) {
			border.width = unscaledWidth;
			border.height = unscaledHeight;
		}
		
		rawChildren.width = unscaledWidth;
		rawChildren.height = unscaledHeight;
		
		modalRect.graphics.clear();
		modalRect.graphics.beginFill(0xDDDDDD, 0.5);
		modalRect.graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
		modalRect.graphics.endFill();
	}

	//--------------------------------------------------------------------------
	//	Internal
	//--------------------------------------------------------------------------
	
	/**
	 * 	TODO : 스크롤 이벤트를 받아 타겟 스크롤을 구현.
	 */
	protected function scrollTarget():void {
	}
	
	/**
	 *	@private
	 */
	private function configureListeners(dispatcher:IEventDispatcher):void {
		dispatcher.addEventListener(MouseEvent.MOUSE_DOWN, scrollBar_mouseDownHandler, false, 0, true);
		dispatcher.addEventListener(MouseEvent.ROLL_OVER, scrollBar_rollOverHandler, false, 0, true);
		dispatcher.addEventListener(ScrollEvent.SCROLL, scrollHandler, false, 0, true);
	}
	
	/**
	 * 	@private
	 */
	private function createBorder():DisplayObject {
		var borderClass:Class = replaceNullorUndefined(getStyle(StyleProp.BORDER_SKIN), Border);
		if( borderClass ) {
			var border:DisplayObject = createSkinBy(borderClass);
			border.width = unscaledWidth;
			border.height = unscaledHeight;
			
			if( border is IInteractiveObject )
				IInteractiveObject(border).enabled = enabled;
				
			rawChildren.addChildAt(border, 0);
			
			if( border is Border )
				Border(border).styleName = getCSSStyleDeclaration();
			
			return border;
		}
		return null;
	}
	
	/**
	 * 	@private
	 */
	private function createScrollBar(Definition:Class, styleProp:String):ScrollBarBase {
		var scrollBar:ScrollBarBase = new Definition();
		scrollBar.styleName = getStyle(styleProp);
		configureListeners(scrollBar);
		return ScrollBarBase(rawChildren.addChild(scrollBar));
	}
	
	/**
	 * 	@private
	 */
	protected function createHorizontalScrollBar():HScrollBar {
		if( horizontalScrollBar )	return horizontalScrollBar;
		return createScrollBar(HScrollBar, StyleProp.HORIZONTAL_SCROLL_BAR_STYLE_NAME) as HScrollBar;
	}
	
	/**
	 * 	@private
	 */
	protected function createVerticalScrollBar():VScrollBar {
		if( verticalScrollBar )	return verticalScrollBar;
		return createScrollBar(VScrollBar, StyleProp.VERTICAL_SCROLL_BAR_STYLE_NAME) as VScrollBar;
	}
	
	/**
	 *	@private
	 */
	protected function getBorderThickness():Number {
		return getStyle(StyleProp.BACKGROUND_IMAGE) ?
			0 : replaceNullorUndefined(getStyle(StyleProp.BORDER_THICKNESS), 1);
	}
	
	/**
	 * 	@private
	 */
	protected function getHScrollBar():HScrollBar {
		return horizontalScrollBar ? horizontalScrollBar : HScrollBar.newNull();
	}
	
	/**
	 *	@private
	 */
	protected function getHScrollBarWidth():Number {
		return unscaledWidth - getVScrollBar().width - getBorderThickness() * 2;
	}
	
	/**
	 * 	@private
	 */
	protected function getVScrollBar():VScrollBar {
		return verticalScrollBar ? verticalScrollBar : VScrollBar.newNull();
	}
	
	/**
	 *	@private
	 */
	protected function getVScrollBarHeight():Number {
		return unscaledHeight - getHScrollBar().height - getBorderThickness() * 2;
	}
	
	/**
	 * 	@private
	 */
	private function removeBorder():void {
		if( border && rawChildren.contains(border) ) {
			rawChildren.removeChild(border);
			border = null;
		}
	}
	
	/**
	 *	@private
	 */
	private function removeListeners(dispatcher:IEventDispatcher):void {
		dispatcher.removeEventListener(MouseEvent.MOUSE_DOWN, scrollBar_mouseDownHandler);
		dispatcher.removeEventListener(MouseEvent.ROLL_OVER, scrollBar_rollOverHandler);
		dispatcher.removeEventListener(ScrollEvent.SCROLL, scrollHandler);
	}
	
	/**
	 * 	@private
	 */
	private function removeScrollBar(instance:ScrollBarBase, instanceName:String):void {
		if( !instance.isNull() ) {
			rawChildren.removeChild(instance);
			this[instanceName] = null;
		}
	}
	
	/**
	 * 	@private
	 */
	private function setHScrollBarBy(creatable:Boolean):void {
		if( creatable )		horizontalScrollBar = createHorizontalScrollBar();
		else				removeScrollBar(getHScrollBar(), "horizontalScrollBar");
	}
	
	/**
	 * 	@private
	 */
	private function setVScrollBarBy(creatable:Boolean):void {
		if( creatable )		verticalScrollBar = createVerticalScrollBar();
		else				removeScrollBar(getVScrollBar(), "verticalScrollBar");
	}
	
	/**
	 * 	@private
	 */
	protected function setScrollBars(
		totalColumns:Number, visibleColumns:Number, totalRows:Number, visibleRows:Number):void {
		var creatableHorizontalScrollBar:Boolean = (horizontalScrollPolicy == ScrollPolicy.ON) || /* case scrollPolicy is "on" */
			(horizontalScrollPolicy == ScrollPolicy.AUTO && visibleColumns < totalColumns && totalColumns > 0); /* case scrollPolicy is "auto" */
			
		var creatableVerticalScrollBar:Boolean = (verticalScrollPolicy == ScrollPolicy.ON) || /* case scrollPolicy is "on" */
			(verticalScrollPolicy == ScrollPolicy.AUTO && visibleRows < totalRows && totalRows > 0); /* case scrollPolicy is "auto" */
			
		setHScrollBarBy(creatableHorizontalScrollBar);
		setVScrollBarBy(creatableVerticalScrollBar);
		updateScrollBarProperties();
	}
	
	/**
	 * 	@private
	 */
	public function setScrollBarProperties(
		totalColumns:Number, visibleColumns:Number, totalRows:Number, visibleRows:Number):void {
		getVScrollBar().wheelEnabled = wheelEnabled;
		getHScrollBar().setScrollProperties(totalColumns, visibleColumns);
		getVScrollBar().setScrollProperties(totalRows, visibleRows);
	}
	
	/**
	 * 	@private
	 */
	protected function updateScrollBarProperties():void {
		var borderThickness:Number = getBorderThickness();

		// update horizontalScrollBar display
		getHScrollBar().width = unscaledWidth - getVScrollBar().width - borderThickness * 2;
		getHScrollBar().x = borderThickness;
		getHScrollBar().y = unscaledHeight - getHScrollBar().height - borderThickness;

		// update verticalScrollBar display
		getVScrollBar().height = unscaledHeight - getHScrollBar().height - borderThickness * 2;
		getVScrollBar().x = unscaledWidth - getVScrollBar().width - borderThickness;
		getVScrollBar().y = borderThickness;
	}
	
	//--------------------------------------------------------------------------
	//
	//	Event handlers
	//
	//--------------------------------------------------------------------------
	
	/**
	 * 	@private
	 */
	override protected function focusInHandler(event:FocusEvent):void {
		if( stage.focus == this )
			wheelEnabled = true;
	}
	
	/**
	 * 	@private
	 */
	override protected function focusOutHandler(event:FocusEvent):void {
		wheelEnabled = false;
	}
	
	/**
	 * 	@private
	 */
	private function scrollBar_mouseDownHandler(event:MouseEvent):void {
		setFocus();
	}
	
	/**
	 * 	@private
	 */
	protected function scrollBar_rollOverHandler(event:MouseEvent):void {
	}
	
	/**
	 * 	@private
	 */
	protected function scrollHandler(event:ScrollEvent):void {
		if( event.direction == ScrollBarDirection.HORIZONTAL )
			_horizontalScrollPosition = event.position;
		else
			_verticalScrollPosition = event.position;
			
		scrollTarget();
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//	maxHorizontalScrollPosition
	//--------------------------------------
	
	public function get maxHorizontalScrollPosition():int {
		return getHScrollBar().maxScrollPosition;
	}
	
	//--------------------------------------
	//	maxVerticalScrollPosition
	//--------------------------------------
	
	public function get maxVerticalScrollPosition():int {
		return getVScrollBar().maxScrollPosition;
	}
	
	//--------------------------------------
	//  horizontalScrollBar
	//--------------------------------------
	
	gz_internal function get horizontalScrollBar():ScrollBarBase {
		return horizontalScrollBar;
	}
	
	//--------------------------------------
	//  verticalScrollBar
	//--------------------------------------
	
	gz_internal function get verticalScrollBar():ScrollBarBase {
		return verticalScrollBar;
	}
	
	//--------------------------------------
	//	horizontalScrollPolicy
	//--------------------------------------
	
	private var horizontalScrollPolicyChanged:Boolean;
	
	private var _horizontalScrollPolicy:String = ScrollPolicy.AUTO;
	
	public function get horizontalScrollPolicy():String {
		return _horizontalScrollPolicy;
	}
	
	public function set horizontalScrollPolicy(value:String):void {
		if( value == _horizontalScrollPolicy )
			return;
		
		_horizontalScrollPolicy = value;
		horizontalScrollPolicyChanged = true;
		
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	horizontalScrollPosition
	//--------------------------------------
	
	private var horizontalScrollPositionChanged:Boolean;
	
	private var _horizontalScrollPosition:int = 0;
	
	public function get horizontalScrollPosition():int {
		return _horizontalScrollPosition;
	}
	
	public function set horizontalScrollPosition(value:int):void {
		if( value == _horizontalScrollPosition )
			return;
		
		_horizontalScrollPosition = value;
		horizontalScrollPositionChanged = true;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//	verticalScrollPolicy
	//--------------------------------------
	
	private var verticalScrollPolicyChanged:Boolean;
	
	private var _verticalScrollPolicy:String = ScrollPolicy.AUTO;
	
	public function get verticalScrollPolicy():String {
		return _verticalScrollPolicy;
	}
	
	public function set verticalScrollPolicy(value:String):void {
		if( value == _verticalScrollPolicy )
			return;
		
		_verticalScrollPolicy = value;
		verticalScrollPolicyChanged = true;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//	verticalScrollPosition
	//--------------------------------------
	
	private var verticalScrollPositionChanged:Boolean;
	
	private var _verticalScrollPosition:int = 0;
	
	public function get verticalScrollPosition():int {
		return _verticalScrollPosition;
	}
	
	public function set verticalScrollPosition(value:int):void {
		if( value == _verticalScrollPosition )
			return;
		
		_verticalScrollPosition = value;
		verticalScrollPositionChanged = true;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//  scrolling
	//--------------------------------------
	
	public function get scrolling():Boolean {
		return getHScrollBar().scrolling || getVScrollBar().scrolling;
	}
	
	//--------------------------------------
	//	wheelEnabled
	//--------------------------------------
	
	private var wheelEnabledChanged:Boolean;
	
	private var _wheelEnabled:Boolean;
	
	public function get wheelEnabled():Boolean {
		return _wheelEnabled;
	}
	
	public function set wheelEnabled(value:Boolean):void {
		if( value == _wheelEnabled )
			return;
		
		_wheelEnabled = value;
		wheelEnabledChanged = true;
		
		invalidateProperties();
	}
}

}