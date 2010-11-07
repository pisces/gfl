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

package com.golfzon.gfl.controls
{

import com.golfzon.gfl.controls.listClasses.IListItemRenderer;
import com.golfzon.gfl.controls.listClasses.ListBase;
import com.golfzon.gfl.core.ScrollPolicy;
import com.golfzon.gfl.core.gz_internal;
import com.golfzon.gfl.styles.IStyleClient;

use namespace gz_internal;

/**
 *	@Author				KHKim
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.09.29
 *	@Modify
 *	@Description
 * 	@includeExample		ListSample.as
 */
public class List extends ListBase
{
	/**
	 *	@Constructor
	 */
	public function List() {
		super();
		
		columnCount = 1;
		rowHeight = 25;
		horizontalScrollPolicy = ScrollPolicy.OFF;
	}
	
	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Overriden : ListBase
	//--------------------------------------------------------------------------
	
	/**
	 * 	컴퍼넌트의 기본 크기와 최소 크기를 설정한다.
	 */
	override protected function measure():void {
		super.measure();
		
		measureWidth = isNaN(measureWidth) ? 200 : measureWidth;
		measureHeight = isNaN(measureHeight) ? 250 : measureHeight;
		
		setActualSize(unscaledWidth, unscaledHeight);
	}
	
	/**
	 *	@realization
	 * 	스크롤 범위값을 설정한다.
	 */
	override protected function setScrollProperties():void {
		if( _dataProvider ) {
			var totalRows:int = _rowHeight * Math.ceil(dataProviderLength / _columnCount);
			var cw:Number = getContentPaneWidth();
			var ch:Number = getContentPaneHeight();
			setScrollBars(cw, cw, totalRows, ch + getBorderThickness() * 2);
			getVScrollBar().lineScrollSize = _rowHeight;
			setScrollBarProperties(cw, cw, totalRows, ch + getBorderThickness() * 2);
		}
	}
}

}