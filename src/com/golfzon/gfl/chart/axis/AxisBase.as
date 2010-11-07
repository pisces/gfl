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

import com.golfzon.gfl.core.ComponentBase;

/**
 *	@Author				SH Jung
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.11.30
 *	@Modify
 *	@Description
 */
public class AxisBase extends ComponentBase implements IAxis
{
	//--------------------------------------------------------------------------
	//
	//	Class constants
	//
	//--------------------------------------------------------------------------
	
	public static const AXIS_TYPE_HORIZONTAL:String = "axisTypeHorizontal";
	
	public static const AXIS_TYPE_VERTICAL:String = "axisTypeVertical";
	
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	@Constructor
	 */
	public function AxisBase() {
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
		
		drawAxis();
	}
	
	//--------------------------------------------------------------------------
	//  Public
	//--------------------------------------------------------------------------
	
	/**
	 *  TODO : 컬럼의 길이(width or height)를 반환
	 */
	public function getColumnSize():Number {
		throw new Error("이 메소드는 구현이 필요한 추상 메소드입니다.");
	}
	
	/**
	 *  TODO : value위 좌표값을 반환
	 */
	public function getValuePoint(value:String):Number {
		throw new Error("이 메소드는 구현이 필요한 추상 메소드입니다.");
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	/**
	 *  TODO : 축을 그린다
	 */	
	protected function drawAxis():void {
		measure();
		
		// 초기화
		while( numChildren > 0 ) {
			removeChildAt(0);
		}
	}
	
	/**
	 *  TODO : 스킨 그리기
	 */
	protected function drawSkin():void {
		throw new Error("이 메소드는 구현이 필요한 추상 메소드입니다.");
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//	axisSkin
	//--------------------------------------
	
	private var _axisSkin:Class;
	
	public function get axisSkin():Class {
		return _axisSkin;
	}
	
	public function set axisSkin(skin:Class):void {
		if( _axisSkin == skin )
			return;
		
		_axisSkin = skin;
	}
	
	//--------------------------------------
	//	dataFields
	//--------------------------------------
	
	private var _dataFields:Array;
	
	public function get dataFields():Array {
		return _dataFields;
	}
	
	public function set dataFields(value:Array):void {
		if( _dataFields == value )
			return;
		
		_dataFields = value;
	}
	
	//--------------------------------------
	//	dataProvider
	//--------------------------------------
	
	private var _dataProvider:Array = [];
	
	public function get dataProvider():Array {
		return _dataProvider;
	}
	
	public function set dataProvider(value:Array):void {
		if( _dataProvider == value )
			return;
		
		_dataProvider = value;
	}
	
	//--------------------------------------
	//	type
	//--------------------------------------
	
	private var _type:String;
	
	public function get type():String {
		return _type;
	}
	
	public function set type(value:String):void {
		if( _type == value )
			return;
		
		_type = value;
	}
	
	//--------------------------------------
	//	lineColor
	//--------------------------------------
	
	private var _lineColor:uint;
	
	public function get lineColor():uint {
		return _lineColor;
	}
	
	public function set lineColor(color:uint):void {
		if( _lineColor == color )
			return;
		
		_lineColor = color;
	}
}

}