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

package com.golfzon.gfl.chart.axis
{

import com.golfzon.gfl.controls.Label;

import flash.display.DisplayObject;
import flash.display.Sprite;

/**
 *	@Author				SH Jung
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.11.30
 *	@Modify
 *	@Description
 */
public class CountAxis extends AxisBase
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	@Constructor
	 */
	public function CountAxis() {
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Overriden : IAxis
	//--------------------------------------------------------------------------

	/**
	 *  컬럼의 길이(width or height)를 반환
	 */
	override public function getColumnSize():Number {
		var columnSize:Number;
		if( type == AxisBase.AXIS_TYPE_HORIZONTAL )		columnSize = (unscaledWidth - 1) / stepSize;
		else if( type == AxisBase.AXIS_TYPE_VERTICAL )	columnSize = (unscaledHeight - 1) / stepSize;
		return columnSize;
	}
	
	/**
	 *  value위 좌표값을 반환
	 */
	override public function getValuePoint(value:String):Number {
		var point:Number = Number(value);
		if( point > maximum || point < minimum )
			return 0;
		
		var dotPitch:Number;
		if( type == AxisBase.AXIS_TYPE_HORIZONTAL )		dotPitch = unscaledWidth / (maximum - minimum);
		else if( type == AxisBase.AXIS_TYPE_VERTICAL )	dotPitch = unscaledHeight / (maximum - minimum);
		
		point = (point - minimum) * dotPitch;
		return point;
	}
	
	//--------------------------------------------------------------------------
	//  Overriden : AxisBase
	//--------------------------------------------------------------------------
	
	/**
	 *  축을 그린다
	 */
	override protected function drawAxis():void {
		super.drawAxis();
		if( axisSkin ) {
			drawSkin();
		} else {
			drawLine();
			drawGuide();
		}
	}
	
	/**
	 *  스킨 그리기
	 */
	override protected function drawSkin():void {
		var skin:DisplayObject = createSkinBy(axisSkin);
		if( type == AxisBase.AXIS_TYPE_HORIZONTAL )		skin.x = 1;
		else if( type == AxisBase.AXIS_TYPE_VERTICAL )	skin.x = skin.width * -1 + 1;
		addChild(skin);
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	/**
	 *  1/2 포인트 생성
	 */
	private function createHalfPoint():Sprite {
		var halfPoint:Sprite = new Sprite();
		halfPoint.graphics.clear();
		halfPoint.graphics.beginFill(lineColor);
		if( type == AxisBase.AXIS_TYPE_HORIZONTAL )		halfPoint.graphics.drawRect(0, 2, 1, 2);
		else if( type == AxisBase.AXIS_TYPE_VERTICAL )	halfPoint.graphics.drawRect(-4, 0, 2, 1);
		halfPoint.graphics.endFill();
		return halfPoint;
	}
	
	/**
	 *  포인트 생성
	 */
	private function createPoint():Sprite {
		var point:Sprite = new Sprite();
		point.graphics.clear();
		point.graphics.beginFill(lineColor);
		if( type == AxisBase.AXIS_TYPE_HORIZONTAL )		point.graphics.drawRect(0, 0, 1, 5);
		else if( type == AxisBase.AXIS_TYPE_VERTICAL )	point.graphics.drawRect(-5, 0, 5, 1);
		point.graphics.endFill();
		return point;
	}
	
	/**
	 *  가이드 그리기
	 */
	private function drawGuide():void {
		if( stepSize == 0 )
			return;
		
		var countGap:Number = getColumnSize();
		var valueGap:Number = (maximum - minimum) / stepSize;
		
		for( var index:uint = 0; index <= stepSize; index++ ) {
			// point 그리기
			var point:Sprite = createPoint();
			if( type == AxisBase.AXIS_TYPE_HORIZONTAL )		point.x = countGap * index;
			else if( type == AxisBase.AXIS_TYPE_VERTICAL )	point.y = countGap * (stepSize - index);
			addChild(point);
			
			// label 그리기
			var label:Label = new Label();
			label.mouseEnabled = label.selectable = false;
			label.text = String(valueGap * index + minimum);
			addChild(label);
			if( type == AxisBase.AXIS_TYPE_HORIZONTAL ) {
				label.x = point.x - label.width / 2;
				label.y = 5;
			} else if( type == AxisBase.AXIS_TYPE_VERTICAL ) {
				label.x = point.x +label.width * -1 - 5;
				label.y = point.y + label.height / 2 * -1;
			}
			
			// 2/1 point 그리기
			if( index != stepSize ) {
				var halfPoint:Sprite = createHalfPoint();
				if( type == AxisBase.AXIS_TYPE_HORIZONTAL )		halfPoint.x = point.x + (countGap / 2);
				else if( type == AxisBase.AXIS_TYPE_VERTICAL )	halfPoint.y = point.y - (countGap / 2);
				addChild(halfPoint);
			}
		}
	}
	
	/**
	 *  라인 그리기
	 */
	private function drawLine():void {
		graphics.clear();
		graphics.beginFill(lineColor);
		if( type == AxisBase.AXIS_TYPE_HORIZONTAL )		graphics.drawRect(0, 0, unscaledWidth, 1);
		else if( type == AxisBase.AXIS_TYPE_VERTICAL )	graphics.drawRect(0, 0, 1, unscaledHeight);
		graphics.endFill();
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//	maximum
	//--------------------------------------
	
	private var _maximum:Number;
	
	public function get maximum():Number {
		return _maximum;
	}
	
	public function set maximum(value:Number):void {
		if( _maximum == value )
			return;
		
		_maximum = value;
	}
	
	//--------------------------------------
	//	minimum
	//--------------------------------------
	
	private var _minimum:Number;
	
	public function get minimum():Number {
		return _minimum;
	}
	
	public function set minimum(value:Number):void {
		if( _minimum == value )
			return;
		
		_minimum = value;
	}
	
	//--------------------------------------
	//	stepSize
	//--------------------------------------
	
	private var _stepSize:uint;
	
	public function get stepSize():uint {
		return _stepSize;
	}
	
	public function set stepSize(value:uint):void {
		if( _stepSize == value )
			return;
		
		_stepSize = value;
	}
}

}