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

package com.golfzon.gfl.core
{
	
import com.golfzon.gfl.managers.SystemManager;
	
/**
 *	@Author				KHKim
 *	@Version			1.0
 *	@Lanaguage			Action Script 3.0
 *	@Date				2010.03.11
 *	@Modify
 *	@Description
 */
public interface ISystemManagerClient
{
	function get systemManager():SystemManager;
	function set systemManager(value:SystemManager):void;
}

}