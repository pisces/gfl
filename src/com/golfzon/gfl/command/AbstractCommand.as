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

package com.golfzon.gfl.command
{

import flash.utils.getQualifiedClassName;

/**
 *	@Author				KHKim
 *	@Version			1.0
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.03.07
 *	@Modify
 *	@Description
 */
public class AbstractCommand implements ICommand
{
	//--------------------------------------------------------------------------
	//
	//  Instance variables
	//
	//--------------------------------------------------------------------------

	/**
	 *	Prameters for instancing the command class.
	 */
	protected var parameters:Object;
	
	/**
	 *	Receiver object.
	 */
	protected var receiver:IReceiver;
	
	/**
	 *	@Constructor
	 */
	public function AbstractCommand(receiver:IReceiver, parameters:Object=null) {
		this.receiver = receiver;
		this.parameters = parameters;
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
	 *	TODO : 실행시킬 기능을 구현한다.
	 */
	public function execute():void {
	}
	
	/**
	 *	TODO : 다시실행을 구현한다.
	 */
	public function redo():void {
	}
	
	/**
	 *	TODO : 실행취소를 구현한다.
	 */
	public function undo():void {
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter/setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//  name
	//--------------------------------------
	
	/**
	 *	Gain the class name.
	 */
	public function get name():String {
		return getQualifiedClassName(this).split("::")[1];
	}
}

}