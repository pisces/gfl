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

import com.golfzon.gfl.managers.classes.IModalController;
import com.golfzon.gfl.managers.classes.PopUpManagerImpl;

import flash.display.DisplayObject;

/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.11.06
 *	@Modify
 *	@Description
 * 	@includeExample		PopUpManagerSample.as
 */
public class PopUpManager
{
	/**
	 *	@Constructor
	 */
	public function PopUpManager() {
		throw new Error("PopUpManager is not allowed instnacing!");
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
	 *	팝업 인스턴스를 스테이지에 추가한다.
	 */
	public static function addPopUp(popUp:DisplayObject, modal:Boolean=false):DisplayObject {
		return PopUpManagerImpl.getInstance().addPopUp(popUp, modal);
	}
	
	/**
	 *	팝업 인스턴스의 인덱스를 최상위로 올린다.
	 */
	public static function bringToFront(popUp:DisplayObject):void {
		PopUpManagerImpl.getInstance().bringToFront(popUp);
	}
	
	/**
	 *	입력받은 클래스 정의로 새로운 팝업을 생성한 후 스테이지에 추가한다.
	 */
	public static function createPopUp(definition:Class, modal:Boolean=false):DisplayObject {
		return PopUpManagerImpl.getInstance().createPopUp(definition, modal);
	}
	
	/**
	 *	팝업 인스턴스를 정중앙으로 정렬한다.
	 */
	public static function centerPopUp(popUp:DisplayObject):void {
		PopUpManagerImpl.getInstance().centerPopUp(popUp);
	}
	
	/**
	 *	팝업 인스턴스를 삭제한다.
	 */
	public static function removePopUp(popUp:DisplayObject):void {
		PopUpManagerImpl.getInstance().removePopUp(popUp);
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//	modalController
	//--------------------------------------
	
	public static function get modalController():IModalController {
		return PopUpManagerImpl.getInstance().modalController;
	}
	
	public static function set modalController(value:IModalController):void {
		PopUpManagerImpl.getInstance().modalController = value;
	}
}

}