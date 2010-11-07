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
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.09.24
 *	@Modify
 *	@Description
 */
public class ScrollEvent extends Event
{
    //--------------------------------------------------------------------------
	//
	//	Class constants
	//
    //--------------------------------------------------------------------------
	
	public static const SCROLL:String = "scroll";
	
	/**
	 *	@Constructor
	 */
	public function ScrollEvent(
		type:String, bubbles:Boolean=false, cancelable:Boolean=false,
		detail:String=null, position:Number=NaN, direction:String=null, delta:Number=NaN) {
		super(type, bubbles, cancelable);
		
		_detail = detail;
		_delta = delta;
		_direction = direction;
		_position = position;
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
     *	ScrollEvent의 복사본을 생성해 반환한다.
     */
    override public function clone():Event {
    	return new ScrollEvent(
    		type, bubbles, cancelable, detail, position, direction, delta);
    }

    //--------------------------------------------------------------------------
	//
	//	getter / setter
	//
    //--------------------------------------------------------------------------
	
	//--------------------------------------
	//  detail
	//--------------------------------------
	
	private var _detail:String;
	
	public function get detail():String {
		return _detail;
	}
	
	//--------------------------------------
	//  delta
	//--------------------------------------
	
	private var _delta:Number;
	
	public function get delta():Number {
		return _delta;
	}
	
	//--------------------------------------
	//  direction
	//--------------------------------------
	
	private var _direction:String;
	
	public function get direction():String {
		return _direction;
	}
	
	//--------------------------------------
	//  position
	//--------------------------------------
	
	private var _position:Number;
	
	public function get position():Number {
		return _position;
	}
}

}