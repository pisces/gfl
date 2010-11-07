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
 *	@Author				KH Kim
 *	@Version			1.0 beta
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
		
		if( usable ) {
    		var t:Number = getBorderThickness();
    		var x:Number = listOwner.viewMetrics.left + dependentTarget.x + t;
    		var y:Number = listOwner.viewMetrics.top + dependentTarget.y + t;
    		var cw:Number = listOwner.gz_internal::contentPane.width + t;
    		var ch:Number = listOwner.gz_internal::contentPane.height + t;
    		
    		var w:Number = x + listOwner.columnWidth > cw ?
    			listOwner.columnWidth - ((x + listOwner.columnWidth) - cw) :
    			listOwner.columnWidth;

    		var h:Number = y + listOwner.rowHeight > ch ?
    			listOwner.rowHeight - ((y + listOwner.rowHeight) - ch) :
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
    
    //--------------------------------------------------------------------------
    //  Internal
    //--------------------------------------------------------------------------
    
	/**
	 *	@private
	 */
    private function getBorderThickness():Number {
    	return !listOwner || listOwner.getStyle(StyleProp.BACKGROUND_IMAGE) ?
    		0 : replaceNullorUndefined(listOwner.getStyle(StyleProp.BORDER_THICKNESS), 1);
    }
    
	/**
	 *	@private
	 */
    private function newBitmapData(color:uint):BitmapData {
    	return new BitmapData(1, 1, false, color);
    }
}

}