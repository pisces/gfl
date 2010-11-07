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
	
import com.golfzon.gfl.utils.UIDUtil;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *	내부에서 value가 변경 되었을때 송출 한다.
 */
[Event(name="change", type="flash.events.Event")]

/**
 *	@Author				SH Jung
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.11.03
 *	@Modify
 *	@Description
 * 	@includeExample		RadioButtonGroupSample.as
 */
public class RadioButtonGroup extends EventDispatcher
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	라디오 버튼을 담는 배열
	 */
	private var radioButtons:Array;

	/**
	 *	@Constructor
	 */
	public function RadioButtonGroup() {
		super();
		
		dataInit();
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
	 *	버튼 추가
	 */	
	public function addButton(client:RadioButton):Boolean {
		var result:Boolean = true;
		for( var i:uint = 0; i<radioButtons.length; i++ ) {
			if( radioButtons[i] === client ) {
				result = false;
				break;
			}
		}
		
		if( result ) {
			if( !_enabled ) client.enabled = _enabled;
			client.addEventListener(Event.CHANGE, changeHandler, false, 0, true);
			radioButtons[radioButtons.length] = client;
			if(client.selected) _selectedIndex = radioButtons.length - 1;
		}
		
		if( _selectedIndex != -1 && radioButtons.length > _selectedIndex ) {
			radioButtons[_selectedIndex].selected = true;
			radioButtons[_selectedIndex].dispatchEvent(new Event(Event.CHANGE));
		}
		
		return result;
	}
  
	/**
	 *	버튼 삭제
	 */	
	public function removeButton(client:RadioButton):void {
		var index:uint = radioButtons.indexOf(client);
		client.removeEventListener(Event.CHANGE, changeHandler);
		radioButtons.splice(index, 1);
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	/**
	 *	데이터 초기화
	 */
	private function dataInit():void {
		_uid = UIDUtil.createUID();
		radioButtons /* of RadioButton */ = [];
	}
	
	/**
	 *	enabled 적용
	 */
	private function setEnabled():void {
		for( var i:uint = 0; i<radioButtons.length; i++ ) {
			radioButtons[i].enabled = _enabled;
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//	Event handlers
	//
	//--------------------------------------------------------------------------

	/**
	 *	버튼 변경시
	 */
	private function changeHandler(event:Event):void {
		if( !_enabled )
			return;
		
		var result:Boolean = true;
		for( var i:uint = 0; i<radioButtons.length; i++ ) {
			if( radioButtons[i] !== event.currentTarget ) {
				radioButtons[i].selected = false;
			} else {
				if( _selectedIndex == i ) result = false;
				_selectedIndex = i;
				_value = radioButtons[i].value;
				radioButtons[i].selected = true;
			}
		}
		
		if( result )
			dispatchEvent(new Event(Event.CHANGE));
	}
	
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//	enabled
	//--------------------------------------
	
	private var _enabled:Boolean = true;
	
	public function get enabled():Boolean {
		return _enabled;
	}
	
	public function set enabled(value:Boolean):void {
		if( value == _enabled )
			return;
		
		_enabled = value;
		
		setEnabled();
	}
	
	//--------------------------------------
	//	name
	//--------------------------------------
	
	private var _name:String;
	
	public function get name():String {
		return _name;
	}
	
	public function set name(value:String):void {
		_name = value;
	}
	
	//--------------------------------------
	//	selectedIndex
	//--------------------------------------
	
	private var _selectedIndex:int = -1;
	
	public function get selectedIndex():int {
		return _selectedIndex;
	}
	
	public function set selectedIndex(value:int):void {
		if( value == _selectedIndex )
			return;
		
		_selectedIndex = value;
		if(radioButtons[_selectedIndex])
			radioButtons[_selectedIndex].dispatchEvent(new Event(Event.CHANGE));
	}
	
	//--------------------------------------
	//	value
	//--------------------------------------
	
	private var _value:String;
	
	public function get value():String {
		return _value;
	}
	
	//--------------------------------------
	//	length
	//--------------------------------------
	
	public function get lenght():uint {
		return radioButtons.length;
	}
	
	//--------------------------------------
	//	uid
	//--------------------------------------
	
	private var _uid:String;
	
	public function get uid():String {
		return _uid;
	}
}
}