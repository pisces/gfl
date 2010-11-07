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
public class ArrayList implements ICollection
{
	//--------------------------------------------------------------------------
	//
	//  Instance variables
	//
	//--------------------------------------------------------------------------

	private var list:Array = [];

	/**
	 *	@Constructor
	 */
	public function ArrayList(list:Array=null) {
		clear();
		
		if( list )
			this.list = list;
	}
	
	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Public
	//--------------------------------------------------------------------------
	
	public function add(item:*):Boolean {
		return Boolean(list.push(item));
	}
	
	public function addAt(item:*, index:int):Boolean {
		var end:int = list.length;
		for( var i:int=end; i>index; i-- ) {
			list[i] = list[i - 1];
		}
		return Boolean(list[index] = item);
	}
	
	public function attach(list:ArrayList):void {
		if( !list )	return;
		
		var itr:Iterator = list.iterator;
		while( itr.hasNext() ) {
			var item:Object = itr.next();
			this.list.push(item);
		}
	}
	
	public function remove(item:*):Boolean {
		if( !contains(item) )	return false;
		
		var index:int = getItemIndex(item);
		list.splice(index, 1);
		return true;
	}
	
	public function contains(item:*):Boolean {
		return getItemIndex(item) >= 0;
	}
	
	public function copy():ArrayList {
		return new ArrayList(list);
	}
	
	public function clear():void {
		for( var i:int; i<length; i++ ) {
			remove(list[i]);
		}
		list = [];
	}
	
	public function getItemAt(index:int):* {
		return list[index]
	}
	
	public function getItemIndex(item:*):int {
		for( var i:int = length - 1; i >= 0; i-- ) {
			if( getItemAt(i) == item )
				return i;
		}
		return -1;
	}
	
	public function changeItem(origine:*, newOne:*):void {
		var index:int = getItemIndex(origine);
		list[index] = newOne;
	}
	
	public function swapItem(o1:*, o2:*):ArrayList {
		var i1:int = getItemIndex(o1);
		var i2:int = getItemIndex(o2);
		list[i1] = o2;
		list[i2] = o1;
		
		return new ArrayList(list);
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	public function get iterator():Iterator {
		return new ArrayListIterator(this);
	}
	
	//--------------------------------------
	//  length
	//--------------------------------------
	
	public function get length():int {
		return list.length;
	}
	
	//--------------------------------------
	//  isEmpty
	//--------------------------------------
	
	public function get isEmpty():Boolean {
		return length == 0;
	}
	
	//--------------------------------------
	//  source
	//--------------------------------------
	
	public function get source():Array {
		return list;
	}
	
	public function set source(list:Array):void {
		list = list;
	}
}

}