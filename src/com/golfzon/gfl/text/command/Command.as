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

package com.golfzon.gfl.text.command
{

import flash.events.EventDispatcher;

import pcl.command.ICommand;

/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.10.22
 *	@Modify
 *	@Description
 */
public class Command extends EventDispatcher implements ICommand
{
	/**
	 *	@Construcotr
	 */
	public function Command() {
	}
	
    //--------------------------------------------------------------------------
	//
	//	Instance methods
	//
    //--------------------------------------------------------------------------
    
	/**
	 *	TODO : 커맨드 실행을 구현한다.
	 */
	public function execute():void {
	}
	
	/**
	 *	TODO : undo 기능 구현
	 */
	public function undo():void {
	}
	
	/**
	 *	TODO : redo 기능 구현
	 */
	public function redo():void {
	}
	
    //--------------------------------------------------------------------------
	//
	//	getter / setter
	//
    //--------------------------------------------------------------------------
	
	//--------------------------------------
	//  name
	//--------------------------------------
	
	private var _name:String;
	
	public function get name():String {
		return _name;
	}
	
	public function set name(value:String):void {
		_name = value;
	}
}

}