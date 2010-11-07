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

import collection.Hashtable;

import com.golfzon.gfl.controls.Label;
import com.golfzon.gfl.core.ComponentBase;
import com.golfzon.gfl.core.EdgeMetrics;
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
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.09.29
 *	@Modify
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
    
    private var label:Label;
    
	/**
	 *	@Constructor
	 */
	public function ListItemRenderer() {
		super();
		
		configureListeners();
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
    }
    
    /**
     * 	자식 객체 생성 및 추가
     */
    override protected function createChildren():void {
    	label = new Label();
    	label.mouseEnabled = label.selectable = false;
    	
    	if( listOwner )
    		listOwner.addEventListener("labelFieldChanged", labelFieldChangedHandler, false, 0, true);
    	
    	addChild(label);
    }
    
	/**
	 *	상속시킬 스타일 프로퍼티 정의를 반환한다.
	 */
    override public function getInheritStyleTable():Hashtable {
    	var table:Hashtable = super.getInheritStyleTable();
    	table.add(StyleProp.PADDING_LEFT, StyleProp.PADDING_LEFT);
    	table.add(StyleProp.PADDING_RIGHT, StyleProp.PADDING_RIGHT);
    	return table;
    }
    
    /**
     *	스타일 프로퍼티로 값을 설정한다.
     */
    override public function styleChanged(styleProp:String):void {
    	super.styleChanged(styleProp);

    	switch( styleProp ) {
    		case StyleProp.BACKGROUND_COLOR: case StyleProp.TEXT_ALIGN:
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
    	
	    var color:uint = selected ?
	    	replaceNullorUndefined(getStyle(StyleProp.TEXT_SELECTED_COLOR), 0xFFFFFF) :
	    	getColorByState();
	    
	    label.setStyle(StyleProp.COLOR, color);
    }
    
    //--------------------------------------------------------------------------
    //  Internal
    //--------------------------------------------------------------------------
    
	/**
	 *	@private
	 */
    private function configureListeners():void {
    	addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
    	addEventListener(MouseEvent.ROLL_OUT, rollOutHandler, false, 0, true);
    	addEventListener(MouseEvent.ROLL_OVER, rollOverHandler, false, 0, true);
    }
    
	/**
	 *	@private
	 */
    private function drawBackground():void {
    	if( isNaN(unscaledWidth) || isNaN(unscaledHeight) || !listOwner )
    		return;
    		
    	var color:uint = replaceNullorUndefined(getStyle(StyleProp.BACKGROUND_COLOR), 0xFFFFFF);
    	var alpha:Number = replaceNullorUndefined(getStyle(StyleProp.BACKGROUND_ALPHA), 0);
    	graphics.clear();
    	graphics.beginFill(color, alpha);
    	graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
    	graphics.endFill();
    }
    
	/**
	 *	@private
	 */
    private function getColorByState():uint {
    	return overed ?
    		replaceNullorUndefined(getStyle(StyleProp.TEXT_ROLL_OVER_COLOR), 0x333333) :
    		replaceNullorUndefined(getStyle(StyleProp.COLOR), 0x999999)
    }
    
	/**
	 *	@private
	 */
    protected function setDataChangeState():void {
    	if( data is String )
    		label.text = String(data);
    	else if( data is Object )
    		label.text = replaceNullorUndefined(data[listOwner.labelField], "");
    	else
    		label.text = "";
    }
    
    //--------------------------------------------------------------------------
	//
	//	Event handlers
	//
    //--------------------------------------------------------------------------
	
	/**
	 *	@private
	 */
    private function labelFieldChangedHandler(event:Event):void {
    	setDataChangeState();
    	invalidateDisplayList();
    }
	
	/**
	 *	@private
	 */
	private function mouseDownHandler(event:MouseEvent):void {
		selected = true;
	}
	
	/**
	 *	@private
	 */
	private function rollOutHandler(event:MouseEvent):void {
		if( !event.buttonDown ) {
			overed = false;
			invalidateDisplayList();
		}
	}
	
	/**
	 *	@private
	 */
	private function rollOverHandler(event:MouseEvent):void {
		if( !event.buttonDown ) {
			overed = true;
			invalidateDisplayList();
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
	//	listOwner
	//--------------------------------------
	
	private var _listOwner:ListBase;
	
	public function get listOwner():ListBase {
		return _listOwner;
	}
	
	public function set listOwner(value:ListBase):void {
		_listOwner = value;
	}
	
	//--------------------------------------
	//	selected
	//--------------------------------------
	
	private var _selected:Boolean;
	
	public function get selected():Boolean {
		return _selected;
	}
	
	public function set selected(value:Boolean):void {
		if( value == _selected )
			return;
		
		_selected = value;
		
		if( value )
			overed = false;
		
		invalidateDisplayList();
	}
}

}