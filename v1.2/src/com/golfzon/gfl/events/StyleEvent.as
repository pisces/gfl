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

package com.golfzon.gfl.events
{
	
import flash.events.Event;

/**
 *	@Author				KHKim
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.10.04
 *	@Modify
 *	@Description
 */
public class StyleEvent extends Event
{
	//--------------------------------------------------------------------------
	//
	//	Class constants
	//
	//--------------------------------------------------------------------------
	
	public static const REGISTER_INSTANCE:String = "registerInstane";
	public static const STYLE_CHANGED:String = "styleChanged";
	
	/**
	 *	@Constructor
	 */
	public function StyleEvent(type:String, styleProp:String=null, value:*=null, bubbles:Boolean=false, cancelable:Boolean=false) {
		super(type, bubbles, cancelable);
		
		_styleProp = styleProp;
		_value = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Overriden : Event
	//--------------------------------------------------------------------------
	
	/**
	 *	StyleEvent의 복사본을 생성해 반환한다.
	 */
	override public function clone():Event {
		return new StyleEvent(type, styleProp, value, bubbles, cancelable);
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
   
	//--------------------------------------
	//	styleProp
	//--------------------------------------
	
	private var _styleProp:String;
	
	public function get styleProp():String {
		return _styleProp;
	}
   
	//--------------------------------------
	//	value
	//--------------------------------------
	
	private var _value:*;
	
	public function get value():* {
		return _value;
	}
}

}