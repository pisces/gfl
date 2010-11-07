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
	
import com.golfzon.gfl.video.controllerClasses.BaseVideoController;

/**
 *	@Author				KHKim
 *	@Version			1.0
 *	@Lanaguage			Action Script 3.0
 *	@Date				2010.03.17
 *	@Modify
 *	@Description
 */
public class NullVideoController extends BaseVideoController
{
	/**
	 *	@Constructor
	 */
	public function NullVideoController() {
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//	Instance methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//  Overriden : BaseVideoController
	//--------------------------------------------------------------------------
	
	/**
	 * 	자식 객체 생성 및 추가
	 */
	override protected function createChildren():void {
	}
	
	/**
	 *	enabled에 따른 구현
	 */
	override protected function setStateToChangeEnabled():void {
	}
	
	/**
	 *	스타일 프로퍼티로 값을 설정한다.
	 */
	override public function styleChanged(styleProp:String):void {
	}
	
	/**
	 * 	디스플레이 변경사항에 대한 처리
	 */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
	}
	
	/**
	 *	자신이 Null객체인지 아닌지 반환한다.
	 */
	override public function isNull():Boolean {
		return true;
	}

	/**
	 *	비디오를 버퍼링할 때의 비주얼을 설정한다.
	 */
	override public function buffering(current:Number, total:Number):void {
	}
	
	/**
	 *	컨트롤러의 상태를 초기화한다.
	 */
	override public function reset():void {
	}
	
	/**
	 *	비디오의 상태에 따른 상태를 설정한다.
	 */
	override public function setState(state:String):void {
	}
	
	/**
	 *	진행률을 보여준다.
	 */
	override public function updateTimeSeek(time:Number, duration:Number):void {
	}
}

}