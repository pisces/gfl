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
	
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
	
/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.10.05
 *	@Modify
 *	@Description
 * 	@includeExample		TileListSample.as
 */
public class TileList extends List
{
	/**
	 *	@Constructor
	 */
	public function TileList() {
		super();
		
		columnCount = 3;
		rowCount = 3;
	}
	
	
    //--------------------------------------------------------------------------
	//
	//	Event handlers
	//
    //--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------
    //  Overriden : ListBase
    //--------------------------------------------------------------------------
    
	/**
	 *  @protected
	 */	
	override protected function keyDownHandler(event:KeyboardEvent):void {
		if( !dataProvider )
			return;
		
		switch( event.keyCode ) {
			case Keyboard.LEFT:	selectedIndex = selectedIndex % columnCount != 0 ? selectedIndex - 1 : selectedIndex;
				break;
				
			case Keyboard.RIGHT:
				selectedIndex = selectedIndex % columnCount != columnCount - 1 && selectedIndex != dataProvider.length - 1 ? selectedIndex + 1 : selectedIndex;
				break;
				
			case Keyboard.UP:
				selectedIndex = selectedIndex - columnCount > -1 ? selectedIndex - columnCount : selectedIndex;
				break;
				
			case Keyboard.DOWN:
				selectedIndex = selectedIndex + columnCount < dataProvider.length ? selectedIndex + columnCount : selectedIndex;
				break;
		}
	}
}

}