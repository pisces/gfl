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

import com.golfzon.gfl.collection.Hashtable;
import com.golfzon.gfl.controls.ToolTip;
import com.golfzon.gfl.events.ComponentEvent;
import com.golfzon.gfl.events.DragEvent;
import com.golfzon.gfl.events.StyleEvent;
import com.golfzon.gfl.managers.SystemManager;
import com.golfzon.gfl.styles.CSSStyleDeclaration;
import com.golfzon.gfl.styles.GStyleManager;
import com.golfzon.gfl.styles.IStyleClient;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.BitmapDataUtil;
import com.golfzon.gfl.utils.UIDUtil;
import com.golfzon.gfl.utils.isNothing;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.display.InteractiveObject;
import flash.display.Sprite;
import flash.events.ContextMenuEvent;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.geom.Point;
import flash.net.URLRequest;
import flash.net.navigateToURL;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;
import flash.utils.getQualifiedClassName;

import gs.TweenMax;
import gs.easing.Strong;

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
 *	스타일이 변경되면 송출한다.
 */
[Event(name="styleChanged", type="com.golfzon.events.StyleEvent")]

/**
 *	스타일명이 변경되면 송출한다.
 */
[Event(name="styleNameChanged", type="com.golfzon.events.StyleEvent")]

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  안티알리아스 타입<br>
 * 	@default value normal
 */
[Style(name="antiAliasType", type="String", inherit="yes")]

/**
 *  텍스트 컬러<br>
 * 	@default value 0x333333
 */
[Style(name="color", type="uint", inherit="yes")]

/**
 *  비활성 상태의 텍스트 컬러<br>
 * 	@default value 0xDDDDDD
 */
[Style(name="disabledColor", type="uint", inherit="yes")]

/**
 *  드랍 쉐도우 필터 알파<br>
 * 	@default value 0.2
 */
[Style(name="dropShadowAlpha", type="Number", inherit="no")]

/**
 *  드랍 쉐도우 필터 가로 방향 번짐 정도<br>
 * 	@default value 4
 */
[Style(name="dropShadowBlurX", type="Number", inherit="no")]

/**
 *  드랍 쉐도우 필터 세로 방향 번짐 정도<br>
 * 	@default value 4
 */
[Style(name="dropShadowBlurY", type="Number", inherit="no")]

/**
 *  드랍 쉐도우 필터 강도<br>
 * 	@default value 1
 */
[Style(name="dropShadowStrength", type="Number", inherit="no")]

/**
 *  드랍 쉐도우 필터 사용 여부<br>
 * 	@default value false
 */
[Style(name="dropShadowEnabled", type="Boolean", inherit="no")]

/**
 *  폰트<br>
 * 	@default value dotum
 */
[Style(name="fontFamily", type="String", inherit="yes")]

/**
 *  폰트 크기<br>
 * 	@default value 11
 */
[Style(name="fontSize", type="Number", inherit="yes")]

/**
 *  폰트 두께<br>
 * 	@default value normal
 */
[Style(name="fontWeight", type="String", inherit="yes")]

/**
 *  이태릭 텍스트 사용 여부<br>
 * 	@default value false
 */
[Style(name="italic", type="Boolean", inherit="yes")]

/**
 *  텍스트 정렬<br>
 * 	@default value center
 */
[Style(name="textAlign", type="String", inherit="yes")]

/**
 *  언더라인 텍스트 사용 여부<br>
 * 	@default value false
 */
[Style(name="underline", type="Boolean", inherit="yes")]

/**
 *  텍스트 행간<br>
 * 	@default value 0
 */
[Style(name="leading", type="Number", inherit="yes")]

/**
 *  텍스트 자간<br>
 * 	@default value 0
 */
[Style(name="letterSpacing", type="Number", inherit="yes")]

/**
 *	@Author				KHKim
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.08.20
 *	@Modify
 *	@Description
 * 	@includeExample		ComponentBaseSample.as
 */
public class ComponentBase extends Sprite implements IComponent, IInteractiveObject, IStyleClient
{
	//--------------------------------------------------------------------------
	//
	//	Class constants
	//
	//--------------------------------------------------------------------------
	
	gz_internal static const VERSION:String = "1.0.1";
	
	//--------------------------------------------------------------------------
	//
	//	Class variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	컴포넌트의 인스턴스 순서 테이블
	 */
	private static var componentTable:Hashtable = new Hashtable();
	
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	private var filterIndex:int = -1;
	
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
	 *	스테이지에 추가되기 전에 추가됐던 객체 리스트
	 */
	protected var reservedChildList:Array = [];
	
	private var eventListenerStack:Array = [];
	
	private var bitmapCache:Bitmap;
	
	private var removedChildren:Vector.<DisplayObject>;
	
	/**
	 *	CSSStyleDeclaration 인스턴스
	 */
	private var declaration:CSSStyleDeclaration = new CSSStyleDeclaration();
	
	/**
	 *	툴팁 인스턴스 변수
	 */
	protected var toolTipInstance:ToolTip;
	
	/**
	 *	@Constructor
	 */
	public function ComponentBase() {
		setComponentProperties();
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
	
	override public function addChild(child:DisplayObject):DisplayObject {
		if( pushChildToReservedChildList(child, -1) ) 
			return child;
		return super.addChild(child);
	}
	
	override public function addChildAt(child:DisplayObject, index:int):DisplayObject {
		if( pushChildToReservedChildList(child, index) ) 
			return child;
		return super.addChildAt(child, index);
	}
	
	override public function addEventListener(
		type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
		if( !eventListenerStack )	eventListenerStack = [];
		eventListenerStack[eventListenerStack.length] = {type: type, listener: listener, useCapture: useCapture};
		super.addEventListener(type, listener, useCapture, priority, useWeakReference);
	}
	
	override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
		super.removeEventListener(type, listener, useCapture);
	}
	
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
	//	doubleClickEnabled
	//--------------------------------------
	
	override public function set doubleClickEnabled(value:Boolean):void {
		if( value == super.doubleClickEnabled )
			return;
		
		super.doubleClickEnabled = value;
		
		dispatchEvent(new Event("doubleClickEnableChanged"));
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
		invalidateProperties();
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
		invalidateProperties();
		invalidateDisplayList();
		dispatchEvent(new Event("heightChanged"));
	}
	
	//--------------------------------------
	//	x
	//--------------------------------------
	
	override public function set x(value:Number):void {
		if( super.x == value ) return;
		
		super.x = value;
		
		invalidateProperties();
		dispatchEvent(new Event("xChanged"));
	}
	
	//--------------------------------------
	//	y
	//--------------------------------------
	
	override public function set y(value:Number):void {
		if( super.y == value ) return;
		
		super.y = value;
		
		invalidateProperties();
		dispatchEvent(new Event("yChanged"));
	}
	
	//--------------------------------------------------------------------------
	//  gz_internal
	//--------------------------------------------------------------------------
	
	/**
	 *	스타일명에 따라 스타일을 적용시킨다.
	 */
	public function registerInstance():void {
		if( systemManager.cssInitialized ) {
			GStyleManager.registerInstance(this);
			dispatchEvent(new StyleEvent(StyleEvent.REGISTER_INSTANCE));
		}
	}
	
	//--------------------------------------------------------------------------
	//  Public
	//--------------------------------------------------------------------------
	
	/**
	 *	TODO : 스타일 속성이 바뀌었을 시점에 대한 구현
	 */
	public function styleChanged(styleProp:String):void {
		if( styleProp == StyleProp.DROP_SHADOW_ALPHA || styleProp == StyleProp.DROP_SHADOW_ENABLED ) {
			filters = [];
			setDropShadow();
		}
	}
	
	/**
	 *	초기화
	 */
	public function initialize():void {
		focusRect = tabEnabled = tabChildren = false;
		contextMenu = createContextMenu();
		dispatchEvent(new Event(Event.INIT));
	}
	
	/**
	 *	초기화가 완료되었는지를 확인하고 commitProperties 메서드를 호출한다.
	 */
	public function invalidateProperties():void {
		if( creationComplete )
			commitProperties();
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
	 *	포커스 중인 객체를 반환한다.
	 */
	public function getFocus():InteractiveObject {
		if( stage )
			return stage.focus;
		return null;
	}
	
	/**
	 *	상속시킬 스타일 프로퍼티 정의를 반환한다.
	 */
	public function getInheritStyleTable():Hashtable {
		var table:Hashtable = new Hashtable();
		table.add(StyleProp.ANTI_ALIAS_TYPE, StyleProp.ANTI_ALIAS_TYPE);
		table.add(StyleProp.COLOR, StyleProp.COLOR);
		table.add(StyleProp.DISABLED_COLOR, StyleProp.DISABLED_COLOR);
		table.add(StyleProp.FONT_FAMILY, StyleProp.FONT_FAMILY);
		table.add(StyleProp.FONT_SIZE, StyleProp.FONT_SIZE);
		table.add(StyleProp.FONT_WEIGHT, StyleProp.FONT_WEIGHT);
		table.add(StyleProp.ITALIC, StyleProp.ITALIC);
		table.add(StyleProp.TEXT_ALIGN, StyleProp.TEXT_ALIGN);
		table.add(StyleProp.UNDERLINE, StyleProp.UNDERLINE);
		table.add(StyleProp.LEADING, StyleProp.LEADING);
		table.add(StyleProp.LETTER_SPACING, StyleProp.LETTER_SPACING);
		return table;
	}
	
	/**
	 *	CSS 스타일 정의를 반환한다.
	 */
	public function getCSSStyleDeclaration():CSSStyleDeclaration {
		return declaration;
	}
	
	/**
	 *	스타일 프로퍼티에 의해 값을 반환한다.
	 */
	public function getStyle(styleProp:String):* {
		return declaration.getStyle(styleProp);
	}
	
	/**
	 *	x, y 값만큼 이동한다.
	 */
	public function move(x:Number, y:Number):void {
		this.x = x;
		this.y = y;
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
	 *	CSS 스타일 정의를 설정한다.
	 */
	public function setCSSStyleDeclaration(declaration:CSSStyleDeclaration):void {
		this.declaration = declaration;
	}
	
	/**
	 *	포커스를 자신으로 이동시킨다.
	 */
	public function setFocus():void {
		if( stage )
			stage.focus = this;
	}
	
	/**
	 *	width, height를 설정한다.
	 */
	public function setSize(width:Number, height:Number):void {
		this.width = width;
		this.height = height;
	}
	
	/**
	 *	스타일 프로퍼티로 값을 설정한다.
	 */
	public function setStyle(styleProp:String, value:*):void {
		if( isNothing(value) )
			return;
		
		declaration.setStyle(styleProp, value);
		
		if( creationComplete ) {
			styleChanged(styleProp);
			dispatchEvent(new StyleEvent(StyleEvent.STYLE_CHANGED, styleProp, value));
		} else {
			declaration.setDefaultStyle(styleProp, value);
		}
	}
	
	public function dispose():void {
		toolTip = null;
		_systemManager = null;
		
		if( !_useAutoRemovement )
			return;
		
		var i:uint = numChildren;
		while( i > 0 ) {
			removeChild(getChildAt(0));
			i--;
		}
		
		if( eventListenerStack ) {
			while( eventListenerStack.length > 0 ) {
				var obj:Object = eventListenerStack.shift();
				removeEventListener(obj.type, obj.listener, obj.useCapture);
			}
			eventListenerStack = null;
		}
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	/**
	 * 	TODO : 프로퍼티 변경 사항에 대한 처리
	 */
	protected function commitProperties():void {
		if( enabledChanged ) {
			enabledChanged = false;
			setStateToChangeEnabled();
		}
		
		if( bitmapModeChanged ) {
			bitmapModeChanged = false;
			removeBitmap();
			createBitmap();
		}
		
		if( styleNameChanged ) {
			styleNameChanged = false;
			
			if( typeof styleName == "string" ) {
				registerInstance();
				setStyleBy(declaration);
			} else if( typeof styleName == "object" ) {
				setStyleBy(styleName);
			}
		}
		
		if( toolTipChanged ) {
			toolTipChanged = false;
			setToolTip();
		}
	}
	
	/**
	 * 	TODO : 자식 객체 생성 및 추가
	 */
	protected function createChildren():void {
	}
	
	private function createContextMenu():ContextMenu {
		var contextMenu:ContextMenu = new ContextMenu();
		contextMenu.hideBuiltInItems();
		pushMenuItems(contextMenu);
		return contextMenu;
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
	
	/**
	 * 	자신이 스테이지에 추가되기 전에 추가 요청을 했던 객체를 추가한다.
	 */
	private function addReservedChildList():void {
		loop:
		do {
			if( reservedChildList.length < 1 ) {
				reservedChildList = null;
				break loop;
			} else {
				var obj:Object = reservedChildList.pop();
				if( obj ) {
					if( obj.index < 0 )
						addChildAt(obj.child, 0);
					else
						addChildAt(obj.child, obj.index);
				}
			}
		} while(true);
	}
	
	private function configureListeners():void {
		addEventListener(ComponentEvent.CREATION_COMPLETE, creationCompleteHandler, false, 0, true);
		addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);
		addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler, false, 0, true);
		addEventListener(DragEvent.DRAG_COMPLETE, dragCompleteHandler, false, 0, true);
		addEventListener(DragEvent.DRAG_DROP, dragDropHandler, false, 0, true);
		addEventListener(DragEvent.DRAG_ENTER, dragEnterHandler, false, 0, true);
		addEventListener(DragEvent.DRAG_OVER, dragOverHandler, false, 0, true);
		addEventListener(DragEvent.DRAG_START, dragStartHandler, false, 0, true);
		addEventListener(FocusEvent.FOCUS_IN, focusInHandler, false, 0, true);
		addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler, false, 0, true);
	}
	
	private function configureListenersToParent():void {
		if( parent is IInteractiveObject )
			parent.addEventListener("doubleClickEnableChanged", parent_doubleClickEnableChangedHandler, false, 0, true);
		
		if( parent is IStyleClient ) {
			parent.addEventListener(StyleEvent.REGISTER_INSTANCE, parent_registerInstanceHandler, false, 0, true);
			parent.addEventListener(StyleEvent.STYLE_CHANGED, parent_styleChangedHandler, false, 0, true);
		}
		
		if( (parent is ComponentBase) && !useAutoRemovementChanged ) {
			_useAutoRemovement = ComponentBase(parent).useAutoRemovement;
			parent.addEventListener("useAutoRemovementChanged", parent_useAutoRemovementChangedHandler, false, 0, true);
		}
	}
	
	protected function createSkinBy(definition:Class):DisplayObject {
		return GStyleManager.createSkin(definition);
	}
	
	private function createToolTip():void {
		if( toolTipInstance ) {
			toolTipInstance.text = _toolTip;
		} else {
			toolTipInstance = ToolTip.create(_toolTip);
			toolTipInstance.alpha = 0;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler, false, 0, true);
			stage.addChild(toolTipInstance);
		}
	}
	
	private function dispatchCreationComplete():void {
		if( creationComplete )
			dispatchEvent(new ComponentEvent(ComponentEvent.CREATION_COMPLETE));
	}
	
	protected function invalidSize():Boolean {
		return isNaN(unscaledWidth) || unscaledWidth < 1 || isNaN(unscaledHeight) || unscaledHeight < 1;
	}
	
	/**
	 * 	예약 리스트에 객체를 추가한다.
	 */
	protected function pushChildToReservedChildList(child:DisplayObject, index:int):Boolean {
		if( initialized )	return false;
		if( !reservedChildList )	reservedChildList = [];
		reservedChildList[reservedChildList.length] = {child:child, index:index};
		return true;
	}
	
	private function pushMenuItems(contextMenu:ContextMenu):void {
		var item:ContextMenuItem = new ContextMenuItem("Golfzon.co.Ltd");
		item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
		contextMenu.customItems.push(item);
	}
	
	private function removeOrigineStyle():void {
		if( creationComplete && getCSSStyleDeclaration() ) {
			getCSSStyleDeclaration().clear();
			setStyleBy(getCSSStyleDeclaration());
		}
	}
	
	private function removeToolTip():void {
		if( toolTipInstance && stage && stage.contains(toolTipInstance) ) {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
			stage.removeChild(toolTipInstance);
			toolTipInstance = null;
		}
	}
	
	/**
	 *	origineWidth와 origineHeight를 unscaledWidth, unscaledHeight 값으로 갱신한다.
	 */
	protected function resetToOrigineSize():void {
		origineWidth = _unscaledWidth;
		origineHeight = _unscaledHeight;
	}
	
	private function setComponentProperties():void {
		var fullName:String = getQualifiedClassName(this);
		var name:String = fullName.search("::") > -1 ? fullName.split("::")[1] : fullName;
		var value:int = 0;
		if( componentTable.contains(name) ) {
			value = componentTable.getValue(name) + 1;
			componentTable.remove(name);
		}
		
		componentTable.add(name, value);
		
		_instanceName = name + componentTable.getValue(name);
		_uid = UIDUtil.createUID();
	}
	
	/**
	 *	스테이지에 추가됐을 때에 대한 셋팅
	 */
	protected function setAddedState():void {
		initialized = true;
		configureListenersToParent();
		registerInstance();
		setDropShadow();
		
		if( !styleNameChanged ) {
			if( typeof _styleName == "object" )
				setStyleBy(_styleName);
		}
		
		createChildren();
		addReservedChildList();
		commitProperties();
		measure();
		updateDisplayList(unscaledWidth, unscaledHeight);
		creationComplete = true;
		dispatchCreationComplete();
	}
	
	/**
	 *	enabled 속성이 변경되었을 때 호출되며, mouseEnabled, mouseChildren이 변경된다.
	 */
	protected function setStateToChangeEnabled():void {
		mouseEnabled = mouseChildren = _enabled;
	}
	
	private function setDropShadow():void {
		var enabled:Boolean = replaceNullorUndefined(getStyle(StyleProp.DROP_SHADOW_ENABLED), false);
		if( enabled ) {
			var alpha:Number = replaceNullorUndefined(getStyle(StyleProp.DROP_SHADOW_ALPHA), 0.2);
			var blurX:Number = replaceNullorUndefined(getStyle(StyleProp.DROP_SHADOW_BLUR_X), 4);
			var blurY:Number = replaceNullorUndefined(getStyle(StyleProp.DROP_SHADOW_BLUR_Y), 4);
			var strength:Number = replaceNullorUndefined(getStyle(StyleProp.DROP_SHADOW_STRENGTH), 1);
			var filter:DropShadowFilter = new DropShadowFilter(3, 45, 0, alpha, blurX, blurY, strength, 10);
			if( filters.length > 0 )
				filters.push(filter);
			else
				filters = [filter];
			
			filterIndex = filters.length - 1;
		} else if( filterIndex > -1 ) {
			filters.splice(filterIndex, 1);
			filterIndex = -1;
		}
	}
	
	private function setStyleBy(styleObj:Object):void {
		for( var styleProp:String in styleObj ) {
			setStyle(styleProp, styleObj[styleProp]);
		}
	}
	
	private function setToolTip():void {
		if( _toolTip ) {
			createToolTip();
			moveToolTip();
			
			var duration:Number = replaceNullorUndefined(toolTipInstance.getStyle(StyleProp.SHOW_DURATION), 0.8);
			TweenMax.to(toolTipInstance, duration, {alpha:1, ease:Strong.easeOut});
		} else {
			removeToolTip();
		}
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
		return _unscaledWidth != origineWidth || _unscaledHeight != origineHeight;
	}
	
	private function createBitmap():void {
		if( !bitmapCache && _bitmapMode && !invalidSize() ) {
			bitmapCache = new Bitmap(BitmapDataUtil.generate(this, true, 0xff0000));
			removeAll();
			addChild(bitmapCache);
		}
	}
	
	private function removeBitmap():void {
		if( bitmapCache ) {
			removeChild(bitmapCache);
			if( bitmapCache.bitmapData )
				bitmapCache.bitmapData.dispose();
			bitmapCache = null;
			
			recoverAll();
		}
	}
	
	private function recoverAll():void {
		for each( var child:DisplayObject in removedChildren ) {
			addChild(child);
		}
		removedChildren = null;
	}
	
	private function removeAll():void {
		removedChildren = new Vector.<DisplayObject>;
		var count:uint = numChildren;
		for( var i:uint=0; i<count; i++ ) {
			removedChildren.push(removeChildAt(0));
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//	Event handlers
	//
	//--------------------------------------------------------------------------
	
	protected function addedToStageHandler(event:Event):void {
		removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		setAddedState();
	}
	
	protected function creationCompleteHandler(event:ComponentEvent):void {
	}
	
	protected function dragCompleteHandler(event:DragEvent):void {
	}
	
	protected function dragDropHandler(event:DragEvent):void {
	}
	
	protected function dragEnterHandler(event:DragEvent):void {
	}
	
	protected function dragOverHandler(event:DragEvent):void {
	}
	
	protected function dragStartHandler(event:DragEvent):void {
	}
	
	protected function focusInHandler(event:FocusEvent):void {
	}
	
	protected function focusOutHandler(event:FocusEvent):void {
	}
	
	protected function moveToolTip():void {
		if( stage.mouseX < 0 )
			toolTipInstance.x = 0;
		else if( stage.mouseX + toolTipInstance.width > ApplicationBase.application.width )
			toolTipInstance.x = ApplicationBase.application.width - toolTipInstance.width;
		else
			toolTipInstance.x = stage.mouseX;
		
		if( stage.mouseY - toolTipInstance.height < 0 )
			toolTipInstance.y = 0;
		else if( stage.mouseY + toolTipInstance.height > ApplicationBase.application.height )
			toolTipInstance.y = ApplicationBase.application.height - toolTipInstance.height;
		else
			toolTipInstance.y = stage.mouseY - toolTipInstance.height - 5;
	}
	
	private function menuItemSelectHandler(event:ContextMenuEvent):void {
		navigateToURL(new URLRequest("http://www.golfzon.com"), "_blank");
	}
	
	private function parent_doubleClickEnableChangedHandler(event:Event):void {
		doubleClickEnabled = IInteractiveObject(parent).doubleClickEnabled;
	}
	
	private function parent_registerInstanceHandler(event:StyleEvent):void {
		registerInstance();
	}
	
	private function parent_styleChangedHandler(event:StyleEvent):void {
		if( systemManager.cssInitialized && parent is IStyleClient && IStyleClient(parent).getInheritStyleTable().contains(event.styleProp) )
			setStyle(event.styleProp, event.value);
	}
	
	private function parent_useAutoRemovementChangedHandler(event:Event):void {
		if( !useAutoRemovementChanged )
			_useAutoRemovement = ComponentBase(parent).useAutoRemovement;
	}
	
	protected function removeFromStageHandler(event:Event):void {
		removeEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
		dispose();
	}
	
	private function stage_mouseMoveHandler(event:MouseEvent):void {
		moveToolTip();
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//  bitmapMode
	//--------------------------------------
	
	private var bitmapModeChanged:Boolean;
	
	private var _bitmapMode:Boolean;
	
	public function get bitmapMode():Boolean {
		return _bitmapMode;
	}
	
	public function set bitmapMode(value:Boolean):void {
		if( value == _bitmapMode )
			return;
		
		_bitmapMode = value;
		bitmapModeChanged = true;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//	enabled
	//--------------------------------------
	
	private var enabledChanged:Boolean;
	
	private var _enabled:Boolean = true;
	
	public function get enabled():Boolean {
		return _enabled;
	}
	
	public function set enabled(value:Boolean):void {
		if( value == _enabled )
			return;
		
		_enabled = value;
		enabledChanged = true;
		
		invalidateProperties();
		dispatchEvent(new Event("enableChanged"));
	}
	
	//--------------------------------------
	//	id
	//--------------------------------------
	
	private var _id:String;
	
	public function get id():String {
		var parentId:String = "";
		var p:DisplayObject = parent;
		while( p ) {
			if( p is IComponent )
				parentId = IComponent(p).instanceName + "." + parentId;
			p = p.parent;
		}
		
		_id = parentId + instanceName;
		return _id;
	}
	
	public function set id(value:String):void {
		_id = value;
	}
	
	//--------------------------------------
	//	instanceName
	//--------------------------------------
	
	private var _instanceName:String;
	
	public function get instanceName():String {
		return _instanceName;
	}
	
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
	//	styleName
	//--------------------------------------
	
	private var styleNameChanged:Boolean;
	
	private var _styleName:Object;
	
	public function get styleName():Object {
		return _styleName;
	}
	
	public function set styleName(value:Object):void {
		if( value === _styleName )
			return;
		
		removeOrigineStyle();
		
		_styleName = value;
		styleNameChanged = creationComplete;
		
		invalidateProperties();
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	systemManager
	//--------------------------------------
	
	private var _systemManager:SystemManager;
	
	public function get systemManager():SystemManager {
		if( _systemManager )
			return _systemManager;
		
		var p:DisplayObject = parent;
		while( p ) {
			if( p is ISystemManagerClient && ISystemManagerClient(p).systemManager )
				_systemManager = ISystemManagerClient(p).systemManager;
			
			p = p.parent;
		}
		return _systemManager ? _systemManager : SystemManager.newNull();
	}
	
	public function set systemManager(value:SystemManager):void {
		if( !_systemManager )
			_systemManager = value;
	}
	
	//--------------------------------------
	//	toolTip
	//--------------------------------------
	
	private var toolTipChanged:Boolean;
	
	private var _toolTip:String;
	
	public function get toolTip():String {
		return _toolTip;
	}
	
	public function set toolTip(value:String):void {
		if( value == _toolTip ) return;
		
		_toolTip = value;
		toolTipChanged = true;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//	uid
	//--------------------------------------
	
	private var _uid:String;
	
	public function get uid():String {
		return _uid;
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
	
	//--------------------------------------
	//	useAutoRemovement
	//--------------------------------------
	
	private var useAutoRemovementChanged:Boolean;
	
	private var _useAutoRemovement:Boolean = true;
	
	public function get useAutoRemovement():Boolean {
		return _useAutoRemovement;
	}
	
	/**
	 *	Allows to dispose resources in self.<br/>
	 * 	@default value true.
	 */
	public function set useAutoRemovement(value:Boolean):void {
		if( value == _useAutoRemovement )
			return;
		
		_useAutoRemovement = value;
		useAutoRemovementChanged = true;
		dispatchEvent(new Event("useAutoRemovementChanged"));
	}
}
	
}