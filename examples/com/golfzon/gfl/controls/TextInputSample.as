package
{
	
import com.golfzon.gfl.controls.TextInput;
import com.golfzon.gfl.core.ApplicationBase;
import com.golfzon.gfl.events.ComponentEvent;

import flash.events.Event;

public class TextInputSample extends ApplicationBase
{
	private var textInput:TextInput;
	
	public function TextInputSample() {
		super();
	}
	
	override protected function creationCompleteHandler(event:ComponentEvent):void {
		textInput = new TextInput();
		textInput.width = 150;
		textInput.height = 20;
		textInput.displayAsPassword = true;
		textInput.maxChars = 10;
		
		textInput.setStyle("color", 0x000000);
		textInput.setStyle("fontSize", 10);
		
		textInput.addEventListener(Event.CHANGE, changeHandler, false, 0, true);
		
		addChild(textInput);
	}
	
	private function changeHandler(event:Event):void {
		trace("changeHandler");
	}
}

}