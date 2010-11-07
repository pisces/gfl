package
{
	
import com.golfzon.gfl.controls.Button;
import com.golfzon.gfl.core.ApplicationBase;
import com.golfzon.gfl.events.ComponentEvent;
import com.golfzon.gfl.managers.CursorManager;

import flash.events.MouseEvent;

public class CursorManagerSample extends ApplicationBase
{
	private var busyCursorButton:Button;
	private var removeBusyCursorButton:Button;
	
	public function CursorManagerSample() {
		super();
	}
	
	override protected function creationCompleteHandler(event:ComponentEvent):void {
		busyCursorButton = new Button();
		busyCursorButton.label = "busyCursor";
		
		removeBusyCursorButton = new Button();
		removeBusyCursorButton.x = 100;
		removeBusyCursorButton.label = "remove busyCursor";
		
		busyCursorButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		removeBusyCursorButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		addChild(busyCursorButton);
		addChild(removeBusyCursorButton);
	}
	
	private function clickHandler(event:MouseEvent):void {
		if( event.currentTarget == busyCursorButton )
			CursorManager.setBusyCursor();
		else
			CursorManager.removeBusyCursor();
	}
}

}