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
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.10.01
 *	@Modify
 *	@Description
 */
public class ArrayUtil
{
	/**
	 *	@Constructor
	 * 	Does not allowed to construct a instance.
	 */
	public function ArrayUtil() {
	   throw new Error("Error: Instantiation failed: This class cannot instancing!");
	}

	//--------------------------------------------------------------------------
	//
	//	Class methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Public
	//--------------------------------------------------------------------------
	
	/**
	 *	배열에서 아이템의 인덱스를 반환한다.
	 */
	public static function getItemIndex(item:Object, array:Array):int {
		if( !item || !array )	return -1;
		
		var i:int = 0;
		while( i < array.length ) {
			if( array[i] === item )
				return i;
			i++;
		}
		return -1;
	}
}

}