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

package com.golfzon.gfl.collection
{

/**
 *	@Author				KHKim
 *	@Version			1.0
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.05.06
 *	@Modify
 *	@Description
 */
public class ArrayListIterator implements Iterator
{
	//--------------------------------------------------------------------------
	//
	//  Instance variables
	//
	//--------------------------------------------------------------------------

	private var index:int;
	
	private var arrayList:ICollection;
	
	/**
	 *	@Constructor
	 */
	public function ArrayListIterator(arrayList:ArrayList) {
		this.arrayList = arrayList;
		this.index = 0;
	}
	
	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Public
	//--------------------------------------------------------------------------
	
	public function hasNext():Boolean {
		if( index >= arrayList.length )
			return false;
		return true;
	}
	
	public function next():* {
		return arrayList.getItemAt(index++);
	}
	
	public function hasPrev():Boolean {
		if( index <=0 )
			return false;
		return true;
	}
	
	public function prev():* {
		return arrayList.getItemAt(index--);
	}
	
	public function reset():void {
		gotoFirst();
	}
	
	public function gotoFirst():void {
		index = 0 ;
	}
	
	public function gotoEnd():void {
		index = arrayList.length - 1;
	}
}

}