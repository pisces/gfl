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

package com.golfzon.gfl.styles.classes
{
	
import com.golfzon.gfl.collection.Hashtable;
import com.golfzon.gfl.core.ComponentBase;
import com.golfzon.gfl.styles.CSSStyleDeclaration;
import com.golfzon.gfl.styles.IStyleClient;
import com.golfzon.gfl.utils.BitmapDataUtil;

import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.utils.getQualifiedClassName;
import flash.utils.getQualifiedSuperclassName;

import lt.uza.ui.Scale9BitmapSprite;
	
/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.10.13
 *	@Modify
 *	@Description
 */
public class GStyleManagerImpl
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	private var globalStyleTable:Hashtable = new Hashtable();
	private var localStyleTable:Hashtable = new Hashtable();
	
	/**
	 *	@Constructor
	 */
	public function GStyleManagerImpl() {
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
	 *	scale9 그리드를 위한 Rectangle 객체를 저장한다.
	 */
	public function createSkin(definition:Class):DisplayObject {
		if( !definition )	return null;
		
		var instance:DisplayObject = DisplayObject(new definition());
		if( definition.scale9Grid != undefined ) {
			var bitmapData:BitmapData = BitmapDataUtil.generate(instance);
			var scale9GridBitmapSprite:Scale9BitmapSprite = new Scale9BitmapSprite();
			scale9GridBitmapSprite.init(bitmapData, definition.scale9Grid);
			return scale9GridBitmapSprite;
		}
		return instance;
	}
	
	/**
	 *	컴퍼넌트의 글로벌 스타일 정의를 반환한다.
	 */
	public function getGlobalStyleDeclaration(client:Object):CSSStyleDeclaration {
		var key:String = getQualifiedClassName(client).replace("::", ".");
		return getGlobalStyleDeclarationBy(key);
	}
	
	/**
	 *	클래스명으로 컴퍼넌트의 글로벌 스타일 정의를 찾아 반환한다.
	 */
	public function getGlobalStyleDeclarationBy(className:String):CSSStyleDeclaration {
		if( globalStyleTable.contains(className) )
			return globalStyleTable.getValue(className);
		return null;
	}
	
	/**
	 *	상위 클래스의 글로벌 스타일 정의를 반환한다.
	 */
	public function getSuperClassStyleDeclaration(client:Object):CSSStyleDeclaration {
		var key:String = getQualifiedSuperclassName(client).replace("::", ".");
		if( globalStyleTable.contains(key) )
			return globalStyleTable.getValue(key);
		return null;
	}
	
	/**
	 *	인스턴스의 스타일 정의를 반환한다.
	 */
	public function getStyleDeclaration(name:String):CSSStyleDeclaration {
		if( localStyleTable.contains(name) )
			return localStyleTable.getValue(name);
		return null;
	}
	
	/**
	 *	인스턴스에 스타일 정의를 등록한다.
	 */
	public function registerInstance(instance:DisplayObject):void {
		var styleClient:IStyleClient = IStyleClient(instance);
		var declaration:CSSStyleDeclaration = getCurrnetStyleDeclartion(styleClient);
		if( declaration ) {
			declaration.mergeStyleClient(instance.parent as ComponentBase);
			styleClient.getCSSStyleDeclaration().merge(declaration);
		} else if( instance.parent is ComponentBase ) {
			styleClient.getCSSStyleDeclaration().mergeStyleClient(instance.parent as ComponentBase);
		}
	}
	
	/**
	 *	글로벌 스타일 정의를 설정한다.
	 */
	public function setGlobalStyle(name:String, style:Object):void {
		if( globalStyleTable.contains(name) )
			globalStyleTable.remove(name);
		globalStyleTable.add(name, style);
	}
	
	/**
	 *	스타일 정의를 설정한다.
	 */
	public function setStyle(name:String, style:Object):void {
		if( localStyleTable.contains(name) )
			localStyleTable.remove(name);
		localStyleTable.add(name, style);
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	/**
	 *	스타일 정의를 반환한다.
	 *	
	 * 	우선 순위
	 *	1. 객체의 스타일명
	 *	2. 컴퍼넌트 글로벌 정의
	 */
	private function getCurrnetStyleDeclartion(client:IStyleClient):CSSStyleDeclaration {
		var declaration:CSSStyleDeclaration = getStyleDeclaration(client.styleName as String);
		var sdeclaration:CSSStyleDeclaration = getGlobalStyleDeclaration(client) ? getGlobalStyleDeclaration(client) : null;
		if( declaration ) {
			declaration.merge(sdeclaration);
			return declaration;
		}
		return sdeclaration;
	}
}

}