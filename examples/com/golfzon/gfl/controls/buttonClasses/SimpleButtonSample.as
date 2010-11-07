package
{

import com.golfzon.gfl.controls.buttonClasses.SimpleButton;
import com.golfzon.gfl.core.ApplicationBase;
import com.golfzon.gfl.events.ComponentEvent;

import flash.events.MouseEvent;

public class SimpleButtonSample extends ApplicationBase
{
	public function SimpleButtonSample() {
		super();
	}
	
	override protected function creationCompleteHandler(event:ComponentEvent):void {
		var button:SimpleButton = new SimpleButton();
		button.width = 100;
		button.height = 20;
		
		button.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		addChild(button);
	}
	
	private function clickHandler(event:MouseEvent):void {
		trace("clickHandler : " + event.currentTarget);
	}
}

}