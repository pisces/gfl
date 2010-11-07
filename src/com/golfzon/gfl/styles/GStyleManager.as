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
	
import com.golfzon.gfl.styles.classes.GStyleManagerImpl;

import flash.display.DisplayObject;
	
/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.10.13
 *	@Modify
 *	@Description
 */
public class GStyleManager
{
	//--------------------------------------------------------------------------
	//
	//	Class variables
	//
	//--------------------------------------------------------------------------
	
	public static var impl:GStyleManagerImpl = new GStyleManagerImpl();
	
	/**
	 *	@Constructor
	 */
	public function GStyleManager() {
		throw new Error("GStyleManager is not allowed instnacing!");
	}
	
	//--------------------------------------------------------------------------
	//
	//	Class methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Public
	//--------------------------------------------------------------------------
	
	/**
	 *	scale9 그리드를 위한 Rectangle 객체를 저장한다.
	 */
	public static function createSkin(definition:Class):DisplayObject {
		return impl.createSkin(definition);
	}
	
	/**
	 *	컴퍼넌트의 글로벌 스타일 정의를 반환한다.
	 */
	public static function getGlobalStyleDeclaration(client:Object):CSSStyleDeclaration {
		return impl.getGlobalStyleDeclaration(client);
	}
	
	/**
	 *	클래스명으로 컴퍼넌트의 글로벌 스타일 정의를 찾아 반환한다.
	 */
	public static function getGlobalStyleDeclarationBy(className:String):CSSStyleDeclaration {
		return impl.getGlobalStyleDeclarationBy(className);
	}
	
	/**
	 *	상위 클래스의 글로벌 스타일 정의를 반환한다.
	 */
	public static function getSuperClassStyleDeclaration(client:Object):CSSStyleDeclaration {
		return impl.getSuperClassStyleDeclaration(client);
	}
	
	/**
	 *	인스턴스의 스타일 정의를 반환한다.
	 */
	public static function getStyleDeclaration(name:String):CSSStyleDeclaration {
		return impl.getStyleDeclaration(name);
	}
	
	/**
	 *	인스턴스에 스타일 정의를 등록한다.
	 */
	public static function registerInstance(instance:DisplayObject):void {
		impl.registerInstance(instance);
	}
	
	/**
	 *	글로벌 스타일 정의를 설정한다.
	 */
	public static function setGlobalStyle(name:String, style:Object):void {
		impl.setGlobalStyle(name, style);
	}
	
	/**
	 *	스타일 정의를 설정한다.
	 */
	public static function setStyle(name:String, style:Object):void {
		impl.setStyle(name, style);
	}
}

}