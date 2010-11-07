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
import com.golfzon.gfl.events.DragEvent;

use namespace gz_internal;

/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.10.05
 *	@Modify
 *	@Description
 * 	@includeExample		HorizontalListSample.as
 */
public class HorizontalList extends ListBase
{
	/**
	 *	@Constructor
	 */
	public function HorizontalList() {
		super();
		
		columnCount = 5;
		rowCount = 1;
		verticalScrollPolicy = ScrollPolicy.OFF;
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
	 *	@private
	 * 	change data for dataProvider
	 */
    override protected function changeData(index:int, item1:Object, item2:Object):void {
    	dataProvider[index + horizontalLineIndex] = item1;
    	dataProvider[selectedIndex] = item2;
    }
    
	/**
	 *	@private
	 */
    override protected function dragScroll():void {
    	var newPosition:Number = horizontalScrollPosition + dragScrollSize;
    	if( newPosition > maxHorizontalScrollPosition || newPosition < 0 ) {
    		removeDragScrolling();
    	} else {
	    	horizontalScrollPosition = newPosition;
	    	scrollTarget();
	    	setDragGuider();
    	}
    }
    
    /**
     * 	컴퍼넌트의 기본 크기와 최소 크기를 설정한다.
     */
    override protected function measure():void {
    	super.measure();
    	
    	measureWidth = isNaN(measureWidth) ? 350 : measureWidth;
    	measureHeight = isNaN(measureHeight) ? 100 : measureHeight;
    	
    	setActureSize(unscaledWidth, unscaledHeight);
    }
    
	/**
     *	@realization
	 *	인덱스에 따라 아이템 렌더러의 프로퍼티를 설정한다.
	 */
	override protected function setItemRendererBy(index:int, renderer:IListItemRenderer):void {
		renderer.width = columnWidth;
		renderer.height = rowHeight;
		renderer.x = Math.floor(index / rowCount) * columnWidth;
		renderer.data = dataProvider ? dataProvider[horizontalLineIndex * rowCount + index] : null;
    }
    
    /**
     *	@realization
     * 	스크롤 범위값을 설정한다.
     */
    override protected function setScrollProperties():void {
	    if( dataProvider ) {
		    var totalColumns:int = columnWidth * Math.round(dataProvider.length / rowCount);
		    var cw:Number = getContentPaneWidth();
		    var ch:Number = getContentPaneHeight();
		    setScrollBars(totalColumns, cw, ch, ch);
			getHScrollBar().lineScrollSize = columnWidth;
			setScrollBarProperties(totalColumns, cw, ch, ch);
	    }
    }
    
    //--------------------------------------------------------------------------
	//
	//	Event handlers
	//
    //--------------------------------------------------------------------------
    
	/**
	 *	@private
	 */
    override protected function dragEnterHandler(event:DragEvent):void {
		if( mouseX > unscaledWidth - columnWidth / 2 )
			setDragScrollProperties(unscaledWidth - mouseX, 1);
		else if( mouseX < columnWidth / 2 )
			setDragScrollProperties((columnWidth / 2 - mouseX) * -1, -1);
		else
			removeDragScrolling();
		
		setDragGuider();
    }
}

}