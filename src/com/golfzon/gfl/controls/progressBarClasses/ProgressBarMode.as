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

package com.golfzon.gfl.controls.progressBarClasses
{
	
/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.08.18
 *	@Modify
 *	@Description
 */
public class ProgressBarMode
{
    //--------------------------------------------------------------------------
	//
	//	Class constants
	//
    //--------------------------------------------------------------------------
	
	public static const MANUAL:String = "manual";
	public static const POLLED:String = "polled";
	
	/**
	 *	@Constructor
	 */
	public function ProgressBarMode() {
		throw new Error("Error: Instantiation failed: This class not allowed instacing.");
	}
}

}