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

package com.golfzon.gfl.preloaders
{

import com.golfzon.gfl.controls.ProgressBar;
import com.golfzon.gfl.controls.progressBarClasses.ProgressBarMode;

/**
 *	@Author				KHKim
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.10.20
 *	@Modify
 *	@Description
 */
public class Preloader extends ProgressBar implements IPreloader
{
	/**
	 *	@Constructor
	 */
	public function Preloader() {
		super();
		
		mode = ProgressBarMode.POLLED;
		
		setActualSize(26, 25);
		setProgress(0, 0);
	}
	
	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Public
	//--------------------------------------------------------------------------
	
	/**
	 *	CSS 로딩 프로그레스
	 */
	public function setCSSFileProgress(currentValue:Number, totalValue:Number):void {
		setProgress(currentValue, totalValue);
	}
}

}