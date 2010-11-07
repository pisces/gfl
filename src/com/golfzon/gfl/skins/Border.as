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

package com.golfzon.gfl.skins
{
	
import com.golfzon.gfl.core.ComponentBase;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.isNothing;
import com.golfzon.gfl.utils.replaceNullorUndefined;
import com.golfzon.gfl.utils.touint;

import flash.display.DisplayObject;

/**
 *	@Include the external file to define background styles.
 */
include "../styles/metadata/BackgroundStyles.as";

/**
 * 
 *	@Include the external file to define padding styles.
 *
 */
include "../styles/metadata/PaddingStyles.as";

/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.09.24
 *	@Modify
 *	@Description
 */
public class Border extends ComponentBase
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	protected var backgroundColor:uint = 0xFFFFFF;
	protected var borderColor:uint = 0xBDC7D8;
	
	protected var backgroundAlpha:Number = 1;
	protected var borderThickness:Number = 1;
	protected var cornerRadius:Number = 0;
	
	private var backgroundInstance:DisplayObject;
	
	/**
	 *	@Constructor
	 */
	public function Border() {
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Overriden : ComponentBase
	//--------------------------------------------------------------------------
	
	override protected function createChildren():void {
		updateBackground();
	}
	
	/**
	 *	스타일 속성이 바뀌었을 시점에 대한 구현
	 */
	override public function styleChanged(styleProp:String):void {
		switch( styleProp ) {
			case StyleProp.BACKGROUND_ALPHA:	case StyleProp.BACKGROUND_COLOR:
			case StyleProp.BORDER_COLOR:		case StyleProp.BORDER_THICKNESS:
			case StyleProp.CORNER_RADIUS:
				drawBorder();
				break;
				
			case StyleProp.BACKGROUND_IMAGE:
				updateBackground();
				break;
		}
	}
	
	/**
	 * 	디스플레이 변경 사항에 대한 처리
	 */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		if( backgroundInstance ) {
			backgroundInstance.width = unscaledWidth;
			backgroundInstance.height = unscaledHeight;
		} else {
			drawBorder();
		}
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	/**
	 *	@private
	 */
	protected function canDraw():Boolean {
		return isNothing(getStyle(StyleProp.BACKGROUND_IMAGE)) &&
			!isNaN(unscaledWidth) && unscaledWidth > 0  &&
			!isNaN(unscaledHeight) && unscaledHeight > 0;
	}
	
	/**
	 *	@private
	 */
	private function createBackground():void {
		var SkinClass:Class = getStyle(StyleProp.BACKGROUND_IMAGE) as Class;
		if( SkinClass ) {
			graphics.clear();
			backgroundInstance = createSkinBy(SkinClass);
			addChildAt(backgroundInstance, 0);
		}
	}
	
	/**
	 *	@private
	 */
	protected function drawBorder():void {
		graphics.clear();
		
		if( isNaN(unscaledWidth) || isNaN(unscaledHeight) )
			return;

		if( canDraw() ) {
			var backgroundAlpha:Number = replaceNullorUndefined(getStyle(StyleProp.BACKGROUND_ALPHA), this.backgroundAlpha);
			var backgroundColor:uint = touint(replaceNullorUndefined(getStyle(StyleProp.BACKGROUND_COLOR), this.backgroundColor));
			var borderColor:uint = replaceNullorUndefined(getStyle(StyleProp.BORDER_COLOR), this.borderColor);
			var borderThickness:Number = replaceNullorUndefined(getStyle(StyleProp.BORDER_THICKNESS), this.borderThickness);
			var cornerRadius:Number = replaceNullorUndefined(getStyle(StyleProp.CORNER_RADIUS), this.cornerRadius);
			
			if( cornerRadius > 0 ) {
				if( borderThickness > 0 ) {
					graphics.beginFill(borderColor);
					graphics.drawRoundRect(0, 0, unscaledWidth, unscaledHeight, cornerRadius);
				}

				graphics.beginFill(backgroundColor, backgroundAlpha);
				graphics.drawRoundRect(borderThickness, borderThickness,
					unscaledWidth - borderThickness * 2, unscaledHeight - borderThickness * 2, cornerRadius);
			} else {
				if( borderThickness > 0 ) {
					graphics.beginFill(borderColor);
					graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
				}
				
				graphics.beginFill(backgroundColor, backgroundAlpha);
				graphics.drawRect(borderThickness, borderThickness,
					unscaledWidth - borderThickness * 2, unscaledHeight - borderThickness * 2);
			}
				
			graphics.endFill();
		}
	}
	
	/**
	 *	@private
	 */
	private function removeBackground():void {
		if( backgroundInstance && contains(backgroundInstance) ) {
			removeChild(backgroundInstance);
			backgroundInstance = null;
		}
	}
	
	/**
	 *	@private
	 */
	private function updateBackground():void {
		removeBackground();
		createBackground();
	}
}

}