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
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.09.29
 *	@Modify
 *	@Description
 */
public interface IListItemRenderer extends IDataItemRenderer, IDisplayObject, IEventDispatcher
{
	function get listOwner():ListBase;
	function set listOwner(value:ListBase):void;
}

}