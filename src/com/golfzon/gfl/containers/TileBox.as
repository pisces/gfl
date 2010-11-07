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
	
import com.golfzon.gfl.skins.Border;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.display.DisplayObject;
import flash.display.Shape;
import flash.events.Event;

/**
 *	@Author				KHKim
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.10.30
 *	@Modify
 *	@Description
 * 	@includeExample		TileBoxSample.as
 */
public class TileBox extends Box
{
	private var maskStack:Vector.<Shape> = new Vector.<Shape>();
	
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
			case StyleProp.BACKGROUND_ALPHA: case StyleProp.BACKGROUND_COLOR:
			case StyleProp.BACKGROUND_IMAGE: case StyleProp.BORDER_COLOR:
			case StyleProp.BORDER_THICKNESS: case StyleProp.CORNER_RADIUS:
				invalidateDisplayList();
				break;
	 	}
	}
	
	/**
	 * 	컴퍼넌트의 기본 크기와 최소 크기를 설정한다.
	 */
	override protected function updateChildDisplay():void {
		super.updateChildDisplay();
		
		removeMaskStack();
		
		maskStack = new Vector.<Shape>();
		
		var w:Number = getContentPaneWidth() / _columnCount;
		var h:Number = getContentPaneHeight() / _rowCount;
		for( var i:int=0; i<numChildren; i++ ) {
			var ox:Number = (i%_columnCount) * w;
			var oy:Number = Math.floor(i/_columnCount) * h;
			var child:DisplayObject = getChildAt(i);
			child.x = int(getChildXBy(child, ox, w));
			child.y = int(getChildYBy(child, oy, h));
			
			var mask:Shape = new Shape();
			mask.graphics.beginFill(0x0);
			mask.graphics.drawRect(contentPane.x+ox, contentPane.y+oy, w, h);
			mask.graphics.endFill();
			
			rawChildren.addChild(mask);
			child.mask = mask;
			maskStack.push(mask);
		}
		
		drawBorder();
	}
	
	override protected function updateContentPaneChildProperties():void {
		var borderThickness:Number = getBorderThickness();
		largestChildPoint.x = unscaledWidth - borderThickness * 2 - viewMetrics.left - viewMetrics.right;
		largestChildPoint.y = unscaledHeight - borderThickness * 2 - viewMetrics.top - viewMetrics.bottom;
	}
	
	override protected function child_propertyChangeHandler(event:Event):void {
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	private function drawBorder():void {
		var border:Border = this.border as Border;
		if( border ) {
			var w:Number = getContentPaneWidth()/_columnCount;
			var h:Number = getContentPaneHeight()/_rowCount;
			var backgroundColor:uint = border.backgroundColor;
			var borderColor:uint = border.borderColor;
			var bt:Number = border.borderThickness;
			if (bt > 0) {
				border.graphics.beginFill(backgroundColor, 1);
				border.graphics.lineStyle(bt, borderColor);
				
				for( var i:int=1; i<_columnCount; i++ ) {
					var ox:Number = (i%_columnCount) * w;
					border.graphics.moveTo(contentPane.x+ox, contentPane.y);
					border.graphics.lineTo(contentPane.x+ox, contentPane.y+getContentPaneHeight());
				}
				
				for( var j:int=1; j<_rowCount; j++ ) {
					var oy:Number = (j%_rowCount) * h;
					border.graphics.moveTo(contentPane.x, contentPane.y+oy);
					border.graphics.lineTo(contentPane.x+getContentPaneWidth(), contentPane.y+oy);
				}
				border.graphics.endFill();
			}
		}
	}
	
	private function getChildXBy(child:DisplayObject, xOffset:Number, tileWidth:Number):Number {
		var horizontalAlign:String = replaceNullorUndefined(getStyle(StyleProp.HORIZONTAL_ALIGN), "left");
		if( horizontalAlign == "center" )
			return xOffset + (tileWidth - child.width)/2;
		if( horizontalAlign == "right" )
			return xOffset + tileWidth - child.width;
		return xOffset;
	}
	
	private function getChildYBy(child:DisplayObject, yOffset:Number, tileHeight:Number):Number {
		var verticalAlign:String = replaceNullorUndefined(getStyle(StyleProp.VERTICAL_ALIGN), "top");
		if( verticalAlign == "middle" )
			return yOffset + (tileHeight - child.height)/2;
		if( verticalAlign == "bottom" )
			return yOffset + tileHeight - child.height;
		return yOffset;
	}
	
	private function removeMaskStack():void {
		for each( var m:Shape in maskStack ) {
			rawChildren.removeChild(m);
		}
		maskStack = null;
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
	
	//--------------------------------------
	//	rowCount
	//--------------------------------------
	
	private var _rowCount:uint = 3;
	
	public function get rowCount():uint {
		return _rowCount;
	}
	
	public function set rowCount(value:uint):void {
		if( value == _rowCount )
			return;
		
		_rowCount = value;
		
		invalidateDisplayList();
	}
}

}