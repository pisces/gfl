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
import com.golfzon.gfl.controls.Label;
import com.golfzon.gfl.core.Container;
import com.golfzon.gfl.core.IInteractiveObject;
import com.golfzon.gfl.events.DragEvent;
import com.golfzon.gfl.managers.CursorManager;
import com.golfzon.gfl.managers.DragManager;
import com.golfzon.gfl.skins.Border;
import com.golfzon.gfl.styles.GStyleManager;
import com.golfzon.gfl.styles.IStyleClient;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.display.DisplayObject;
import flash.events.MouseEvent;
import flash.ui.Mouse;
import flash.ui.MouseCursor;

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *	헤더 높이
 */
[Style(name="headerHeight", type="Number", inherit="no")]

/**
 *	헤더 스킨
 */
[Style(name="headerSkin", type="Class", inherit="no")]

/**
 *	헤더 높이
 */
[Style(name="headerStyleName", type="String", inherit="no")]

/**
 *	타이틀 아이콘
 */
[Style(name="titleIcon", type="Class", inherit="no")]

/**
 *	@Author				KHKim
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.11.04
 *	@Modify
 *	@Description
 */
public class Panel extends Container
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	protected var titleLabel:Label;
	
	protected var header:DisplayObject;
	protected var titleIcon:DisplayObject;
	
	/**
	 *	@Constructor
	 */
	public function Panel() {
		super();
		
		setStyle(StyleProp.BORDER_THICKNESS, 1);
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
	 * 	프로퍼티 변경 사항에 대한 처리
	 */
	override protected function commitProperties():void {
		super.commitProperties();

		if( titleChanged ) {
			titleChanged = false;
			titleLabel.text = _title;
		}
	}
	
	/**
	 * 	자식 객체 생성 및 추가
	 */
	override protected function createChildren():void {
		super.createChildren();
		
		header = createHeader();
		titleIcon = createTitleIcon();
		
		titleLabel = new Label();
		titleLabel.mouseChildren = titleLabel.mouseEnabled = false;
		titleLabel.styleName = getStyle(StyleProp.HEADER_STYLE_NAME);
		titleLabel.text = _title;
		
		setViewMetrics(10);
		rawChildren.addChild(titleLabel);
	}
	
	override protected function getContentPaneWidth():Number {
		return getHScrollBarWidth() - viewMetrics.left - viewMetrics.right;
	}
	
	override protected function getContentPaneHeight():Number {
		return getVScrollBarHeight() - viewMetrics.top - viewMetrics.bottom - headerHeight;
	}
	
	/**
	 * 	컴퍼넌트의 기본 크기와 최소 크기를 설정한다.
	 */
	override protected function measure():void {
		super.measure();
		
		measureWidth = isNaN(measureWidth) ? 300 : measureWidth;
		measureHeight = isNaN(measureHeight) ? 250 : measureHeight;
		
		setActualSize(unscaledWidth, unscaledHeight);
		updateContentPaneChildProperties();
	}
	
	/**
	 *	타겟 스크롤
	 */
	override protected function scrollTarget():void {
		super.scrollTarget();
		
		contentPane.y += headerHeight;
	}
	
	/**
	 *	스타일 프로퍼티로 값을 설정한다.
	 */
	override public function styleChanged(styleProp:String):void {
		super.styleChanged(styleProp);

		switch( styleProp ) {
			case StyleProp.BACKGROUND_ALPHA: case StyleProp.BACKGROUND_COLOR:
			case StyleProp.BACKGROUND_IMAGE: case StyleProp.BORDER_COLOR:
			case StyleProp.BORDER_THICKNESS: case StyleProp.CORNER_RADIUS:
				if( header is Border ) {
					Border(header).setStyle(styleProp, getStyle(styleProp));
					invalidateDisplayList();
				}
				break;
				
			case StyleProp.BORDER_SKIN: case StyleProp.HEADER_HEIGHT:
			case StyleProp.HORIZONTAL_ALIGN: case StyleProp.VERTICAL_ALIGN:
			case StyleProp.HEADER_HEIGHT:
				invalidateDisplayList();
				break;
				
			case StyleProp.HEADER_SKIN:
				removeHeader();
				header = createHeader();
				break;
			
			case StyleProp.HEADER_STYLE_NAME:
				if( header is IStyleClient )
					IStyleClient(header).styleName = getStyle(styleProp);
				titleLabel.styleName = getStyle(styleProp);
				break;
				
			case StyleProp.TITLE_ICON:
				removeTitleIcon();
				titleIcon = createTitleIcon();
				invalidateDisplayList();
				break;
	 	}
	}
	
	/**
	 * 	디스플레이 변경 사항에 대한 처리
	 */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		var borderThickness:Number = getBorderThickness();
		var headerHeight:Number = this.headerHeight;
		
		border.height = unscaledHeight - headerHeight + borderThickness;
		border.y = headerHeight - borderThickness;
		
		border.width = header.width = unscaledWidth;
		header.height = headerHeight;
		
		var headerStyle:String = getStyle(StyleProp.HEADER_STYLE_NAME);
		var pl:Number = headerStyle ? GStyleManager.getStyleDeclaration(headerStyle).getStyle(StyleProp.PADDING_LEFT) : 5;
		if( titleIcon ) {
			titleIcon.x = borderThickness + pl;
			titleIcon.y = Math.round((headerHeight - titleIcon.height) / 2);
			titleLabel.x = titleIcon.x + titleIcon.width + 3;
		} else {
			titleLabel.x = borderThickness;
		}
		
		titleLabel.width = unscaledWidth - titleLabel.x;
		titleLabel.height = titleLabel.measureHeight;
		titleLabel.y = Math.round((headerHeight - titleLabel.height) / 2);
	}
	
	override protected function updateChildDisplay():void {
		super.updateChildDisplay();
		
		contentPane.y = getBorderThickness() + viewMetrics.top + headerHeight;
		
		drawContentMask();
	}
	
	override protected function updateScrollBarProperties():void {
		var borderThickness:Number = getBorderThickness();
		getVScrollBar().height = unscaledHeight - borderThickness * 2 - headerHeight - viewMetrics.top - viewMetrics.bottom;
		getVScrollBar().x = unscaledWidth - borderThickness - viewMetrics.left - getVScrollBar().width;
		getVScrollBar().y = borderThickness + viewMetrics.top + headerHeight;
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	private function createHeader():DisplayObject {
		var headerClass:Class = replaceNullorUndefined(getStyle(StyleProp.HEADER_SKIN), Border);
		if( headerClass ) {
			var header:DisplayObject = createSkinBy(headerClass);
			var borderThickness:Number = header is Border ? getBorderThickness() : 0;
			header.width = unscaledWidth - borderThickness;
			header.height = headerHeight - borderThickness;
			
			if( header is IInteractiveObject )
				IInteractiveObject(border).enabled = enabled;
			
			rawChildren.addChild(header);
			
			if( header is Border )
				Border(header).styleName = getStyle(StyleProp.HEADER_STYLE_NAME);
				
			header.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
			
			return header;
		}
		return null;
	}
	
	private function createTitleIcon():DisplayObject {
		var iconClass:Class = replaceNullorUndefined(getStyle(StyleProp.TITLE_ICON), null);
		if( iconClass ) {
			var headerStyle:String = getStyle(StyleProp.HEADER_STYLE_NAME);
			var pl:Number = headerStyle ? GStyleManager.getStyleDeclaration(headerStyle).getStyle(StyleProp.PADDING_LEFT) : 5;
			var icon:DisplayObject = createSkinBy(iconClass);
			icon.x = getBorderThickness() + pl;
			icon.y = Math.round((headerHeight - icon.height) / 2);
			return rawChildren.addChild(icon);
		}
		return null;
	}
	
	private function getAlignedChildX(child:DisplayObject):Number {
		var horizontalAlign:String = replaceNullorUndefined(getStyle(StyleProp.HORIZONTAL_ALIGN), "left");
		if( horizontalAlign == "center" )
			return (Math.max(getContentPaneWidth(), largestChildPoint.x) - child.width) / 2;
		if( horizontalAlign == "right" )
			return Math.max(getContentPaneWidth(), largestChildPoint.x) - child.width;
		return 0;
	}
	
	protected function updateContentPaneChildProperties():void {
		largestChildPoint.x = largestChildPoint.y = 0;
		
		var verticalGap:Number = replaceNullorUndefined(getStyle(StyleProp.VERTICAL_GAP), 10);
		var newY:Number = 0;
		for( var i:int=0; i<numChildren; i++ ) {
			var child:DisplayObject = getChildAt(i);
			child.x = getAlignedChildX(child);
			child.y = newY;
			compareLargestChildPoint(child);
			newY = child.y + child.height + verticalGap;
		}
	}
	
	private function removeHeader():void {
		if( header && rawChildren.contains(header) ) {
			header.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			rawChildren.removeChild(header);
			header = null;
		}
	}
	
	private function removeTitleIcon():void {
		if( titleIcon && rawChildren.contains(titleIcon) ) {
			rawChildren.removeChild(titleIcon);
			titleIcon = null;
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//	Event handlers
	//
	//--------------------------------------------------------------------------
	
	private function mouseDownHandler(event:MouseEvent):void {
		if( _dragEnabled ) {
			DragManager.doDrag(this, null, null, 0, 0, 1.5, 1);
			DragManager.showFeedback(DragManager.NONE);
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//	headerHeight
	//--------------------------------------
	
	protected function get headerHeight():Number {
		return replaceNullorUndefined(getStyle(StyleProp.HEADER_HEIGHT), 25);
	}
	
	//--------------------------------------
	//	dragEnabled
	//--------------------------------------
	
	private var _dragEnabled:Boolean = true;
	
	public function get dragEnabled():Boolean {
		return _dragEnabled;
	}
	
	public function set dragEnabled(value:Boolean):void {
		if( value === _dragEnabled )
			return;
		
		_dragEnabled = value;
	}
	
	//--------------------------------------
	//	title
	//--------------------------------------
	
	private var titleChanged:Boolean;
	
	private var _title:String;
	
	public function get title():String {
		return _title;
	}
	
	public function set title(value:String):void {
		if( value === _title )
			return;
		
		_title = value;
		titleChanged = true;
		
		invalidateProperties();
		invalidateDisplayList();
	}
}

}