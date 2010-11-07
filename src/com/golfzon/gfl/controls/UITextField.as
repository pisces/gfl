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

import com.golfzon.gfl.core.ComponentBase;
import com.golfzon.gfl.core.IInteractiveObject;
import com.golfzon.gfl.core.gz_internal;
import com.golfzon.gfl.events.StyleEvent;
import com.golfzon.gfl.events.TextEvent;
import com.golfzon.gfl.styles.CSSStyleDeclaration;
import com.golfzon.gfl.styles.GStyleManager;
import com.golfzon.gfl.styles.IStyleClient;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.text.RichTextField;
import com.golfzon.gfl.utils.UIDUtil;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.events.Event;
import flash.text.AntiAliasType;
import flash.text.TextFormat;

use namespace gz_internal;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *	텍스트 포멧이 변경되었을 때 송출한다.
 */
[Event(name="textFormatChanged", type="com.golfzon.gfl.events.TextEvent")]

/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.08.20
 *	@Modify
 *	@Description
 */
public class UITextField extends RichTextField implements IInteractiveObject, IStyleClient
{
    //--------------------------------------------------------------------------
	//
	//	Instance value
	//
    //--------------------------------------------------------------------------

    gz_internal static const TEXT_WIDTH_PADDING:int = 4;
    gz_internal static const TEXT_HEIGHT_PADDING:int = 4;
	
	/**
	 *	객체 생성 및 추가 완료에 대한 부울값
	 */
	protected var creationComplete:Boolean;
    
	/**
	 *	CSSStyleDeclaration 인스턴스
	 */
    private var declaration:CSSStyleDeclaration = new CSSStyleDeclaration();
	
	/**
	 *	@Constructor
	 */
	public function UITextField() {
		super();
		
		_uid = UIDUtil.createUID();
		addEventListener(Event.ADDED, addedHandler, false, 0, true);
	}
	
    //--------------------------------------------------------------------------
	//
	//	Instance methods
	//
    //--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------
    //  Overriden : RichTextField
    //--------------------------------------------------------------------------
	
	//--------------------------------------
	//	enabled
	//--------------------------------------
	
	override public function set enabled(value:Boolean):void {
		if( super.enabled == value ) return;
		
		super.enabled = value;
    	
    	setTextFormat(getTextFormatByStyleProperties());
	}
    
	//--------------------------------------
	//	text
	//--------------------------------------
	
    override public function set text(value:String):void {
    	if( super.text == value ) return;
    	
    	super.text = value;
    	
    	if( creationComplete )
    		setTextFormat(getTextFormatByStyleProperties());
    }
    
	//--------------------------------------
	//	htmlText
	//--------------------------------------
	
    override public function set htmlText(value:String):void {
    	if( super.htmlText == value ) return;
    		
    	super.htmlText = value;
    	
    	if( creationComplete )
    		setTextFormat(getTextFormatByStyleProperties());
    }
    
    //--------------------------------------------------------------------------
    //  Public
    //--------------------------------------------------------------------------
    
    /**
     *	CSS 스타일 정의를 반환한다.
     */
    public function getCSSStyleDeclaration():CSSStyleDeclaration {
    	return declaration;
    }
    
	/**
	 *	상속시킬 스타일 프로퍼티 정의를 반환한다.
	 */
    public function getInheritStyleTable():Hashtable {
    	return null;
    }
    
    /**
     *	스타일 프로퍼티에 의해 값을 반환한다.
     */
    public function getStyle(styleProp:String):* {
    	return declaration.getStyle(styleProp);
    }
    
    /**
     *	CSS 스타일 정의를 설정한다.
     */
	public function setCSSStyleDeclaration(declaration:CSSStyleDeclaration):void {
		this.declaration = declaration;
	}
    
    /**
     *	스타일 프로퍼티로 값을 설정한다.
     */
    public function setStyle(styleProp:String, value:*):void {
    	declaration.setStyle(styleProp, value);
    	
    	if( creationComplete )
    		styleChanged(styleProp);
    }
    
	/**
	 *	스타일 속성이 바뀌었을 시점에 대한 구현
	 */
    public function styleChanged(styleProp:String):void {
    	antiAliasType = replaceNullorUndefined(getStyle(StyleProp.ANTI_ALIAS_TYPE), AntiAliasType.NORMAL);
    	embedFonts = (getStyle(StyleProp.ANTI_ALIAS_TYPE) == AntiAliasType.ADVANCED);
		
		var textFormat:TextFormat = getTextFormatByStyleProperties();
		defaultTextFormat = textFormat;
    	setTextFormat(textFormat);
    	dispatchEvent(new TextEvent(TextEvent.TEXT_FORMAT_CHANGED));
    }
    
    //--------------------------------------------------------------------------
    //  Internal
    //--------------------------------------------------------------------------
    
	/**
	 *	@private
	 */
    private function configureListenersToParent():void {
    	if( parent is IInteractiveObject )
    		parent.addEventListener("enableChanged", parent_enableChangedHandler, false, 0, true);
    		
    	if( parent is IStyleClient ) {
    		parent.addEventListener(StyleEvent.REGISTER_INSTANCE, parent_registerInstanceHandler, false, 0, true);
    		parent.addEventListener(StyleEvent.STYLE_CHANGED, parent_styleChangedHandler, false, 0, true);
    	}
    }
    
    /**
     *	@private
     */
    private function getColor():uint {
    	return enabled ? replaceNullorUndefined(getStyle(StyleProp.COLOR), 0x333333) :
    		replaceNullorUndefined(getStyle(StyleProp.DISABLED_COLOR), 0xDDDDDD);
    }
    
    /**
     *	@private
     */
    private function getTextFormatByStyleProperties():TextFormat {
    	var format:TextFormat = getTextFormat();
    	format.align = replaceNullorUndefined(getStyle(StyleProp.TEXT_ALIGN), "left");
    	format.bold = getStyle(StyleProp.FONT_WEIGHT) == "bold";
    	format.color = getColor();
    	format.font = replaceNullorUndefined(getStyle(StyleProp.FONT_FAMILY), "dotum");
    	format.italic = replaceNullorUndefined(getStyle(StyleProp.ITALIC), false);
    	format.leading = replaceNullorUndefined(getStyle(StyleProp.LEADING), 0);
    	format.letterSpacing = replaceNullorUndefined(getStyle(StyleProp.LETTER_SPACING), 0);
    	format.size = replaceNullorUndefined(getStyle(StyleProp.FONT_SIZE), 11);
    	format.underline = replaceNullorUndefined(getStyle(StyleProp.UNDERLINE), false);
    	return format;
    }
    
    /**
     *	@private
     */
    public function registerInstance():void {
    	var canDo:Boolean = creationComplete && parent is ComponentBase && ComponentBase(parent).systemManager.cssInitialized;
		if( canDo ) {
			GStyleManager.registerInstance(this);
			styleChanged(null);
			dispatchEvent(new StyleEvent(StyleEvent.REGISTER_INSTANCE));
		}
    }
    
    /**
     *	@private
     */
    private function setStyleBy(styleObj:Object):void {
		for( var styleProp:String in styleObj ) {
			setStyle(styleProp, styleObj[styleProp]);
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
    private function addedHandler(event:Event):void {
		removeEventListener(Event.ADDED, addedHandler);
		configureListenersToParent();
		creationComplete = true;
    	registerInstance();
    }
    
	/**
	 *	@private
	 */
    private function parent_enableChangedHandler(event:Event):void {
    	enabled = IInteractiveObject(parent).enabled;
    }
    
	/**
	 *	@private
	 */
    private function parent_registerInstanceHandler(event:StyleEvent):void {
    	registerInstance();
    }
    
	/**
	 *	@private
	 */
    private function parent_styleChangedHandler(event:StyleEvent):void {
    	if( creationComplete && IStyleClient(parent).getInheritStyleTable().contains(event.styleProp) )
    		setStyle(event.styleProp, event.value);
    }
		
    //--------------------------------------------------------------------------
	//
	//	getter / setter
	//
    //--------------------------------------------------------------------------

    //----------------------------------
    //  measuredWidth
    //----------------------------------

    public function get measuredWidth():Number {
        if( !stage )	return textWidth + TEXT_WIDTH_PADDING;
        return textWidth * transform.concatenatedMatrix.d + TEXT_WIDTH_PADDING;
    }

    //----------------------------------
    //  measuredHeight
    //----------------------------------

    public function get measuredHeight():Number {
        if( !stage )	return textHeight + TEXT_HEIGHT_PADDING;
        return textHeight * transform.concatenatedMatrix.a + TEXT_HEIGHT_PADDING;
    }
	
	//--------------------------------------
	//	styleName
	//--------------------------------------
	
	private var styleNameChanged:Boolean;
	
	private var _styleName:Object;
	
	public function get styleName():Object {
		return _styleName;
	}
	
	public function set styleName(value:Object):void {
		if( value === _styleName )
			return;
		
		_styleName = value;
		styleNameChanged = creationComplete;
		
		if( !styleNameChanged )
			return;
		
		if( typeof styleName == "string" ) {
			var styleObj:Object = GStyleManager.getStyleDeclaration(String(styleName));
			setStyleBy(styleObj);
		} else if( typeof styleName == "object" ) {
			setStyleBy(styleName);
		}
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