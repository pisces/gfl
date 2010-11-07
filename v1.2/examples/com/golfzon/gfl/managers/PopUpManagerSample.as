package
{
	
import com.golfzon.gfl.containers.Panel;
import com.golfzon.gfl.controls.Button;
import com.golfzon.gfl.core.ApplicationBase;
import com.golfzon.gfl.events.ComponentEvent;
import com.golfzon.gfl.managers.PopUpManager;

import flash.display.DisplayObject;
import flash.events.MouseEvent;

public class PopUpManagerSample extends ApplicationBase
{
	private var panel:DisplayObject;
	
	public function PopUpManagerSample() {
		super();
	}
	
	override protected function creationCompleteHandler(event:ComponentEvent):void {
		var openButton:Button = new Button();
		openButton.label = "open";
		
		var closeButton:Button = new Button();
		closeButton.label = "close";
		closeButton.x = 60;
		
		openButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		closeButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		
		addChild(openButton);
		addChild(closeButton);
	}
	
	private function clickHandler(event:MouseEvent):void {
		var button:Button = Button(event.currentTarget);
		if( button.label == "open" ) {
			panel = PopUpManager.createPopUp(Panel);
			PopUpManager.centerPopUp(panel);
		} else {
			PopUpManager.removePopUp(panel);
		}
	}
}

}