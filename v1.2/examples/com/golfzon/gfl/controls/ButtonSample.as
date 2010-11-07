package
{

import com.golfzon.gfl.controls.Button;
import com.golfzon.gfl.core.ApplicationBase;
import com.golfzon.gfl.core.LabelPlacement;
import com.golfzon.gfl.events.ComponentEvent;

import flash.events.MouseEvent;

public class ButtonSample extends ApplicationBase
{
	public function ButtonSample() {
		super();
	}
	
	override protected function creationCompleteHandler(event:ComponentEvent):void {
		var button:Button = new Button();
		button.width = 100;
		button.height = 20;
		button.label = "button instance";
		button.labelPlacement = LabelPlacement.CENTER;
		button.toggle = true;
		button.selected = true;
		
		button.setStyle("color", 0x333333);
		button.setStyle("fontFamily", "verdana");
		button.setStyle("fontSize", 10);
		button.setStyle("fontWeight", "bold");
		button.setStyle("textRollOverColor", 0x000000);
		button.setStyle("textSelectedColor", 0xFFFFFF);
		
		button.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		addChild(button);
	}
	
	private function clickHandler(event:MouseEvent):void {
		trace("clickHandler : " + event.currentTarget);
	}
}

}