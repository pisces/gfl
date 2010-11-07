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

package com.golfzon.gfl.utils
{
	
/**
 *	@Author				KHKim
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.08.20
 *	@Modify
 *	@Description
 */
public function getRandomString(source:String):String {
	var suffix:String = source.indexOf("?") > -1 ? "&" : "?";
	return source + suffix + "random=" + Math.random().toString();
}
	
}