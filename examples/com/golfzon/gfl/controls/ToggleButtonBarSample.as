package
{
import com.golfzon.gfl.controls.ToggleButtonBar;
import com.golfzon.gfl.core.ApplicationBase;
import com.golfzon.gfl.events.ButtonBarEvent;
import com.golfzon.gfl.events.ComponentEvent;

public class ToggleButtonBarSample extends ApplicationBase
{
	public function ToggleButtonBarSample() {
		super();
	}
	
	override protected function creationCompleteHandler(event:ComponentEvent):void {
		var buttonBar:ToggleButtonBar = new ToggleButtonBar();
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