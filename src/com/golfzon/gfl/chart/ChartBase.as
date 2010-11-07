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
import com.golfzon.gfl.chart.grid.Grid;
import com.golfzon.gfl.chart.renderer.RendererBase;
import com.golfzon.gfl.chart.styles.ChartStyleProp;
import com.golfzon.gfl.core.ComponentBase;
import com.golfzon.gfl.core.EdgeMetrics;
import com.golfzon.gfl.skins.Border;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *	dataProvider가 변경되면  송출한다.
 */
[Event(name="change", type="flash.events.Event")]

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  그리드의 0점 점선 색<br>
 * 	@default value 0x29447E
 */
[Style(name="gridBaseLineColor", type="uint", inherit="no")]

/**
 *  그리드의 선 색<br>
 * 	@default value 0xC8C8C8
 */
[Style(name="gridColor", type="uint", inherit="no")]

/**
 *  그리드 스킨<br>
 * 	@default value none
 */
[Style(name="gridSkin", type="class", inherit="no")]

/**
 *  차트의 아래쪽 여백<br>
 * 	@default value 50
 */
[Style(name="paddingBottom", type="int", format="Length", inherit="no")]

/**
 *  차트의 왼쪽 여백<br>
 * 	@default value 50
 */
[Style(name="paddingLeft", type="int", format="Length", inherit="no")]

/**
 *  차트의 위쪽 여백<br>
 * 	@default value 15
 */
[Style(name="paddingTop", type="int", format="Length", inherit="no")]

/**
 *  차트의 오른쪽 여백<br>
 * 	@default value 15
 */
[Style(name="paddingRight", type="int", format="Length", inherit="no")]

/**
 *  랜더러 색상 배열<br>
 * 	@default value ["0x29447E", "0x5872AA", "0x8297C0", "0xA2B1CE", "0xB9C4C9"]
 */
[Style(name="rendererColorList", type="Array", inherit="no")]

/**
 *  x축 선 색<br>
 * 	@default value 0x29447E
 */
[Style(name="xAxisLineColor", type="uint", inherit="no")]

/**
 *  x축 스킨<br>
 * 	@default value none
 */
[Style(name="xAxisSkin", type="uint", inherit="no")]

/**
 *  y축 선 색<br>
 * 	@default value 0x29447E
 */
[Style(name="yAxisLineColor", type="uint", inherit="no")]

/**
 *  y축 스킨<br>
 * 	@default value none
 */
[Style(name="yAxisSkin", type="uint", inherit="no")]

/**
 *	@Author				SH Jung
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.11.30
 *	@Modify
 *	@Description
 */
public class ChartBase extends ComponentBase
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  보더
	 */
	protected var border:DisplayObject;
	
	/**
	 *  데이터 팁
	 */
	protected var dataTip:DisplayObject;
	
	/**
	 *  차트 랜더링 객체
	 */
	protected var renderer:RendererBase;
	
	
	/**
	 *  뷰 메트릭스
	 */
	protected var viewMetrics:EdgeMetrics;
	
	/**
	 *	@Constructor
	 */
	public function ChartBase() {
		super();
		
		width = 400;
		height = 400;
		
		setStyle(ChartStyleProp.GRID_BASE_LINE_COLOR, 0x29447E);
		setStyle(ChartStyleProp.GRID_COLOR, 0xC8C8C8);
		setStyle(ChartStyleProp.XAXIS_LINE_COLOR, 0x29447E);
		setStyle(ChartStyleProp.YAXIS_LINE_COLOR, 0x29447E);
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
	 * 	자식 객체 생성 및 추가
	 */
	override protected function createChildren():void {
		border = createBorder();
		addChild(border);
	}
	
	/**
	 * 	디스플레이 변경 사항에 대한 처리
	 */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		border.width = unscaledWidth;
		border.height = unscaledHeight;
		
		if( !creationComplete ) {
			dataProviderChanged = false;
			heightChanged = false;
			widthChanged = false;
			xDataFieldChanged = false;
			yDataFieldChanged = false;
			drawChart();
		}
		
		if( dataProviderChanged ) {
			dataProviderChanged = false;
			drawChart();
		}
		
		if( heightChanged ) {
			heightChanged = false;
			drawChart();
		}
		
		if( widthChanged ) {
			widthChanged = false;
			drawChart();
		}
		
		if( xDataFieldChanged ) {
			xDataFieldChanged = false;
			drawChart();
		}
		
		if( yDataFieldChanged ) {
			yDataFieldChanged = false;
			drawChart();
		}
	}
	
	/**
	 *	enabled에 따른 구현
	 */
	override protected function setStateToChangeEnabled():void {
		super.setStateToChangeEnabled();
		
		for( var index:uint = 0; index < numChildren; index++ ) {
			ComponentBase(getChildAt(index)).enabled = enabled;
		}
	}
	
	/**
	 *	스타일 프로퍼티로 값을 설정한다.
	 */
	override public function styleChanged(styleProp:String):void {
		super.styleChanged(styleProp);
		
		switch( styleProp ) {
			case ChartStyleProp.XAXIS_LINE_COLOR:	case ChartStyleProp.XAXIS_SKIN:
				drawXAxis();
				alignChild();
				break;
				
			case ChartStyleProp.YAXIS_LINE_COLOR:	case ChartStyleProp.YAXIS_SKIN:
				drawYAxis();
				alignChild();
				break;
			
			case StyleProp.PADDING_BOTTOM:	case StyleProp.PADDING_LEFT:
			case StyleProp.PADDING_RIGHT:	case StyleProp.PADDING_TOP:
				drawChart();
				break;
			
			case ChartStyleProp.GRID_BASE_LINE_COLOR:
				drawBaseLine();
				break;
			
			case ChartStyleProp.GRID_COLOR:	case ChartStyleProp.GRID_SKIN:
				drawChart();
				break;
			
			case ChartStyleProp.RENDERER_COLOR_LIST:
				drawChart();
				break;
			
		}
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	/**
	 *  x축, y축, 그리드, 랜더러 정렬
	 */
	protected function alignChild():void {
		throw new Error("이 메소드는 구현이 필요한 추상 메소드입니다.");
	}
	
	/**
	 *  차트를 지움
	 */
	protected function clearChart():void {
		while( numChildren > 1 ) {
			removeChildAt(1);
		}
	}
	
	/**
	 * 	보더 생성
	 */
	private function createBorder():DisplayObject {
		var borderClass:Class = replaceNullorUndefined(getStyle(StyleProp.BORDER_SKIN), Border);
		if( borderClass ) {
			var border:DisplayObject = createSkinBy(borderClass);
			
			if( border is Border )
				Border(border).styleName = getCSSStyleDeclaration();
				
			return border;
		}
		return null;
	}
	
	/**
	 *  기준 라인 그리기
	 */
	protected function drawBaseLine():void {
		throw new Error("이 메소드는 구현이 필요한 추상 메소드입니다.");
	}
	
	/**
	 *  차트를 그리기
	 */
	protected function drawChart():void {
		if( !_dataProvider )
			return;
		
		if( !xDataField )
			return;
		
		if( !yDataField )
			return;
		
		// style
		colorList = ["0x29447E", "0x5872AA", "0x8297C0", "0xA2B1CE", "0xB9C4D9"];
		if( getStyle(ChartStyleProp.RENDERER_COLOR_LIST) is Number ) {
			colorList[0] = getStyle(ChartStyleProp.RENDERER_COLOR_LIST);
		} else if( getStyle(ChartStyleProp.RENDERER_COLOR_LIST) is Array ) {
			colorList = [];
			colorList = getStyle(ChartStyleProp.RENDERER_COLOR_LIST);
		}
		setViewMetrics();
		
		// draw
		clearChart();
		drawXAxis();
		drawYAxis();
		drawGrid();
		drawRenderer();
		drawBaseLine();
		alignChild();
		
		dispatchEvent(new Event(Event.CHANGE));
	}
	
	/**
	 *  그리드 그리기
	 */
	protected function drawGrid():void {
		if( getStyle(ChartStyleProp.GRID_SKIN) ) {
			grid = new Sprite();
			var drawObject:DisplayObject = createSkinBy(getStyle(ChartStyleProp.GRID_SKIN));
			var bitmapData:BitmapData = new BitmapData(drawObject.width, drawObject.height);
			bitmapData.draw(drawObject);
			grid.graphics.beginBitmapFill(bitmapData);
			grid.graphics.drawRect(0, 0, unscaledWidth - viewMetrics.left - viewMetrics.right, unscaledHeight - viewMetrics.top - viewMetrics.bottom);
			grid.graphics.endFill();
		} else {
			grid = new Grid();
			Grid(grid).color = replaceNullorUndefined(getStyle(ChartStyleProp.GRID_COLOR), 0xC8C8C8);
			Grid(grid).xValue = xAxis.getColumnSize();
			Grid(grid).yValue = yAxis.getColumnSize();
			Grid(grid).width = unscaledWidth - viewMetrics.left - viewMetrics.right;
			Grid(grid).height = unscaledHeight - viewMetrics.top - viewMetrics.bottom;
		}
		addChildAt(grid, 1);
	}
	
	/**
	 *  랜더러 그리기
	 */
	protected function drawRenderer():void {
		throw new Error("이 메소드는 구현이 필요한 추상 메소드입니다.");
	}
	
	/**
	 *  X축 그리기
	 */
	protected function drawXAxis():void {
		throw new Error("이 메소드는 구현이 필요한 추상 메소드입니다.");
	}
	
	/**
	 *  Y축 그리기
	 */
	protected function drawYAxis():void {
		throw new Error("이 메소드는 구현이 필요한 추상 메소드입니다.");
	}
	
	/**
	 *	viewMetrics
	 */
	protected function setViewMetrics():void {
		viewMetrics = new EdgeMetrics(
			replaceNullorUndefined(getStyle(StyleProp.PADDING_LEFT), 50),
			replaceNullorUndefined(getStyle(StyleProp.PADDING_TOP), 15),
			replaceNullorUndefined(getStyle(StyleProp.PADDING_RIGHT), 15),
			replaceNullorUndefined(getStyle(StyleProp.PADDING_BOTTOM), 50)
		);
	}
	
	/**
	 *	rendererSkinList
	 */
	public function getRendererSkinList():Array {
		throw new Error("이 메소드는 구현이 필요한 추상 메소드입니다.");
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//	colorList
	//--------------------------------------
	
	private var _colorList:Array = [];
	
	public function get colorList():Array {
		return _colorList;
	}
	
	public function set colorList(value:Array):void {
		if( _colorList == value )
			return;
		
		_colorList = value;
	}
	
	//--------------------------------------
	//	dataProvider
	//--------------------------------------
	
	private var dataProviderChanged:Boolean = false;
	
	private var _dataProvider:Array;
	
	public function get dataProvider():Array {
		return _dataProvider;
	}
	
	public function set dataProvider(value:Array):void {
		if( _dataProvider == value )
			return;
		
		_dataProvider = value;
		dataProviderChanged = true;
		
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	grid
	//--------------------------------------
	
	private var _grid:Sprite;
	
	public function get grid():Sprite {
		return _grid;
	}
	
	public function set grid(client:Sprite):void {
		if( _grid == client )
			return;
		
		_grid = client;
	}
	
	//--------------------------------------
	//	legrndField
	//--------------------------------------
	
	private var _legrndField:String;
	
	public function get legrndField():String {
		return _legrndField;
	}
	
	public function set legrndField(value:String):void {
		if( _legrndField == value )
			return;
		
		_legrndField = value;
	}
	
	//--------------------------------------
	//	xAxis
	//--------------------------------------
	
	private var _xAxis:AxisBase;
	
	public function get xAxis():AxisBase {
		return _xAxis;
	}
	
	public function set xAxis(client:AxisBase):void {
		if( _xAxis == client )
			return;
		
		_xAxis = client;
	}
	
	//--------------------------------------
	//	xDataField
	//--------------------------------------
	
	private var xDataFieldChanged:Boolean = false;
	
	private var _xDataField:Array;
	
	public function get xDataField():Array {
		return _xDataField;
	}
	
	public function set xDataField(value:Array):void {
		if( _xDataField == value )
			return;
		
		_xDataField = value;
		xDataFieldChanged = true;
		
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	xStepSize
	//--------------------------------------
	
	private var xStepSizeChanged:Boolean = false;
	
	private var _xStepSize:uint;
	
	public function get xStepSize():uint {
		return _xStepSize;
	}
	
	public function set xStepSize(value:uint):void {
		if( _xStepSize == value )
			return;
		
		_xStepSize = value;
		xStepSizeChanged = true;
		
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	yAxis
	//--------------------------------------
	
	private var _yAxis:AxisBase;
	
	public function get yAxis():AxisBase {
		return _yAxis;
	}
	
	public function set yAxis(client:AxisBase):void {
		if( _yAxis == client )
			return;
		
		_yAxis = client;
	}
	
	//--------------------------------------
	//	yDataField
	//--------------------------------------
	
	private var yDataFieldChanged:Boolean = false;
	
	private var _yDataField:Array;
	
	public function get yDataField():Array {
		return _yDataField;
	}
	
	public function set yDataField(value:Array):void {
		if( _yDataField == value )
			return;
		
		_yDataField = value;
		yDataFieldChanged = true;
		
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	yStepSize
	//--------------------------------------
	
	private var yStepSizeChanged:Boolean = false;
	
	private var _yStepSize:uint;
	
	public function get yStepSize():uint {
		return _yStepSize;
	}
	
	public function set yStepSize(value:uint):void {
		if( _yStepSize == value )
			return;
		
		_yStepSize = value;
		yStepSizeChanged = true;
		
		invalidateDisplayList();
	}
}

}