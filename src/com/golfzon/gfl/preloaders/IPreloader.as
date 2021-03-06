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

package com.golfzon.gfl.preloaders
{

import com.golfzon.gfl.core.IComponent;

/**
 *	@Author				KHKim
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.10.20
 *	@Modify
 *	@Description
 */
public interface IPreloader extends IComponent
{
	function setCSSFileProgress(currentValue:Number, totalValue:Number):void;
	function setProgress(currentValue:Number, totalValue:Number):void;
}

}