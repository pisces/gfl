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

package com.golfzon.gfl.skins.blueTheme
{

import com.golfzon.gfl.skins.Border;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;
import com.golfzon.gfl.utils.touint;

/**
 *	@Author				KHKim
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.11.18
 *	@Modify
 *	@Description
 */
public class ButtonSkin extends Border
{
	/**
	 *	@Constructor
	 */
	public function ButtonSkin() {
		super();
		
		_backgroundColor = 0x637BAD;
		_borderColor = 0x29447E;
	}
	
	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Overriden : Border
	//--------------------------------------------------------------------------
	
	/**
	 * 	컴퍼넌트의 기본 크기와 최소 크기를 설정한다.
	 */
	override protected function measure():void {
		super.measure();

		if( isNaN(measureWidth) )
			measureWidth = 50;
			
		if( isNaN(measureHeight) )
			measureHeight = 20;

		setActualSize(unscaledWidth, unscaledHeight);
	}
}

}