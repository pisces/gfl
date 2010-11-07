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

package com.golfzon.gfl.core
{
	
import com.golfzon.gfl.skins.Border;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.display.DisplayObject;
	
//--------------------------------------
//  Styles
//--------------------------------------

/**
 *	@Include the external file to define background styles.
 */
include "../styles/metadata/BackgroundStyles.as";
	
/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.12.08
 *	@Modify
 *	@Description
 */
public class BorderBasedComponent extends ComponentBase
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	protected var defaultBorderClass:Class = Border;
	
	protected var border:DisplayObject;
	
	/**
	 *	@Constructor
	 */
	public function BorderBasedComponent() {
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
	
	/**
	 * 	자식 객체 생성 및 추가
	 */
	override protected function createChildren():void {
		super.createChildren();
		
		border = createBorder();
		
		setViewMetrics();
	}
	
	
	/**
	 *	스타일 프로퍼티로 값을 설정한다.
	 */
	override public function styleChanged(styleProp:String):void {
		super.styleChanged(styleProp);

		switch( styleProp ) {
			case StyleProp.PADDING_LEFT: case StyleProp.PADDING_TOP:
			case StyleProp.PADDING_RIGHT: case StyleProp.PADDING_BOTTOM:
				setViewMetrics();
				invalidateDisplayList();
				break;
				
			case StyleProp.BORDER_SKIN:
				removeBorder();
				border = createBorder();
				break;
				
			case StyleProp.BACKGROUND_ALPHA: case StyleProp.BACKGROUND_COLOR:
			case StyleProp.BACKGROUND_IMAGE: case StyleProp.BORDER_COLOR:
			case StyleProp.BORDER_THICKNESS: case StyleProp.CORNER_RADIUS:
				if( border is Border ) {
					Border(border).setStyle(styleProp, getStyle(styleProp));
					invalidateDisplayList();
				}
				break;
	 	}
	}
	
	/**
	 * 	디스플레이 변경 사항에 대한 처리
	 */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		if( border ) {
			border.width = unscaledWidth;
			border.height = unscaledHeight;
		}
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	/**
	 * 	@private
	 */
	private function createBorder():DisplayObject {
		var borderClass:Class = replaceNullorUndefined(
			getStyle(StyleProp.BORDER_SKIN), defaultBorderClass ? defaultBorderClass : Border);
		if( borderClass ) {
			var border:DisplayObject = createSkinBy(borderClass);
			border.width = unscaledWidth;
			border.height = unscaledHeight;
			
			if( border is IInteractiveObject )
				IInteractiveObject(border).enabled = enabled;
				
			addChildAt(border, 0);
			
			if( border is Border )
				Border(border).styleName = getCSSStyleDeclaration();
			
			return border;
		}
		return null;
	}
	
	/**
	 * 	@private
	 */
	private function removeBorder():void {
		if( border && contains(border) ) {
			removeChild(border);
			border = null;
		}
	}
	
	/**
	 *	@private
	 */
	private function setViewMetrics(defaultValue:Number=0):void {
		_viewMetrics = new EdgeMetrics(
			replaceNullorUndefined(getStyle(StyleProp.PADDING_LEFT), defaultValue),
			replaceNullorUndefined(getStyle(StyleProp.PADDING_TOP), defaultValue),
			replaceNullorUndefined(getStyle(StyleProp.PADDING_RIGHT), defaultValue),
			replaceNullorUndefined(getStyle(StyleProp.PADDING_BOTTOM), defaultValue)
		);
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//  viewMetrics
	//--------------------------------------
	
	private var _viewMetrics:EdgeMetrics;
	
	public function get viewMetrics():EdgeMetrics {
		return _viewMetrics;
	}
}

}