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
	
import com.golfzon.gfl.core.ApplicationBase;
import com.golfzon.gfl.core.gz_internal;
import com.golfzon.gfl.nullObject.Null;
import com.golfzon.gfl.nullObject.NullSystemManager;

import flash.display.MovieClip;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

use namespace gz_internal;

/**
 *	@Author				KHKim
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.09.24
 *	@Modify
 *	@Description
 */
public class SystemManager extends MovieClip implements Null
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	public var cssInitialized:Boolean = true;
	
	/**
	 *	@Constructor
	 */
	public function SystemManager() {
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//	Class methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	새로운 Null 객체를 생성하여 반환한다.
	 */
	public static function newNull():NullSystemManager {
		return new NullSystemManager();
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
	 *	초기화
	 */
	public function initialize():void {
		if( !hasEventListener(Event.ADDED_TO_STAGE) )
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);
	}
	
	/**
	 *	객체가 Null 객체인지에 대한 부울값
	 */
	public function isNull():Boolean {
		return false;
	}
	
	//--------------------------------------------------------------------------
	//
	//	Event handlers
	//
	//--------------------------------------------------------------------------
	
	private function addedToStageHandler(event:Event):void {
		setStage();
	}
	
	private function resizeHandler(event:Event):void {
		if( ApplicationBase.application ) {
			ApplicationBase.application.setActualSize(stage.stageWidth, stage.stageHeight);
			ApplicationBase.application.invalidateDisplayList();
		}
		alignPreloader();
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	private function alignPreloader():void {
		var app:ApplicationBase = ApplicationBase.application;
		if( app.preloaderInstance ) {
			app.preloaderInstance.x = Math.floor((stage.stageWidth - app.preloaderInstance.width) / 2);
			app.preloaderInstance.y = Math.floor((stage.stageHeight - app.preloaderInstance.height) / 2);
		}
	}
	
	private function setStage():void {
		if( stage ) {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, resizeHandler, false, 0, true);
			ApplicationBase.application.setActualSize(stage.stageWidth, stage.stageHeight);
			alignPreloader();
		}
	}
}

}