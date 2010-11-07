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

package com.golfzon.gfl.controls.buttonClasses
{
	
import com.golfzon.gfl.controls.Button;
import com.golfzon.gfl.core.ComponentBase;
import com.golfzon.gfl.core.gz_internal;
import com.golfzon.gfl.events.ButtonBarEvent;
import com.golfzon.gfl.styles.StyleProp;

import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.events.MouseEvent;

use namespace gz_internal;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *	아이템이 클릭 되었을 때 발송한다.
 */
[Event(name="buttonClick", type="com.golfzon.gfl.events.ButtonBarEvent")]

/**
 *	아이템이 롤오버 되었을 때 발송한다.
 */
[Event(name="buttonRollOver", type="com.golfzon.gfl.events.ButtonBarEvent")]

//--------------------------------------
//  Style
//--------------------------------------

/**
 *  버튼 스킨
 * 	@default value com.golfzon.gfl.controls.buttonClasses.SimpleButton
 */
[Style(name="buttonStyleName", type="String", inherit="no")]

/**
 *  첫번째 버튼의 스킨
 * 	@default value com.golfzon.gfl.controls.buttonClasses.SimpleButton
 */
[Style(name="firstButtonStyleName", type="String", inherit="no")]

/**
 *  마지막 버튼의 스킨
 * 	@default value com.golfzon.gfl.controls.buttonClasses.SimpleButton
 */
[Style(name="lastButtonStyleName", type="String", inherit="no")]

/**
 *  왼쪽 상위 버튼의 스킨
 * 	@default value com.golfzon.gfl.controls.buttonClasses.SimpleButton
 */
[Style(name="leftTopButtonStyleName", type="String", inherit="no")]

/**
 *  왼쪽 하단  버튼의 스킨
 * 	@default value com.golfzon.gfl.controls.buttonClasses.SimpleButton
 */
[Style(name="leftBottomButtonStyleName", type="String", inherit="no")]

/**
 *  오른쪽 상위 버튼의 스킨
 * 	@default value com.golfzon.gfl.controls.buttonClasses.SimpleButton
 */
[Style(name="rightTopButtonStyleName", type="String", inherit="no")]

/**
 *  오른쪽 하단 버튼의 스킨
 * 	@default value com.golfzon.gfl.controls.buttonClasses.SimpleButton
 */
[Style(name="rightBottomButtonStyleName", type="String", inherit="no")]

/**
 *  버튼의 가로 길이
 * 	@default value undefind
 */
[Style(name="buttonWidth", type="uint", inherit="no")]

/**
 *  버튼의 세로 길이
 * 	@default value undefind
 */
[Style(name="buttonHeight", type="uint", inherit="no")]

/**
 *	@Author				SH Jung
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.10.26
 *	@Modify
 *	@Description
 */	
public class ButtonBarBase extends ComponentBase
{
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
    //--------------------------------------------------------------------------
    
    /**
     *	버튼 리스트
     */
    protected var buttonList:Array;
    
    /**
     *	버튼 토글 모드
     */
    protected var toggleMode:Boolean;
    
    /**
     *	선택된 버튼
     */
    private var selectedButton:Button;
    
	/**
	 *	@Constructor
	 */
	public function ButtonBarBase(){
		super();
		
		toggleMode = false;
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
	}
	
	/**
     * 	프로퍼티 변경 사항에 대한 처리
     */
	override protected function commitProperties():void {
		super.commitProperties();
		
		if( dataProviderChanged ) {
			dataProviderChanged = false;
			setButtons();
		}
	}
    
    /**
     * 	컴퍼넌트의 기본 크기와 최소 크기를 설정한다.
     */
    override protected function measure():void {
    	super.measure();

    	measureWidth = getWidth();
    	measureHeight = getHeight();
    	
    	setActureSize(measureWidth, measureHeight);
    }
	
	/**
     * 	디스플레이 변경 사항에 대한 처리
     */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		if( selectedIndexChanged ) {
			selectedIndexChanged = false;
			buttonList[_selectedIndex].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		setButtonsGap();
	}
	
	/**
     *	스타일 프로퍼티로 값을 설정한다.
     */
	override public function styleChanged(styleProp:String):void {
		super.styleChanged(styleProp);
		
		switch( styleProp ) {
			case StyleProp.FIRST_BUTTON_STYLE_NAME:			case StyleProp.LAST_BUTTON_STYLE_NAME:
			case StyleProp.LEFT_TOP_BUTTON_STYLE_NAME:		case StyleProp.LEFT_BOTTOM_BUTTON_STYLE_NAME:
			case StyleProp.RIGHT_TOP_BUTTON_STYLE_NAME:		case StyleProp.RIGHT_BOTTOM_BUTTON_STYLE_NAME:
			case StyleProp.BUTTON_STYLE_NAME:
				setButtonStyle();
				break;
			
			case StyleProp.BUTTON_WIDTH:	case StyleProp.BUTTON_HEIGHT:
				setButtonScale();
				break;
			
			case StyleProp.HORIZONTAL_GAP:	case StyleProp.VERTICAL_GAP:
				setButtonsGap();
				break;
		}
	}
	
	/**
	 *	enabled 속성이 변경되었을 때 호출되며, mouseEnabled, mouseChildren이 변경된다.
	 */
	override protected function setEnabledState():void {
		super.setEnabledState();
		
		for( var i:uint = 0; i<buttonList.length; i++ ) {
			buttonList[i].enabled = enabled;
		}
	}
    
	//--------------------------------------------------------------------------
    //  Internal
    //--------------------------------------------------------------------------
	
    /**
     *  이벤트 리스너 등록
     */
    private function configureListeners(dispatcher:IEventDispatcher):void {
    	dispatcher.addEventListener(Event.CHANGE, changeHandler, false, 0, true);
    	dispatcher.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
    	dispatcher.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler, false, 0, true);
    }
    
    /**
     * 	버튼 생성
     */
	private function setButtons():void {
		var i:uint;
		var length:uint;
		
		if( buttonList ) {
			length = buttonList.length;
			for( i = 0; i<length; i++ ) {
				removeListeners(buttonList[i]);
				removeChild(buttonList[i]);
			}
		}
		buttonList = [];
		
		length = _dataProvider.length;
		for( i = 0; i<length; i++ ) {
			var button:Button = new Button();
			button.name = _dataProvider[i];
			button.label = _dataProvider[i];
			button.enabled = enabled;
			button.toggle = toggleMode;
			if( getStyle(StyleProp.BUTTON_WIDTH) != undefined ) button.width = getStyle(StyleProp.BUTTON_WIDTH);
			if( getStyle(StyleProp.BUTTON_HEIGHT) != undefined ) button.height = getStyle(StyleProp.BUTTON_HEIGHT);
			configureListeners(button);
			buttonList[buttonList.length] = button;
			addChild(button);
		}
		
		setButtonsGap();
		setButtonStyle();
	}
	
    /**
     * 	버튼 크기 설정
     */
	private function setButtonScale():void {
		var w:Number = getStyle(StyleProp.BUTTON_WIDTH);
		var h:Number = getStyle(StyleProp.BUTTON_HEIGHT);
		var button:Button;
		for( var i:uint = 0; i<buttonList.length; i++ ) {
			button = buttonList[i];
			button.width = w;
			button.height = h;
		}
		
		invalidateDisplayList();
	}
	
    /**
     * 	버튼 스타일 설정
     */
	protected function setButtonStyle():void {
		for( var i:uint = 0; i<buttonList.length; i++ ) {
			buttonList[i].styleName = getStyle(StyleProp.BUTTON_STYLE_NAME);
		}
		
		if( getStyle(StyleProp.FIRST_BUTTON_STYLE_NAME) ) {
			buttonList[0].styleName = getStyle(StyleProp.FIRST_BUTTON_STYLE_NAME);
		}
		
		if( getStyle(StyleProp.LAST_BUTTON_STYLE_NAME) ) {
			buttonList[buttonList.length - 1].styleName = getStyle(StyleProp.LAST_BUTTON_STYLE_NAME);
		}
		
		invalidateDisplayList();
	}
    
    /**
	 *	이벤트 리스너 해지
	 */
    private function removeListeners(dispatcher:IEventDispatcher):void {
    	dispatcher.removeEventListener(Event.CHANGE, changeHandler);
		dispatcher.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		dispatcher.removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
    }
	
    /**
     *  TODO : 버튼 토글 구현
     */
	protected function setToggle():void {
    	throw new Error("이 메소드는 구현이 필요한 추상 메소드입니다.");
	}
	
	/**
     *	TODO : 버튼바 가로 길이
     */
    protected function getWidth():Number {
    	throw new Error("이 메소드는 구현이 필요한 추상 메소드입니다.");
    }
    
    /**
     *	TODO : 버튼바 세로 길이
     */
    protected function getHeight():Number {
    	throw new Error("이 메소드는 구현이 필요한 추상 메소드입니다.");
    }
	
	
    /**
     * 	TODO : 버튼 간격 설정
     */
	protected function setButtonsGap():void {
    	throw new Error("이 메소드는 구현이 필요한 추상 메소드입니다.");
	}
	
	//--------------------------------------------------------------------------
	//
	//	Event handlers
	//
    //--------------------------------------------------------------------------

	/**
     * 	@Event.CHANGE
     */
	private function changeHandler(event:Event):void {
		if( !toggleMode )
			return;
		
		if( selectedButton === event.currentTarget )
			selectedButton.selected = !selectedButton.selected;
		
		selectedButton = Button(event.currentTarget);
	}
	
	/**
     * 	@MouseEvent.MOUSE_DOWN
     */
    private function mouseDownHandler(event:MouseEvent):void {
    	_selectedIndex = buttonList.indexOf(event.currentTarget);
    	dispatchEvent(new ButtonBarEvent(ButtonBarEvent.BUTTON_CLICK));
    	setToggle();
    }
    
	/**
	 *  @MouseEvent.ROLL_OVER
	 */
	private function rollOverHandler(event:MouseEvent):void {
    	_overIndex = buttonList.indexOf(event.currentTarget);
    	dispatchEvent(new ButtonBarEvent(ButtonBarEvent.BUTTON_ROLL_OVER));
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
    //--------------------------------------------------------------------------
	
	//--------------------------------------
	//	columnCount
	//--------------------------------------
	
	protected var columnCountChanged:Boolean;
	
	protected var _columnCount:uint;
	
	public function get columnCount():uint {
		return _columnCount;
	}
	
	public function set columnCount(value:uint):void {
		if( value == _columnCount )
			return;
		
		_columnCount = value;
		columnCountChanged = true;
		
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	dataProvider
	//--------------------------------------
	
	private var dataProviderChanged:Boolean = false;
	
	private var _dataProvider:Array = [];
	
	public function get dataProvider():Array {
		return _dataProvider;
	}
	
	public function set dataProvider(value:Array):void {
		if( _dataProvider === value )
			return;
		
		_dataProvider = value;
		dataProviderChanged = true;
		invalidateProperties();
	}
	
	//--------------------------------------
	//	overIndex
	//--------------------------------------
	
	private var _overIndex:uint;
	
	public function get overIndex():uint {
		return _overIndex;
	}
	
	private function set overIndex(value:uint):void {
		_overIndex = value;
	}
	
	//--------------------------------------
	//	selectedIndex
	//--------------------------------------
	
	protected var selectedIndexChanged:Boolean;
	
	private var _selectedIndex:uint = uint.MAX_VALUE;
	
	public function get selectedIndex():uint {
		return _selectedIndex;
	}
	
	public function set selectedIndex(value:uint):void {
		if( value == _selectedIndex )
			return;
		
		selectedIndexChanged = true;
		_selectedIndex = value;
		
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	rowCount
	//--------------------------------------
	
	protected var rowCountChanged:Boolean;
	
	protected var _rowCount:uint;
	
	public function get rowCount():uint {
		return _rowCount;
	}
	
	public function set rowCount(value:uint):void {
		if( value == _rowCount )
			return;
		
		_rowCount = value;
		rowCountChanged = true;
		
		invalidateDisplayList();
	}
}

}