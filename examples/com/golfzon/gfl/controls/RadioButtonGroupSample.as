package
{

import com.golfzon.gfl.controls.RadioButton;
import com.golfzon.gfl.controls.RadioButtonGroup;
import com.golfzon.gfl.core.ApplicationBase;
import com.golfzon.gfl.events.ComponentEvent;

import flash.events.Event;

public class RadioButtonGroupSample extends ApplicationBase
{
	private	var radioButtonGroup:RadioButtonGroup;
	private var radioButton1:RadioButton;
	private var radioButton2:RadioButton;
	private var radioButton3:RadioButton;
	private var radioButton4:RadioButton;
	private var radioButton5:RadioButton;

	public function RadioButtonGroupSample() {
		super();
	}
	
	override protected function creationCompleteHandler(event:ComponentEvent):void {
		radioButtonGroup = new RadioButtonGroup();
		radioButtonGroup.selectedIndex = 1;
		radioButtonGroup.addEventListener(Event.CHANGE, radioButtonGroupHandler);
		
		radioButton1 = new RadioButton();
		radioButton1.name = "radioButton1";
		radioButton1.label = "radioButton1";
		radioButton1.value = "value1";
		radioButton1.group = radioButtonGroup;
		
		radioButton2 = new RadioButton();
		radioButton2.x = 100;
		radioButton2.name = "radioButton2";
		radioButton2.label = "radioButton2";
		radioButton2.value = "value2";
		radioButton2.group = radioButtonGroup;
		
		addChild(radioButton1);
		addChild(radioButton2);
	}
	
	private function radioButtonGroupHandler(event:Event):void {
		trace(event.currentTarget.selectedIndex, event.currentTarget.value);
	}
}

}