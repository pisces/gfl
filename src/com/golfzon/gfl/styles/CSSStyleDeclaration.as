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
	import com.golfzon.gfl.utils.isNothing;
	
	
/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.10.17
 *	@Modify
 *	@Description
 */
public dynamic class CSSStyleDeclaration
{
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
		return hasOwnProperty(styleProp);
	}
	
	/**
	 *	모든 스타일의 값을 undefined으로 설정한다.
	 */
	public function clear():void {
		for( var styleProp:String in this ) {
			setStyle(styleProp, undefined);
		}
	}
	
	/**
	 *	다른 CSSStyleDeclaration 인스턴스의 스타일 정의를 합친다.
	 */
	public function merge(declaration:CSSStyleDeclaration):void {
		if( !declaration )
			return;
		
		for( var styleProp:String in declaration ) {
			if( !hasStyle(styleProp) )
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
			var settable:Boolean = !hasStyle(styleProp) && !isNothing(map[styleProp]);
			if( settable )
				setStyle(styleProp, client.getCSSStyleDeclaration().getStyle(styleProp));
		}
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