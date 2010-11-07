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

import flash.display.GradientType;
import flash.display.SpreadMethod;
import flash.display.Sprite;
import flash.filters.BitmapFilterQuality;
import flash.filters.GlowFilter;
import flash.geom.Matrix;

import org.casalib.math.geom.Ellipse;
import org.casalib.util.DrawUtil;

use namespace gz_internal;

/**
 *	@Author				SH Jung
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.12.10
 *	@Modify
 *	@Description
 */
public class PieRenderer extends RendererBase
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	@Constructor
	 */
	public function PieRenderer() {
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
	
	override public function rendering(data:Class = null):Sprite {
		var sprite:Sprite = new Sprite();
		beginFill(sprite);
		beginGradientFill(sprite);
		glowFilter(sprite);
		addLabel(sprite);
		
		return sprite;
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	/**
	 *  addLabel
	 */
	private function addLabel(client:Sprite):void {
		var startAngle:Number = _startAngle + 90 - _arc / 2;
		var radius:Number = _ellipse.width / 1.2 * .5;
		var yRadius:Number = _ellipse.height / 1.2 * .5;
		var x:Number = _ellipse.x + radius * 1.2;
		var y:Number = _ellipse.y + yRadius * 1.2;
		var ax:Number = x + Math.cos(startAngle / 180 * Math.PI) * radius;
		var ay:Number = y + Math.sin(-startAngle / 180 * Math.PI) * yRadius;
		var label:Label = new Label();
		
		label.text = _data;
		client.addChild(label);
		label.x = ax - label.width / 2;
		label.y = ay - label.height / 2;
	}
	
	/**
	 *  beginFill
	 */
	private function beginFill(client:Sprite):void {
		client.graphics.beginFill(gz_internal::color);
		DrawUtil.drawWedge(client.graphics, _ellipse, _startAngle, _arc);
		client.graphics.endFill();
	}
	
	/**
	 *  beginGradientFill
	 */
	private function beginGradientFill(client:Sprite):void {
		var alphas:Array = [0.9, 0];
		var colors:Array = [0xFFFFFF, 0xFFFFFF];
		var fillType:String = GradientType.LINEAR;
		var matr:Matrix = new Matrix();
		var spreadMethod:String = SpreadMethod.PAD;
		var ratios:Array = [0, 255];
		
		matr.createGradientBox(client.width, client.height, Math.PI / 2, 0, 0);
		client.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);  
		DrawUtil.drawWedge(client.graphics, _ellipse, _startAngle, _arc);
		client.graphics.endFill();
	}
	
	/**
	 *  glowFilter
	 */
	private function glowFilter(client:Sprite):void { 
		var glow:GlowFilter = new GlowFilter();
		glow.alpha = 0.5;
		glow.blurX = 2;
		glow.blurY = 2;
		glow.color = 0x000000;
		glow.quality = BitmapFilterQuality.LOW;
		client.filters = [glow];
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//	arc
	//--------------------------------------
	
	private var _arc:Number;
	
	public function set arc(value:Number):void {
		if( _arc == value )
			return;
		
		_arc = value;
	}
	
	//--------------------------------------
	//	data
	//--------------------------------------
	
	private var _data:String;
	
	public function set data(value:String):void {
		if( _data == value )
			return;
		
		_data = value;
	}
	
	//--------------------------------------
	//	ellipse
	//--------------------------------------
	
	private var _ellipse:Ellipse;
	
	public function set ellipse(client:Ellipse):void {
		if( _ellipse == client )
			return;
		
		_ellipse = client;
	}
	
	//--------------------------------------
	//	startAngle
	//--------------------------------------
	
	private var _startAngle:Number;
	
	public function set startAngle(value:Number):void {
		if( _startAngle == value )
			return;
		
		_startAngle = value;
	}
}

}