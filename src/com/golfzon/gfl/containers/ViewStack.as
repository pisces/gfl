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

package com.golfzon.gfl.containers
{
	
import com.golfzon.gfl.core.ComponentBase;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.display.DisplayObject;

import gs.TweenMax;
import gs.easing.Expo;

/**
 *	@Author				rrobbie
 *	@Version			1.0
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.10.28
 *	@Modify
 *	@Description
 */
public class ViewStack extends ComponentBase
{
	//----------------------------------------------------------------
	//
	//	Instance Variables
	//
	//----------------------------------------------------------------
	
	private var origineSelectedChild:DisplayObject;
	
	/**
	 *	@Constructure 
	 */ 
	public function ViewStack() {
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Overriden : BorderBasedComponent
	//--------------------------------------------------------------------------

	/**
	 * 	프로퍼티 변경 사항에 대한 처리
	 */
	override protected function commitProperties():void {
		super.commitProperties();
		
		if( selectedIndexChanged ) {
			selectedIndexChanged = false;
			selectedChild = getChildAt(_selectedIndex);
		}
		
		if( selectedChildChanged ) {
			selectedChildChanged = false;
				
			hide();
			show();
			_selectedIndex = _selectedChild ? getChildIndex(_selectedChild) : -1;
		}
	}
	
	/**
	 *	자식 객체를 추가한다.
	 */
	override public function addChild(child:DisplayObject):DisplayObject {
		child.visible = false;
		return super.addChild(child);;
	}
	
	/**
	 *	자식 객체를 특정 인덱스에 추가한다.
	 */
	override public function addChildAt(child:DisplayObject, index:int):DisplayObject {
		child.visible = false;
		return super.addChildAt(child, index);;
	}
		
	//--------------------------------------------------------------------------
	//
	//	Instance Methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	private
	//--------------------------------------------------------------------------
	
	/**
	 *	@private 
	 */
	private function hide():void {
		if( origineSelectedChild )
			origineSelectedChild.visible = false;
	}
	
	/**
	 *	@private 
	 */ 
	private function show():void {
		if( _selectedChild ) {
			var duration:Number = replaceNullorUndefined(getStyle(StyleProp.SHOW_DURATION), 0.5);
			_selectedChild.alpha = 0;
			_selectedChild.visible = true;
			TweenMax.to(_selectedChild, duration, {alpha:1, ease:Expo.easeOut});
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//	selectedIndex
	//--------------------------------------
	
	private var selectedIndexChanged:Boolean;
	
	private var _selectedIndex:int = -1;
	
	public function get selectedIndex():int {
		return _selectedIndex;
	}   
	
	public function set selectedIndex(value:int):void {
		if( _selectedIndex === value )
			return;
			
		_selectedIndex = value;
		selectedIndexChanged = true;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//	selectedChild
	//--------------------------------------
	
	private var selectedChildChanged:Boolean;
	
	private var _selectedChild:DisplayObject;
	
	public function get selectedChild():DisplayObject {
		return _selectedChild;
	}
	
	public function set selectedChild(value:DisplayObject):void {
		if( _selectedChild === value )
			return;
		
		origineSelectedChild = _selectedChild;
		_selectedChild = value;
		selectedChildChanged = true;
		
		invalidateProperties();
	}
}

}