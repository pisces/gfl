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
import com.golfzon.gfl.chart.renderer.LineRenderer;
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
 *  라인 랜더러의 두께<br>
 * 	@default value 2
 */
[Style(name="lineSize", type="uint", inherit="no")]

/**
 *  라인 랜더러 스킨<br>
 * 	@default value none
 */
[Style(name="lineSkinList", type="Array", inherit="no")]

/**
 *	@Author				SH Jung
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.12.08
 *	@Modify
 *	@Description
 * 	@includeExample		LineChartSample.as
 */
public class LineChart extends ChartBase
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	@Constructor
	 */
	public function LineChart() {
		super();
		
		legrndField = "yDataField";
		
		renderer = new LineRenderer();
		
		setStyle(ChartStyleProp.LINE_SIZE, 2);
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
			case ChartStyleProp.LINE_SIZE:	case ChartStyleProp.LINE_SKIN_LIST:
				drawChart();
			break;
			
			case ChartStyleProp.RENDERER_COLOR_LIST:
				drawRenderer();
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
		if( xPos > 0 ) {
			for( index; index + 3 <= length; index = index + 4 ) {
				baseLine.graphics.beginFill((replaceNullorUndefined(getStyle(ChartStyleProp.GRID_BASE_LINE_COLOR), 0x29447E)));
				baseLine.graphics.drawRect(xPos, yPos + index, 1, 3);
				baseLine.graphics.endFill();
			}
		}
		
		index = 0;
		length = unscaledWidth - viewMetrics.left - viewMetrics.right;
		xPos = viewMetrics.left;
		yPos = unscaledHeight - viewMetrics.bottom - yAxis.getValuePoint("0");
		if( yPos > 0 ) {
			for( index; index + 3 <= length; index = index + 4 ) {
				baseLine.graphics.beginFill((replaceNullorUndefined(getStyle(ChartStyleProp.GRID_BASE_LINE_COLOR), 0x29447E)));
				baseLine.graphics.drawRect(xPos + index, yPos, 3, 1);
				baseLine.graphics.endFill();
			}
		}
		addChild(baseLine);
	}
	
	/**
	 *  랜더러 그리기
	 */
	override protected function drawRenderer():void {
		var rendererLineList:Array = [];
		var rendererPoint:Point;
		var dotPitch:Number = (unscaledHeight - viewMetrics.top - viewMetrics.bottom) / (maximum - minimum);
		var skinList:Array = getRendererSkinList();
		var value:Number;
		
		for( var length:uint = 0; length < yDataField.length; length++ )
		{
			var rendererPointList:Array = [];
			
			for( var index:uint = 0; index < dataProvider.length; index++ ) {
				value = dataProvider[index][yDataField[length]];
				
				renderer.dotPitch = dotPitch;
				renderer.size = replaceNullorUndefined(getStyle(ChartStyleProp.LINE_SIZE), 2);
				renderer.value = value;
				if( colorList[length] )	renderer.color = colorList[length];
				
				var dataSprite:Sprite = renderer.rendering(skinList[length]);
				dataSprite.x = CategoryAxis(xAxis).getColumnSize() * index + CategoryAxis(xAxis).getColumnSize() / 2 + viewMetrics.left;
				dataSprite.y = unscaledHeight - viewMetrics.bottom - value * dotPitch - yAxis.getValuePoint("0");
				dataSprite.name = dataProvider[index][xDataField[0]] + "\n" + yDataField[length] + "\n<b>" + String(value) + "</b>";
				dataSprite.addEventListener(MouseEvent.MOUSE_OVER, renderer_mouseDownHandler, false, 0, true);
				dataSprite.addEventListener(MouseEvent.MOUSE_OUT, renderer_mouseOutHandler, false, 0, true);
				addChild(dataSprite);
				
				dataSprite.scaleX = 0
				dataSprite.scaleY = 0;
				setTimeout(rendererMotion, length * 200 + index * 200, dataSprite);
				
				rendererPointList.push(new Point(dataSprite.x, dataSprite.y));
			}
			rendererLineList.push(rendererPointList);
		}
		
		drawBridge(rendererLineList);
	}
	
	/**
	 *  X축 그리기
	 */
	override protected function drawXAxis():void {
		xAxis = new CategoryAxis();
		xAxis.axisSkin = getStyle(ChartStyleProp.XAXIS_SKIN);
		xAxis.lineColor = replaceNullorUndefined(getStyle(ChartStyleProp.XAXIS_LINE_COLOR), 0x29447E);
		xAxis.dataProvider = dataProvider;
		xAxis.dataFields = xDataField;
		xAxis.width = unscaledWidth - viewMetrics.left - viewMetrics.right;
		xAxis.type = AxisBase.AXIS_TYPE_HORIZONTAL;
		addChild(xAxis);
	}
	
	/**
	 *  Y축 그리기
	 */
	override protected function drawYAxis():void {
		yAxis = new CountAxis();
		yAxis.axisSkin = getStyle(ChartStyleProp.YAXIS_SKIN);
		yAxis.lineColor = replaceNullorUndefined(getStyle(ChartStyleProp.YAXIS_LINE_COLOR), 0x29447E);
		CountAxis(yAxis).dataProvider = dataProvider;
		CountAxis(yAxis).type = AxisBase.AXIS_TYPE_VERTICAL;
		CountAxis(yAxis).stepSize = xStepSize;
		CountAxis(yAxis).height = unscaledHeight - viewMetrics.top - viewMetrics.bottom;
		CountAxis(yAxis).minimum = _minimum;
		CountAxis(yAxis).maximum = _maximum;
		addChild(yAxis);
	}
	
	/**
	 *	rendererSkinList
	 */
	override public function getRendererSkinList():Array {
		var skinList:Array = [];
		if( getStyle(ChartStyleProp.LINE_SKIN_LIST) is Array )	skinList = getStyle(ChartStyleProp.LINE_SKIN_LIST);
		if( getStyle(ChartStyleProp.LINE_SKIN_LIST) is Class )	skinList[0] = getStyle(ChartStyleProp.LINE_SKIN_LIST);
		return skinList;
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	/**
	 *  랜더러를 잊는 다리 그리기
	 */
	private function drawBridge(data:Array):void {
		var bridge:Sprite = new Sprite();
		addChildAt(bridge, 2);
		
		for( var length:uint = 0; length < data.length; length++ ) {
			for( var index:uint = 1; index < data[length].length; index++ ) {
				var post:Sprite = new Sprite();
				post.graphics.lineStyle(replaceNullorUndefined(getStyle(ChartStyleProp.LINE_SIZE), 2), colorList[length]);
				post.graphics.moveTo(data[length][index - 1].x, data[length][index - 1].y);
				post.graphics.lineTo(data[length][index].x, data[length][index].y);
				bridge.addChild(post);
			}
		}
		
		var bridgeMask:Sprite = new Sprite();
		bridgeMask.graphics.beginFill(0x000000);
		bridgeMask.graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
		bridgeMask.graphics.endFill();
		bridgeMask.width = 0;
		bridge.mask = bridgeMask;
		addChildAt(bridgeMask, 2);
		
		TweenMax.to(bridgeMask, 0.5 * index, {width:unscaledWidth});
	}
	
	/**
	 *  랜더러 모션
	 */
	private function rendererMotion(client:Sprite):void {
		TweenMax.to(client, 0.5, {scaleX:1, scaleY:1});
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
		DataTip(dataTip).x = point.x - (dataTip.width / 2);
		DataTip(dataTip).y = point.y - event.currentTarget.height - dataTip.height;
		
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