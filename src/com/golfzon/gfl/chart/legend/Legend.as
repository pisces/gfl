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

package com.golfzon.gfl.chart.legend
{

import com.golfzon.gfl.chart.ChartBase;
import com.golfzon.gfl.containers.Box;
import com.golfzon.gfl.containers.HBox;
import com.golfzon.gfl.containers.VBox;
import com.golfzon.gfl.controls.Label;
import com.golfzon.gfl.core.ComponentBase;
import com.golfzon.gfl.styles.StyleProp;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;

/**
 *	@Author				SH Jung
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.11.30
 *	@Modify
 *	@Description
 */
public class Legend extends ComponentBase
{
	//--------------------------------------------------------------------------
	//
	//	Class constants
	//
	//--------------------------------------------------------------------------
	
	public static const LEGEND_ALIGN_HORIZONTAL:String = "legendAlignHorizontal";
	
	public static const LEGEND_ALIGN_VERTICAL:String = "legendAlignVertical";
	
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  컨테이너로 활용 할 타일박스
	 */	
	private var box:Box;
	
	/**
	 *	@Constructor
	 */
	public function Legend() {
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
	 * 	컴퍼넌트의 기본 크기와 최소 크기를 설정한다.
	 */
	override protected function measure():void {
		super.measure();
		
		if( !box )
			return;
		
		measureWidth = box.width;
		measureHeight = box.height;
		
		setActureSize(measureWidth, measureHeight);
	}
	
	/**
	 * 	디스플레이 변경 사항에 대한 처리
	 */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		if( _dataProvider )	drawLegend();
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	/**
	 *  범례를 생성 
	 */	
	private function createLegend(index:uint):Sprite {
		var skinList:Array = _dataProvider.getRendererSkinList();
		var legend:Sprite = new Sprite();
		var label:Label = new Label();
		
		label.text = _dataProvider[_dataProvider.legrndField][index];
		label.x = 10;
		legend.addChild(label);
		
		if( skinList[index] ) {
			var dataObject:DisplayObject = createSkinBy(skinList[index]);
			dataObject.y = int((label.height - dataObject.height) / 2);
			legend.addChild(dataObject);
		} else {
			var color:uint;
			if( !_dataProvider.colorList[index] )	color = 0x29447E;
			else									color = _dataProvider.colorList[index];
			legend.graphics.beginFill(color);
			legend.graphics.drawRect(0, 2, 10, 10);
			legend.graphics.endFill();
		}
		
		return legend;
	}
	
	/**
	 *  범례를 그리기
	 */	
	private function drawLegend():void {
		if( !_dataProvider.legrndField || !_dataProvider[_dataProvider.legrndField] )
			return;
		
		// 초기화
		while( numChildren > 0 ) {
			removeChildAt(0);
		}
		
		if( _align == LEGEND_ALIGN_HORIZONTAL ) {
			box = new HBox();
		} else if ( _align == LEGEND_ALIGN_VERTICAL ) {
			box = new VBox();
		}
		box.setStyle(StyleProp.BORDER_THICKNESS, 1);
		box.setStyle(StyleProp.PADDING_LEFT, 5);
		box.setStyle(StyleProp.PADDING_TOP, 5);
		box.setStyle(StyleProp.PADDING_RIGHT, 5);
		box.setStyle(StyleProp.PADDING_BOTTOM, 5);
		addChild(box);
		
		for( var index:uint = 0; index < _dataProvider[_dataProvider.legrndField].length; index++ ) {
			box.addChild(createLegend(index));
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//	Event handlers
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  데이터 변경
	 */
	private function dataProvider_changeHandler(event:Event):void {
		invalidateDisplayList();
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//	dataProvider
	//--------------------------------------
	
	private var _dataProvider:ChartBase;
	
	public function set dataProvider(client:ChartBase):void {
		if( _dataProvider == client )
			return;
		
		_dataProvider = client;
		_dataProvider.addEventListener(Event.CHANGE, dataProvider_changeHandler, false, 0, true);
	}
	
	//--------------------------------------
	//	align
	//--------------------------------------
	
	private var _align:String = LEGEND_ALIGN_HORIZONTAL;
	
	public function set align(value:String):void {
		if( _align == value )
			return;
		
		_align = value;
		
		invalidateDisplayList();
	}
}

}