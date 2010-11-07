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

package com.golfzon.gfl.chart.styles
{

/**
 *	@Author				SH Jung
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.12.08
 *	@Modify
 *	@Description
 */
public class ChartStyleProp
{
	//--------------------------------------------------------------------------
	//
	//	Class constants
	//
	//--------------------------------------------------------------------------
	
	// ChartBase
	public static const RENDERER_COLOR_LIST:String = "rendererColorList";
	
	// BarRenderer
	public static const BAR_SIZE:String = "barSize";
	public static const BAR_SKIN_LIST:String = "barSkinList";
	
	// ColumnRenderer
	public static const COLUMN_SIZE:String = "columnSize";
	public static const COLUMN_SKIN_LIST:String = "columnSkinList";
	
	// LineRenderer
	public static const LINE_SIZE:String = "lineSize";
	public static const LINE_SKIN_LIST:String = "lineSkinList";
	
	// Grid
	public static const GRID_BASE_LINE_COLOR:String = "gridBaseLineColor";
	public static const GRID_COLOR:String = "gridColor";
	public static const GRID_SKIN:String = "gridSkin";
	
	// xAxis
	public static const XAXIS_LINE_COLOR:String = "xAxisLineColor";
	public static const XAXIS_SKIN:String = "xAxisSkin";
	
	// yAxis
	public static const YAXIS_LINE_COLOR:String = "yAxisLineColor";
	public static const YAXIS_SKIN:String = "yAxisSkin";
	
	/**
	 *	@Constructor
	 */
	public function ChartStyleProp() {
		throw new Error("Error: Instantiation failed: This class not allowed instacing.");
	}
}

}