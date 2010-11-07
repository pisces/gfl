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

package com.golfzon.gfl.chart.grid
{

import com.golfzon.gfl.core.ComponentBase;

import flash.display.Sprite;

/**
 *	@Author				SH Jung
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.11.30
 *	@Modify
 *	@Description
 */
public class Grid extends ComponentBase
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	@Constructor
	 */
	public function Grid() {
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Overriden : ComponentBase
	//--------------------------------------------------------------------------
	
	/**
	 * 	디스플레이 변경 사항에 대한 처리
	 */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		drawGrid();
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	/**
	 *  그리드 그리기
	 */
	protected function drawGrid():void {
		var index:Number;
		
		// 초기화
		while( numChildren > 0 ) {
			removeChildAt(0);
		}
		
		// x그리드 라인
		for( index = _xValue; index <= unscaledWidth; index = index + _xValue ) {
			var xGrid:Sprite = new Sprite();
			xGrid.graphics.beginFill(color);
			xGrid.graphics.drawRect(index, 0, 1, unscaledHeight);
			xGrid.graphics.endFill();
			addChild(xGrid);
		}
		
		// y그리드 라인
		for( index = 0; index < unscaledHeight; index = index + _yValue ) {
			var yGrid:Sprite = new Sprite();
			yGrid.graphics.beginFill(color);
			yGrid.graphics.drawRect(0, index, unscaledWidth, 1);
			yGrid.graphics.endFill();
			addChild(yGrid);
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//	color
	//--------------------------------------
	
	private var _color:uint;
	
	public function get color():uint {
		return _color;
	}
	
	public function set color(color:uint):void {
		if( _color == color )
			return;
		
		_color = color;
	}
	
	//--------------------------------------
	//	xValue
	//--------------------------------------
	
	private var _xValue:Number;
	
	public function get xValue():Number {
		return _xValue;
	}
	
	public function set xValue(value:Number):void {
		if( _xValue == value )
			return;
		
		_xValue = value;
	}
	
	//--------------------------------------
	//	yValue
	//--------------------------------------
	
	private var _yValue:Number;
	
	public function get yValue():Number {
		return _yValue;
	}
	
	public function set yValue(value:Number):void {
		if( _yValue == value )
			return;
		
		_yValue = value;
	}
}

}