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
import com.golfzon.gfl.nullObject.NullHScrollBar;

use namespace gz_internal;

/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.09.21
 *	@Modify
 *	@Description
 * 	@includeExample		HScrollBarSample.as
 */
public class HScrollBar extends ScrollBarBase
{
    //--------------------------------------------------------------------------
	//
	//	Class variables
	//
    //--------------------------------------------------------------------------
    
	private static var nullInstance:NullHScrollBar;
	
	/**
	 *	@Constructor
	 */
	public function HScrollBar() {
		super();
		
		_direction = ScrollBarDirection.HORIZONTAL;
		width = 120;
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
     *	새로운 NullHScrollBar 인스턴스를 생성해 반환한다.
     */
    public static function newNull():NullHScrollBar {
    	if( nullInstance )	return nullInstance;
    	return new NullHScrollBar();
    }
	
    //--------------------------------------------------------------------------
	//
	//	Instance methods
	//
    //--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------
    //  Overriden : ScrollBarBase
    //--------------------------------------------------------------------------
    
    /**
     * 	자식 객체 생성 및 추가
     */
	override protected function createChildren():void {
		super.createChildren();
		
		gz_internal::upArrow.rotation = 90;
		gz_internal::downArrow.rotation = 90;
	}
    
    /**
     * 	컴퍼넌트의 기본 크기와 최소 크기를 설정한다.
     */
    override protected function measure():void {
    	super.measure();

		arrowSize = Math.max(downArrow.width, upArrow.width);
			
		if( !heightChanged )
			measureHeight = arrowSize;
		
		setActureSize(unscaledWidth, unscaledHeight);
    }
}

}