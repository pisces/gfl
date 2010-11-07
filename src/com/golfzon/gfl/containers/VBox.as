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
 * 	@includeExample		VBoxSample.as
 */
public class VBox extends Box
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	private var heightSum:Number;
	
	/**
	 *	@Constructor
	 */
	public function VBox() {
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
			case StyleProp.VERTICAL_GAP:
				invalidateDisplayList();
				break;
	 	}
	}
	
	override protected function updateContentPaneChildProperties():void {
		heightSum = largestChildPoint.x = largestChildPoint.y = 0;
		
		var verticalGap:Number = replaceNullorUndefined(getStyle(StyleProp.VERTICAL_GAP), 10);
		var newY:Number = 0;
		var num:Number = numChildren;
		for( var i:int=0; i<num; i++ ) {
			var child:DisplayObject = getChildAt(i);
			child.x = getAlignedChildX(child);
			child.y = newY;
			compareLargestChildPoint(child);
			newY = child.y + child.height + verticalGap;
			heightSum += child.height;
		}
		heightSum += verticalGap * (num-1);
	}
	
	/**
	 * 	디스플레이 변경 사항에 대한 처리
	 */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		var addendY:Number = getAddendY();
		for( var i:int=0; i<numChildren; i++ ) {
			var child:DisplayObject = getChildAt(i);
			child.y += addendY;
		}
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	private function getAddendY():Number {
		var verticalAlign:String = replaceNullorUndefined(getStyle(StyleProp.VERTICAL_ALIGN), "top");
		if( verticalAlign == "middle" )
			return (getContentPaneHeight() - heightSum) / 2;
		if( verticalAlign == "bottom" )
			return getContentPaneHeight() - heightSum;
		return 0;
	}
}

}