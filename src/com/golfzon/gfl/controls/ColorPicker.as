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
	
import com.golfzon.gfl.controls.colorPickerClasses.ColorSampleViewer;
import com.golfzon.gfl.controls.colorPickerClasses.ColorTextField;
import com.golfzon.gfl.controls.colorPickerClasses.IColorSelectableObject;
import com.golfzon.gfl.controls.colorPickerClasses.SwatchPanel;
import com.golfzon.gfl.core.ComponentBase;
import com.golfzon.gfl.core.EdgeMetrics;
import com.golfzon.gfl.skins.Border;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *	아이템 선택이 변경되었을 때 송출한다.
 */
[Event(name="change", type="flash.events.Event")]

//--------------------------------------
//  Style
//--------------------------------------

/**
 * 	컬러 텍스트 필드의 스타일명<br>
 * 	@default value none
 */
[Style(name="colorTextFieldStyleName", type="String", inherit="no")]

/**
 * 	컬러 뷰어의 스타일명<br>
 * 	@default value none
 */
[Style(name="sampleColorViewStyleName", type="String", inherit="no")]

/**
 * 	스와치 패널의 스타일명<br>
 * 	@default value none
 */
[Style(name="swatchPanelStyleName", type="String", inherit="no")]

/**
 *	@Author				HJ Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.10.06
 *	@Modify
 *	@Description
 * 	@includeExample		ColorPickerSample.as
 */	
public class ColorPicker extends ComponentBase
{
	//--------------------------------------------------------------------------
	//
	//	Class constant
	//
	//--------------------------------------------------------------------------
	
	private static const KEY_CODE_ENTER:int = 13;
	 
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
    //--------------------------------------------------------------------------
    
    private var border:Border;
    
    private var colorSampleViewer:ColorSampleViewer;
    
    private var colorTextField:ColorTextField;
    
    private var swatchPanel:SwatchPanel;
	
	/**
	 *	@Constructor
	 */
	public function ColorPicker(){
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
     * 	자식 객체 생성 및 추가
     */
	override protected function createChildren():void {
		super.createChildren();
		
		border = new Border();
		
    	colorSampleViewer = new ColorSampleViewer();
    	colorSampleViewer.width = 20;
    	colorSampleViewer.height = 20;
		colorSampleViewer.styleName = getStyle(StyleProp.SAMPLE_COLOR_VIEW_STYLE_NAME);
		
    	colorTextField = new ColorTextField();
    	colorTextField.width = 70;
    	colorTextField.height = 20;
		colorTextField.styleName = getStyle(StyleProp.COLOR_TEXT_FIELD_STYLE_NAME);
		
    	swatchPanel = new SwatchPanel();
		swatchPanel.styleName = getStyle(StyleProp.SWATCH_PANEL_STYLE_NAME);
		
		setViewMetrics();
		configureListeners();
		addChild(border);
    	addChild(colorTextField);
    	addChild(swatchPanel);
    	addChild(colorSampleViewer);
	}
	
	/**
     * 	프로퍼티 변경 사항에 대한 처리
     */
	override protected function commitProperties():void {
		super.commitProperties();
		
		if( selectedChanged ) {
			selectedChanged = false;
			colorSampleViewer.selectedColor = colorTextField.selectedColor = swatchPanel.selectedColor =  selectedColor;
		}
		
		if( columnWidthChanged ) {
			columnWidthChanged = false;
			swatchPanel.columnWidth = columnWidth;
		}
		
		if( rowHeightChanged ) {
			rowHeightChanged = false;
			swatchPanel.rowHeight = rowHeight;
		}
		
		if( dataProviderChanged ) {
			dataProviderChanged = false;
			swatchPanel.dataProvider = dataProvider;
		}
		
		if( openModeChanged ) {
			openModeChanged = false;
			
			swatchPanelClose();
		}
	}
	
	/**
     * 	컴퍼넌트의 기본 크기와 최소 크기를 설정한다.
     */
	override protected function measure():void {
		super.measure();
		
		measureWidth = isNaN(measureWidth) ? 120 : measureWidth;
    	measureHeight = isNaN(measureHeight) ? 70 : measureHeight;
    	
    	setActureSize(unscaledWidth, unscaledHeight);
	}
	
	/**
     *	enabled 속성 변경에 대한 처리
     */
    override protected function setEnabledState():void {
    	super.setEnabledState();
    	colorSampleViewer.enabled = swatchPanel.enabled = colorTextField.enabled = enabled;
    }
	
	/**
     * 	디스플레이 변경 사항에 대한 처리
     */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		border.width = unscaledWidth;
		border.height = unscaledHeight;
		
		colorSampleViewer.y = colorTextField.y = borderThickness + viewMetrics.top;
		colorSampleViewer.x = swatchPanel.x = borderThickness + viewMetrics.left;
		
    	colorTextField.x = colorSampleViewer.x + colorSampleViewer.width + 5;
    	
    	swatchPanel.y = colorSampleViewer.y + colorSampleViewer.height + 5;
    	swatchPanel.width = unscaledWidth - (borderThickness * 2) - viewMetrics.left - viewMetrics.right;
	}
	
	/**
     *	스타일 프로퍼티로 값을 설정한다.
     */
	override public function styleChanged(styleProp:String):void {
		super.styleChanged(styleProp);
		
		switch( styleProp ) {
    		case StyleProp.COLOR_TEXT_FIELD_STYLE_NAME:
    			colorTextField.styleName = getStyle(styleProp);
    			break;
    			
    		case StyleProp.SAMPLE_COLOR_VIEW_STYLE_NAME:
    			colorSampleViewer.styleName = getStyle(styleProp);
    			break;
    			
   			case StyleProp.SWATCH_PANEL_STYLE_NAME:
    			swatchPanel.styleName = getStyle(styleProp);
    			break;
    			
    		case StyleProp.PADDING_LEFT: case StyleProp.PADDING_RIGHT:
    		case StyleProp.PADDING_TOP: case StyleProp.PADDING_BOTTOM:
    			setViewMetrics();
    			invalidateDisplayList();
    			break; 
    			
    		case StyleProp.BACKGROUND_ALPHA: case StyleProp.BACKGROUND_COLOR:
    		case StyleProp.BACKGROUND_IMAGE: case StyleProp.BORDER_COLOR:
    		case StyleProp.BORDER_THICKNESS: case StyleProp.CORNER_RADIUS:
    			if( border is Border ) {
    				Border(border).setStyle(styleProp, getStyle(styleProp));
    				invalidateDisplayList();
    			}
    			break;
    	}
	}
	//--------------------------------------------------------------------------
    //  Public
    //--------------------------------------------------------------------------
    
    /**
     * 	스와치 패널 열기
     */
	public function swatchPanelOpen():void {
		setVisiblity(!swatchPanel.visible);
	}
	
	/**
     *	스와치 패널 닫기
     */
	public function swatchPanelClose():void {
		setVisiblity(false);
	}
	
	//--------------------------------------------------------------------------
    //  Internal
    //--------------------------------------------------------------------------
    
    /**
     * 	@private
     */
    private function configureListeners():void {
    	colorSampleViewer.addEventListener(MouseEvent.MOUSE_DOWN, sampleViewerMouseDownHandler, false, 0, true);
    	colorTextField.addEventListener(Event.CHANGE, changeHandler, false, 0, true);
    	colorTextField.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler, false, 0, true);
    	swatchPanel.addEventListener(Event.CHANGE, changeHandler, false, 0, true);
    	swatchPanel.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler, false, 0, true);
    }
    
    /**
     *	@private
     */ 
    private function setViewMetrics():void {
    	_viewMetrics = new EdgeMetrics(
    		replaceNullorUndefined(getStyle(StyleProp.PADDING_LEFT), 5),
    		replaceNullorUndefined(getStyle(StyleProp.PADDING_TOP), 5),
    		replaceNullorUndefined(getStyle(StyleProp.PADDING_RIGHT), 5),
    		replaceNullorUndefined(getStyle(StyleProp.PADDING_BOTTOM), 5)
    	);
    }
	
    /**
     *	@private
     */ 
	private function setVisiblity(value:Boolean):void {
		if( openMode )
			return;
		
		border.visible = swatchPanel.visible = colorTextField.visible = value;
		invalidateDisplayList();
	}
	
	//--------------------------------------------------------------------------
	//
	//	Event handlers
	//
    //--------------------------------------------------------------------------

	/**
     *	@private
     */
    private function changeHandler(event:Event):void {
    	selectedColor = IColorSelectableObject(event.currentTarget).selectedColor;
    	
		dispatchEvent(event.clone());
    }
    
	/**
     *	@private
     */    
    private function mouseDownHandler(event:MouseEvent):void {
		swatchPanelClose();
    }
    
	/**
     *	@private
     */
    private function sampleViewerMouseDownHandler(event:MouseEvent):void {
    	swatchPanelOpen();
    }
    
	/**
     *	@private
     */
    private function keyDownHandler(event:KeyboardEvent):void {
		if( event.keyCode == KEY_CODE_ENTER)
			swatchPanelClose();
    }
    
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
    //--------------------------------------------------------------------------
	
	//--------------------------------------
	//	selectedColor   
	//--------------------------------------
	
	private var _selectedColor:uint;
	
	private var selectedChanged:Boolean;
	
	public function get selectedColor():uint {
		return _selectedColor;
	}
	
	public function set selectedColor(value:uint):void {
		if( value == _selectedColor )
			return;
		
		_selectedColor = value;
		selectedChanged = true;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//	columnWidth
	//--------------------------------------
	
	private var _columnWidth:int;
	
	private var columnWidthChanged:Boolean;
	
    public function get columnWidth():uint {
		return _columnWidth;
	}
	
	public function set columnWidth(value:uint):void {
		if( value == _columnWidth )
			return;
		
		_columnWidth = value;
		columnWidthChanged = true;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//	rowHeight
	//--------------------------------------
	
	private var _rowHeight:int;
	
	private var rowHeightChanged:Boolean;
	
    public function get rowHeight():uint {
		return _rowHeight;
	}
	
	public function set rowHeight(value:uint):void {
		if( value == _rowHeight )
			return;
		
		_rowHeight = value;
		rowHeightChanged = true;
		
		invalidateProperties();
	}

	//--------------------------------------
	//	dataProvider
	//--------------------------------------
	
	private var _dataProvider:Array = [];
	
	private var dataProviderChanged:Boolean;
	
	public function get dataProvider():Array {
		return _dataProvider;
	}
	
	public function set dataProvider(value:Array):void {
		if( value == _dataProvider )
			return;
		
		_dataProvider = value;
		dataProviderChanged = true;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//  openMode
	//--------------------------------------
	
	private var _openMode:Boolean = true;
	
	private var openModeChanged:Boolean;
	
	public function get openMode():Boolean {
		return _openMode
	}
	
	public function set openMode(value:Boolean):void {
		if( value == _openMode )
			return;
		
		_openMode = value;
		openModeChanged = true;
		invalidateProperties();
	}
	
	//--------------------------------------
	//  viewMetrics
	//--------------------------------------
	
	private var _viewMetrics:EdgeMetrics;
	
	public function get viewMetrics():EdgeMetrics {
		return _viewMetrics;
	}
	
	//--------------------------------------
	//  borderThickness
	//--------------------------------------
	
	private function get borderThickness():int {
		return replaceNullorUndefined(getStyle(StyleProp.BORDER_THICKNESS), 0);
	}
}

}