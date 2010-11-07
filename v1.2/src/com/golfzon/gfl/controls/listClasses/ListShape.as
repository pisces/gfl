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

package com.golfzon.gfl.controls.listClasses
{
	
import com.golfzon.gfl.core.gz_internal;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Shape;

import gs.TweenMax;

use namespace gz_internal;

/**
 *	@Author				KHKim
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.10.01
 *	@Modify
 *	@Description
 */
public class ListShape extends Shape implements IListShape
{
	//--------------------------------------------------------------------------
	//
	//	Variable methods
	//
	//--------------------------------------------------------------------------
	
	private var bitmapData:BitmapData;
	
	private var listOwner:ListBase;
	
	/**
	 *	@Constructor
	 */
	public function ListShape(listOwner:ListBase) {
		super();
		
		if( !listOwner )	throw new Error("listOwner는 Null이 아니어야 합니다.");
		else				this.listOwner = listOwner;
	}
	
	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Public
	//--------------------------------------------------------------------------
	
	public function clear():void {
		graphics.clear();
	}
	
	public function drawBy(dependentTarget:DisplayObject, color:uint, usable:Boolean=true):void {
		graphics.clear();
		
		if( dependentTarget && usable ) {
			var t:Number = getBorderThickness();
			var x:Number = listOwner.gz_internal::contentPane.x + dependentTarget.x;
			var y:Number = listOwner.gz_internal::contentPane.y + dependentTarget.y;
			var cw:Number = listOwner.gz_internal::contentPane.width + t;
			var ch:Number = listOwner.gz_internal::contentPane.height + t;
			
			var w:Number = dependentTarget.x + listOwner.columnWidth > cw ?
				listOwner.columnWidth - ((dependentTarget.x + listOwner.columnWidth) - cw) - t :
				listOwner.columnWidth;

			var h:Number = dependentTarget.y + listOwner.rowHeight  > ch ?
				listOwner.rowHeight - ((dependentTarget.y + listOwner.rowHeight) - ch) - t :
				listOwner.rowHeight;
			
			graphics.beginBitmapFill(newBitmapData(color));
			graphics.drawRect(x, y, w, h);
			graphics.endFill();
		}
	}
	
	public function drawWithTransition(dependentTarget:DisplayObject, color:uint, duration:Number, usable:Boolean=true):void {
		alpha = 0;
		drawBy(dependentTarget, color, usable);
		TweenMax.to(this, duration, {alpha:1});
	}
	
	public function multiDraw(color:uint, usable:Boolean=true):void {
		graphics.clear();

		if( usable ) {
			var count:int = listOwner.selectedIndices.length;
			for( var i:uint=0; i<count; i++ ) {
				var index:int = listOwner.selectedIndices[i] -
					(listOwner.verticalLineIndex * listOwner.columnCount) -
					(listOwner.horizontalLineIndex * listOwner.rowCount);
				var dependentTarget:DisplayObject = listOwner.getItemRendererBy(index) as DisplayObject;

				if( !dependentTarget ) {
					continue;
				}
				
				var t:Number = getBorderThickness();
				var x:Number = listOwner.gz_internal::contentPane.x + dependentTarget.x;
				var y:Number = listOwner.gz_internal::contentPane.y + dependentTarget.y;
				var cw:Number = listOwner.gz_internal::contentPane.width + t;
				var ch:Number = listOwner.gz_internal::contentPane.height + t;
				
				var w:Number = dependentTarget.x + listOwner.columnWidth > cw ?
					listOwner.columnWidth - ((dependentTarget.x + listOwner.columnWidth) - cw) - t :
					listOwner.columnWidth;
				
				var h:Number = dependentTarget.y + listOwner.rowHeight  > ch ?
					listOwner.rowHeight - ((dependentTarget.y + listOwner.rowHeight) - ch) - t :
					listOwner.rowHeight;
				
				graphics.beginBitmapFill(newBitmapData(color));
				graphics.drawRect(x, y, w, h);
				graphics.endFill();
			}
		}
	}
	
	public function multiDrawWithTransition(color:uint, duration:Number, usable:Boolean=true):void {
		alpha = 0;
		multiDraw(color, usable);
		TweenMax.to(this, duration, {alpha:1});
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	private function getBorderThickness():Number {
		return !listOwner || listOwner.getStyle(StyleProp.BACKGROUND_IMAGE) ?
			0 : replaceNullorUndefined(listOwner.getStyle(StyleProp.BORDER_THICKNESS), 1);
	}
	
	private function newBitmapData(color:uint):BitmapData {
		return new BitmapData(1, 1, false, color);
	}
}

}