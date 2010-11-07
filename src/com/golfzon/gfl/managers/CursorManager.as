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

package com.golfzon.gfl.managers
{

import com.golfzon.gfl.managers.classes.CursorManagerImpl;

/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.11.13
 *	@Modify
 *	@Description
 * 	@includeExample		CursorManagerSample.as
 */
public class CursorManager
{
	/**
	 *	@Constructor
	 */
	public function CursorManager() {
		throw new Error("CursorManager is not allowed instnacing!");
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
	 *	커서를 제거한다.
	 */
	public static function removeCursor():void {
		CursorManagerImpl.getInstance().removeCursor();
	}
	
	/**
	 *	바쁨 상태 커서를 제거한다.
	 */
	public static function removeBusyCursor():void {
		CursorManagerImpl.getInstance().removeBusyCursor();
	}
	
	/**
	 *	커서를 바쁨 상태로 설정한다.
	 */
	public static function setBusyCursor():void {
		CursorManagerImpl.getInstance().setBusyCursor();
	}
	
	/**
	 *	커서를 설정한다.
	 */
	public static function setCursor(cursorClass:Class, xOffset:Number=0, yOffset:Number=0):void {
		CursorManagerImpl.getInstance().setCursor(cursorClass, xOffset, yOffset);
	}
}

}