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

package com.golfzon.gfl.chart
{

import com.golfzon.gfl.chart.axis.AxisBase;
import com.golfzon.gfl.chart.axis.CategoryAxis;
import com.golfzon.gfl.chart.axis.CountAxis;
import com.golfzon.gfl.chart.helper.DataTip;
import com.golfzon.gfl.chart.renderer.BarRenderer;
import com.golfzon.gfl.chart.styles.ChartStyleProp;
import com.golfzon.gfl.managers.PopUpManager;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.utils.setTimeout;

import gs.TweenMax;

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  바 랜더러의 두께<br>
 * 	@default value 10
 */
[Style(name="barSize", type="uint", inherit="no")]

/**
 *  바 랜더러 스킨<br>
 * 	@default value none
 */
[Style(name="barSkinList", type="Array", inherit="no")]

/**
 *	@Author				SH Jung
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.12.01
 *	@Modify
 *	@Description
 * 	@includeExample		BarChartSample.as
 */
public class BarChart extends ChartBase
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	@Constructor
	 */
	public function BarChart() {
		super();
		
		legrndField = "xDataField";
		
		renderer = new BarRenderer();
		
		setStyle(ChartStyleProp.BAR_SIZE, 10);
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
		
		if( _maximumChanged ) {
			_maximumChanged = false;
			drawChart();
		}
		
		if( _minimumChanged ) {
			_minimumChanged = false;
			drawChart();
		}
	}
	
	/**
	 *	스타일 프로퍼티로 값을 설정한다.
	 */
	override public function styleChanged(styleProp:String):void {
		super.styleChanged(styleProp);
		
		switch( styleProp ) {
			case ChartStyleProp.BAR_SIZE:	case ChartStyleProp.BAR_SKIN_LIST:
				drawChart();
			break;
		}
	}
	
	//--------------------------------------------------------------------------
	//  Overriden : ChartBase
	//--------------------------------------------------------------------------

	/**
	 *  x축, y축, 그리드, 랜더러 정렬
	 */
	override protected function alignChild():void {
		grid.x = viewMetrics.left;
		grid.y = viewMetrics.top;
		xAxis.x = viewMetrics.left;
		xAxis.y = unscaledHeight - 1 - viewMetrics.bottom;
		yAxis.x = viewMetrics.left;
		yAxis.y = viewMetrics.top;
	}
	
	/**
	 *  기준 라인 그리기
	 */
	override protected function drawBaseLine():void {
		if( !minimum )
			return;
		
		var baseLine:Sprite = new Sprite();
		var index:uint = 0;
		var length:Number = unscaledHeight - viewMetrics.top - viewMetrics.bottom;
		var xPos:Number = viewMetrics.left + xAxis.getValuePoint("0");
		var yPos:Number = viewMetrics.top;
		for( index; index + 3 <= length; index = index + 4 ) {
			baseLine.graphics.beginFill(replaceNullorUndefined(getStyle(ChartStyleProp.GRID_BASE_LINE_COLOR), 0x29447E));
			baseLine.graphics.drawRect(xPos, yPos + index, 1, 3);
			baseLine.graphics.endFill();
		}
		addChild(baseLine);
	}
	
	/**
	 *  랜더러 그리기
	 */
	override protected function drawRenderer():void {
		var dotPitch:Number = (unscaledWidth - viewMetrics.left - viewMetrics.right) / (maximum - minimum);
		var skinList:Array = getRendererSkinList();
		var value:Number;
		
		for( var length:uint = 0; length < xDataField.length; length++ )
		{
			for( var index:uint = 0; index < dataProvider.length; index++ ) {
				value = dataProvider[index][xDataField[length]];
				
				renderer.dotPitch = dotPitch;
				renderer.size = replaceNullorUndefined(getStyle(ChartStyleProp.BAR_SIZE), 10);
				renderer.value = value;
				if( colorList[length] )	renderer.color = colorList[length];
				
				var dataSprite:Sprite = renderer.rendering(skinList[length]);
				dataSprite.x = viewMetrics.left + xAxis.getValuePoint("0");
				dataSprite.y = CategoryAxis(yAxis).getColumnSize() * index + CategoryAxis(yAxis).getColumnSize() / 2 - dataSprite.height / 2 + viewMetrics.top;
				if( xDataField.length > 1 ) {
					dataSprite.y += dataSprite.height * length;
					dataSprite.y -= dataSprite.height * xDataField.length / 2 - dataSprite.height / 2;
				}
				dataSprite.name = dataProvider[index][yDataField[0]] + "\n" + xDataField[length] + "\n<b>" + String(value) + "</b>";
				dataSprite.addEventListener(MouseEvent.MOUSE_OVER, renderer_mouseDownHandler, false, 0, true);
				dataSprite.addEventListener(MouseEvent.MOUSE_OUT, renderer_mouseOutHandler, false, 0, true);
				addChild(dataSprite);
				
				dataSprite.scaleX = 0;
				setTimeout(rendererMotion, length * 200 + index * 200, dataSprite);
			}
		}
	}
	
	/**
	 *  X축 그리기
	 */
	override protected function drawXAxis():void {
		xAxis = new CountAxis();
		xAxis.axisSkin = getStyle(ChartStyleProp.XAXIS_SKIN);
		xAxis.lineColor = replaceNullorUndefined(getStyle(ChartStyleProp.XAXIS_LINE_COLOR), 0x29447E);
		CountAxis(xAxis).dataProvider = dataProvider;
		CountAxis(xAxis).type = AxisBase.AXIS_TYPE_HORIZONTAL;
		CountAxis(xAxis).stepSize = xStepSize;
		CountAxis(xAxis).width = unscaledWidth - viewMetrics.left - viewMetrics.right;
		CountAxis(xAxis).minimum = _minimum;
		CountAxis(xAxis).maximum = _maximum;
		addChild(xAxis);
	}
	
	/**
	 *  Y축 그리기
	 */
	override protected function drawYAxis():void {
		yAxis = new CategoryAxis();
		yAxis.axisSkin = getStyle(ChartStyleProp.YAXIS_SKIN);
		yAxis.lineColor = replaceNullorUndefined(getStyle(ChartStyleProp.YAXIS_LINE_COLOR), 0x29447E);
		yAxis.dataProvider = dataProvider;
		yAxis.dataFields = yDataField;
		yAxis.height = unscaledHeight - viewMetrics.top - viewMetrics.bottom;
		yAxis.type = AxisBase.AXIS_TYPE_VERTICAL;
		addChild(yAxis);
	}
	
	/**
	 *	rendererSkinList
	 */
	override public function getRendererSkinList():Array {
		var skinList:Array = [];
		if( getStyle(ChartStyleProp.BAR_SKIN_LIST) is Array )	skinList = getStyle(ChartStyleProp.BAR_SKIN_LIST);
		if( getStyle(ChartStyleProp.BAR_SKIN_LIST) is Class )	skinList[0] = getStyle(ChartStyleProp.BAR_SKIN_LIST);
		return skinList;
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	/**
	 *  랜더러 모션
	 */
	private function rendererMotion(client:Sprite):void {
		TweenMax.to(client, 1, {scaleX:1});
	}
	
	//--------------------------------------------------------------------------
	//
	//	Event handlers
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  렌더러 마우스 오버
	 */
	private function renderer_mouseDownHandler(event:MouseEvent):void {
		var point:Point = new Point(x, y);
		point = localToGlobal(point);
		point = new Point(point.x + event.currentTarget.x, point.y + event.currentTarget.y);
		
		dataTip = PopUpManager.createPopUp(DataTip);
		DataTip(dataTip).label = event.currentTarget.name;
		DataTip(dataTip).x = event.localX < 0 ? point.x : point.x + event.currentTarget.width;
		DataTip(dataTip).y = point.y + (event.currentTarget.height - dataTip.height) / 2;
		
		PopUpManager.addPopUp(dataTip);
	}
	
	/**
	 *  렌더러 마우스 아웃
	 */
	private function renderer_mouseOutHandler(event:MouseEvent):void {
		PopUpManager.removePopUp(dataTip);
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//	maximum
	//--------------------------------------
	
	private var _maximumChanged:Boolean;
	
	private var _maximum:Number = 100;
	
	public function get maximum():Number {
		return _maximum;
	}
	
	public function set maximum(value:Number):void {
		if( _maximum == value )
			return;
		
		_maximum = value;
		_maximumChanged = true;
		
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	minimum
	//--------------------------------------
	
	private var _minimumChanged:Boolean;
	
	private var _minimum:Number = 0;
	
	public function get minimum():Number {
		return _minimum;
	}
	
	public function set minimum(value:Number):void {
		if( _minimum == value )
			return;
		
		_minimum = value;
		_minimumChanged = true;
		
		invalidateDisplayList();
	}
}

}