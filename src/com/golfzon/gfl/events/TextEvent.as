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
import flash.text.TextFormat;

/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.08.25
 *	@Modify
 *	@Description
 */
public class TextEvent extends Event
{
    //--------------------------------------------------------------------------
	//
	//	Class constants
	//
    //--------------------------------------------------------------------------
	
	/**
	 *	텍스트 필드의 텍스트포멧이 변경되었을 때 발생되는 이벤트 타입
	 */
	public static const TEXT_FORMAT_CHANGED:String = "textFormatChanged";
	
	/**
	 *	@Constructor
	 */
	public function TextEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
		super(type, bubbles, cancelable);
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
     *	TextEvent의 복사본을 생성해 반환한다.
     */
    override public function clone():Event {
    	return new TextEvent(type, bubbles, cancelable);
    }
}

}