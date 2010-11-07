package
{

import com.golfzon.gfl.controls.RadioButton;
import com.golfzon.gfl.core.ApplicationBase;
import com.golfzon.gfl.events.ComponentEvent;

public class RadioButtonSample extends ApplicationBase
{
	private var radioButton1:RadioButton;
	private var radioButton2:RadioButton;
	private var radioButton3:RadioButton;
	private var radioButton4:RadioButton;
	private var radioButton5:RadioButton;

	public function RadioButtonSample() {
		super();
	}
	
	override protected function creationCompleteHandler(event:ComponentEvent):void {
		radioButton1 = new RadioButton();
		radioButton1.name = "radioButton1";
		radioButton1.label = "radioButton1";
		radioButton1.value = "value1";
		
		radioButton2 = new RadioButton();
		radioButton2.x = 100;
		radioButton2.name = "radioButton2";
		radioButton2.label = "radioButton2";
		radioButton2.value = "value2";
		
		addChild(radioButton1);
		addChild(radioButton2);
	}
}

}