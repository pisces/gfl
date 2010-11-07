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
 *	@Author				KHKim
 *	@Version			1.0
 *	@Lanaguage			Action Script 3.0
 *	@Date				2010.03.16
 *	@Modify
 *	@Description
 */
public class VideoPlayState
{
	//--------------------------------------------------------------------------
	//
	//	Class constants
	//
	//--------------------------------------------------------------------------
	
	public static const PAUSE:String = "pause";
	public static const PLAY:String = "play";
	public static const STOP:String = "stop";
	
	/**
	 *	@Constructor
	 */
	public function VideoPlayState() {
		throw new Error("Error: Instantiation failed: This class not allowed instacing.");
	}
}

}