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

package com.golfzon.gfl.managers.classes
{

import com.golfzon.gfl.core.ApplicationBase;
import com.golfzon.gfl.styles.CSSStyleDeclaration;
import com.golfzon.gfl.styles.GStyleManager;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.display.DisplayObject;
import flash.display.InteractiveObject;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.ui.Mouse;

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *	Skin for busy cursor<br>
 * 	@default value CursorManager_busyCursor of GZSkin.swf
 */
[Style(name="busyCursor", type="Class", inherit="no")]

/**
 *	@Author				KHKim
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.11.13
 *	@Modify
 *	@Description
 */
public class CursorManagerImpl
{
	//--------------------------------------------------------------------------
	//
	//	Class variables
	//
	//--------------------------------------------------------------------------
	
	private static var allowInstancing:Boolean;
	
	private static var uniqueInstance:CursorManagerImpl;
	
	//--------------------------------------------------------------------------
	//
	//	Instance constants
	//
	//--------------------------------------------------------------------------
	
	[Embed(source="/assets/GZSkin.swf", symbol="CursorManager_busyCursor")]
	private var BUSY_CURSOR:Class;
	
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	private var xOffset:Number;
	private var yOffset:Number;
	
	private var cursorClass:Class;
	private var cursor:DisplayObject;
	
	private var stage:Stage;
	
	private var emptyDeclaration:CSSStyleDeclaration = new CSSStyleDeclaration();
	
	/**
	 *	@Constructor
	 */
	public function CursorManagerImpl() {
		if( !allowInstancing )
			throw new Error("CursorManagerImpl is not allowed instnacing!");
			
		stage = ApplicationBase.application.stage;
	}
	
	//--------------------------------------------------------------------------
	//
	//	Class methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Public
	//--------------------------------------------------------------------------
	
	/**
	 *	싱글톤 인스턴스를 반환한다.
	 */
	public static function getInstance():CursorManagerImpl {
		if( !uniqueInstance ) {
			allowInstancing = true;
			uniqueInstance = new CursorManagerImpl();
			allowInstancing = false;
		}
		return uniqueInstance;
	}
	
	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Public
	//--------------------------------------------------------------------------
	
	/**
	 *	현재 디스플레이 커서 객체를 반환한다.
	 */
	public function getCursor():DisplayObject {
		return cursor;
	}
	
	/**
	 *	바쁨 상태 커서를 제거한다.
	 */
	public function removeBusyCursor():void {
		removeCursor();
	}
	
	/**
	 *	커서를 제거한다.
	 */
	public function removeCursor():void {
		if( cursor && stage && stage.contains(cursor) ) {
			stage.removeChild(cursor);
			removeListeners();
			Mouse.show();
			
			cursor = null;
			cursorClass = null;
			xOffset = yOffset = NaN;
		}
	}
	
	/**
	 *	커서를 바쁨 상태로 설정한다.
	 */
	public function setBusyCursor():void {
		setCursor(getBusyCursorClass());
	}
	
	/**
	 *	커서를 설정한다.
	 */
	public function setCursor(cursorClass:Class, xOffset:Number=0, yOffset:Number=0):void {
		if( cursor || cursorClass == this.cursorClass )
			return;
		
		this.cursorClass = cursorClass;
		this.xOffset = xOffset;
		this.yOffset = yOffset;
		
		if( cursorClass ) {
			createCursor();
			configureListeners();
			Mouse.hide();
		}
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	private function configureListeners():void {
		if( stage ) {
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0, true);
			stage.addEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler, false, 0, true);
		}
	}
	
	private function createCursor():void {
		if( !cursor ) {
			cursor = DisplayObject(new cursorClass());
			cursor.x = stage.mouseX + xOffset;
			cursor.y = stage.mouseY + yOffset;

			if( cursor is InteractiveObject )
				InteractiveObject(cursor).mouseEnabled = false;
			
			stage.addChild(cursor);
		}
	}
	
	private function getCSSStyleDeclaration():CSSStyleDeclaration {
		if( GStyleManager.getGlobalStyleDeclarationBy("com.golfzon.gfl.managers.CursorManager") )
			return GStyleManager.getGlobalStyleDeclarationBy("com.golfzon.gfl.managers.CursorManager");
		return emptyDeclaration; 
	}
	
	private function getBusyCursorClass():Class {
		var declaration:CSSStyleDeclaration = getCSSStyleDeclaration();
		return replaceNullorUndefined(declaration.getStyle(StyleProp.BUSY_CURSOR), BUSY_CURSOR);
	}
	
	private function removeListeners():void {
		if( stage ) {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.removeEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//	Event handlers
	//
	//--------------------------------------------------------------------------
	
	private function mouseLeaveHandler(event:Event):void {
		if( cursor ) {
			Mouse.show();
			cursor.visible = false;
		}
	}
	
	private function mouseMoveHandler(event:MouseEvent):void {
		if( cursor ) {
			Mouse.hide();
			cursor.x = stage.mouseX + xOffset;
			cursor.y = stage.mouseY + yOffset;
			cursor.visible = true;
		}
	}
}

}