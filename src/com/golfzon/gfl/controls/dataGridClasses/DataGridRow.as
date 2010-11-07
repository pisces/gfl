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
	
import com.golfzon.gfl.controls.DataGrid;
import com.golfzon.gfl.controls.listClasses.BaseListData;
import com.golfzon.gfl.controls.listClasses.IListItemRenderer;
import com.golfzon.gfl.core.ComponentBase;
import com.golfzon.gfl.core.ISelectable;

import flash.display.DisplayObject;

/**
 *	@Author				KHKim
 *	@Version			1.0
 *	@Lanaguage			Action Script 3.0
 *	@Date				2010. 4. 15.
 *	@Modify
 *	@Description
 */
public class DataGridRow extends ComponentBase implements IListItemRenderer, ISelectable
{
	//--------------------------------------------------------------------------
	//
	//  Instance variables
	//
	//--------------------------------------------------------------------------
	
	private var dataGrid:DataGrid;
	
	/**
	 *	@Constructor
	 */
	public function DataGridRow() {
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
	 * 	프로퍼티 변경 사항에 대한 처리
	 */
	override protected function commitProperties():void {
		super.commitProperties();
		
		if( dataChanged ) {
			dataChanged = false;
			setChildrenProperties();
		}
		
		if( listDataChanged ) {
			listDataChanged = false;
			setChildrenProperties();
		}
		
		if( selectionChanged ) {
			selectionChanged = false;
			setChildrenProperties();
		}
	}
	
	override public function addChild(child:DisplayObject):DisplayObject {
		setChildProperties(child as IListItemRenderer, numChildren);
		
		return super.addChild(child);
	}
	
	override public function addChildAt(child:DisplayObject, index:int):DisplayObject {
		setChildProperties(child as IListItemRenderer, index);
		
		return super.addChildAt(child, index);
	}
	
	override public function removeChild(child:DisplayObject):DisplayObject {
		removeChildProperties(child as IListItemRenderer);
		
		return super.removeChild(child);
	}
	
	override public function removeChildAt(index:int):DisplayObject {
		removeChildProperties(getChildAt(index) as IListItemRenderer);
		
		return super.removeChildAt(index);
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	private function removeChildProperties(child:IListItemRenderer):void {
		if( child ) {
			child.data = null;
			child.listData = null;
			
			if( child is ISelectable )
				ISelectable(child).selected = false;
		}
	}
	
	private function setChildProperties(child:IListItemRenderer, columnIndex:int):void {
		if( child ) {
			var column:DataGridColumn = dataGrid.columns[columnIndex];
			if( column )
				child.data = _data ? _data[column.dataField] : null;
			child.listData = _listData;
			
			if( child is ISelectable )
				ISelectable(child).selected = _selected;
		}
	}
	
	private function setChildrenProperties():void {
		var count:uint = numChildren;
		for( var i:uint=0; i<count; i++ ) {
			setChildProperties(getChildAt(i) as IListItemRenderer, i);
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//	listData
	//--------------------------------------
	
	private var listDataChanged:Boolean;
	
	private var _listData:BaseListData;
	
	public function get listData():BaseListData {
		return _listData;
	}
	
	public function set listData(value:BaseListData):void {
		if( value === _listData )
			return;
		
		_listData = value;
		
		if( _listData )
			dataGrid = _listData.owner as DataGrid;
		
		listDataChanged = true;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//	data
	//--------------------------------------
	
	private var dataChanged:Boolean;
	
	private var _data:Object;
	
	public function get data():Object {
		return _data;
	}
	
	public function set data(value:Object):void {
		if( value === _data )
			return;
		
		_data = value;
		dataChanged = true;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//	selected
	//--------------------------------------
	
	private var selectionChanged:Boolean;
	
	private var _selected:Boolean;
	
	public function get selected():Boolean {
		return _selected;
	}
	
	public function set selected(value:Boolean):void {
		if( value === _selected )
			return;
		
		_selected = value;
		selectionChanged = true;
		
		invalidateProperties();
	}
}
	
}