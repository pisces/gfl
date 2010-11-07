package
{

import com.golfzon.gfl.controls.CheckBox;
import com.golfzon.gfl.core.ApplicationBase;
import com.golfzon.gfl.events.ComponentEvent;

import flash.events.Event;

public class CheckBoxSample extends ApplicationBase
{
	public function CheckBoxSample() {
		super();
	}
	
	override protected function creationCompleteHandler(event:ComponentEvent):void {
		var checkBox:CheckBox = new CheckBox();
		checkBox.label = "checkBox instance";
		checkBox.addEventListener(Event.CHANGE, changeHandler);
		
		addChild(checkBox);
	}
	
	private function changeHandler(event:Event):void {
		var checkBox:CheckBox = CheckBox(event.currentTarget);
		trace(checkBox.selected, checkBox.width, checkBox.unscaledWidth, checkBox.measureWidth);
	}
}

}