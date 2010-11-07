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
/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.09.17
 *	@Modify
 *	@Description
 */
public class EdgeMetrics
{
	/**
	 *	@Constructor
	 */
	public function EdgeMetrics(left:Number=0, top:Number=0, right:Number=0, bottom:Number=0) {
		this.left = left;
		this.top = top;
		this.right = right;
		this.bottom = bottom;
	}

	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//	left
	//--------------------------------------
	
	private var _left:Number;
	
	public function get left():Number {
		return _left;
	}
	
	public function set left(value:Number):void {
		_left = value;
	}
	
	//--------------------------------------
	//	top
	//--------------------------------------
	
	private var _top:Number;
	
	public function get top():Number {
		return _top;
	}
	
	public function set top(value:Number):void {
		_top = value;
	}
	
	//--------------------------------------
	//	right
	//--------------------------------------
	
	private var _right:Number;
	
	public function get right():Number {
		return _right;
	}
	
	public function set right(value:Number):void {
		_right = value;
	}
	
	//--------------------------------------
	//	bottom
	//--------------------------------------
	
	private var _bottom:Number;
	
	public function get bottom():Number {
		return _bottom;
	}
	
	public function set bottom(value:Number):void {
		_bottom = value;
	}
}

}