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

package com.golfzon.gfl.controls.scrollBarClasses
{
	
import com.golfzon.gfl.controls.Button;
import com.golfzon.gfl.core.ComponentBase;
import com.golfzon.gfl.core.gz_internal;
import com.golfzon.gfl.events.GZMouseEvent;
import com.golfzon.gfl.events.ScrollEvent;
import com.golfzon.gfl.nullObject.Null;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Shape;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.ui.Keyboard;
import flash.utils.clearInterval;

import gs.TweenMax;
import gs.easing.Expo;

use namespace gz_internal;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *	스크롤될 때 송출한다.
 */
[Event(name="scroll", type="com.golfzon.gfl.events.ScrollEvent")]

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *	@Include the external file to define scroll bar styles.
 */
include "../../styles/metadata/ScrollBarStyles.as";

/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.09.22
 *	@Modify
 *	@Description		Abstract Class
 */
public class ScrollBarBase extends ComponentBase implements Null
{
    //--------------------------------------------------------------------------
	//
	//	Instance constants
	//
    //--------------------------------------------------------------------------
    
    [Embed(source="/assets/GZSkin.swf", symbol="ScrollArrowDown_disabledSkin")]
    private var DOWN_ARROW_DISABLED_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="ScrollArrowDown_downSkin")]
    private var DOWN_ARROW_DOWN_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="ScrollArrowDown_overSkin")]
    private var DOWN_ARROW_OVER_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="ScrollArrowDown_upSkin")]
    private var DOWN_ARROW_UP_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="ScrollThumb_downSkin")]
    private var THUMB_DOWN_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="ScrollThumb_overSkin")]
    private var THUMB_OVER_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="ScrollThumb_upSkin")]
    private var THUMB_UP_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="ScrollTrack_disabledSkin")]
    private var TRACK_DISABLED_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="ScrollTrack_skin")]
    private var TRACK_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="ScrollArrowUp_disabledSkin")]
    private var UP_ARROW_DISABLED_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="ScrollArrowUp_downSkin")]
    private var UP_ARROW_DOWN_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="ScrollArrowUp_overSkin")]
    private var UP_ARROW_OVER_SKIN:Class;
    
    [Embed(source="/assets/GZSkin.swf", symbol="ScrollArrowUp_upSkin")]
    private var UP_ARROW_UP_SKIN:Class;
    
    //--------------------------------------------------------------------------
	//
	//	Instance variables
	//
    //--------------------------------------------------------------------------
    
    private var downedMouseX:Number;
    private var downedMouseY:Number;
    private var downedThumbX:Number;
    private var downedThumbY:Number;
    private var localMaxScrollPosition:Number = 0;
	private var pageSize:Number = 0;
	private var viewSize:Number = 0;
	
	private var intervalId:uint;
	
	private var controlKeyDowned:Boolean;
	
	private var trackGuider:Shape;
    
    // gz_internal varialbes
	gz_internal var arrowSize:Number;
	
	gz_internal var downArrow:Button;
	gz_internal var thumb:Button;
	gz_internal var track:Button;
	gz_internal var upArrow:Button;
	
	/**
	 *	@Constructor
	 */
	public function ScrollBarBase() {
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
     * 	@private
     */
    override protected function addedToStageHandler(event:Event):void {
    	super.addedToStageHandler(event);
    	
		stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler, false, 0, true);
		stage.addEventListener(KeyboardEvent.KEY_UP, stage_keyUpHandler, false, 0, true);
		stage.addEventListener(MouseEvent.MOUSE_WHEEL, stage_mouseWheelHandler, false, 0, true);
    }
	
    /**
     * 	프로퍼티 변경 사항에 대한 처리
     */
	override protected function commitProperties():void {
		super.commitProperties();
		
		if( buttonModeChanged ) {
			buttonModeChanged = false;
			downArrow.buttonMode = upArrow.buttonMode = thumb.buttonMode = buttonMode;
		}
		
		if( localScrollPositionChanged ) {
			localScrollPositionChanged = false;
			_scrollPosition = localPositionToTargetPosition(localScrollPosition);
			scroll();
			dispatchScroll();
		}
		
		if( minThumbSizeChanged ) {
			minThumbSizeChanged = false;
			invalidateDisplayList();
		}
		
		if( scrollPositionChanged ) { 
			scrollPositionChanged = false;
			_localScrollPosition = targetPositionToLocalPosition(scrollPosition);
			scroll();
		}
	}
    
    /**
     * 	자식 객체 생성 및 추가
     */
	override protected function createChildren():void {
		track = createButton();
		downArrow = createButton();
		upArrow = createButton();
		thumb = createButton();
		track.delay = 70;
		
		trackGuider = new Shape();
		
		addChildAt(trackGuider, 1);
		setDefaultStyle();
	}
	
    /**
     *	enabled에 따른 구현
     */
	override protected function setEnabledState():void {
		super.setEnabledState();
		
		thumb.enabled = track.enabled = downArrow.enabled = upArrow.enabled = enabled;
		thumb.visible = enabled;
	}
	
    /**
     *	스타일 프로퍼티로 값을 설정한다.
     */
	override public function styleChanged(styleProp:String):void {
		super.styleChanged(styleProp);
    
		switch( styleProp ) {
			case StyleProp.DOWN_ARROW_DISABLED_SKIN:	case StyleProp.DOWN_ARROW_DOWN_SKIN:
			case StyleProp.DOWN_ARROW_OVER_SKIN:		case StyleProp.DOWN_ARROW_UP_SKIN:
				setDownArrowStyle(styleProp);
				break;
				
			case StyleProp.THUMB_DOWN_SKIN:	case StyleProp.THUMB_OVER_SKIN:
			case StyleProp.THUMB_UP_SKIN:
				setThumbStyle(styleProp);
				break;
				
			case StyleProp.TRACK_DISABLED_SKIN:
				setThumbStyle(styleProp);
				break;
				
			case StyleProp.TRACK_DISABLED_SKIN:	case StyleProp.TRACK_SKIN:
				setTrackStyle(styleProp);
				break;
				
			case StyleProp.UP_ARROW_DISABLED_SKIN:	case StyleProp.UP_ARROW_DOWN_SKIN:
			case StyleProp.UP_ARROW_OVER_SKIN:		case StyleProp.UP_ARROW_UP_SKIN:
				setUpArrowStyle(styleProp);
				break;
		}
	}
	
    /**
     * 	디스플레이 변경 사항에 대한 처리
     */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		track.width = unscaledWidth;
		track.height = unscaledHeight;
		
		downArrow.width = upArrow.width = isHorizontal() ? unscaledHeight : unscaledWidth;;
		downArrow.height = upArrow.height = arrowSize;
		downArrow.x = isHorizontal() ? arrowSize : 0;
		downArrow.y = isHorizontal() ? 0 : unscaledHeight - arrowSize;
		
		upArrow.x = isHorizontal() ? unscaledWidth : 0;
		upArrow.y = 0;
		
		setThumbProperties();
		moveThumb();
	}
	
	//--------------------------------------
	//  buttonMode
	//--------------------------------------
	
	private var buttonModeChanged:Boolean;
	
	private var _buttonMode:Boolean;
	
	override public function get buttonMode():Boolean {
		return _buttonMode;
	}
	
	override public function set buttonMode(value:Boolean):void {
		if( _buttonMode == value ) return;
		
		_buttonMode = value;
		buttonModeChanged = true;
		
		invalidateProperties();
	}
	
    //--------------------------------------------------------------------------
    //	gz_internal
    //--------------------------------------------------------------------------
	
	/**
	 *	Thumb를 이동시킨다.
	 */
	gz_internal function moveThumb():void {
		if( isHorizontal() )
			thumb.x = positionToCoordinate(localScrollPosition);
		else
			thumb.y = positionToCoordinate(localScrollPosition);
	}
	
	/**
	 *	Thumb를 이동시킨다.
	 */
	gz_internal function scroll():void {
		moveThumb();
	}
    
	/**
	 *	Thumb의 넓이를 설정한다.
	 */
	gz_internal function setThumbProperties():void {
		thumb.visible = downArrow.enabled = track.enabled = upArrow.enabled = maxScrollPosition > 0;
			
		var maxThumbSize:Number = (getSizeByDirection() - arrowSize * 2);
		var ratio:Number = pageSize / viewSize;
		var newThumbSize:Number = Math.max(minThumbSize, maxThumbSize / ratio);
		localMaxScrollPosition = maxThumbSize - newThumbSize;
		
		if( isHorizontal() ) {
			thumb.width = newThumbSize;
			thumb.height = unscaledHeight;
		} else {
			thumb.width = unscaledWidth;
			thumb.height = newThumbSize;
		}
	}
	
    //--------------------------------------------------------------------------
    //	Public
    //--------------------------------------------------------------------------
    
	/**
	 *	객체가 null object인지에 대한 부울값
	 */
    public function isNull():Boolean {
    	return false;
    }
	
	/**
	 *	스크롤 라인 단위로 스크롤한다.
	 */
	public function lineScroll(line:Number):void {
		var value:Number = isHorizontal() ? scrollPosition + line * -1 : scrollPosition + line;
		scrollPosition = getCurrentScrollPosition(value);
		dispatchScroll();
	}
	
	/**
	 *	스크롤바의 페이지 사이즈를 설정한다.
	 */
	public function setScrollProperties(pageSize:Number, viewSize:Number):void {
		this.pageSize = pageSize;
		this.viewSize = viewSize;
		_maxScrollPosition = Math.ceil(Math.max(0, pageSize - viewSize) / lineScrollSize);
		setThumbProperties();
		moveThumb();
	}
	
    //--------------------------------------------------------------------------
    //	Internal
    //--------------------------------------------------------------------------
	
	/**
	 *	@private
	 */
	private function animateTrackGuider():void {
		trackGuider.alpha = 1.0;
		TweenMax.to(trackGuider, 1.5, {alpha:0.0, ease:Expo.easeOut});
	}
    
    /**
     * 	@private
     */
	protected function configureListeners(dispatcher:IEventDispatcher):void {
		dispatcher.addEventListener(GZMouseEvent.KEEP_MOUSE_PRESS, mousePressHandler, false, 0, true);
		dispatcher.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, -1, true);
		dispatcher.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true);
	}
	
    /**
     * 	@private
     */
	private function configureStageListeners(includeMouseMove:Boolean=true):void {
		if( includeMouseMove )
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler_stage, false, 0, true);
		stage.addEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler_stage, false, 1, true);
		stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler_stage, false, 1, true);
	}
	
    /**
     * 	@private
     */
	private function coordinateToPosition(value:Number):Number {
		return Math.min(localMaxScrollPosition, value - arrowSize);
	}
	
    /**
     * 	@private
     */
	private function createButton():Button {
		var button:Button = new Button();
		button.label = null;
		configureListeners(button);
		return Button(addChild(button));
	}
	
	/**
	 *	@private
	 */
	private function dispatchScroll(delta:Number=0):void {
		dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL, false, false, null, scrollPosition, direction, delta));
	}
	
	/**
	 *	@private
	 */
	private function drawTrackGuider():void {
		var w:Number = getTrackGuiderWidth();
		var h:Number = getTrackGuiderHeight();
		var color:uint = replaceNullorUndefined(getStyle(StyleProp.TRACK_GUIDER_COLOR), 0x000000);
		trackGuider.graphics.clear();
		trackGuider.graphics.beginBitmapFill(new BitmapData(1, 1, false, color));
		trackGuider.graphics.drawRect(getTrackGuiderXBy(w), getTrackGuiderYBy(h), w, h);
		trackGuider.graphics.endFill();
	}
	
    /**
     * 	@private
     */
	private function getCurrentLocalScrollPosition(value:Number):Number {
		return Math.min(Math.max(0, value), localMaxScrollPosition);
	}
	
    /**
     * 	@private
     */
	private function getCurrentScrollPosition(value:Number):Number {
		return Math.min(Math.max(0, value), maxScrollPosition);
	}
	
	/**
	 *	@private
	 */
	private function getAddendLocalPositionByMousePoint():Number {
		if( isHorizontal() )
			return downedMouseX > downedThumbX ? thumb.width : -thumb.width;
		return downedMouseY > downedThumbY ? thumb.height : -thumb.height;
	}
	
    /**
     * 	@private
     */
	private function getSizeByDirection():Number {
		return isHorizontal() ? unscaledWidth : unscaledHeight;
	}
	
	/**
	 *	@private
	 */
	private function getThumbPositionByMouseMoving():Number {
		return isHorizontal() ?
			downedThumbX + (mouseX - downedMouseX) :
			downedThumbY + (mouseY - downedMouseY);
	}
	
	/**
	 *	@private
	 */
	private function getThumbPositionByTrack():Number {
		if( isHorizontal() )
			return mouseX < thumb.x ? thumb.x - thumb.width : thumb.x + thumb.width;
		return mouseY < thumb.y ? thumb.y - thumb.height : thumb.y + thumb.height;
	}
	
	/**
	 *	@private
	 */
	private function getTrackGuiderHeight():Number {
		if( isHorizontal() )
			return unscaledHeight;
		return downedMouseY < downedThumbY ? thumb.y - arrowSize : unscaledHeight - arrowSize - thumb.y - thumb.height;
	}
	
	/**
	 *	@private
	 */
	private function getTrackGuiderWidth():Number {
		if( !isHorizontal() )
			return unscaledWidth;
		return downedMouseX < downedThumbX ? thumb.x - arrowSize : unscaledWidth - arrowSize - thumb.x - thumb.width;
	}
	
	/**
	 *	@private
	 */
	private function getTrackGuiderXBy(w:Number):Number {
		if( !isHorizontal() )
			return 0;
		return downedMouseX < downedThumbX ? thumb.x - w : thumb.x + thumb.width;
	}
	
	/**
	 *	@private
	 */
	private function getTrackGuiderYBy(h:Number):Number {
		if( isHorizontal() )
			return 0;
		return downedMouseY < downedThumbY ? thumb.y - h : thumb.y + thumb.height;
	}
	
	/**
	 *	@private
	 */
	private function isHorizontal():Boolean {
		return direction == ScrollBarDirection.HORIZONTAL;
	}
	
	/**
	 *	@private
	 */
	private function isValidPosition():Boolean {
		if( isHorizontal() )
			return downedMouseX < downedThumbX ? mouseX < thumb.x : mouseX > thumb.x + thumb.width;
		return downedMouseY < downedThumbY ? mouseY < thumb.y : mouseY > thumb.y + thumb.height;
	}
	
    /**
     * 	@private
     */
	private function localPositionToTargetPosition(value:Number):Number {
		return Math.round(value * maxScrollPosition / localMaxScrollPosition);
	}
	
    /**
     * 	@private
     */
	private function positionToCoordinate(value:Number):Number {
		return Math.ceil(Math.min(localMaxScrollPosition + arrowSize, value + arrowSize));
	}
	
    /**
     * 	@private
     */
	private function targetPositionToLocalPosition(value:Number):Number {
		return value * localMaxScrollPosition / maxScrollPosition;
	}
	
	/**
	 *	@private
	 */
	private function released():void {
		thumb.allowPhaseChange = true;
		_scrolling = false;
		downedMouseX = downedMouseY = downedThumbX = downedThumbX = NaN;
		clearInterval(intervalId);
		stage.removeEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler_stage);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler_stage);
		stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler_stage);
	}
    
    /**
     * 	@private
     */
    private function scrollBy(target:DisplayObject):void {
		if( target == track )
			scrollByTrack();
		else
			lineScroll(target == upArrow ? -1 : 1);
    }
	
	/**
	 *	@private
	 */
	private function scrollByTrack():void {
		var scrollable:Boolean = isValidPosition() && !thumb.hitTestPoint(stage.mouseX, stage.mouseY, true);
		if( scrollable ) {
			localScrollPosition += getAddendLocalPositionByMousePoint();
			drawTrackGuider();
			animateTrackGuider();
		}
	}
	
    /**
     * 	@private
     */
	private function setDefaultStyle():void {
		setDownArrowStyle(StyleProp.DOWN_ARROW_DISABLED_SKIN);
		setDownArrowStyle(StyleProp.DOWN_ARROW_DOWN_SKIN);
		setDownArrowStyle(StyleProp.DOWN_ARROW_OVER_SKIN);
		setDownArrowStyle(StyleProp.DOWN_ARROW_UP_SKIN);
		
		setTrackStyle(StyleProp.TRACK_DISABLED_SKIN);
		setTrackStyle(StyleProp.TRACK_SKIN);
		
		setThumbStyle(StyleProp.THUMB_DOWN_SKIN);
		setThumbStyle(StyleProp.THUMB_OVER_SKIN);
		setThumbStyle(StyleProp.THUMB_UP_SKIN);
		
		setUpArrowStyle(StyleProp.UP_ARROW_DISABLED_SKIN);
		setUpArrowStyle(StyleProp.UP_ARROW_DOWN_SKIN);
		setUpArrowStyle(StyleProp.UP_ARROW_OVER_SKIN);
		setUpArrowStyle(StyleProp.UP_ARROW_UP_SKIN);
	}
	
    /**
     * 	@private
     */
	private function setDownArrowStyle(styleProp:String):void {
		switch( styleProp ) {
			case StyleProp.DOWN_ARROW_DISABLED_SKIN:
				downArrow.setStyle(StyleProp.DISABLED_SKIN,
					replaceNullorUndefined(getStyle(styleProp), DOWN_ARROW_DISABLED_SKIN));
				break;
			
			case StyleProp.DOWN_ARROW_DOWN_SKIN:
				downArrow.setStyle(StyleProp.DOWN_SKIN,
					replaceNullorUndefined(getStyle(styleProp), DOWN_ARROW_DOWN_SKIN));
				break;
			
			case StyleProp.DOWN_ARROW_OVER_SKIN:
				downArrow.setStyle(StyleProp.OVER_SKIN,
					replaceNullorUndefined(getStyle(styleProp), DOWN_ARROW_OVER_SKIN));
				break;
			
			case StyleProp.DOWN_ARROW_UP_SKIN:
				downArrow.setStyle(StyleProp.UP_SKIN,
					replaceNullorUndefined(getStyle(styleProp), DOWN_ARROW_UP_SKIN));
				break;
		}
	}
	
    /**
     * 	@private
     */
	private function setTrackStyle(styleProp:String):void {
		switch( styleProp ) {
			case StyleProp.TRACK_DISABLED_SKIN:
				track.setStyle(StyleProp.DISABLED_SKIN,
					replaceNullorUndefined(getStyle(styleProp), TRACK_DISABLED_SKIN));
				break;
			
			case StyleProp.TRACK_SKIN:
				track.setStyle(StyleProp.DOWN_SKIN,
					replaceNullorUndefined(getStyle(styleProp), TRACK_SKIN));
				track.setStyle(StyleProp.OVER_SKIN,
					replaceNullorUndefined(getStyle(styleProp), TRACK_SKIN));
				track.setStyle(StyleProp.UP_SKIN,
					replaceNullorUndefined(getStyle(styleProp), TRACK_SKIN));
				break;
		}
	}
	
    /**
     * 	@private
     */
	private function setThumbStyle(styleProp:String):void {
		switch( styleProp ) {
			case StyleProp.THUMB_DOWN_SKIN:
				thumb.setStyle(StyleProp.DOWN_SKIN,
					replaceNullorUndefined(getStyle(styleProp), THUMB_DOWN_SKIN));
				break;
			
			case StyleProp.THUMB_OVER_SKIN:
				thumb.setStyle(StyleProp.OVER_SKIN,
					replaceNullorUndefined(getStyle(styleProp), THUMB_OVER_SKIN));
				break;
			
			case StyleProp.THUMB_UP_SKIN:
				thumb.setStyle(StyleProp.UP_SKIN,
					replaceNullorUndefined(getStyle(styleProp), THUMB_UP_SKIN));
				break;
		}
	}
	
    /**
     * 	@private
     */
	private function setUpArrowStyle(styleProp:String):void {
		switch( styleProp ) {
			case StyleProp.UP_ARROW_DISABLED_SKIN:
				upArrow.setStyle(StyleProp.DISABLED_SKIN,
					replaceNullorUndefined(getStyle(styleProp), UP_ARROW_DISABLED_SKIN));
				break;
			
			case StyleProp.UP_ARROW_DOWN_SKIN:
				upArrow.setStyle(StyleProp.DOWN_SKIN,
					replaceNullorUndefined(getStyle(styleProp), UP_ARROW_DOWN_SKIN));
				break;
			
			case StyleProp.UP_ARROW_OVER_SKIN:
				upArrow.setStyle(StyleProp.OVER_SKIN,
					replaceNullorUndefined(getStyle(styleProp), UP_ARROW_OVER_SKIN));
				break;
			
			case StyleProp.UP_ARROW_UP_SKIN:
				upArrow.setStyle(StyleProp.UP_SKIN,
					replaceNullorUndefined(getStyle(styleProp), UP_ARROW_UP_SKIN));
				break;
		}
	}
	
    /**
     * 	@private
     */
	private function setMouseDownState():void {
		downedMouseX = mouseX;
		downedMouseY = mouseY;
		downedThumbX = thumb.x;
		downedThumbY = thumb.y;
	}
	
    //--------------------------------------------------------------------------
	//
	//	Event handlers
	//
    //--------------------------------------------------------------------------
    
    /**
     * 	@private
     */
	protected function mouseDownHandler(event:MouseEvent):void {
		_scrolling = true;
		
		setMouseDownState();
		
		if( event.currentTarget == thumb ) {
			thumb.allowPhaseChange = false;
			configureStageListeners();
		} else {
			configureStageListeners(false);
			scrollBy(DisplayObject(event.currentTarget));
		}
	}
	
    /**
     * 	@private
     */
	private function mousePressHandler(event:MouseEvent):void {
		if( event.currentTarget != thumb )
			scrollBy(DisplayObject(event.currentTarget));
	}
	
    /**
     * 	@private
     */
	private function mouseLeaveHandler_stage(event:MouseEvent):void {
		released();
	}
	
    /**
     * 	@private
     */
	private function mouseMoveHandler_stage(event:MouseEvent):void {
		localScrollPosition = coordinateToPosition(getThumbPositionByMouseMoving());
	}
	
    /**
     * 	@private
     */
	private function mouseUpHandler(event:MouseEvent):void {
		released();
	}
	
    /**
     * 	@private
     */
	private function mouseUpHandler_stage(event:MouseEvent):void {
		released();
	}
    
    /**
     * 	@private
     */
    private function stage_keyDownHandler(event:KeyboardEvent):void {
    	if( event.keyCode == Keyboard.CONTROL )
    		controlKeyDowned = true;
    }
    
    /**
     * 	@private
     */
    private function stage_keyUpHandler(event:KeyboardEvent):void {
    	if( event.keyCode == Keyboard.CONTROL )
    		controlKeyDowned = false;
    }
    
    /**
     * 	@private
     */
    private function stage_mouseWheelHandler(event:MouseEvent):void {
    	if( wheelEnabled ) {
    		var muliply:Number = controlKeyDowned ? 5 : 1;
	    	lineScroll(event.delta / 3 * muliply * -1);
	    }
    }

    //--------------------------------------------------------------------------
	//
	//	getter / setter
	//
    //--------------------------------------------------------------------------

	//--------------------------------------
	//  direction
	//--------------------------------------
	
	protected var _direction:String;
	
	public function get direction():String {
		return _direction;
	}
	
	//--------------------------------------
	//  lineScrollSize
	//--------------------------------------
	
	protected var _lineScrollSize:Number = 1;
	
	public function get lineScrollSize():Number {
		return _lineScrollSize;
	}
	
	public function set lineScrollSize(value:Number):void {
		_lineScrollSize = value;
	}

	//--------------------------------------
	//  maxScrollPosition
	//--------------------------------------
	
	protected var _maxScrollPosition:int;
	
	public function get maxScrollPosition():int {
		return _maxScrollPosition;
	}
	
	//--------------------------------------
	//  minThumbSize
	//--------------------------------------
	
	private var minThumbSizeChanged:Boolean;
	
	private var _minThumbSize:Number = 14;
	
	public function get minThumbSize():Number {
		return _minThumbSize;
	}
	
	public function set minThumbSize(value:Number):void {
		if( value == _minThumbSize )
			return;
		
		_minThumbSize = value;
		minThumbSizeChanged = true;
		
		invalidateProperties();
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//  localScrollPosition
	//--------------------------------------
	
	private var localScrollPositionChanged:Boolean;
	
	private var _localScrollPosition:Number = 0;
	
	public function get localScrollPosition():Number {
		return _localScrollPosition;
	}
	
	public function set localScrollPosition(value:Number):void {
		if( value == _localScrollPosition )
			return;
		
		_localScrollPosition = getCurrentLocalScrollPosition(value);
		localScrollPositionChanged = true;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//  scrolling
	//--------------------------------------
	
	private var _scrolling:Boolean;
	
	public function get scrolling():Boolean {
		return _scrolling;
	}
	
	//--------------------------------------
	//  scrollPosition
	//--------------------------------------
	
	private var scrollPositionChanged:Boolean;
	
	private var _scrollPosition:int = 0;
	
	public function get scrollPosition():int {
		return _scrollPosition;
	}
	
	public function set scrollPosition(value:int):void {
		if( value == _scrollPosition )
			return;
		
		_scrollPosition = getCurrentScrollPosition(value);
		scrollPositionChanged = true;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//	wheelEnabled
	//--------------------------------------
	
	private var _wheelEnabled:Boolean;
	
	public function get wheelEnabled():Boolean {
		return _wheelEnabled;
	}
	
	public function set wheelEnabled(value:Boolean):void {
		_wheelEnabled = value;
	}
}

}