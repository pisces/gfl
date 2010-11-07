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

use namespace gz_internal;

/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
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
    	
    	setActureSize(unscaledWidth, unscaledHeight);
    }
    
	/**
     *	@realization
	 *	인덱스에 따라 아이템 렌더러의 프로퍼티를 설정한다.
	 */
	override protected function setItemRendererBy(index:int, renderer:IListItemRenderer):void {
		renderer.width = columnWidth;
		renderer.height = rowHeight;
		renderer.x = index % columnCount * columnWidth;
		renderer.y = Math.floor(index / columnCount) * rowHeight;
		renderer.data = dataProvider ? dataProvider[verticalLineIndex * columnCount + index] : null;
    }
    
    /**
     *	@realization
     * 	스크롤 범위값을 설정한다.
     */
    override protected function setScrollProperties():void {
	    if( dataProvider ) {
		    var totalRows:int = rowHeight * Math.round(dataProvider.length / columnCount);
		    var cw:Number = getContentPaneWidth();
		    var ch:Number = getContentPaneHeight();
		    setScrollBars(cw, cw, totalRows, ch);
			getVScrollBar().lineScrollSize = rowHeight;
			setScrollBarProperties(cw, cw, totalRows, ch);
	    }
    }
}

}