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

import flash.utils.Dictionary;
import flash.utils.Proxy;
import flash.utils.flash_proxy;

/**
 *	@Author				KHKim
 *	@Version			1.0
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.05.11
 *	@Modify
 *	@Description
 */
public class Hashtable extends Proxy
{
	//--------------------------------------------------------------------------
	//
	//  Instance variables
	//
	//--------------------------------------------------------------------------

	private var _map:Dictionary;
	private var _count:uint;
 
	/**
	 *	@Constructor
	 */
	public function Hashtable() {
		_count = 0;
		_map = new Dictionary(true);
	}
 
	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Overriden : Proxy
	//--------------------------------------------------------------------------
   
	flash_proxy override function getProperty(name:*):* {
		return _map[name];
	}
 
	//--------------------------------------------------------------------------
	//  Public
	//--------------------------------------------------------------------------
   
	/**
	 *	Gain the value by key.
	 */
	public function getValue(key:*):* {
		return _map[key];
	}
 
	/**
	 *	Wheather map has item about key.
	 */
	public function contains(key:*):Boolean {
		return _map[key] != null;
	}

	/**
	 *	Add item into map.
	 */
	public function add(key:*, value:*):void {
		if( contains(key) )
			return;
	 
		_map[key] = value;
		_count++;
	}
 
	/**
	 *	Remove item from map.
	 */
	public function remove(key:*):void {
		if( contains(key) ) {
			_map[key] = null;
			delete _map[key];
			_count--;
		}
	}

	//--------------------------------------------------------------------------
	//
	//	getter/setter
	//
	//--------------------------------------------------------------------------

	//--------------------------------------
	//	count
	//--------------------------------------
   
	/**
	 *	Gain the count for items.
	 */
	public function get count():uint {
		return _count;
	}
 
	//--------------------------------------
	//  map
	//--------------------------------------
   
	/**
	 *	Get the map.
	 */
	public function get map():Dictionary {
		return _map;
	}
}

}
