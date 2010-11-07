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
	
	import com.golfzon.gfl.controls.buttonClasses.ButtonBarBase;
	import com.golfzon.gfl.styles.StyleProp;
	import com.golfzon.gfl.utils.replaceNullorUndefined;
	
	/**
	 *	@Author				SH Jung
	 *	@Version			1.2 beta
	 *	@Lanaguage			Action Script 3.0
	 *	@Date				2009.10.30
	 *	@Modify
	 *	@Description
	 * 	@includeExample		ToggleButtonBarSample.as
	 */	
	public class ToggleButtonBar extends ButtonBarBase
	{
		//--------------------------------------------------------------------------
		//
		//	Instance variables
		//
		//--------------------------------------------------------------------------
		
		private var columnSize:uint;
		private var rowSize:uint;
		
		/**
		 *	@Constructor
		 */
		public function ToggleButtonBar(){
			super();
			
			toggleMode = true;
		}
		
		//--------------------------------------------------------------------------
		//
		//	Instance methods
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//  Overriden : ButtonBarBase
		//--------------------------------------------------------------------------
		
		/**
		 * 	버튼 스타일 설정
		 */
		override protected function setButtonStyle():void {
			super.setButtonStyle();
			
			if( getStyle(StyleProp.LEFT_TOP_BUTTON_STYLE_NAME) ) {
				var lt:uint = 0;
				buttonList[lt].styleName = getStyle(StyleProp.LEFT_TOP_BUTTON_STYLE_NAME);
			}
			
			if( getStyle(StyleProp.LEFT_BOTTOM_BUTTON_STYLE_NAME) ) {
				var lb:uint = (Math.ceil(buttonList.length / columnSize) - 1) * columnSize;
				buttonList[lb].styleName = getStyle(StyleProp.LEFT_BOTTOM_BUTTON_STYLE_NAME);
			}
			
			if( getStyle(StyleProp.RIGHT_TOP_BUTTON_STYLE_NAME) ) {
				var rt:uint = columnSize - 1;
				buttonList[rt].styleName = getStyle(StyleProp.RIGHT_TOP_BUTTON_STYLE_NAME);
			}
			
			if( getStyle(StyleProp.RIGHT_BOTTOM_BUTTON_STYLE_NAME) ) {
				var rb:uint = buttonList.length % columnSize <= 1 ? Math.floor(buttonList.length / columnSize) * columnSize - 1 : buttonList.length - 1;
				buttonList[rb].styleName = getStyle(StyleProp.RIGHT_BOTTOM_BUTTON_STYLE_NAME);
			}
			invalidateDisplayList();
		}
		
		/**
		 *  버튼 토글 구현
		 */
		override protected function setToggle():void {
			for( var i:uint = 0; i<buttonList.length; i++ ) {
				if( i == selectedIndex ) {
					buttonList[i].selected = true;
				} else {
					buttonList[i].selected = false;
				}
			}
		}
		
		/**
		 *	버튼바 가로 길이
		 */
		override protected function getWidth():Number {
			var width:Number = 0;
			
			for( var i:uint = 0; i<columnSize; i++ ) {
				if( i != columnSize - 1 )	width += buttonList[i].width + replaceNullorUndefined(getStyle(StyleProp.HORIZONTAL_GAP), -1);
				else						width += buttonList[i].width;
			}
			return width;
		}
		
		/**
		 *	버튼바 세로 길이
		 */
		override protected function getHeight():Number {
			var height:Number = 0;
			
			for( var i:uint = 0; i<rowSize; i++ ) {
				if( buttonList[i] == undefined )
					continue;
				
				if( i != rowSize - 1 )	height += buttonList[i].height + replaceNullorUndefined(getStyle(StyleProp.VERTICAL_GAP), -1);
				else					height += buttonList[i].height;
			}
			return height;
		}
		
		/**
		 * 	버튼 간격 설정
		 */
		override protected function setButtonsGap():void {
			if( !buttonList )
				return;
			
			var hGap:Number = replaceNullorUndefined(getStyle(StyleProp.HORIZONTAL_GAP), -1);
			var vGap:Number = replaceNullorUndefined(getStyle(StyleProp.VERTICAL_GAP), -1);
			var columns:uint = _columnCount == 0 ? 3 : _columnCount;
			var rows:uint = _rowCount == 0 ? 3 : _rowCount;
			var i:uint;
			columnSize = 1;
			rowSize = 1;
			
			if( !_columnCount && _rowCount ) {
				// rowCount 기준 정렬
				for( i = 1; i<buttonList.length; i++ ) {
					if( i % Math.ceil(buttonList.length / rows) == 0 ) {
						buttonList[i].y = buttonList[i - 1].y + buttonList[i - 1].height + vGap;
						buttonList[i].x = buttonList[i - Math.ceil(buttonList.length / rows)].x;
						rowSize++;
					} else {
						buttonList[i].y = buttonList[i - 1].y;
						buttonList[i].x = buttonList[i - 1].x + buttonList[i - 1].width + hGap;
					}
				}
				columnSize = Math.ceil(buttonList.length / rows);
			} else {
				// columnCount 기준 정렬
				for( i = 1; i<buttonList.length; i++ ) {
					if( i % columns == 0 ) {
						buttonList[i].y = buttonList[i - 1].y + buttonList[i - 1].height + vGap;
						buttonList[i].x = buttonList[i - columns].x;
						rowSize++;
					} else {
						buttonList[i].y = buttonList[i - 1].y;
						buttonList[i].x = buttonList[i - 1].x + buttonList[i - 1].width + hGap;
					}
				}
				columnSize = columns < dataProvider.length ? columns : dataProvider.length;
			}
		}
	}
	
}