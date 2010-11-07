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
 *	@Author				KHKim
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.10.30
 *	@Modify
 *	@Description
 * 	@includeExample		HBoxSample.as
 */
public class HBox extends Box
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	private var widthSum:Number;
	
	/**
	 *	@Constructor
	 */
	public function HBox() {
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Overriden : Box
	//--------------------------------------------------------------------------
	
	/**
	 *	스타일 프로퍼티로 값을 설정한다.
	 */
	override public function styleChanged(styleProp:String):void {
		super.styleChanged(styleProp);
		
		switch( styleProp ) {
			case StyleProp.HORIZONTAL_GAP:
				invalidateDisplayList();
				break;
	 	}
	}
	
	override protected function updateContentPaneChildProperties():void {
		widthSum = largestChildPoint.x = largestChildPoint.y = 0;
		
		var horizontalGap:Number = replaceNullorUndefined(getStyle(StyleProp.HORIZONTAL_GAP), 10);
		var newX:Number = 0;
		var num:Number = numChildren;
		for( var i:int=0; i<num; i++ ) {
			var child:DisplayObject = getChildAt(i);
			child.x = newX;
			child.y = getAlignedChildY(child);
			compareLargestChildPoint(child);
			newX = child.x + child.width + horizontalGap;
			widthSum += child.width;
		}
		widthSum += horizontalGap * (num-1);
	}
	
	/**
	 * 	디스플레이 변경 사항에 대한 처리
	 */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		var addendX:Number = getAddendX();
		for( var i:int=0; i<numChildren; i++ ) {
			var child:DisplayObject = getChildAt(i);
			child.x += addendX;
		}
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	private function getAddendX():Number {
		var horizontalAlign:String = replaceNullorUndefined(getStyle(StyleProp.HORIZONTAL_ALIGN), "left");
		if( horizontalAlign == "center" )
			return (getContentPaneWidth() - widthSum) / 2;
		if( horizontalAlign == "right" )
			return getContentPaneWidth() - widthSum;
		return 0;
	}
}

}