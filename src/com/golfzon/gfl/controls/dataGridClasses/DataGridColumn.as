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

package com.golfzon.gfl.controls.dataGridClasses
{

import com.golfzon.gfl.core.ClassFactory;
import com.golfzon.gfl.core.ComponentBase;

/**
 *	@Author				HJ Kim
 *	@Version			1.0
 *	@Lanaguage			Action Script 3.0
 *	@Date				2010.01.21
 *	@Modify
 *	@Description
 */
public class DataGridColumn extends ComponentBase
{
	/**
	 * 	@Construct
	 */
	public function DataGridColumn(){
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//	headerText
	//--------------------------------------
	
	private var _headerText:String;

	public function get headerText():String {
		return _headerText
	}
	
	public function set headerText(value:String):void {
		if( value == _headerText )
			return;
			
		_headerText = value;
	}
	
	//--------------------------------------
	//	itemRenderer
	//--------------------------------------
	
	private var _itemRenderer:ClassFactory = new ClassFactory(DataGridItemRenderer);

	public function get itemRenderer():ClassFactory {
		return _itemRenderer
	}
	
	public function set itemRenderer(value:ClassFactory):void {
		if( value === _itemRenderer )
			return;
			
		_itemRenderer = value;
	}

	//--------------------------------------
	//	_headerRenderer
	//--------------------------------------
	
	private var _headerRenderer:ClassFactory = new ClassFactory(DataGridHeaderRenderer);

	public function get headerRenderer():ClassFactory {
		return _headerRenderer
	}
	
	public function set headerRenderer(value:ClassFactory):void {
		if( value === _headerRenderer )
			return;
			
		_headerRenderer = value;
	}

	//--------------------------------------
	//	dataField
	//--------------------------------------
	
	private var _dataField:String;
	
	public function get dataField():String {
		return _dataField;
	}
	
	public function set dataField(value:String):void {
		if( value == _dataField )
			return;
			
		_dataField = value; 
	}
	
	//--------------------------------------
	//	sortable
	//--------------------------------------
	
	private var _sortable:Boolean = true;
	
	public function get sortable():Boolean {
		return _sortable;
	}
	
	public function set sortable(value:Boolean):void {
		if( value == _sortable )
			return;
		
		_sortable = value;
	}

	//--------------------------------------
	//	useCalculatorWidth
	//--------------------------------------
	
	private var _useCalculatorWidth:Boolean;
	
	public function get useCalculatorWidth():Boolean {
		return _useCalculatorWidth;
	}
	
	public function set useCalculatorWidth(value:Boolean):void {
		if( value == _useCalculatorWidth )
			return;
			
		_useCalculatorWidth = value; 
	}
}

}