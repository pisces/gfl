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
 *	@Date				2009.12.07
 *	@Modify
 *	@Description
 */
public class ColumnRenderer extends RendererBase
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	@Constructor
	 */
	public function ColumnRenderer() {
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
		if( data ) {
			var height:Number = gz_internal::value * gz_internal::dotPitch;
			var dataObject:DisplayObject = createSkinBy(data);
			dataObject.width = gz_internal::size
			dataObject.height = height < 0 ? height * -1 : height;
			
			var dataSprite:Sprite = new Sprite()
			dataSprite.addChild(dataObject);

			var bitmapData:BitmapData = new BitmapData(dataSprite.width, dataSprite.height);
			bitmapData.draw(dataSprite);
			sprite.graphics.beginBitmapFill(bitmapData);
		} else {
			sprite.graphics.beginFill(gz_internal::color);
		}
		sprite.graphics.drawRect(0, gz_internal::value * gz_internal::dotPitch * - 1, gz_internal::size, gz_internal::value * gz_internal::dotPitch);
		sprite.graphics.endFill();
		
		var rendererLabel:Bitmap = rendererLabel();
		rendererLabel.rotation = 270
		rendererLabel.x = (gz_internal::size - rendererLabel.width) / 2;
		rendererLabel.y = gz_internal::value * gz_internal::dotPitch * -1;
		if( rendererLabel.y > 0 ) rendererLabel.y += rendererLabel.height;
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