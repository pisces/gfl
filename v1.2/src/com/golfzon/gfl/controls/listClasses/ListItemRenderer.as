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

import com.golfzon.gfl.collection.Hashtable;
import com.golfzon.gfl.controls.Label;
import com.golfzon.gfl.core.ComponentBase;
import com.golfzon.gfl.core.ISelectable;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.events.Event;
import flash.events.MouseEvent;

/**
 * 
 *	@Include the external file to define padding styles.
 *
 */
include "../../styles/metadata/PaddingStyles.as";

/**
 * 
 *	Background color style property<br>
 * 	default : none
 * 
 */
[Style(name="backgroundColor", type="uint", inherit="no")]

/**
 *	@Author				KHKim
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.09.29
 *	@Modify				2010.04.20 by KHKim
 *	@Description
 */
public class ListItemRenderer extends ComponentBase implements IListItemRenderer, ISelectable
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	private var overed:Boolean;
	
	protected var label:Label;
	
	protected var listOwner:ListBase;
	
	/**
	 *	@Constructor
	 */
	public function ListItemRenderer() {
		super();
		
		configureListeners();
		setStyle(StyleProp.COLOR, 0x333333);
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
			setDataChangeState();
		}
		
		if( selectionChanged ) {
			selectionChanged = false;
			setLabelColor();
		}
	}
	
	/**
	 * 	자식 객체 생성 및 추가
	 */
	override protected function createChildren():void {
		label = new Label();
		label.selectable = false;
		
		if( listOwner )
			listOwner.addEventListener("labelFieldChanged", labelFieldChangedHandler, false, 0, true);
		
		addChild(label);
	}
	
	/**
	 *	스타일 프로퍼티로 값을 설정한다.
	 */
	override public function styleChanged(styleProp:String):void {
		super.styleChanged(styleProp);

		switch( styleProp ) {
			case StyleProp.BACKGROUND_COLOR:
			case StyleProp.TEXT_ALIGN:
				invalidateDisplayList();
				break;
	 	}
	}
	
	/**
	 * 	디스플레이 변경 사항에 대한 처리
	 */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		drawBackground();
		
		label.width = unscaledWidth;
		label.y = Math.floor(unscaledHeight - label.height) / 2;
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	private function configureListeners():void {
		addEventListener(MouseEvent.ROLL_OUT, rollOutHandler, false, 0, true);
		addEventListener(MouseEvent.ROLL_OVER, rollOverHandler, false, 0, true);
	}
	
	private function drawBackground():void {
		if( invalidSize() || !listOwner )
			return;
			
		var color:uint = replaceNullorUndefined(getStyle(StyleProp.BACKGROUND_COLOR), 0xFFFFFF);
		var alpha:Number = replaceNullorUndefined(getStyle(StyleProp.BACKGROUND_ALPHA), 0);
		graphics.clear();
		graphics.beginFill(color, alpha);
		graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
		graphics.endFill();
	}
	
	private function getColorByState():uint {
		return overed && replaceNullorUndefined(getStyle(StyleProp.USE_ROLL_OVER), true) ?
			replaceNullorUndefined(getStyle(StyleProp.TEXT_ROLL_OVER_COLOR), 0x333333) :
			replaceNullorUndefined(getStyle(StyleProp.COLOR), 0x333333);
	}
	
	protected function setDataChangeState():void {
		if( data is String )
			label.text = String(data);
		else if( data is Object )
			label.text = replaceNullorUndefined(data[listOwner.labelField], "");
		else
			label.text = "";
	}
	
	private function setLabelColor():void {
		var color:uint = _selected ?
			replaceNullorUndefined(getStyle(StyleProp.TEXT_SELECTED_COLOR), 0xFFFFFF) :
			getColorByState();
		
		label.setStyle(StyleProp.COLOR, color);
	}
	
	//--------------------------------------------------------------------------
	//
	//	Event handlers
	//
	//--------------------------------------------------------------------------
	
	private function labelFieldChangedHandler(event:Event):void {
		setDataChangeState();
		invalidateDisplayList();
	}
	
	private function rollOutHandler(event:MouseEvent):void {
		if( !event.buttonDown ) {
			overed = false;
			setLabelColor();
		}
	}
	
	private function rollOverHandler(event:MouseEvent):void {
		if( !event.buttonDown ) {
			overed = true;
			setLabelColor();
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
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
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	listData
	//--------------------------------------
	
	private var _listData:BaseListData;
	
	public function get listData():BaseListData {
		return _listData;
	}
	
	public function set listData(value:BaseListData):void {
		_listData = value;
		
		if( _listData )
			listOwner = _listData.owner as ListBase;
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
		if( value == _selected )
			return;
		
		_selected = value;
		selectionChanged = true;
		
		if( value )
			overed = false;
		
		invalidateProperties();
	}
}

}