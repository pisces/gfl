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

package com.golfzon.gfl.containers
{
	
import com.golfzon.gfl.core.Container;

import flash.display.DisplayObject;

/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.10.29
 *	@Modify
 *	@Description
 * 	@includeExample		BoxSample.as
 */
public class Box extends Container
{
	/**
	 *	@Constructor
	 */
	public function Box() {
		super();
	}
	
    //--------------------------------------------------------------------------
	//
	//	Instance methods
	//
    //--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------
    //  Overriden : Container
    //--------------------------------------------------------------------------
    
    /**
     * 	컴퍼넌트의 기본 크기와 최소 크기를 설정한다.
     */
    override protected function measure():void {
    	super.measure();
    	
    	updateContentPaneChildProperties();
    	
    	var borderThickness:Number = getBorderThickness();

    	if( !widthChanged )
    		measureWidth = largestChildPoint.x + borderThickness * 2 + viewMetrics.left + viewMetrics.right;
    	
    	if( !heightChanged )
    		measureHeight = largestChildPoint.y + borderThickness * 2 + viewMetrics.top + viewMetrics.bottom;
    	
    	setActureSize(unscaledWidth, unscaledHeight);
    }
    
    //--------------------------------------------------------------------------
    //  Internal
    //--------------------------------------------------------------------------
    
    /**
     * 	@private
     */
    protected function updateContentPaneChildProperties():void {
    	largestChildPoint.x = largestChildPoint.y = 0;
    	for( var i:int=0; i<numChildren; i++ ) {
    		var child:DisplayObject = getChildAt(i);
    		child.x = 0;
    		child.y = 0;
    		compareLargestChildPoint(child);
    	}
    }
}

}