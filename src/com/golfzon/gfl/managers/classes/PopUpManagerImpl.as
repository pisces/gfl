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

import com.golfzon.gfl.collection.ArrayList;
import com.golfzon.gfl.core.ApplicationBase;
import com.golfzon.gfl.core.ComponentBase;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Stage;
import flash.events.Event;

/**
 *	@Author				KHKim
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.11.13
 *	@Modify
 *	@Description
 */
public class PopUpManagerImpl
{
	//--------------------------------------------------------------------------
	//
	//	Class variables
	//
	//--------------------------------------------------------------------------
	
	private static var allowInstancing:Boolean;
	
	private static var uniqueInstance:PopUpManagerImpl;
	
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	public var modalController:IModalController = new ModalController();
	
	private var modalList:ArrayList = new ArrayList();
	
	private var popUpHolder:DisplayObjectContainer;
	
	private var stage:Stage;
	
	/**
	 *	@Constructor
	 */
	public function PopUpManagerImpl() {
		if( !allowInstancing )
			throw new Error("PopUpManagerImpl is not allowed instnacing!");
			
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
	public static function getInstance():PopUpManagerImpl {
		if( !uniqueInstance ) {
			allowInstancing = true;
			uniqueInstance = new PopUpManagerImpl();
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
	 *	팝업 인스턴스를 스테이지에 추가한다.
	 */
	public function addPopUp(popUp:DisplayObject, modal:Boolean=false):DisplayObject {
		return _addPopUp(popUp, modal);
	}
	
	/**
	 *	팝업 인스턴스의 인덱스를 최상위로 올린다.
	 */
	public function bringToFront(popUp:DisplayObject):void {
		if( popUp && popUpHolder.contains(popUp) )
			popUpHolder.setChildIndex(popUp, popUpHolder.numChildren - 1);
	}
	
	/**
	 *	팝업 인스턴스가 존재하는지에 대한 부울값
	 */
	public function contains(popUp:DisplayObject):Boolean {
		if( !popUpHolder )	return false;
		return popUpHolder.contains(popUp);
	}
	
	/**
	 *	입력받은 클래스 정의로 새로운 팝업을 생성한 후 스테이지에 추가한다.
	 */
	public function createPopUp(definition:Class, modal:Boolean=false):DisplayObject {
		var popUp:DisplayObject = DisplayObject(new definition());
		return _addPopUp(popUp, modal);
	}
	
	/**
	 *	팝업 인스턴스를 정중앙으로 정렬한다.
	 */
	public function centerPopUp(popUp:DisplayObject):void {
		popUp.x = Math.floor((popUpHolder.width - popUp.width) / 2);
		popUp.y = Math.floor((popUpHolder.height - popUp.height) / 2);
	}
	
	/**
	 *	팝업 인스턴스를 삭제한다.
	 */
	public function removePopUp(popUp:DisplayObject):void {
		if( popUp && popUpHolder.contains(popUp) )
			popUpHolder.removeChild(popUp);
			
		if( modalList.contains(popUp) )
			modalList.remove(popUp);
			
		if( modalController.isModal() && modalList.length < 1 ) {
			ApplicationBase.application.mouseChildren = ApplicationBase.application.mouseEnabled = true;
			modalController.removeModal();
		}
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	private function _addPopUp(popUp:DisplayObject, modal:Boolean=false):DisplayObject {
		createPopUpHolder();
		
		if( popUp && !popUpHolder.contains(popUp) )
			popUpHolder.addChild(popUp);
			
		if( modal ) {
			if( !modalList.contains(popUp) )
				modalList.add(popUp);
			
			ApplicationBase.application.mouseChildren = ApplicationBase.application.mouseEnabled = false;
			modalController.setTarget(ApplicationBase.application);
			modalController.setModal();
		}
		return popUp;
	}
	
	private function createPopUpHolder():void {
		if( popUpHolder && stage.contains(popUpHolder) ) {
			stage.setChildIndex(popUpHolder, stage.numChildren - 1);
		} else {
			popUpHolder = new ComponentBase();
			stage.addEventListener(Event.RESIZE, stage_resizeHandler, false, 0, true);
			stage.addChild(popUpHolder);
		}
		
		popUpHolder.width = ApplicationBase.application.width;
		popUpHolder.height = ApplicationBase.application.height;
	}
	
	private function stage_resizeHandler(event:Event):void {
		popUpHolder.width = ApplicationBase.application.width;
		popUpHolder.height = ApplicationBase.application.height;
	}
}

}