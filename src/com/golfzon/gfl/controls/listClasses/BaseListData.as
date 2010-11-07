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

package com.golfzon.gfl.controls.listClasses
{

import com.golfzon.gfl.core.ComponentBase;
	
/**
 *	@Author				KHKim
 *	@Version			1.0
 *	@Lanaguage			Action Script 3.0
 *	@Date				2010. 4. 14.
 *	@Modify
 *	@Description
 */
public class BaseListData
{
	//--------------------------------------------------------------------------
	//
	//  Instance variables
	//
	//--------------------------------------------------------------------------
	
	public var label:String;
	public var uid:String;
	public var owner:ComponentBase;
	public var rowIndex:int;
	public var columnIndex:int;
	
	/**
	 *	@Constructor
	 */
	public function BaseListData(label:String, uid:String, owner:ComponentBase, rowIndex:int=0, columnIndex:int=0) {
		this.label = label;
		this.uid = uid;
		this.owner = owner;
		this.rowIndex = rowIndex;
		this.columnIndex = columnIndex;
	}
}
	
}