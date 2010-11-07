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

package com.golfzon.gfl.controls.listClasses
{
	
import com.golfzon.gfl.core.IDataItemRenderer;
import com.golfzon.gfl.core.IDisplayObject;

import flash.events.IEventDispatcher;

/**
 *	@Author				KHKim
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.09.29
 *	@Modify
 *	@Description
 */
public interface IListItemRenderer extends IDataItemRenderer, IDisplayObject, IEventDispatcher
{
	function get listData():BaseListData;
	function set listData(value:BaseListData):void;
}

}