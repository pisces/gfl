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
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.12.03
 *	@Modify
 *	@Description
 */
public class CategoryAxis extends AxisBase
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	@Constructor
	 */
	public function CategoryAxis() {
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
		if( type == AxisBase.AXIS_TYPE_HORIZONTAL )		columnSize = (unscaledWidth - 1) / dataProvider.length;
		else if( type == AxisBase.AXIS_TYPE_VERTICAL )	columnSize = (unscaledHeight - 1) / dataProvider.length;
		return columnSize;
	}
	
	/**
	 *  value위 좌표값을 반환
	 */
	override public function getValuePoint(value:String):Number {
		var point:Number;
		for( var index:uint = 0; index < dataProvider.length; index++ ) {
			if( dataProvider[index][dataFields[0]] == value ) {
				point = getColumnSize() * index + getColumnSize() / 2;
				break;
			}
		}
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
			drawColumn();
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
	 *  라벨 생성
	 */
	protected function createLabel(msg:String):Label {
		var label:Label = new Label();
		label.text = msg;
		label.mouseEnabled = label.selectable = false;
		return label;
	}
	
	/**
	 *  포인트 생성
	 */
	protected function createPoint():Sprite {
		var point:Sprite = new Sprite();
		point.graphics.clear();
		point.graphics.beginFill(lineColor);
		if( type == AxisBase.AXIS_TYPE_HORIZONTAL )		point.graphics.drawRect(0, 0, 1, 5);
		else if( type == AxisBase.AXIS_TYPE_VERTICAL )	point.graphics.drawRect(-5, 0, 5, 1);
		point.graphics.endFill();
		return point;
	}
	
	/**
	 *  컬럼 그리기
	 */
	protected function drawColumn():void {
		var columnGap:Number = getColumnSize();
		
		for( var index:uint = 0; index <= dataProvider.length; index++ ) {
			// point 그리기
			var point:Sprite = createPoint();
			if( type == AxisBase.AXIS_TYPE_HORIZONTAL )		point.x = columnGap * index;
			else if( type == AxisBase.AXIS_TYPE_VERTICAL )	point.y = columnGap * index;
			addChild(point);
			
			// label 그리기
			if( index != dataProvider.length ) {
				var label:Label = createLabel(dataProvider[index][dataFields[0]]);
				addChild(label);
				if( type == AxisBase.AXIS_TYPE_HORIZONTAL ) {
					label.x = point.x + (columnGap / 2) - (label.width / 2);
					label.y = 0;
				} else if( type == AxisBase.AXIS_TYPE_VERTICAL ) {
					label.x = label.textWidth * -1 - 2;
					label.y = point.y + (columnGap / 2) - (label.height / 2);
				}
			}
		}
	}
	
	/**
	 *  라인 그리기
	 */
	protected function drawLine():void {
		graphics.clear();
		graphics.beginFill(lineColor);
		if( type == AxisBase.AXIS_TYPE_HORIZONTAL )		graphics.drawRect(0, 0, unscaledWidth, 1);
		else if( type == AxisBase.AXIS_TYPE_VERTICAL )	graphics.drawRect(0, 0, 1, unscaledHeight);
		graphics.endFill();
	}
}

}