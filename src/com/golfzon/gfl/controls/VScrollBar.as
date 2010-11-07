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

package com.golfzon.gfl.controls
{

import com.golfzon.gfl.controls.scrollBarClasses.ScrollBarBase;
import com.golfzon.gfl.controls.scrollBarClasses.ScrollBarDirection;
import com.golfzon.gfl.core.gz_internal;
import com.golfzon.gfl.nullObject.NullVScrollBar;

import flash.events.MouseEvent;

use namespace gz_internal;

/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.09.22
 *	@Modify
 *	@Description
 * 	@includeExample		VScrollBarSample.as
 */
public class VScrollBar extends ScrollBarBase
{
    //--------------------------------------------------------------------------
	//
	//	Class variables
	//
    //--------------------------------------------------------------------------
    
	private static var nullInstance:NullVScrollBar;
	
	/**
	 *	@Constructor
	 */
	public function VScrollBar() {
		super();
		
		_direction = ScrollBarDirection.VERTICAL;
		height = 200;
	}
	
    //--------------------------------------------------------------------------
	//
	//	Class methods
	//
    //--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------
    //  Public
    //--------------------------------------------------------------------------
    
    /**
     *	새로운 NullVScrollBar 인스턴스를 생성해 반환한다.
     */
    public static function newNull():NullVScrollBar {
    	if( nullInstance )	return nullInstance;
    	return new NullVScrollBar();
    }
    
    /**
     * 	컴퍼넌트의 기본 크기와 최소 크기를 설정한다.
     */
    override protected function measure():void {
    	super.measure();

		arrowSize = Math.max(downArrow.height, upArrow.height);
			
		if( !widthChanged )
			measureWidth = arrowSize;
		
		setActureSize(unscaledWidth, unscaledHeight);
    }
}

}