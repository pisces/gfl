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

import flash.display.Stage;

/**
 *	@Author				KHKim
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.12.13
 *	@Modify
 *	@Description
 */
public class ComponentGlobal
{
	//--------------------------------------------------------------------------
	//
	//	Class variables
	//
	//--------------------------------------------------------------------------
	
	public static var stage:Stage;
	
	/**
	 *	@Constructor
	 */
	public function ComponentGlobal() {
		throw new Error("ComponentGlobal is not allowed instnacing!");
	}
}

}