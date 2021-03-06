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
	
import com.golfzon.gfl.controls.progressBarClasses.ProgressBarMode;
import com.golfzon.gfl.core.ComponentBase;
import com.golfzon.gfl.styles.StyleProp;
import com.golfzon.gfl.utils.replaceNullorUndefined;

import flash.display.DisplayObject;

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *	백그라운드 스킨 스타일 프로퍼티<br>
 *	@default value Class ProgressBar_backgroundSkin of "GZSkin.swf"
 */
[Style(name="backgroundSkin", type="Class", inherit="no")]

/**
 *	바 스킨 스타일 프로퍼티<br>
 *	@default value Class ProgressBar_barSkin of "GZSkin.swf"
 */
[Style(name="barSkin", type="Class", inherit="no")]

/**
 *	 애니메이션 스킨 스타일 프로퍼티<br>
 *	@default value Class ProgressBar_animationSkin of "GZSkin.swf"
 */
[Style(name="animationSkin", type="Class", inherit="no")]
	
/**
 *	@Author				KHKim
 *	@Version			1.2 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.08.20
 *	@Modify
 *	@Description
 * 	@includeExample		ProgressBarSample.as
 */
public class ProgressBar extends ComponentBase
{
	//--------------------------------------------------------------------------
	//
	//	Instance constants
	//
	//--------------------------------------------------------------------------
	
	[Embed(source="/assets/GZSkin.swf", symbol="ProgressBar_animationSkin")]
	private var ANIMATION_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="ProgressBar_backgroundSkin")]
	private var BACKGROUND_SKIN:Class;
	
	[Embed(source="/assets/GZSkin.swf", symbol="ProgressBar_barSkin")]
	private var BAR_SKIN:Class;
	
	//--------------------------------------------------------------------------
	//
	//	Instance variables
	//
	//--------------------------------------------------------------------------
	
	private var currentValue:Number = 0;
	private var totalValue:Number = 0;
	
	private var animation:DisplayObject;
	private var background:DisplayObject;
	private var bar:DisplayObject;
	
	/**
	 *	@Constructor
	 */
	public function ProgressBar() {
		super();
		
		minWidth = minHeight = 1;
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
		
		if( modeChanged ) {
			modeChanged = false;
			updateBackground();
			updateBar();
			updateAnimation();
		}
	}
	
	/**
	 * 	자식 객체 생성 및 추가
	 */
	override protected function createChildren():void {
		updateBackground();
		updateBar();
		updateAnimation();
	}
	
	/**
	 *	스타일 프로퍼티로 값을 설정한다.
	 */
	override public function styleChanged(styleProp:String):void {
		super.styleChanged(styleProp);
		
		switch( styleProp ) {
			case StyleProp.BACKGROUND_SKIN:
				updateBackground();
				invalidateDisplayList();
				break;
				
			case StyleProp.BAR_SKIN:
				updateBar();
				invalidateDisplayList();
				break;
		}
	}
	
	/**
	 * 	디스플레이 변경 사항에 대한 처리
	 */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		if( background ) {
			background.width = unscaledWidth;
			background.height = unscaledHeight;
		}
			
		setBarSize();
	}
	
	//--------------------------------------------------------------------------
	//  Public
	//--------------------------------------------------------------------------
	
	/**
	 * 	진행 상황을 디스플레이 한다.
	 */
	public function setProgress(currentValue:Number, totalValue:Number):void {
		if( !creationComplete )
			return;
		
		this.currentValue = Math.min(totalValue, currentValue);
		this.totalValue = totalValue;
		
		setBarSize();
	}
	
	//--------------------------------------------------------------------------
	//  Internal
	//--------------------------------------------------------------------------
	
	private function setBarSize():void {
		if( bar != null ) {
			var temp:Number = (unscaledWidth * currentValue) / totalValue;
			bar.width = isNaN(temp) ? 0 : temp;
			bar.height = unscaledHeight;
		}
	}
	
	private function updateBackground():void {
		var skinclass:Class = replaceNullorUndefined(getStyle(StyleProp.BACKGROUND_SKIN), BACKGROUND_SKIN);
		updateDisplayObject("background", skinclass, mode == ProgressBarMode.MANUAL, 0);
	}
	
	private function updateBar():void {
		var skinclass:Class = replaceNullorUndefined(getStyle(StyleProp.BAR_SKIN), BAR_SKIN);
		updateDisplayObject("bar", skinclass, mode == ProgressBarMode.MANUAL, NaN);
	}
	
	private function updateAnimation():void {
		var skinclass:Class = replaceNullorUndefined(getStyle(StyleProp.ANIMATION_SKIN), ANIMATION_SKIN);
		updateDisplayObject("animation", skinclass, mode == ProgressBarMode.POLLED, NaN);
		if( animation )
			setActualSize(animation.width, animation.height);
	}
	
	private function updateDisplayObject(pName:String, skin:Class, add:Boolean, index:Number):void {
		if( this[pName] && contains(this[pName]) )
			removeChild(this[pName]);
		
		if( skin && add )
			this[pName] = isNaN(index) ? addChild(createSkinBy(skin)) : addChildAt(createSkinBy(skin), index);
	}
	
	//--------------------------------------------------------------------------
	//
	//	getter / setter
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------
	//	mode
	//--------------------------------------
	
	private var modeChanged:Boolean;
	
	private var _mode:String = ProgressBarMode.MANUAL;
	
	public function get mode():String {
		return _mode;
	}
	
	public function set mode(value:String):void {
		if( value == _mode )
			return;
		
		_mode = value;
		modeChanged = true;
		
		invalidateProperties();
		invalidateDisplayList();
	}
}

}