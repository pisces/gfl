package
{

import com.golfzon.gfl.controls.ColorPicker;
import com.golfzon.gfl.core.ApplicationBase;
import com.golfzon.gfl.events.ComponentEvent;
import com.golfzon.gfl.styles.StyleProp;

import flash.events.Event;

public class ColorPickerSample extends ApplicationBase
{
	public function ColorPickerSample() {
		super();
	}
	
	override protected function creationCompleteHandler(event:ComponentEvent):void {
		var colorPicker:ColorPicker = new ColorPicker();
		colorPicker.width = 150;
		colorPicker.height = 150;
		colorPicker.selectedColor = 0xFFFFFF;
		colorPicker.columnWidth = 15;
		colorPicker.rowHeight = 10;
		colorPicker.openMode = false;
		colorPicker.dataProvider =
			[
				0x330d00, 0x3300FF, 0x000300, 0x990000, 0xFFFF00,
				0x33CC33, 0xCC0033, 0x660000, 0xCCCC66, 0x330d00,
				0x3300FF, 0x000300, 0x990000, 0xFFFF00, 0x33CC33,
				0xCC0033, 0x660000, 0xCCCC66, 0x330d00, 0x3300FF,
				0x000300, 0x990000, 0xFFFF00, 0x33CC33, 0xCC0033,
				0x660000, 0xCCCC66
			];
		
		colorPicker.setStyle(StyleProp.COLOR, 0x0000FF);
		colorPicker.setStyle(StyleProp.BORDER_COLOR, 0xFF0000)
		colorPicker.setStyle(StyleProp.BORDER_THICKNESS, 2);
		colorPicker.setStyle(StyleProp.PADDING_LEFT, 5);
		colorPicker.setStyle(StyleProp.PADDING_TOP, 5);
		colorPicker.setStyle(StyleProp.PADDING_RIGHT, 5);
		colorPicker.setStyle(StyleProp.PADDING_BOTTOM, 5);
		
		colorPicker.addEventListener(Event.CHANGE, changeHandler);
		addChild(colorPicker);
	}
	
	private function changeHandler(event:Event):void {
		var colorPicker:ColorPicker = ColorPicker(event.currentTarget);
		trace("selectedColor : " + colorPicker.selectedColor.toString(16));
	}
}

}