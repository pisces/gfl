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

package com.golfzon.gfl.styles
{

import com.golfzon.gfl.collection.Hashtable;
import com.golfzon.gfl.utils.isNothing;
	
/**
 *	@Author				KHKim
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.10.17
 *	@Modify
 *	@Description
 */
public dynamic class CSSStyleDeclaration
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	private var defaultStyleTable:Hashtable = new Hashtable();
	
	/**
	 *	@Constructor
	 */
	public function CSSStyleDeclaration() {
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
	 *	자신을 복제하여 반환한다.
	 */
	public function clone():CSSStyleDeclaration {
		var clone:CSSStyleDeclaration = new CSSStyleDeclaration();
		for( var styleProp:String in this ) {
			clone.setStyle(styleProp, getStyle(styleProp));
		}
		return clone;
	}
	
	/**
	 *	정의된 스타일의 값을 반환한다.
	 */
	public function getStyle(styleProp:String):* {
		return this[styleProp];
	}
	
	/**
	 *	스타일이 존재하는지에 대한 부울값을 반환한다.
	 */
	public function hasStyle(styleProp:String):Boolean {
		return this[styleProp] != undefined;
	}
	
	public function isDefaultStyle(styleProp:String):Boolean {
		return defaultStyleTable.contains(styleProp);
	}
	
	/**
	 *	모든 스타일의 값을 undefined으로 설정한다.
	 */
	public function clear():void {
		for( var styleProp:String in this ) {
			this[styleProp] = undefined;
			delete this[styleProp];
		}
	}
	
	/**
	 *	다른 CSSStyleDeclaration 인스턴스의 스타일 정의를 합친다.
	 */
	public function merge(declaration:CSSStyleDeclaration):void {
		if( !declaration )
			return;
		
		for( var styleProp:String in declaration ) {
			if( !hasStyle(styleProp) || isDefaultStyle(styleProp) )
				setStyle(styleProp, declaration.getStyle(styleProp));
		}
	}
	
	/**
	 *	IStyleClient 인스턴스의 스타일 정의를 합친다.
	 */
	public function mergeStyleClient(client:IStyleClient):void {
		if( !client || !client.getInheritStyleTable() )
			return;

		var map:Object = client.getInheritStyleTable().map;
		for( var styleProp:String in map ) {
			var settable:Boolean = !hasStyle(styleProp) && !isNothing(client.getCSSStyleDeclaration().getStyle(styleProp));
			if( settable )
				setStyle(styleProp, client.getCSSStyleDeclaration().getStyle(styleProp));
		}
	}
	
	public function setDefaultStyle(styleProp:String, value:*):void {
		if( !defaultStyleTable.contains(styleProp) )
			defaultStyleTable.add(styleProp, value);
	}
	
	/**
	 *	스타일 정의의 값을 설정한다.
	 */
	public function setStyle(styleProp:String, value:*):void {
		this[styleProp] = value;
	}
	
	/**
	 *	스타일 정의를 스트링으로 반환한다.
	 */
	public function toString():String {
		var result:String = "";
		for( var styleProp:String in this ) {
			result += "\n" + styleProp + " : " + getStyle(styleProp);
		}
		return result;
	}
}

}