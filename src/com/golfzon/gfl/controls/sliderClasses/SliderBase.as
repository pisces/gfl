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

package com.golfzon.gfl.controls.sliderClasses
{

import com.golfzon.gfl.controls.Label;
import com.golfzon.gfl.controls.buttonClasses.SimpleButton;
import com.golfzon.gfl.core.ComponentBase;
import com.golfzon.gfl.core.gz_internal;
import com.golfzon.gfl.events.SliderEvent;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.display.Shape;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.ui.Keyboard;

use namespace gz_internal;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *	내부에서 value가 변경되면 송출한다.
 */
[Event(name="change", type="com.golfzon.gfl.events.SliderEvent")]

/**
 *	Thumb가 드래그되면 송출한다.
 */
[Event(name="thumbDrag", type="com.golfzon.gfl.events.SliderEvent")]

/**
 *	Thumb가 press 상태일 때 송출한다.
 */
[Event(name="thumbPress", type="com.golfzon.gfl.events.SliderEvent")]

/**
 *	Thumb가 release 상태일 때 송출한다.
 */
[Event(name="thumbRelease", type="com.golfzon.gfl.events.SliderEvent")]

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *	눈금자의 색상
 *	@default value 0x666666
 */
[Style(name="tickColor", type="uint", inherit="no")]

/**
 *	눈금자의 크기
 *	@default value 5
 */
[Style(name="tickSize", type="Number", inherit="no")]

/**
 *	트랜 스킨
 *	@default value "Symbol VSlider_trackSkin of GZSkin.swf"
 */
[Style(name="trackSkin", type="Class", inherit="no")]

/**
 *	비활성 상태의 트랜 스킨
 *	@default value "Symbol VSlider_trackDisabledSkin of GZSkin.swf"
 */
[Style(name="trackDisabledSkin", type="Class", inherit="no")]

/**
 *	Thumb의 up상태 스킨
 *	@default value "Symbol VSlider_thumbUpSkin of GZSkin.swf"
 */
[Style(name="thumbUpSkin", type="Class", inherit="no")]

/**
 *	Thumb의 over상태 스킨
 *	@default value "Symbol VSlider_thumbOverSkin of GZSkin.swf"
 */
[Style(name="thumbOverSkin", type="Class", inherit="no")]

/**
 *	Thumb의 down상태 스킨
 *	@default value "Symbol VSlider_thumbDownSkin of GZSkin.swf"
 */
[Style(name="thumbDownSkin", type="Class", inherit="no")]

/**
 *	Thumb의 disabled상태 스킨
 *	@default value "Symbol VSlider_thumbDisabledSkin of GZSkin.swf"
 */
[Style(name="thumbDisabledSkin", type="Class", inherit="no")]

/**
 *	@Author				KHKim
 *	@Version			1.0
 *	@Lanaguage			Action Script 3.0
 *	@Date				2010.03.15
 *	@Modify
 *	@Description
 * 	@includeExample
 */
public class SliderBase extends ComponentBase
{
	//--------------------------------------------------------------------------
	//
	//	Instance constants
	//
	//--------------------------------------------------------------------------
	
	private const TICK_COLOR_STYLE_PROP:String = "tickColor";
	private const TICK_SIZE_STYLE_PROP:String = "tickSize";
	private const TRACK_SKIN_STYLE_PROP:String = "trackSkin";
	private const TRACK_DISABLED_SKIN_STYLE_PROP:String = "trackDisabledSkin";
	private const THUMB_UP_SKIN_STYLE_PROP:String = "thumbUpSkin";
	private const THUMB_OVER_SKIN_STYLE_PROP:String = "thumbOverSkin";
	private const THUMB_DOWN_SKIN_STYLE_PROP:String = "thumbDownSkin";
	private const THUMB_DISABLED_SKIN_STYLE_PROP:String = "thumbDisabledSkin";
	
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	gz_internal var trackSkin:Class;
	gz_internal var trackDisabledSkin:Class;
	gz_internal var thumbUpSkin:Class;
	gz_internal var thumbOverSkin:Class;
	gz_internal var thumbDownSkin:Class;
	gz_internal var thumbDisabledSkin:Class;
	
	gz_internal var track:SimpleButton;
	gz_internal var thumb:SimpleButton;
	
	private var labelInstances:Array;
	
	protected var maskShape:Shape;
	private var tick:Shape;
	
	/**
	 *	@Constructor
	 */
	public function SliderBase() {
		super();
		
		setDefaultSkins();
		addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
		addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler, false, 0, true);
		addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, false, 0, true);
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
		
		if( allowTickClickChanged ) {
			allowTickClickChanged = false;
			
			tick.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			
			if( _allowTickClick )
				tick.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
		}
		
		if( labelsChanged ) {
			labelsChanged = false;
			updateLabelInstances();
		}
	}
	
	/**
	 * 	자식 객체 생성 및 추가
	 */
	override protected function createChildren():void {
		track = new SimpleButton();
		thumb = new SimpleButton();
		thumb.buttonMode = true;
		tick = new Shape();
		maskShape = new Shape();
		mask = maskShape;
		
		track.setStyle( StyleProp.UP_SKIN, replaceNullorUndefined(getStyle(TRACK_SKIN_STYLE_PROP), trackSkin) );
		track.setStyle( StyleProp.OVER_SKIN, replaceNullorUndefined(getStyle(TRACK_SKIN_STYLE_PROP), trackSkin) );
		track.setStyle( StyleProp.DOWN_SKIN, replaceNullorUndefined(getStyle(TRACK_SKIN_STYLE_PROP), trackSkin) );
		track.setStyle( StyleProp.DISABLED_SKIN, replaceNullorUndefined(getStyle(TRACK_DISABLED_SKIN_STYLE_PROP), trackDisabledSkin) );
		thumb.setStyle( StyleProp.UP_SKIN, replaceNullorUndefined(getStyle(THUMB_UP_SKIN_STYLE_PROP), thumbUpSkin) );
		thumb.setStyle( StyleProp.OVER_SKIN, replaceNullorUndefined(getStyle(THUMB_OVER_SKIN_STYLE_PROP), thumbOverSkin) );
		thumb.setStyle( StyleProp.DOWN_SKIN, replaceNullorUndefined(getStyle(THUMB_DOWN_SKIN_STYLE_PROP), thumbDownSkin) );
		thumb.setStyle( StyleProp.DISABLED_SKIN, replaceNullorUndefined(getStyle(THUMB_DISABLED_SKIN_STYLE_PROP), thumbDisabledSkin) );
		
		thumb.addEventListener(MouseEvent.MOUSE_DOWN, thumb_mouseDownHandler, false, 0, true);
		thumb.addEventListener(MouseEvent.MOUSE_UP, thumb_mouseUpHandler, false, 0, true);
		
		if( _allowTickClick )
			tick.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
		
		addChild(track);
		addChild(thumb);
		addChild(tick);
		addChild(maskShape);
	}
	
	/**
	 *	enabled에 따른 구현
	 */
	override protected function setStateToChangeEnabled():void {
		super.setStateToChangeEnabled();
		
		track.enabled = thumb.enabled = enabled;
	}
	
	/**
	 *	스타일 프로퍼티로 값을 설정한다.
	 */
	override public function styleChanged(styleProp:String):void {
		super.styleChanged(styleProp);
		
		switch( styleProp ) {
			case TRACK_SKIN_STYLE_PROP:
				track.setStyle( StyleProp.UP_SKIN, replaceNullorUndefined(getStyle(styleProp), trackSkin) );
				track.setStyle( StyleProp.OVER_SKIN, replaceNullorUndefined(getStyle(styleProp), trackSkin) );
				track.setStyle( StyleProp.DOWN_SKIN, replaceNullorUndefined(getStyle(styleProp), trackSkin) );
				break;
			
			case TRACK_DISABLED_SKIN_STYLE_PROP:
				track.setStyle( StyleProp.DISABLED_SKIN, replaceNullorUndefined(getStyle(styleProp), trackDisabledSkin) );
				break;
			
			case THUMB_UP_SKIN_STYLE_PROP:
				thumb.setStyle( StyleProp.UP_SKIN, replaceNullorUndefined(getStyle(styleProp), thumbUpSkin) );
				break;
			
			case THUMB_OVER_SKIN_STYLE_PROP:
				thumb.setStyle( StyleProp.OVER_SKIN, replaceNullorUndefined(getStyle(styleProp), thumbOverSkin) );
				break;
			
			case THUMB_DOWN_SKIN_STYLE_PROP:
				thumb.setStyle( StyleProp.DOWN_SKIN, replaceNullorUndefined(getStyle(styleProp), thumbDownSkin) );
				break;
			
			case THUMB_DISABLED_SKIN_STYLE_PROP:
				thumb.setStyle( StyleProp.DISABLED_SKIN, replaceNullorUndefined(getStyle(styleProp), thumbDisabledSkin) );
				break;
		}
	}
	
	/**
	 * 	디스플레이 변경사항에 대한 처리
	 */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		maskShape.graphics.clear();
		maskShape.graphics.beginFill(0x0, 0);
		maskShape.graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
		maskShape.graphics.endFill();
		
		updateChildrenDisplayList(unscaledWidth, unscaledHeight);
		drawTicks();
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	/**
	 *	TODO : 기본 Thumb 스킨들을 설정한다.
	 */
	protected function setDefaultSkins():void {
	}
	
	private function alignLabels():void {
		var count:uint = _labels ? _labels.length : 0;
		var labelGap:Number = (isHorizontal() ? unscaledWidth : unscaledHeight) / (count - 1);
		for( var i:uint=0; i<count; i++ ) {
			var label:Label = labelInstances[i];
			var xFrom:Number;
			var yFrom:Number;
			
			if( i == 0 ) {
				xFrom = 0;
				yFrom = unscaledHeight - label.measureHeight;
			} else if( i == count - 1 ) {
				xFrom = i * labelGap - label.measureWidth;
				yFrom = 0;
			} else {
				xFrom = i * labelGap - label.measureWidth / 2;
				yFrom = (count - i - 1) * labelGap - label.measureHeight / 2;
			}
			
			if( isHorizontal() ) {
				label.x = xFrom;
				label.y = thumb.y - label.measureHeight - 10;
			} else {
				label.x = thumb.x + thumb.width + 10;
				label.y = yFrom;
			}
		}
	}
	
	private function convert(value:Number):String {
		var split:Array = value.toString().split(".");
		return split.length > 1 ? split[0] + "." + String(split[1]).substr(0, 2) : split[0] + ".00";
	}
	
	private function drawTicks():void {
		tick.graphics.clear();
		
		if( _tickInterval < 1 )
			return;
		
		var color:uint = replaceNullorUndefined(getStyle(TICK_COLOR_STYLE_PROP), 0x666666);
		var tickSize:Number = replaceNullorUndefined(getStyle(TICK_SIZE_STYLE_PROP), 5);
		
		tick.graphics.beginFill(0x0, 0);
		
		if( isHorizontal() )
			tick.graphics.drawRect(0, thumb.y - 3, unscaledWidth, tickSize);
		else
			tick.graphics.drawRect(thumb.width + 3, 0, tickSize, unscaledHeight);
			
		tick.graphics.lineStyle(1, color);
		
		var gap:Number = Math.abs(_maximum - _minimum);
		var count:uint = uint(gap / _tickInterval) + 1;
		var t:Number = isHorizontal() ? track.width : track.height;
		var tickGap:Number = _tickInterval * t / gap;
		
		for( var i:uint=0; i<count; i++ ) {
			if( isHorizontal() ) {
				var xFrom:Number = (thumb.width / 2) + (i * tickGap);
				tick.graphics.moveTo(xFrom, thumb.y - 3);
				tick.graphics.lineTo(xFrom, thumb.y - 3 - tickSize);
			} else {
				var yFrom:Number = (thumb.height / 2) + (i * tickGap);
				tick.graphics.moveTo(thumb.width + 3, yFrom);
				tick.graphics.lineTo(thumb.width + 3 + tickSize, yFrom);
			}
		}
		
		tick.graphics.endFill();
	}
	
	private function dispatchChange():void {
		dispatchEvent(new SliderEvent(SliderEvent.CHANGE));
	}
	
	/**
	 *	Thumb를 드래그한다.
	 */
	protected function dragThumb():void {
		var v:Number = getValueByThumbPosition();
		if( isHorizontal() )
			thumb.x = valueToPosition(v);
		else
			thumb.y = valueToPosition(v);
		
		if( _liveDragging ) {
			var valueChanged:Boolean = v != _value;
			_value = v;
			
			if( valueChanged )
				dispatchChange();
		}
	}
	
	protected function getValueByThumbPosition():Number {
		var pos:Number = isHorizontal() ?
			Math.max(0, Math.min(track.width, track.mouseX)) :
			Math.max(0, Math.min(track.height, track.height - track.mouseY));
		var value:Number = positionToValue(pos);
		var a:Number = Math.round(value % _snapInterval);
		return _snapInterval > 0 ? value - value % _snapInterval + a : value;
	}
	
	private function isHorizontal():Boolean {
		return _direction == SliderDirection.HORIZONTAL;
	}
	
	private function stopThumbDrag():void {
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
		stage.removeEventListener(Event.MOUSE_LEAVE, stage_mouseLeaveHandler);
		stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
		
		toolTip = null;
		
		if( !_liveDragging ) {
			var valueChanged:Boolean = getValueByThumbPosition() != _value;
			_value = getValueByThumbPosition();
			
			if( valueChanged )
				dispatchChange();
		}
	}
	
	private function positionToValue(position:Number):Number {
		var gap:Number = Math.abs(_maximum - _minimum);
		var acture:Number = isHorizontal() ? track.width : track.height;
		var ratio:Number = gap / acture;
		return position * ratio + _minimum;
		return isHorizontal() ?
			position * ratio + _minimum :
			_maximum - (position * ratio + _minimum);
	}
	
	protected function valueToPosition(value:Number):Number {
		var gap:Number = Math.abs(_maximum - _minimum);
		var acture:Number = isHorizontal() ? track.width : track.height;
		var addend:Number = isHorizontal() ? thumb.width / 2 : thumb.height / 2;
		var ratio:Number = acture / gap;
		return isHorizontal() ?
			(value - _minimum) * ratio + addend :
			(_maximum - value) * ratio + addend;
	}
	
	/**
	 *	Track과 Thumb의 크기 및 위치를 설정한다.
	 */
	private function updateChildrenDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		var a:Number = Math.round(value % _snapInterval);
		var v:Number = _snapInterval > 0 ? _value - (_value % _snapInterval) + a : _value;
		if( isHorizontal() ) {
			track.width = unscaledWidth - thumb.width;
			track.x = thumb.width / 2;
			thumb.y = _tickInterval > 0 ? unscaledHeight - thumb.height : (unscaledHeight - thumb.height) / 2;
			track.y = thumb.y + (thumb.height - track.height) / 2;
			thumb.x = valueToPosition(v);
		} else {
			track.height = unscaledHeight - thumb.height;
			track.y = thumb.height / 2;
			thumb.x = _tickInterval > 0 ? 0 : (unscaledWidth - thumb.width) / 2;
			track.x = thumb.x + (thumb.width - track.width) / 2;
			thumb.y = valueToPosition(v);
		}
		
		alignLabels();
	}
	
	private function createLabelInstances():void {
		labelInstances = [];
		
		var count:uint = _labels ? _labels.length : 0;
		for( var i:uint=0; i<count; i++ ) {
			var label:Label = new Label();
			label.text = _labels[i];
			labelInstances[labelInstances.length] = label;
			addChild(label);
		}
	}
	
	private function removeLabelInstances():void {
		for each( var label:Label in labelInstances ) {
			removeChild(label);
		}
		labelInstances = null;
	}
	
	private function updateLabelInstances():void {
		removeLabelInstances();
		createLabelInstances();
	}
	
	//--------------------------------------------------------------------------
	//
	//	Event handlers
	//
	//--------------------------------------------------------------------------
	
	protected function keyDownHandler(event:KeyboardEvent):void {
		var origineValue:Number = _value;
		switch( event.keyCode ) {
			case Keyboard.UP:
				value = Math.min(_maximum, value + 1);
				break;
			
			case Keyboard.DOWN:
				value = Math.max(_minimum, value - 1);
				break;
		}
		
		if( _value != origineValue )
			dispatchChange();
	}
	
	protected function mouseWheelHandler(event:MouseEvent):void {
		var origineValue:Number = _value;
		
		if( event.delta > 0 )
			value = Math.min(_maximum, value + 1);
		else
			value = Math.max(_minimum, value - 1);
		
		if( _value != origineValue )
			dispatchChange();
	}
	
	private function mouseDownHandler(event:MouseEvent):void {
		setFocus();
		dragThumb();

		dispatchEvent(new SliderEvent(SliderEvent.THUMB_PRESS));
		stage.addEventListener(
			MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler, false, 0, true);
		stage.addEventListener(
			Event.MOUSE_LEAVE, stage_mouseLeaveHandler, false, 0, true);
		stage.addEventListener(
			MouseEvent.MOUSE_UP, stage_mouseUpHandler, false, 0, true);		
	}
	
	private function stage_mouseLeaveHandler(event:Event):void {
		stopThumbDrag();
	}
	
	private function stage_mouseMoveHandler(event:MouseEvent):void {
		dragThumb();
		toolTip = _dataTipFormatFunction(_value);
		dispatchEvent(new SliderEvent(SliderEvent.THUMB_DRAG));
	}
	
	private function stage_mouseUpHandler(event:MouseEvent):void {
		stopThumbDrag();
	}
	
	private function thumb_mouseDownHandler(event:MouseEvent):void {
		setFocus();
		dispatchEvent(new SliderEvent(SliderEvent.THUMB_PRESS));
		stage.addEventListener(
			MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler, false, 0, true);
		stage.addEventListener(
			Event.MOUSE_LEAVE, stage_mouseLeaveHandler, false, 0, true);
		stage.addEventListener(
			MouseEvent.MOUSE_UP, stage_mouseUpHandler, false, 0, true);
	}
	
	private function thumb_mouseUpHandler(event:MouseEvent):void {
		dispatchEvent(new SliderEvent(SliderEvent.THUMB_RELEASE));
	}

	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//	dataTipFormatFunction
	//--------------------------------------
	
	private var _dataTipFormatFunction:Function = convert;
	
	public function get dataTipFormatFunction():Function {
		return _dataTipFormatFunction;
	}
	
	public function set dataTipFormatFunction(value:Function):void {
		if( value == _dataTipFormatFunction ) 
			return;
		
		_dataTipFormatFunction = value;
	}
	
	//--------------------------------------
	//	labels
	//--------------------------------------
	
	private var labelsChanged:Boolean;
	
	private var _labels:Array;
	
	public function get labels():Array {
		return _labels;
	}
	
	public function set labels(value:Array):void {
		if( value == _labels ) 
			return;
		
		_labels = value;
		labelsChanged = true;
		
		invalidateProperties();
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	liveDragging
	//--------------------------------------
	
	private var _liveDragging:Boolean = true;
	
	public function get liveDragging():Boolean {
		return _liveDragging;
	}
	
	public function set liveDragging(value:Boolean):void {
		if( value == _liveDragging ) 
			return;
		
		_liveDragging = value;
	}
	
	//--------------------------------------
	//	direction
	//--------------------------------------
	
	protected var _direction:String;
	
	public function get direction():String {
		return _direction;
	}
	
	public function set direction(value:String):void {
		if( value == _direction ) 
			return;
		
		_direction = value;
		
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	maximum
	//--------------------------------------
	
	private var _maximum:Number = 100;
	
	public function get maximum():Number {
		return _maximum;
	}
	
	public function set maximum(value:Number):void {
		if( value == _maximum ) 
			return;
		
		_maximum = value;
		
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	minimum
	//--------------------------------------
	
	private var _minimum:Number = 0;
	
	public function get minimum():Number {
		return _minimum;
	}
	
	public function set minimum(value:Number):void {
		if( value == _minimum ) 
			return;
		
		_minimum = value;
		
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	snapInterval
	//--------------------------------------
	
	private var _snapInterval:Number = 0;
	
	public function get snapInterval():Number {
		return _snapInterval;
	}
	
	public function set snapInterval(value:Number):void {
		if( value == _snapInterval ) 
			return;
		
		_snapInterval = value;
		
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	allowTickClick
	//--------------------------------------
	
	private var allowTickClickChanged:Boolean;
	
	private var _allowTickClick:Boolean = true;
	
	public function get allowTickClick():Boolean {
		return _allowTickClick;
	}
	
	public function set allowTickClick(value:Boolean):void {
		if( value == _allowTickClick ) 
			return;
		
		_allowTickClick = value;
		allowTickClickChanged = true;
		
		invalidateProperties();
	}
	
	//--------------------------------------
	//	tickInterval
	//--------------------------------------
	
	private var _tickInterval:Number = 10;
	
	public function get tickInterval():Number {
		return _tickInterval;
	}
	
	public function set tickInterval(value:Number):void {
		if( value == _tickInterval ) 
			return;
		
		_tickInterval = value;
		
		invalidateDisplayList();
	}
	
	//--------------------------------------
	//	value
	//--------------------------------------
	
	private var _value:Number = 0;
	
	public function get value():Number {
		return _value;
	}
	
	public function set value(v:Number):void {
		if( v == _value ) 
			return;

		_value = v;
		
		invalidateDisplayList();
	}
}

}