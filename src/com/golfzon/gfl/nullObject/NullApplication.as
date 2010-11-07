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

package com.golfzon.gfl.nullObject
{
	
import com.golfzon.gfl.core.ApplicationBase;

import flash.display.Stage;
import flash.events.Event;

/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.12.14
 *	@Modify
 *	@Description		Null Object
 */
public class NullApplication extends ApplicationBase
{
	/**
	 *	@Constructor
	 */
	public function NullApplication() {
	}
	
	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Overriden : ApplicationBase
	//--------------------------------------------------------------------------
	
	/**
	 * 	초기화
	 */
	override public function initialize():void {
	}
	
	override public function isNull():Boolean {
		return true;
	}
	
	/**
	 * 	초기화
	 */
	override protected function createChildren():void {
	}
	
	override protected function commitProperties():void {	
	}
	
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
	}
	
	override protected function measure():void {
	}
	
	/**
	 *	@private
	 */
	override protected function addedToStageHandler(event:Event):void {
	}
	
	//--------------------------------------
	//	css
	//--------------------------------------
	
	override public function get css():String {
		return null;
	}
	
	override public function set css(value:String):void {
	}
	
	//--------------------------------------
	//	preloader
	//--------------------------------------
	
	override public function get preloader():Class {
		return null;
	}
	
	override public function set preloader(value:Class):void {
	}
	
	//--------------------------------------
	//	parameters
	//--------------------------------------
	
	override public function get parameters():Object {
		return null;
	}
	
	//--------------------------------------
	//	url
	//--------------------------------------
	
	override public function get url():String {
		return null;
	}
	
	override public function get stage():Stage {
		return root.stage;
	}
}

}