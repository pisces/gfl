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

package com.golfzon.gfl.nullObject
{
	
import com.golfzon.gfl.controls.HScrollBar;

/**
 *	@Author				KHKim
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.09.29
 *	@Modify
 *	@Description		Null Object
 */
public class NullHScrollBar extends HScrollBar
{
	/**
	 *	@Constructor
	 */
	public function NullHScrollBar() {
	}
	
	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Overriden : HScrollBar
	//--------------------------------------------------------------------------
	
	override public function addEventListener(
		type:String, listener:Function, useCapture:Boolean=false,
		priority:int=0, useWeakReference:Boolean=false):void {
	}
	
	override public function hasEventListener(type:String):Boolean {
		return true;
	}
	
	/**
	 *	구현부 삭제 : 스타일 프로퍼티로 값을 설정한다.
	 */
	override public function styleChanged(styleProp:String):void {
	}
	
	/**
	 * 	구현부 삭제 : 디스플레이 변경 사항에 대한 처리
	 */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
	}
	
	/**
	 *	구현부 삭제 : 객체가 null object인지에 대한 부울값
	 */
	override public function isNull():Boolean {
		return true;
	}
	
	/**
	 *	구현부 삭제 : 스크롤 라인 단위로 스크롤한다.
	 */
	override public function lineScroll(line:Number):void {
	}
	
	/**
	 *	구현부 삭제 : 스크롤바의 페이지 사이즈를 설정한다.
	 */
	override public function setScrollProperties(pageSize:Number, viewSize:Number):void {
	}
	
	/**
	 * 	구현부 삭제 : 프로퍼티 변경 사항에 대한 처리
	 */
	override protected function commitProperties():void {
	}
	
	/**
	 * 	구현부 삭제 : 자식 객체 생성 및 추가
	 */
	override protected function createChildren():void {
	}
	
	/**
	 *	구현부 삭제 : enabled에 따른 구현
	 */
	override protected function setStateToChangeEnabled():void {
	}
	
	override public function get width():Number {
		return 0;
	}
	
	override public function set width(value:Number):void {
	}
	
	override public function set height(value:Number):void {
	}
	
	override public function get height():Number {
		return 0;
	}
	
	override public function get x():Number {
		return 0;
	}
	
	override public function set x(value:Number):void {
	}
	
	override public function get y():Number {
		return 0;
	}
	
	override public function set y(value:Number):void {
	}
	
	override public function get scrolling():Boolean {
		return false;
	}
}

}