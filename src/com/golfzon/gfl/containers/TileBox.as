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
	
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.display.DisplayObject;

/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.10.30
 *	@Modify
 *	@Description
 * 	@includeExample		TileBoxSample.as
 */
public class TileBox extends Box
{
	/**
	 *	@Constructor
	 */
	public function TileBox() {
		super();
	}
	
    //--------------------------------------------------------------------------
	//
	//	Instance methods
	//
    //--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------
    //  Overriden : TileBox
    //--------------------------------------------------------------------------
    
    /**
     *	스타일 프로퍼티로 값을 설정한다.
     */
    override public function styleChanged(styleProp:String):void {
    	super.styleChanged(styleProp);
    	
    	switch( styleProp ) {
    		case StyleProp.HORIZONTAL_GAP: case StyleProp.VERTICAL_GAP:
    			invalidateDisplayList();
    			break;
     	}
    }
    
    /**
     * 	@private
     */
    override protected function updateContentPaneChildProperties():void {
    	largestChildPoint.x = largestChildPoint.y = 0;
    	
    	var horizontalGap:Number = replaceNullorUndefined(getStyle(StyleProp.HORIZONTAL_GAP), 10);
    	var verticalGap:Number = replaceNullorUndefined(getStyle(StyleProp.VERTICAL_GAP), 10);
    	var newX:Number = 0;
    	var newY:Number = 0;
    	for( var i:int=0; i<numChildren; i++ ) {
    		var child:DisplayObject = getChildAt(i);
    		child.x = newX;
    		child.y = newY;
    		compareLargestChildPoint(child);
    		
    		var isCurrentIndex:Boolean = i % columnCount < columnCount - 1;
    		newX = isCurrentIndex ? Math.max(newX, child.x + child.width + horizontalGap) : 0;
    		newY = isCurrentIndex ? newY : largestChildPoint.y + verticalGap;
    	}
    }
	
    //--------------------------------------------------------------------------
	//
	//	getter / setter
	//
    //--------------------------------------------------------------------------
	
	//--------------------------------------
	//	columnCount
	//--------------------------------------
	
	private var _columnCount:uint = 3;
	
	public function get columnCount():uint {
		return _columnCount;
	}
	
	public function set columnCount(value:uint):void {
		if( value == _columnCount )
			return;
		
		_columnCount = value;
		
		invalidateDisplayList();
	}
}

}