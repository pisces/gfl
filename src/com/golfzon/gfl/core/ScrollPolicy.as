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
	
/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.09.24
 *	@Modify
 *	@Description
 */
public class ScrollPolicy
{
    //--------------------------------------------------------------------------
	//
	//	Class constants
	//
    //--------------------------------------------------------------------------
	
	public static const AUTO:String = "auto";
	public static const OFF:String = "off";
	public static const ON:String = "on";
	
	/**
	 *	@Constructor
	 */
	public function ScrollPolicy() {
		throw new Error("Error: Instantiation failed: This class not allowed instacing.");
	}
}

}