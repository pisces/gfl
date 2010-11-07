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

package com.golfzon.gfl.core
{
	
import com.golfzon.gfl.events.ComponentEvent;
import com.golfzon.gfl.managers.SystemManager;
import com.golfzon.gfl.nullObject.Null;
import com.golfzon.gfl.nullObject.NullApplication;
import com.golfzon.gfl.preloaders.IPreloader;
import com.golfzon.gfl.preloaders.Preloader;
import com.golfzon.gfl.styles.CSSManager;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.net.FileReference;

use namespace gz_internal;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *	CSS 파일 로드 후 초기화가 완료되면 송출한다.
 */
[Event(name="cssInitialized", type="com.golfzon.events.ComponentEvent")]

/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.08.20
 *	@Modify
 *	@Description
 * 	@includeExample		ApplicationSample.as
 */
public class ApplicationBase extends Container implements Null
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	private var cssManager:CSSManager;
	
	gz_internal var preloaderInstance:IPreloader;
	
	/**
	 *	@Constructor
	 */
	public function ApplicationBase() {
		_application = this;
		
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//	Class methods
	//
	//--------------------------------------------------------------------------
	
	public static function newNull():ApplicationBase {
		return new NullApplication();
	}
	
	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Overriden : Container
	//--------------------------------------------------------------------------
	
	/**
	 * 	초기화
	 */
	override public function initialize():void {
		if( root ) {
			_parameters = root.loaderInfo.parameters;
			_url = root.loaderInfo.url;
		}
		
		preloaderInstance = new ClassFactory(Preloader).newInstance();
		systemManager = new SystemManager();
		cssManager = new CSSManager();
		
		systemManager.initialize();
		configureListeners();

		super.initialize();
	}
	
	//--------------------------------------------------------------------------
	//  Public
	//--------------------------------------------------------------------------
	
	/**
	 *	실행 위치가 로컬인지 아닌지의 부울값
	 */
	public function isLocal():Boolean {
		return root.loaderInfo.url.indexOf("file://") > -1;
	}
	
	public function isNull():Boolean {
		return false;
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	/**
	 *	@private
	 */
	private function configureListeners():void {
		root.loaderInfo.addEventListener(ProgressEvent.PROGRESS, root_loaderInfo_progressHandler, false, 0, true);
		cssManager.addEventListener(Event.COMPLETE, cssManager_completeHandler, false, 0, true);
		cssManager.addEventListener(ProgressEvent.PROGRESS, cssManager_progressHandler, false, 0, true);
	}
	
	/**
	 *	@private
	 */
	private function removePreloader():void {
		if( preloaderInstance && stage.contains(DisplayObject(preloaderInstance)) ) {
			stage.removeChild(DisplayObject(preloaderInstance));
			preloaderInstance = null;
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//	Event handlers
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	@private
	 */
	override protected function addedHandler(event:Event):void {
		removeEventListener(Event.ADDED, addedHandler);
	}
	
	/**
	 *	@private
	 */
	override protected function addedToStageHandler(event:Event):void {
		super.addedToStageHandler(event);
		
		stage.addChild(DisplayObject(preloaderInstance));
		stage.addChild(systemManager);
		
		if( systemManager.cssInitialized )
			setAddedState();
	}
	
	/**
	 *	@private
	 */
	private function cssManager_completeHandler(event:Event):void {
		systemManager.cssInitialized = true;
		dispatchEvent(new ComponentEvent(ComponentEvent.CSS_INITIALIZED));
		cssManager.removeEventListener(ProgressEvent.PROGRESS, cssManager_progressHandler);
		removePreloader();
		
		if( !creationComplete )
			setAddedState();
	}
	
	/**
	 *	@private
	 */
	private function cssManager_progressHandler(event:ProgressEvent):void {
		preloaderInstance.setCSSFileProgress(event.bytesLoaded, event.bytesTotal);
	}
	
	/**
	 *	@private
	 */
	private function root_loaderInfo_progressHandler(event:ProgressEvent):void {
		preloaderInstance.setProgress(event.bytesLoaded, event.bytesTotal);
		
		if( event.bytesLoaded >= event.bytesTotal ) {
			root.loaderInfo.removeEventListener(ProgressEvent.PROGRESS, root_loaderInfo_progressHandler);
			
			if( systemManager.cssInitialized )
				removePreloader();
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//	application
	//--------------------------------------
	
	private static var _application:ApplicationBase;
	
	public static function get application():ApplicationBase {
		return _application ? _application : newNull();
	}
	
	//--------------------------------------
	//	css
	//--------------------------------------
	
	private var _css:String;
	
	public function get css():String {
		return _css;
	}
	
	public function set css(value:String):void {
		if( value == _css )
			return;
		
		_css = value;
		systemManager.cssInitialized = false;
		cssManager.source = value;
	}
	
	//--------------------------------------
	//	preloader
	//--------------------------------------
	
	private var _preloader:Class = Preloader;
	
	public function get preloader():Class {
		return _preloader;
	}
	
	public function set preloader(value:Class):void {
		_preloader = value;
	}
	
	//--------------------------------------
	//	parameters
	//--------------------------------------
	
	private var _parameters:Object;
	
	/**
	 *	@read-only
	 */
	public function get parameters():Object {
		return _parameters;
	}
	
	//--------------------------------------
	//	url
	//--------------------------------------
	
	private var _url:String;
	
	/**
	 *	@read-only
	 */
	public function get url():String {
		return _url;
	}
}

}