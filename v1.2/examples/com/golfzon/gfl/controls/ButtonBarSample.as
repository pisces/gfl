package
{

import com.golfzon.gfl.controls.ButtonBar;
import com.golfzon.gfl.core.ApplicationBase;
import com.golfzon.gfl.events.ButtonBarEvent;
import com.golfzon.gfl.events.ComponentEvent;

public class ButtonBarSample extends ApplicationBase
{
	public function ButtonBarSample() {
		super();
	}
	
	override protected function creationCompleteHandler(event:ComponentEvent):void {
		var buttonBar:ButtonBar = new ButtonBar();
		buttonBar.x = 100;
		buttonBar.y = 100;
		buttonBar.rowCount = 3;
		buttonBar.columnCount = 2;
		buttonBar.addEventListener(ButtonBarEvent.BUTTON_CLICK, buttonClickHandler);
		buttonBar.dataProvider = ["00", "11", "22", "33", "44", "55", "66", "77", "88"];
		
		addChild(buttonBar);
	}
	
	private function buttonClickHandler(event:ButtonBarEvent):void {
		trace(ButtonBar(event.currentTarget).selectedIndex);
	}
}

}