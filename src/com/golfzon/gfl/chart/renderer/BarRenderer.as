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

package com.golfzon.gfl.chart.renderer
{

import com.golfzon.gfl.controls.Label;
import com.golfzon.gfl.core.gz_internal;
import com.golfzon.gfl.styles.StyleProp;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Rectangle;

use namespace gz_internal;

/**
 *	@Author				SH Jung
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.12.01
 *	@Modify
 *	@Description
 */
public class BarRenderer extends RendererBase
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	@Constructor
	 */
	public function BarRenderer() {
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Overriden : RendererBase
	//--------------------------------------------------------------------------
	
	/**
	 *  랜더링
	 */
	override public function rendering(data:Class = null):Sprite {
		var sprite:Sprite = new Sprite();
		if( data ){
			var width:Number = gz_internal::value * gz_internal::dotPitch;
			var dataObject:DisplayObject = createSkinBy(data);
			dataObject.width = width < 0 ? width * -1 : width;
			dataObject.height = gz_internal::size;
			
			var dataSprite:Sprite = new Sprite()
			dataSprite.addChild(dataObject);

			var bitmapData:BitmapData = new BitmapData(dataSprite.width, dataSprite.height);
			bitmapData.draw(dataSprite);
			sprite.graphics.beginBitmapFill(bitmapData);
		}
		else{
			sprite.graphics.beginFill(gz_internal::color);
		}
		sprite.graphics.drawRect(0, 0, gz_internal::value * gz_internal::dotPitch, gz_internal::size);
		sprite.graphics.endFill();
		
		var rendererLabel:Bitmap = rendererLabel();
		rendererLabel.x = gz_internal::value * gz_internal::dotPitch;
		if( rendererLabel.x < 0 ) rendererLabel.x -= rendererLabel.width + 1;
		rendererLabel.y = (gz_internal::size - rendererLabel.height) / 2;
		sprite.addChild(rendererLabel);
		
		return sprite;
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	/**
	 *  랜더러 레이블
	 */
	private function rendererLabel():Bitmap {
		var sprite:Sprite = new Sprite();
		var label:Label = new Label();
		label.setStyle(StyleProp.COLOR, gz_internal::color);
		label.text = String(gz_internal::value);
		sprite.addChild(label);
		
		var bitmapData1:BitmapData = new BitmapData(sprite.width, sprite.height, true, 0xFFFFFF);
		bitmapData1.draw(label);
		bitmapData1.copyPixels(bitmapData1, new Rectangle(2, 2, sprite.width - 2, sprite.height - 2), new Point(0, 0));
		
		var bitmapData2:BitmapData = new BitmapData(sprite.width - 4, sprite.height - 4, true, 0xFFFFFF);
		bitmapData2.draw(bitmapData1);
		return new Bitmap(bitmapData2);
	}
}

}