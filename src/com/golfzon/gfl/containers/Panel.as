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
import com.golfzon.gfl.managers.DragManager;
import com.golfzon.gfl.skins.Border;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.display.DisplayObject;
import flash.events.MouseEvent;

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *	헤더 스킨
 */
[Style(name="headerSkin", type="Class", inherit="no")]

/**
 *	타이틀 아이콘
 */
[Style(name="titleIcon", type="Class", inherit="no")]

/**
 *	타이틀 라벨의 스타일명
 */
[Style(name="titleLabelStyleName", type="String", inherit="no")]

/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.11.04
 *	@Modify
 *	@Description
 */
public class Panel extends Container
{
	//--------------------------------------------------------------------------
	//
	//	Instance constants
	//
	//--------------------------------------------------------------------------
	
	private const TITLE_PADDING_LEFT:Number = 3;
	
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
		titleLabel.styleName = getStyle(StyleProp.TITLE_LABEL_STYLE_NAME);
		titleLabel.text = _title;
		
		setViewMetrics(10);
		rawChildren.addChild(titleLabel);
	}
	
	/**
	 *	@private
	 */
	override protected function getContentPaneWidth():Number {
		return getHScrollBarWidth() - viewMetrics.left - viewMetrics.right;
	}
	
	/**
	 *	@private
	 */
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
		
		setActureSize(unscaledWidth, unscaledHeight);
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
				invalidateDisplayList();
				break;
				
			case StyleProp.HEADER_SKIN:
				removeHeader();
				header = createHeader();
				break;
				
			case StyleProp.TITLE_ICON:
				removeTitleIcon();
				titleIcon = createTitleIcon();
				invalidateDisplayList();
				break;
				
			case StyleProp.TITLE_LABEL_STYLE_NAME:
				titleLabel.styleName = getStyle(styleProp);
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
	
		if( titleIcon ) {
			titleIcon.x = borderThickness + TITLE_PADDING_LEFT;
			titleIcon.y = Math.round((headerHeight - titleIcon.height) / 2);
			titleLabel.x = titleIcon.x + titleIcon.width + 3;
		} else {
			titleLabel.x = borderThickness + TITLE_PADDING_LEFT;
		}
		
		titleLabel.width = unscaledWidth - titleLabel.x;
		titleLabel.height = titleLabel.measureHeight;
		titleLabel.y = Math.round((headerHeight - titleLabel.height) / 2);

		contentPane.width = Math.max(getContentPaneWidth(), largestChildPoint.x);
		contentPane.height = Math.max(getContentPaneHeight(), largestChildPoint.y);
		contentPane.y = borderThickness + viewMetrics.top + headerHeight;
		
		drawContentMask();
	}
	
	/**
	 * 	@private
	 */
	override protected function updateScrollBarProperties():void {
		var borderThickness:Number = getBorderThickness();
		getVScrollBar().height = unscaledHeight - borderThickness * 2 - headerHeight - viewMetrics.top - viewMetrics.bottom;
		getVScrollBar().x = unscaledWidth - borderThickness - viewMetrics.left - getVScrollBar().width;
		getVScrollBar().y = borderThickness + viewMetrics.top + headerHeight;
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	/**
	 * 	@private
	 */
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
				Border(header).styleName = getCSSStyleDeclaration();
				
			header.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
			
			return header;
		}
		return null;
	}
	
	/**
	 * 	@private
	 */
	private function createTitleIcon():DisplayObject {
		var iconClass:Class = replaceNullorUndefined(getStyle(StyleProp.TITLE_ICON), null);
		if( iconClass ) {
			var icon:DisplayObject = createSkinBy(iconClass);
			icon.x = getBorderThickness() + TITLE_PADDING_LEFT;
			icon.y = Math.round((headerHeight - icon.height) / 2);
			return rawChildren.addChild(icon);
		}
		return null;
	}
	
	/**
	 * 	@private
	 */
	private function getAlignedChildX(child:DisplayObject):Number {
		var horizontalAlign:String = replaceNullorUndefined(getStyle(StyleProp.HORIZONTAL_ALIGN), "left");
		if( horizontalAlign == "center" )
			return (Math.max(getContentPaneWidth(), largestChildPoint.x) - child.width) / 2;
		if( horizontalAlign == "right" )
			return Math.max(getContentPaneWidth(), largestChildPoint.x) - child.width;
		return 0;
	}
	
	/**
	 * 	@private
	 */
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
	
	/**
	 * 	@private
	 */
	private function removeHeader():void {
		if( header && rawChildren.contains(header) ) {
			header.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			rawChildren.removeChild(header);
			header = null;
		}
	}
	
	/**
	 * 	@private
	 */
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
	
	/**
	 * 	@private
	 */
	private function mouseDownHandler(event:MouseEvent):void {
		DragManager.doDrag(this);
		DragManager.showFeedback(DragManager.NONE);
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