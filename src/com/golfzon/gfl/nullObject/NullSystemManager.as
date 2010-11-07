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

import com.golfzon.gfl.managers.SystemManager;

import flash.display.Stage;
	
/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.10.17
 *	@Modify
 *	@Description		Null Object
 */
public class NullSystemManager extends SystemManager
{
	/**
	 *	@Constructor
	 */
	public function NullSystemManager() {
	}

    //--------------------------------------------------------------------------
	//
	//	Instance methods
	//
    //--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------
    //  Overriden : SystemManager
    //--------------------------------------------------------------------------
    
    /**
     *	초기화
     */
    override public function initialize():void {
    }
    
    /**
     *	객체가 Null 객체인지에 대한 부울값
     */
    override public function isNull():Boolean {
    	return true;
    }
}

}