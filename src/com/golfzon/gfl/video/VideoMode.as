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

package com.golfzon.gfl.video
{
	
/**
 *	@Author				rrobbie
 *	@Version			1.0
 *	@Lanaguage			Action Script 3.0
 *	@Date				2010.08.10
 *	@Modify
 *	@Description
 */
public class VideoMode
{
	//--------------------------------------------------------------------------
	//
	//	Class constants
	//
	//--------------------------------------------------------------------------
	
	public static const DOWNLOAD:Number = 0;
	public static const HTTP_STREAMING:Number = 1;
	public static const RTMP_STREAMING:Number = 2;
	
	/**
	 *	@Constructor
	 */
	public function VideoMode() {
		throw new Error("Error: Instantiation failed: This class not allowed instacing.");
	}
}

}