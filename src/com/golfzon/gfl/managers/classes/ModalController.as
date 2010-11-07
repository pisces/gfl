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

import flash.display.DisplayObject;

import gs.TweenMax;

/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.11.06
 *	@Modify
 *	@Description
 */
public class ModalController implements IModalController
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	private var modalMode:Boolean;
	
	private var target:DisplayObject;
	
	/**
	 *	@Constructor
	 */
	public function ModalController() {
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
	 *	Modal 효과를 적용받을 대상
	 */
	public function setTarget(target:DisplayObject):void {
		this.target = target;
	}
	
	/**
	 *	Modal 설정
	 */
	public function setModal():void {
		if( target ) {
			modalMode = true;
			TweenMax.to(target, duration/1000, {alpha:0.3});
		}
	}
	
	/**
	 *	Modal 해제
	 */
	public function removeModal():void {
		if( target ) {
			modalMode = false;
			TweenMax.to(target, duration/1000, {alpha:1});
		}
	}
	
	/**
	 *	Modal 상태인지 아닌지에 대한 부울값
	 */
	public function isModal():Boolean {
		return modalMode;
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//  duration
	//--------------------------------------
	
	private var _duration:uint = 300;
	
	public function get duration():uint {
		return _duration;
	}
	
	public function set duration(value:uint):void {
		if( value == _duration )
			return;
			
		_duration = value;
	}
}

}