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

import com.golfzon.gfl.chart.helper.DataTip;
import com.golfzon.gfl.chart.renderer.PieRenderer;
import com.golfzon.gfl.chart.styles.ChartStyleProp;
import com.golfzon.gfl.core.EdgeMetrics;
import com.golfzon.gfl.managers.PopUpManager;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.utils.setTimeout;

import gs.TweenMax;

import org.casalib.math.geom.Ellipse;

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *	@Author				SH Jung
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.12.10
 *	@Modify
 *	@Description
 * 	@includeExample		PieChartSample.as
 */
public class PieChart extends ChartBase
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  파이 리스트
	 */	
	private var pieList:Array;
	
	/**
	 *	@Constructor
	 */
	public function PieChart() {
		super();
		
		legrndField = "nameList";
		
		renderer = new PieRenderer();
	}
	
	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Overriden : ChartBase
	//--------------------------------------------------------------------------

	/**
	 *  x축, y축, 그리드, 랜더러 정렬
	 */
	override protected function alignChild():void {
	}
	
	/**
	 *  차트를 그리기
	 */
	override protected function drawChart():void {
		if( !dataProvider )
			return;
		
		// style
		colorList = ["0x29447E", "0x5872AA", "0x8297C0", "0xA2B1CE", "0xB9C4D9"];
		if( getStyle(ChartStyleProp.RENDERER_COLOR_LIST) is Array )		colorList = getStyle(ChartStyleProp.RENDERER_COLOR_LIST);
		if( getStyle(ChartStyleProp.RENDERER_COLOR_LIST) is Number )	colorList[0] = getStyle(ChartStyleProp.RENDERER_COLOR_LIST);
		setViewMetrics();
		
		// draw
		clearChart();
		drawRenderer();
		alignChild();
		
		dispatchEvent(new Event(Event.CHANGE));
	}
	
	/**
	 *  랜더러 그리기
	 */
	override protected function drawRenderer():void {
		pieList = [];
		var dataSum:Number = 0;
		var currentAngle:Number = 0;
		var index:uint;
		var ellipse:Ellipse = new Ellipse(viewMetrics.left, viewMetrics.top, unscaledWidth - viewMetrics.left - viewMetrics.right, unscaledHeight - viewMetrics.top - viewMetrics.bottom);
		
		PieRenderer(renderer).ellipse = ellipse;
		dataProvider.sortOn([_dataField, _nameField], [Array.NUMERIC | Array.DESCENDING, Array.CASEINSENSITIVE]);
		
		for( index = 0; index < dataProvider.length; index++ )
		{
			dataSum += dataProvider[index][_dataField];
		}
		
		for( index = 0; index < dataProvider.length; index++ )
		{
			var pieData:String = String(dataProvider[index][_dataField] / dataSum * 100);
			if( pieData.indexOf(".") + 2 < pieData.length ) pieData = pieData.slice(0, pieData.indexOf(".") + 3) + "..";
			
			PieRenderer(renderer).startAngle = currentAngle;
			PieRenderer(renderer).arc = dataProvider[index][_dataField] / dataSum * 360;
			PieRenderer(renderer).data = pieData + "%";
			if( colorList[index] )	PieRenderer(renderer).color = colorList[index];
			
			var pie:Sprite = renderer.rendering();
			pie.name = dataProvider[index][_nameField] + "\n<b>" + pieData + "%</b>";
			pie.addEventListener(MouseEvent.MOUSE_OVER, pie_mouseDownHandler, false, 0, true);
			pie.addEventListener(MouseEvent.MOUSE_OUT, pie_mouseOutHandler, false, 0, true);
			pieList.push(pie);
			addChildAt(pie, 1);
			currentAngle -= dataProvider[index][_dataField] / dataSum * 360;
			
			pie.alpha = 0;
			setTimeout(rendererMotion, index * 250, pie);
		}
	}
	
	/**
	 *	viewMetrics
	 */
	override protected function setViewMetrics():void {
		viewMetrics = new EdgeMetrics(
			replaceNullorUndefined(getStyle(StyleProp.PADDING_LEFT), 10),
			replaceNullorUndefined(getStyle(StyleProp.PADDING_TOP), 10),
			replaceNullorUndefined(getStyle(StyleProp.PADDING_RIGHT), 10),
			replaceNullorUndefined(getStyle(StyleProp.PADDING_BOTTOM), 10)
		);
	}
	
	/**
	 *	rendererSkinList
	 */
	override public function getRendererSkinList():Array {
		return [];
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	/**
	 *  랜더러 모션
	 */
	private function rendererMotion(client:Sprite):void {
		TweenMax.to(client, 0.5, {alpha:1});
	}
	
	//--------------------------------------------------------------------------
	//
	//	Event handlers
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  파이 엔터 프레임
	 */
	private function pie_enterFrameHandler(event:Event): void {
		var point:Point = new Point(stage.mouseX, stage.mouseY);
		DataTip(dataTip).label = event.currentTarget.name;
		DataTip(dataTip).x = point.x - dataTip.width / 2;
		DataTip(dataTip).y = point.y - dataTip.height - 10;
	}
	
	/**
	 *  파이 마우스 오버
	 */
	private function pie_mouseDownHandler(event:MouseEvent):void {
		dataTip = PopUpManager.createPopUp(DataTip);
		PopUpManager.addPopUp(dataTip);
		
		for( var index:uint = 0; index < pieList.length; index++ ) {
			if( pieList[index] != event.currentTarget ) {
				TweenMax.to(pieList[index], 0.5, {alpha:0.2});
			}
		}
		event.currentTarget.addEventListener(Event.ENTER_FRAME, pie_enterFrameHandler, false, 0, true);
	}
	
	/**
	 *  파이 마우스 아웃
	 */
	private function pie_mouseOutHandler(event:MouseEvent):void {
		PopUpManager.removePopUp(dataTip);
		
		for( var index:uint = 0; index < pieList.length; index++ ) {
			TweenMax.to(pieList[index], 0.5, {alpha:1});
		}
		event.currentTarget.removeEventListener(Event.ENTER_FRAME, pie_enterFrameHandler);
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//	dataField
	//--------------------------------------
	
	private var _dataField:String;
	
	public function set dataField(value:String):void {
		if( _dataField == value )
			return;
		
		_dataField = value;
	}
	
	//--------------------------------------
	//	nameField
	//--------------------------------------
	
	private var _nameField:String;
	
	public function get nameField():String {
		return _nameField;
	}
	
	public function set nameField(value:String):void {
		if( _nameField == value )
			return;
		
		_nameField = value;
	}
	
	//--------------------------------------
	//	nameList
	//--------------------------------------
	
	public function get nameList():Array {
		var list:Array = [];
		
		for( var index:uint = 0; index < dataProvider.length; index++ )
		{
			list[list.length] = dataProvider[index][_nameField];
		}
		
		return list;
	}
	
}

}