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

import collection.Hashtable;

import com.golfzon.gfl.controls.progressBarClasses.ProgressBarMode;
import com.golfzon.gfl.core.ComponentBase;

import flash.display.Bitmap;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLRequest;
import flash.system.LoaderContext;
import flash.utils.ByteArray;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *	로드가 완료되었을 때 송출한다.
 */
[Event(name="complete", type="flash.events.Event")]

/**
 *	Input/Output 스트림 에러가 나면 송출한다.
 */
[Event(name="ioError", type="flash.events.IOErrorEvent")]

/**
 *	로드가 진행될 때 송출한다.
 */
[Event(name="progress", type="flash.events.ProgressEvent")]

/**
 *	보안 에러가 나면 송출한다.
 */
[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
	
/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.08.20
 *	@Modify
 *	@Description
 * 	@includeExample		ImageSample.as
 */
public class Image extends ComponentBase
{
    //--------------------------------------------------------------------------
	//
	//	Instance variables
	//
    //--------------------------------------------------------------------------
	
	private var loader:Loader;
	
	private var progressBar:ProgressBar;
	
	private var byteTable:Hashtable = new Hashtable();
	
	/**
	 *	@Constructor
	 */
	public function Image() {
		super();
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
    	
    	if( smoothingChanged ) {
    		smoothingChanged = false;
    		
    		if( loader.content is Bitmap )
    			Bitmap(loader.content).smoothing = smoothing;
    	}
    	
    	if( sourceChanged ) {
    		sourceChanged = false;
    		
    		load(source);
    	}
    }
    
    /**
     * 	자식 객체 생성 및 추가
     */
    override protected function createChildren():void {
    	loader = Loader(addChild(new Loader()));
    }
    
    /**
     * 	컴퍼넌트의 기본 크기와 최소 크기를 설정한다.
     */
    override protected function measure():void {
    	super.measure();
    	
    	if( !loader.content )
    		return;
    	
    	if( scaleContent ) {
    		measureWidth = isNaN(measureWidth) ? loader.content.width : measureWidth;
    		measureHeight = isNaN(measureHeight) ? loader.content.height : measureHeight;
    	} else {
    		measureWidth = loader.content.width;
    		measureHeight = loader.content.height;
    	}

    	setActureSize(unscaledWidth, unscaledHeight);
    }
    
    /**
     * 	디스플레이 변경 사항에 대한 처리
     */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
    	if( isNaN(unscaledWidth) || isNaN(unscaledHeight) )
    		return;
    	
    	graphics.clear();
    	graphics.beginFill(0xFFFFFF, 0);
    	graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
    	graphics.endFill();
    	
		loader.width = unscaledWidth;
		loader.height = unscaledHeight;
    }
    
    //--------------------------------------------------------------------------
    //  Public
    //--------------------------------------------------------------------------
    
    /**
     * 	이미지 로드
     */
    public function load(source:Object):void {
    	try {
			unload();
		
    		if( _source ) {
	    		configureListeners();
	    		getProgressBar().setProgress(0, 100);
	    		
	    		var canUseCache:Boolean = useCache && byteTable.contains(this.source);
	    		var source:Object = canUseCache ? byteTable.getValue(this.source) : this.source;
				
	    		if( source is ByteArray )
	    			loader.loadBytes(ByteArray(source));
	    		else if( source is String )
	    			loader.load(new URLRequest(String(source)), new LoaderContext(true));
    		}

    	} catch(e:Error) {
    	}
    }
    
    /**
     * 	이미지 언로드
     */
    public function unload():void {
    	if( loader && loader.content ) {
    		if( loader.content is Bitmap ) {
    			Bitmap(loader.content).bitmapData.dispose();
    			Bitmap(loader.content).bitmapData = null;
    			loader.unload();
    		} else if( loader.content is MovieClip ) {
				loader.unloadAndStop();
    		}
    	}
    }
    
    //--------------------------------------------------------------------------
    //  Internal
    //--------------------------------------------------------------------------
    
    /**
     *	@private
     */
    private function configureListeners():void {
    	loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
    	loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
    	loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
    	loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
    }
    
    /**
     *	@private
     */
    private function getProgressBar():ProgressBar {
    	if( !progressBar ) {
    		progressBar = new ProgressBar();
    		progressBar.mode = ProgressBarMode.POLLED;
    		addChild(progressBar);
    		progressBar.x = int((width - progressBar.width)/2);
    		progressBar.y = int((height - progressBar.height)/2);
    	}
    	return progressBar;
    }
    
    /**
     *	@private
     */
    private function removeListeners():void {
    	loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
    	loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
    	loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
    	loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
    }
    
    /**
     *	@private
     */
    private function removeProgressBar():void {
    	if( progressBar && contains(progressBar) ) {
    		removeChild(progressBar);
    		progressBar = null;
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
	private function ioErrorHandler(e:IOErrorEvent):void {
		removeListeners();
		dispatchEvent(e.clone());
	}
	
    /**
     *	@private
     */
    private function progressHandler(e:ProgressEvent):void {
    	if( showProgressBar )
    		getProgressBar().setProgress(e.bytesLoaded, e.bytesTotal);
		dispatchEvent(e.clone());
    }
    
    /**
     *	@private
     */
    private function onComplete(e:Event):void {
		if( useCache && !byteTable.contains(source) )
			byteTable.add(source, bytes);
			
		if( loader.content is Bitmap )
			Bitmap(loader.content).smoothing = smoothing;

    	invalidateDisplayList();
    	removeListeners();
    	removeProgressBar();
		dispatchEvent(e.clone());
    }
    
    /**
     *	@private
     */
    private function securityErrorHandler(e:SecurityErrorEvent):void {
		dispatchEvent(e.clone());
    }
    
    //--------------------------------------------------------------------------
	//
	//	getter / setter
	//
    //--------------------------------------------------------------------------
	
	//--------------------------------------
	//	bytes
	//--------------------------------------
	
    /**
     * 	이미지 컨텐츠를 바이트 배열로 반환한다.
     */
	public function get bytes():ByteArray {
		if( !loader.contentLoaderInfo.bytes )
			return null;
		
		var bytes:ByteArray = new ByteArray();
		bytes.writeBytes(loader.contentLoaderInfo.bytes);
		return bytes;
	}
	
	//--------------------------------------
	//	content
	//--------------------------------------
	
    /**
     * 	이미지 컨텐츠를 반환한다.
     */
	public function get content():* {
		return loader ? loader.content : null;
	}
	
	//--------------------------------------
	//	contentLoaderInfo
	//--------------------------------------
	
	public function get contentLoaderInfo():LoaderInfo {
		return loader ? loader.contentLoaderInfo : null;
	}
	
	//--------------------------------------
	//	contentWidth
	//--------------------------------------
	
    /**
     * 	이미지 컨텐츠의 넓이를 반환한다.
     */
	public function get contentWidth():Number {
		return loader && loader.content ? loader.content.width : NaN;
	}
	
	//--------------------------------------
	//	contentHeight
	//--------------------------------------
	
    /**
     * 	이미지 컨텐츠의 높이를 반환한다.
     */
	public function get contentHeight():Number {
		return loader && loader.content ? loader.content.height : NaN;
	}
	
	//--------------------------------------
	//	scaleContent
	//--------------------------------------
	
	private var scaleContentChanged:Boolean;
	
	private var _scaleContent:Boolean = true;
	
	public function get scaleContent():Boolean {
		return _scaleContent;
	}
	
	public function set scaleContent(value:Boolean):void {
		if( value == _scaleContent )
			return;
		
		_scaleContent = value;
		scaleContentChanged = true;
		
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	showProgressBar
	//--------------------------------------
	
	private var _showProgressBar:Boolean = true;
	
	public function get showProgressBar():Boolean {
		return _showProgressBar;
	}
	
	public function set showProgressBar(value:Boolean):void {
		_showProgressBar = value;
	}
	
	//--------------------------------------
	//	smoothing
	//--------------------------------------
	
	private var smoothingChanged:Boolean;
	
	private var _smoothing:Boolean;
	
	public function get smoothing():Boolean {
		return _smoothing;
	}
	
	public function set smoothing(value:Boolean):void {
		if( value === _smoothing )
			return;
    		
		_smoothing = value;
		smoothingChanged = true;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//	source
	//--------------------------------------
	
	private var sourceChanged:Boolean;
	
	private var _source:Object;
	
	public function get source():Object {
		return _source;
	}
	
	public function set source(value:Object):void {
		if( value === _source )
			return;
    		
		_source = value;
		sourceChanged = true;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//	useCache
	//--------------------------------------
	
	private var _useCache:Boolean;
	
	public function get useCache():Boolean {
		return _useCache;
	}
	
	public function set useCache(value:Boolean):void {
		_useCache = value;
	}
}

}