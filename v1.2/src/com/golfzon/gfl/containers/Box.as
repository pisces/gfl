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
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.display.DisplayObject;

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  가로 정렬 방식<br>
 * 	@default value left
 */
[Style(name="horizontalAlign", type="String", inherit="no")]

/**
 *  세로 정렬 방식<br>
 * 	@default value top
 */
[Style(name="verticalalAlign", type="String", inherit="no")]

/**
 *	@Author				KHKim
 *	@Version			1.2 beta
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
		
		setActualSize(unscaledWidth, unscaledHeight);
	}
	
	/**
	 *	스타일 프로퍼티로 값을 설정한다.
	 */
	override public function styleChanged(styleProp:String):void {
		super.styleChanged(styleProp);

		switch( styleProp ) {
			case StyleProp.HORIZONTAL_ALIGN: case StyleProp.VERTICAL_ALIGN:
				invalidateDisplayList();
				break;
	 	}
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	protected function getAlignedChildX(child:DisplayObject):Number {
		var horizontalAlign:String = replaceNullorUndefined(getStyle(StyleProp.HORIZONTAL_ALIGN), "left");
		if( horizontalAlign == "center" )
			return (getContentPaneWidth() - child.width) / 2;
		if( horizontalAlign == "right" )
			return getContentPaneWidth() - child.width;
		return 0;
	}
	
	protected function getAlignedChildY(child:DisplayObject):Number {
		var verticalAlign:String = replaceNullorUndefined(getStyle(StyleProp.VERTICAL_ALIGN), "top");
		if( verticalAlign == "middle" )
			return (getContentPaneHeight() - child.height) / 2;
		if( verticalAlign == "bottom" )
			return getContentPaneHeight() - child.height;
		return 0;
	}
	
	protected function updateContentPaneChildProperties():void {
		largestChildPoint.x = largestChildPoint.y = 0;
		for( var i:int=0; i<numChildren; i++ ) {
			var child:DisplayObject = getChildAt(i);
			child.x = getAlignedChildX(child);
			child.y = getAlignedChildY(child);
			compareLargestChildPoint(child);
		}
	}
}

}