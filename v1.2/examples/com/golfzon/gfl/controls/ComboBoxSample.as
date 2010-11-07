package
{

import com.golfzon.gfl.controls.ComboBox;
import com.golfzon.gfl.core.ApplicationBase;
import com.golfzon.gfl.events.ComponentEvent;

import flash.events.Event;

public class ComboBoxSample extends ApplicationBase
{
	public function ComboBoxSample() {
		super();
	}
	
	override protected function creationCompleteHandler(event:ComponentEvent):void {
		var comboBox:ComboBox = new ComboBox();
		comboBox.width = 100;
		comboBox.height = 20;
		comboBox.labelField = "label";
		comboBox.dataProvider =
			[
				{label:"label 1", data:1},
				{label:"label 2", data:2},
				{label:"label 3", data:3},
				{label:"label 4", data:4},
				{label:"label 5", data:5}
			];
		
		comboBox.addEventListener(Event.CHANGE, changeHandler, false, 0, true);
		addChild(comboBox);
	}
	
	private function changeHandler(event:Event):void {
		var comboBox:ComboBox = ComboBox(event.currentTarget);
		trace("comboBox.selectedIndex : " + comboBox.selectedIndex);
	}
}

}