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

import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.HTTPStatusEvent;
import flash.events.IEventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.geom.Rectangle;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.text.Font;
import flash.text.StyleSheet;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *	StyleManager에 등록이 완료되었을 때 발송한다.
 */
[Event(name="complete", type="flash.events.Event")]

/**
 *	http 프로토콜에 연결되었을 때 발송한다.
 */
[Event(name="httpStatus", type="flash.events.HTTPStatusEvent")]

/**
 *	CSS 파일 로드 시 input/output 에러가 발생하면 발송한다.
 */
[Event(name="ioError", type="flash.events.IOErrorEvent")]

/**
 *	CSS 파일 로드가 진행될 때 송출한다.
 */
[Event(name="progress", type="flash.events.ProgressEvent")]

/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.09.16
 *	@Modify
 *	@Description
 */
public class CSSManager extends EventDispatcher
{
    //--------------------------------------------------------------------------
	//
	//	Class constant
	//
    //--------------------------------------------------------------------------
    
    private static const KEY_CLASS_NAME:String = "className";
    private static const KEY_FONT:String = "@font";
    
    private static const ASSET_REG_EXP:RegExp = /\@font|@skin/g;
    private static const CLASS_REG_EXP:RegExp = /\@class|\(|\)|\"/g;
    private static const CLASS_DEVIDE_REG_EXP:RegExp = /\@class|\(|\)|\"|\s|\t|\n|/g;
    private static const COLOR_REG_EXP:RegExp = /\#|0x/g;
    private static const FONT_REG_EXP:RegExp = /\@font/g;
    private static const SEARCH_DASH_REG_EXP:RegExp = /\"|\"/g;
    
    //--------------------------------------------------------------------------
	//
	//	Instance variables
	//
    //--------------------------------------------------------------------------
    
    private var assets:Array = [];
    private var styleNames:Array = [];
    
    private var sheet:StyleSheet = new StyleSheet();
    
	/**
	 *	@Constructor
	 */
	public function CSSManager() {
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
     *	CSS 파일을 로드한다.
     */
    public function load(source:String):void {
    	if( source ) {
	    	var loader:URLLoader = new URLLoader();
	    	configureListeners(loader);
	    	loader.load(new URLRequest(source));
	    }
    }
    
    //--------------------------------------------------------------------------
    //  Internal
    //--------------------------------------------------------------------------
    
    /**
     *	@private
     */
    private function cascade():void {
    	for( var nm:String in styleNames ) {
    		var name:String = styleNames[nm];
    		var style:Object = sheet.getStyle(name);
    		var declaration:CSSStyleDeclaration = getCSSStyleDeclaration(style);
    		
    		if( getClassName(declaration) )
    			setClassStyle(declaration);
    		else
    			GStyleManager.setStyle(name.replace(".", ""), declaration);
    	}
	   	dispatchEvent(new Event(Event.COMPLETE));
    }
    
    /**
     *	@private
     */
    private function configureListeners(dispatcher:IEventDispatcher):void {
    	dispatcher.addEventListener(Event.COMPLETE, completeHandler);
    	dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler, false, 0, true);
    	dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
    	dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler, false, 0, true);
    }
    
    /**
     *	@private
     */
    private function createRectangeBy(source:Array):Rectangle {
		var x:Number = replaceNullorUndefined(source[0], 0);
		var y:Number = replaceNullorUndefined(source[1], 0);
		var w:Number = replaceNullorUndefined(source[2], 0);
		var h:Number = replaceNullorUndefined(source[3], 0);
		return new Rectangle(x, y, w, h);
    }
    
    /**
     *	@private
     */
    private function getClassName(declaration:CSSStyleDeclaration):String {
    	return declaration.getStyle(KEY_CLASS_NAME) != undefined ? declaration.getStyle(KEY_CLASS_NAME) : null;
    }
    
    /**
     *	@private
     */
	private function getCastValue(value:String):* {
		if( value.search(CLASS_REG_EXP) > -1 )
			return getClassDefinition(value);
		if( value.search(COLOR_REG_EXP) > -1 )
			return uint(value.replace("#", "0x"));
		if( isNaN(Number(value)) )
			return value;
		return Number(value);
	}
    
    /**
     *	@private
     */
    private function getCSSStyleDeclaration(style:Object):CSSStyleDeclaration {
    	var declaration:CSSStyleDeclaration = new CSSStyleDeclaration(); 
    	for( var styleProp:String in style ) {
    		declaration.setStyle(styleProp, getCastValue(style[styleProp]));
    	}
    	return declaration;
    }
    
    /**
     *	@private
     */
    private function getClassDefinition(value:String):* {
    	var replacedText:String = value.replace(CLASS_DEVIDE_REG_EXP, "");
		if( replacedText.search(",") < 0 )
			return ApplicationDomain.currentDomain.getDefinition(replacedText);
		
		var arr:Array = replacedText.split(",");
		var definition:Class = ApplicationDomain.currentDomain.getDefinition(arr.shift()) as Class;
		definition.scale9Grid = createRectangeBy(arr);
		return definition;
    }
	
    /**
     *	@private
     */
	private function isAsset(element:*, index:int, arr:Array):Boolean {
		return String(element).search(ASSET_REG_EXP) > -1;
	}
	
    /**
     *	@private
     */
	private function isStyleName(element:*, index:int, arr:Array):Boolean {
		return String(element).search(ASSET_REG_EXP) < 0;
	}
    
    /**
     *	@private
     */
    private function loadAssetBy(styleName:String):void {
    	var style:Object = sheet.getStyle(styleName);
    	var url:String = String(style.url).replace(SEARCH_DASH_REG_EXP, "");
    	var loader:Loader = new Loader();
    	loader.name = styleName.search(FONT_REG_EXP) > -1?
    		KEY_FONT + String(style.fontClass).replace(SEARCH_DASH_REG_EXP, ""):
    		loader.name;
    	
    	configureListeners(loader.contentLoaderInfo);
    	loader.load(new URLRequest(url), new LoaderContext(false, ApplicationDomain.currentDomain));
    }
	
    /**
     *	@private
     */
	private function parse(CSSText:String):void {
		if( CSSText ) {
			sheet.clear();
			sheet.parseCSS(CSSText);
			assets = sheet.styleNames.filter(isAsset);
    		styleNames = sheet.styleNames.filter(isStyleName);
		}
	}
    
    /**
     *	@private
     */
    private function progressLoadAsset():void {
    	if( assets.length > 0 )
    		loadAssetBy(assets.pop());
    	else
    		cascade();
    }
	
    /**
     *	@private
     */
	private function registerFont(name:String):void {
		if( name.search(KEY_FONT) > -1 ) {
			var font:String = name.replace(KEY_FONT, "");
			Font.registerFont(ApplicationDomain.currentDomain.getDefinition(font) as Class);
		}
	}
    
    /**
     *	@private
     */
    private function removeListeners(dispatcher:IEventDispatcher):void {
    	dispatcher.removeEventListener(Event.COMPLETE, completeHandler);
    	dispatcher.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
    	dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
    	dispatcher.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
    }
    
    /**
     *	@private
     */
    private function setClassStyle(declaration:CSSStyleDeclaration):void {
    	var className:String = getClassName(declaration);
		declaration[KEY_CLASS_NAME] = undefined;
		delete declaration[KEY_CLASS_NAME];
		GStyleManager.setGlobalStyle(className, declaration);
    }
    
    //--------------------------------------------------------------------------
	//
	//	Event handlers
	//
    //--------------------------------------------------------------------------
    
    /**
     *	@private
     */
    private function completeHandler(event:Event):void {
	    removeListeners(IEventDispatcher(event.currentTarget));
	    
    	if( event.currentTarget is LoaderInfo ) {
    		registerFont(LoaderInfo(event.currentTarget).loader.name);
    		progressLoadAsset();
    	} else {
    		try {
    			var loader:URLLoader = URLLoader(event.currentTarget);
	    		loader.close();
	    		parse(loader.data as String);
    			progressLoadAsset();
		    	
	    	} catch(e:Error) {
	    		trace(e.message);
	    	}
    	}
    }
    
    /**
     *	@private
     */
    private function httpStatusHandler(e:HTTPStatusEvent):void {
    	dispatchEvent(e.clone());
    }
    
    /**
     *	@private
     */
    private function ioErrorHandler(e:IOErrorEvent):void {
    	removeListeners(IEventDispatcher(e.currentTarget));
    	dispatchEvent(e.clone());
    }
    
    /**
     *	@private
     */
    private function progressHandler(e:ProgressEvent):void {
    	dispatchEvent(e.clone());
    }
    
    //--------------------------------------------------------------------------
	//
	//	getter / setter
	//
    //--------------------------------------------------------------------------
	
	//--------------------------------------
	//	source
	//--------------------------------------
	
	private var _source:String;
	
	public function get source():String {
		return _source;
	}
	
	public function set source(value:String):void {
		if( value == _source )
			return;
		
		_source = value;
		
		load(value);
	}
}

}