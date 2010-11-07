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
 *	@Version			1.0
 *	@Lanaguage			Action Script 3.0
 *	@Date				2010. 4. 13.
 *	@Modify
 *	@Description
 */
public class VideoEvent extends Event
{
	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------
	
	public static const PAUSE:String = "pause";
	public static const PLAY:String = "play";
	public static const SEEK:String = "seek";
	public static const STOP:String = "stop";
	public static const SUCCESS:String = "success";
	public static const VOLUME_CHANGE:String = "volumeChange";
	public static const NOT_FOUND:String = "notFound";
	
	//--------------------------------------------------------------------------
	//
	//  Class variables
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//
	//  Instance constants
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//
	//  Instance variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	@Constructor
	 */
	public function VideoEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
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
	 *	VideoEvent의 복사본을 생성해 반환한다.
	 */
	override public function clone():Event {
		return new VideoEvent(type, bubbles, cancelable);
	}
}
	
}