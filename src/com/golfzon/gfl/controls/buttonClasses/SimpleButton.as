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

package com.golfzon.gfl.controls.buttonClasses
{
	
import com.golfzon.gfl.collection.Hashtable;
import com.golfzon.gfl.core.ComponentBase;
import com.golfzon.gfl.core.gz_internal;
import com.golfzon.gfl.events.GZMouseEvent;
import com.golfzon.gfl.skins.blueTheme.ButtonDisabledSkin;
import com.golfzon.gfl.skins.blueTheme.ButtonDownSkin;
import com.golfzon.gfl.skins.blueTheme.ButtonOverSkin;
import com.golfzon.gfl.skins.blueTheme.ButtonUpSkin;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;
import flash.utils.clearInterval;
import flash.utils.setInterval;

use namespace gz_internal;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *	버튼이 프레스될 때 송출한다.
 */
[Event(name="mousePress", type="com.golfzon.gfl.events.GZMouseEvent")]

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *	페이즈가 UP 상태일 때의 스킨 스타일<br>
 *	@default value "Button_upSkin of GZSkin.swf"
 */
[Style(name="upSkin", type="Class", inherit="no")]

/**
 *	페이즈가 OVER 상태일 때의 스킨 스타일<br>
 *	@default value "Button_overSkin of GZSkin.swf"
 */
[Style(name="overSkin", type="Class", inherit="no")]

/**
 *	페이즈가 DOWN 상태일 때의 스킨 스타일<br>
 *	@default value "Button_downSkin of GZSkin.swf"
 */
[Style(name="downSkin", type="Class", inherit="no")]

/**
 *	페이즈가 DISABLED 상태일 때의 스킨 스타일<br>
 *	@default value "Button_disabledSkin of GZSkin.swf"
 */
[Style(name="disabledSkin", type="Class", inherit="no")]

/**
 *	@Author				KHKim
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.08.25
 *	@Modify
 *	@Description
 * 	@includeExample		SimpleButtonSample.as
 */
public class SimpleButton extends ComponentBase
{
	//--------------------------------------------------------------------------
	//
	//	Instance constants
	//
	//--------------------------------------------------------------------------
	
	// phase
	gz_internal const PHASE_UP:String = "phaseUp";
	gz_internal const PHASE_OVER:String = "phaseOver";
	gz_internal const PHASE_DOWN:String = "phaseDown";
	gz_internal const PHASE_DISABLED:String = "phaseDisabled";
	gz_internal const PHASE_SELECTED:String = "phaseSelected";
	
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
		
	/**
	 *	마우스 다운 인터벌 딜레이
	 */
	gz_internal var delay:uint = 30;
	
	/**
	 *	타이머 딜레이
	 */
	gz_internal var timerDelay:uint = 500;
	
	/**
	 *	버튼의 상태 페이즈
	 */
	gz_internal var phase:String = PHASE_UP;
	
	/**
	 *	현재 스킨 인스턴스
	 */
	gz_internal var currentSkin:DisplayObject;
	
	[Embed(source="/assets/GZSkin.swf", symbol="Button_upSkin")]
	private var upSkin:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="Button_overSkin")]
	private var overSkin:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="Button_downSkin")]
	private var downSkin:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="Button_disabledSkin")]
	private var disabledSkin:Class;
	
	
	
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	private var intervalId:uint;
	
	private var mouseDowned:Boolean;
	
	private var timer:Timer;
	
	/**
	 *	마우스 인터랙션 영역
	 */
	private var hitRect:Sprite;
	
	/**
	 *	@Constructor
	 */
	public function SimpleButton() {
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
	 * 	자식 객체 생성 및 추가
	 */
	override protected function createChildren():void {
		hitRect = new Sprite();
		
		configureListeners();
		createSkin();
		addChild(hitRect);
	}
	
	/**
	 * 	상속 스타일 정의
	 */
	override public function getInheritStyleTable():Hashtable {
		var table:Hashtable = super.getInheritStyleTable();
		table.add(StyleProp.BACKGROUND_ALPHA, StyleProp.BACKGROUND_ALPHA);
		table.add(StyleProp.BORDER_COLOR, StyleProp.BORDER_COLOR);
		table.add(StyleProp.BORDER_THICKNESS, StyleProp.BORDER_THICKNESS);
		table.add(StyleProp.CORNER_RADIUS, StyleProp.CORNER_RADIUS);
		return table;
	}
	
	/**
	 * 	컴퍼넌트의 기본 크기와 최소 크기를 설정한다.
	 */
	override protected function measure():void {
		super.measure();

		if( !widthChanged && currentSkin )
			measureWidth = currentSkin.width;
			
		if( !heightChanged && currentSkin )
			measureHeight = currentSkin.height;

		setActualSize(unscaledWidth, unscaledHeight);
	}
	
	/**
	 *	enabled 속성 변경에 대한 처리
	 */
	override protected function setStateToChangeEnabled():void {
		super.setStateToChangeEnabled();

		changeSkin(getPhase());
	}
	
	/**
	 *	스타일 변경에 대한 처리
	 */
	override public function styleChanged(styleProp:String):void {
		switch( styleProp ) {
			case StyleProp.UP_SKIN:
				changeSkin(phase, phase == PHASE_UP);
				break;
				
			case StyleProp.OVER_SKIN:
				changeSkin(phase, phase == PHASE_OVER);
				break;
				
			case StyleProp.DOWN_SKIN:
				changeSkin(phase, phase == PHASE_DOWN);
				break;
				
			case StyleProp.DISABLED_SKIN:
				changeSkin(phase, phase == PHASE_DISABLED);
				break;
		}
	}
	
	/**
	 * 	디스플레이 변경 사항에 대한 처리
	 */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		if( currentSkin ) {
			currentSkin.width = unscaledWidth;
			currentSkin.height = unscaledHeight;
		}
		
		drawHitArea();
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	/**
	 * 	페이즈에 따라 스킨을 변경한다.
	 */
	protected function changeSkin(newPhase:String, allowChange:Boolean=false):void {
		if( !allowChange && phase == newPhase )
			return;

		phase = newPhase;
		removeSkin();
		createSkin();
		invalidateDisplayList();
	}
	
	/**
	 * 	dispatcher에 이벤트 핸들러를 등록한다.
	 */
	private function configureListeners():void {
		addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
		addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true);
		addEventListener(MouseEvent.ROLL_OVER, rollOverHandler, false, 0, true);
		addEventListener(MouseEvent.ROLL_OUT, rollOutHandler, false, 0, true);
	}
	
	/**
	 * 	페이즈에 따라 해당 스킨을 생성하고 스테이지에 추가한다.
	 */
	private function createSkin():void {
		var definition:Class = getSkinDefinition();
		if( definition ) {
			currentSkin = createSkinBy(definition);
			addChildAt(currentSkin, 0);
		}
	}
	
	/**
	 * 	마우스 인터랙션 영역을 그린다.
	 */
	private function drawHitArea():void {
		if( isNaN(unscaledWidth) || isNaN(unscaledHeight) )
			return;
		
		hitRect.graphics.clear();
		hitRect.graphics.beginFill(0x000000, 0);
		hitRect.graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
		hitRect.graphics.endFill();
	}
	
	/**
	 * 	enabled에 따른 버튼 페이즈를 반환한다.
	 */
	private function getPhase():String {
		return enabled ? PHASE_UP : PHASE_DISABLED;
	}
	
	/**
	 * 	페이즈에 따라 스킨 클래스를 반환한다.
	 */
	protected function getSkinDefinition():Class {
		if( phase == PHASE_UP )
			return replaceNullorUndefined(getStyle(StyleProp.UP_SKIN), upSkin);
		if( phase == PHASE_OVER )
			return replaceNullorUndefined(getStyle(StyleProp.OVER_SKIN), overSkin);
		if( phase == PHASE_DOWN )
			return replaceNullorUndefined(getStyle(StyleProp.DOWN_SKIN), downSkin);
		return replaceNullorUndefined(getStyle(StyleProp.DISABLED_SKIN), disabledSkin);
	}
	
	/**
	 * 	현재 스킨을 제거한다.
	 */
	private function removeSkin():void {
		if( currentSkin && contains(currentSkin) ) {
			removeChild(currentSkin);
			currentSkin = null;
		}
	}
	
	private function removeTimer():void {
		if( timer ) {
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
			timer = null;
		}
	}
	
	private function released():void {
		setMouseUpState();
		stage.removeEventListener(Event.MOUSE_LEAVE, stage_mouseLeaveHandler);
		stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
	}
	
	private function setMouseUpState():void {
		mouseDowned = false;
		changeSkin(PHASE_UP);
		clearInterval(intervalId);
		removeTimer();
	}
	
	private function startTimer():void {
		removeTimer();
			
		timer = new Timer(timerDelay, 1);
		timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler, false, 0, true);
		timer.start();
	}
	
	//--------------------------------------------------------------------------
	//
	//	Event handlers
	//
	//--------------------------------------------------------------------------
	
	/**
	 * 	flash.events.MouseEvent.MOUSE_DOWN
	 */
	protected function mouseDownHandler(event:MouseEvent):void {
		if( !enabled )
			return;
		
		mouseDowned = true;
		stage.addEventListener(Event.MOUSE_LEAVE, stage_mouseLeaveHandler, false, 0, true);
		stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler, false, 0, true);
		changeSkin(enabled ? PHASE_DOWN : PHASE_DISABLED);
		startTimer();
	}
	
	/**
	 * 	flash.events.MouseEvent.MOUSE_UP
	 */
	protected function mouseUpHandler(event:MouseEvent):void {
		setMouseUpState();
	}
	
	/**
	 * 	flash.events.Event.MOUSE_LEAVE
	 */
	private function stage_mouseLeaveHandler(event:Event):void {
		released();
	}
	
	/**
	 * 	flash.events.MouseEvent.MOUSE_UP
	 */
	protected function stage_mouseUpHandler(event:MouseEvent):void {
		released();
	}
	
	/**
	 * 	flash.events.MouseEvent.ROLL_OVER
	 */
	protected function rollOverHandler(event:MouseEvent):void {
		if( mouseDowned )
			changeSkin(enabled ? PHASE_DOWN : PHASE_DISABLED);
		else if( !event.buttonDown )
			changeSkin(enabled ? PHASE_OVER : PHASE_DISABLED);
	}
	
	/**
	 * 	flash.events.MouseEvent.ROLL_OUT
	 */
	protected function rollOutHandler(event:MouseEvent):void {
		changeSkin(getPhase());
	}
	
	private function dispatchMousePress():void {
		if( phase == PHASE_DOWN )
			dispatchEvent(new GZMouseEvent(GZMouseEvent.KEEP_MOUSE_PRESS));
	}
	
	/**
	 * 	flash.events.TimerEvent.TIMER_COMPLETE
	 */
	private function timerCompleteHandler(event:TimerEvent):void {
		removeTimer();
		intervalId = setInterval(dispatchMousePress, delay);
	}
}

}