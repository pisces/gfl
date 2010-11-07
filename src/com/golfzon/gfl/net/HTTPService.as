////////////////////////////////////////////////////////////////////////////////
//
//  PISCES IS OPEN SOURCE PROVIDER
//  Copyright 2004-2009 PISCES
//  All Rights Reserved.
//
//  NOTICE: PISCES permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.golfzon.gfl.net
{
	
import com.golfzon.gfl.events.FaultEvent;
import com.golfzon.gfl.events.InvokeEvent;
import com.golfzon.gfl.events.ResultEvent;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.HTTPStatusEvent;
import flash.events.IEventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.xml.XMLDocument;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *	dispatch when occurred input/output or security error.
 */
[Event(name="fault", type="com.golfzon.gfl.events.FaultEvent")]

/**
 *	dispatch when receive information for http status.
 */
[Event(name="invoke", type="com.golfzon.gfl.events.InvokeEvent")]

/**
 *	dispatch when complete to send.
 */
[Event(name="result", type="com.golfzon.gfl.events.ResultEvent")]

/**
 *	@Author				KH Kim
 *	@Version			1.0
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.02.10
 *	@Modify				2009.08.17 by KH Kim
 * 						2009.11.18 by KH Kim
 *	@Description
 * 	@includeExample		HTTPServiceSample.as
 */
public class HTTPService extends EventDispatcher
{
	//--------------------------------------------------------------------------
	//
	//	Class constants
	//
	//--------------------------------------------------------------------------
	
    /**
     *  The result format "flashvars" specifies that the value returned is text containing name=value pairs
     *  separated by ampersands, which is parsed into an ActionScript object.
     */
    public static const RESULT_FORMAT_FLASHVARS:String = "flashvars";

	/**
	 *  The result format "object" specifies that the value returned is XML but
	 * 	is parsed as a tree of ActionScript objects. This is the default.
	 */
	public static const RESULT_FORMAT_OBJECT:String = "object";

	/**
	 *  The result format "text" specifies that the HTTPService result text should be an unprocessed String.
	 */
	public static const RESULT_FORMAT_TEXT:String = "text";

	/**
	 *  The result format "xml" specifies that results should be returned as an flash.xml.XMLNode instance pointing to
	 *  the first child of the parent flash.xml.XMLDocument.
	 */
	public static const RESULT_FORMAT_XML:String = "xml";

	/**
	 *  Indicates that the data being sent by the HTTP service is encoded as application/xml.
	 */
	public static const CONTENT_TYPE_XML:String = "application/xml";
	
	/**
	 *  Indicates that the data being sent by the HTTP service is encoded as application/x-www-form-urlencoded.
	 */
	public static const CONTENT_TYPE_FORM:String = "application/x-www-form-urlencoded";
	
	public static const CONTENT_TYPE_OCTECT_STREAM:String = "application/octet-stream";
    
	/**
	 *	@Contsructor
	 */
	public function HTTPService() {
	}
	
	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------
    
	//--------------------------------------------------------------------------
	//	Public
	//--------------------------------------------------------------------------

	/**
	 *	Wheather instance is null object.
	 */
	public function isNull():Boolean {
		return false;
	}
	
	/**
	 * Send to server with parameters.
	 */
	public function send(parameters:Object=null):URLLoader {
		if( !url )
			return null;

		var request:URLRequest = new URLRequest(url);
		request.data = createVariables(parameters);
		request.contentType = contentType;
		request.method = sendMethod;

		if( requestHeaders )
			request.requestHeaders.push(requestHeaders);
		
		var loader:URLLoader = new URLLoader();
		configureListeners(loader);
		loader.load(request);

		return loader;
	}
	
	//--------------------------------------------------------------------------
	//	Internal
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private function createResultObject(body:Object):* {
		if( !body )
			return null;

		var result:*;
		try {
			if( resultFormat == RESULT_FORMAT_XML ) {
				var tmp:Object = new XMLDocument();
				XMLDocument(tmp).ignoreWhite = true;
				XMLDocument(tmp).parseXML(String(body));
				
				if( tmp.childNodes.length == 1 )
					tmp = tmp.firstChild;

				result = tmp;
			} else if( resultFormat == RESULT_FORMAT_OBJECT ) {
				result = new URLVariables(String(body));
			} else if( resultFormat == RESULT_FORMAT_TEXT ) {
				result = String(body);
			}
		} catch(e:Error) {
		}
		return result;
	}
	
	/**
	 * @private
	 */
	private function createVariables(parameters:Object):URLVariables {
		var variables:URLVariables = new URLVariables();
		for( var name:String in parameters ) {
			variables[name] = parameters[name];
		}
		return variables;
	}
	
	/**
	 * @private
	 * Configure event listeners to the instance of IEventDispatcher.
	 */
	private function configureListeners(dispatcher:IEventDispatcher):void {
		dispatcher.addEventListener(Event.COMPLETE, onComplete);
		dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
		dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
	}
	
	/**
	 * @private
	 * Remove event listeners to the instance of IEventDispatcher.
	 */
	private function removeListeners(dispatcher:IEventDispatcher):void {
		dispatcher.removeEventListener(Event.COMPLETE, onComplete);
		dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		dispatcher.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
		dispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
	}
	
	//--------------------------------------------------------------------------
	//
	//	Event Handlers
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private function httpStatusHandler(e:HTTPStatusEvent):void {
		dispatchEvent(e.clone());
		dispatchEvent(new InvokeEvent(InvokeEvent.INVOKE, e.status));
	}
	
	/**
	 * @private
	 */
	private function ioErrorHandler(e:IOErrorEvent):void {
		removeListeners(IEventDispatcher(e.currentTarget));
		dispatchEvent(new FaultEvent(FaultEvent.FAULT, e.text));
	}
	
	/**
	 * @private
	 */
	private function onComplete(e:Event):void {
		removeListeners(IEventDispatcher(e.currentTarget));
		var body:Object = URLLoader(e.currentTarget).data;
		dispatchEvent(new ResultEvent(ResultEvent.RESULT, createResultObject(body)));
	}
	
	/**
	 * @private
	 */
	private function securityErrorHandler(e:SecurityErrorEvent):void {
		removeListeners(IEventDispatcher(e.currentTarget));
		dispatchEvent(new FaultEvent(FaultEvent.FAULT, e.text));
	}

	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//	contentType
	//--------------------------------------
	
	private var _contentType:String = CONTENT_TYPE_FORM;
	
	/**
	 *	@read/write
	 */
	public function get contentType():String {
		return _contentType;
	}
	
	public function set contentType(value:String):void {
		_contentType = value;
	}
	
	//--------------------------------------
	//	sendMethod
	//--------------------------------------
	
	private var _sendMethod:String = URLRequestMethod.POST;
	
	/**
	 *	@read/write
	 */
	public function get sendMethod():String {
		return _sendMethod;
	}
	
	public function set sendMethod(value:String):void {
		_sendMethod = value;
	}
	
	//--------------------------------------
	//	requestHeaders
	//--------------------------------------
	
	private var _requestHeaders:Object;
	
	/**
	 *	@read/write
	 */
	public function get requestHeaders():Object {
		return _requestHeaders;
	}
	
	public function set requestHeaders(value:Object):void {
		_requestHeaders = value;
	}
	
	//--------------------------------------
	//	resultFormat
	//--------------------------------------
	
	private var _resultFormat:String = RESULT_FORMAT_TEXT;
	
	/**
	 *	@read/write
	 */
	public function get resultFormat():String {
		return _resultFormat;
	}
	
	public function set resultFormat(value:String):void {
		_resultFormat = value;
	}
	
	//--------------------------------------
	//  url
	//--------------------------------------
	
	private var _url:String;
	
	/**
	 *	@read/write
	 */
	public function get url():String {
		return _url;
	}
	
	public function set url(value:String):void {
		_url = value;
	}
}

}