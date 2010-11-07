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

package com.golfzon.gfl.video.controllerClasses
{
	
import com.golfzon.gfl.core.gz_internal;

use namespace gz_internal;

/**
 *	@Author				rrobbie
 *	@Version			1.0
 *	@Lanaguage			Action Script 3.0
 *	@Date				2010.08.31
 *	@Modify				
 *	@Description
 */
public class StreamingVideoSeekBar extends VideoSeekBar
{
	/**
	 *	@Constructor
	 */
	public function StreamingVideoSeekBar() {
		super();
	}
	
	override protected function createChildren():void {
		super.createChildren();
		
		highlight.width = 0;
	}
	
	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Overriden : SliderBase
	//--------------------------------------------------------------------------
	
	/**
	 * 	디스플레이 변경 사항에 대한 처리
	 */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		if( _xChange )
			return;
		
		super.updateDisplayList(unscaledWidth, unscaledHeight);		

		if( thumb.x == 0 )
			thumb.x = track.x;
	}
	
	//--------------------------------------------------------------------------
	//  Public
	//--------------------------------------------------------------------------
	
	/**
	 * 	HTTP_Streaming 방식은 Download방식과는 달리 진행율이 불필요하다고 판단. 초기 크기만 표시하고 갱신하지 않는다.
	 */
	override public function setProgress(current:Number, total:Number):void {
		if( loadProgressBar ) {
			loadProgressBar.width = track.width;
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	private var _xChange:Boolean;
	
	public function set xChange(value:Boolean):void{
		_xChange = value;
	}
	
}
	
}