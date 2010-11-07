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

import flash.display.DisplayObject;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.ui.Mouse;

/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
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
    
	/**
	 *	@Constructor
	 */
	public function CursorManagerImpl() {
		if( !allowInstancing )
			throw new Error("CursorManagerImpl is not allowed instnacing!");
			
		stage = ApplicationBase.application ? ApplicationBase.application.systemManager.stage : null;
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
    	setCursor(BUSY_CURSOR);
    }
    
    /**
     *	커서를 설정한다.
     */
    public function setCursor(cursorClass:Class, xOffset:Number=0, yOffset:Number=0):void {
    	if( cursor )
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
    
	/**
	 *	@private
	 */
    private function configureListeners():void {
		if( stage ) {
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler, false, 0, true);
			stage.addEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler, false, 0, true);
		}
    }
    
	/**
	 *	@private
	 */
	private function createCursor():void {
		if( !cursor ) {
			cursor = DisplayObject(new cursorClass());
			cursor.x = stage.mouseX + xOffset;
			cursor.y = stage.mouseY + xOffset;
			
			stage.addChild(cursor);
		}
	}
    
	/**
	 *	@private
	 */
    private function removeListeners():void {
		if( stage ) {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			stage.removeEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);
		}
    }
	
    //--------------------------------------------------------------------------
	//
	//	Event handlers
	//
    //--------------------------------------------------------------------------
    
	/**
	 *	@private
	 */
    private function mouseLeaveHandler(event:Event):void {
    	if( cursor ) {
	    	Mouse.show();
	    	cursor.visible = false;
    	}
    }
    
	/**
	 *	@private
	 */
	private function mouseMoveHandler(event:MouseEvent):void {
		if( cursor ) {
			cursor.x = stage.mouseX + xOffset;
			cursor.y = stage.mouseY + xOffset;
		}
	}
    
	/**
	 *	@private
	 */
	private function mouseOverHandler(event:MouseEvent):void {
		if( cursor ) {
	    	Mouse.hide();
	    	cursor.visible = true;
		}
	}
}

}