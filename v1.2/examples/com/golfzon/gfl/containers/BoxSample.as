package
{
	
import com.golfzon.gfl.containers.Box;
import com.golfzon.gfl.controls.Button;
import com.golfzon.gfl.controls.Label;
import com.golfzon.gfl.core.ApplicationBase;
import com.golfzon.gfl.core.ScrollPolicy;
import com.golfzon.gfl.events.ComponentEvent;

public class BoxSample extends ApplicationBase
{
	public function BoxSample() {
		super();
	}
	
	override protected function creationCompleteHandler(event:ComponentEvent):void {
		var box:Box = new Box();
		box.width = 200;
		box.height = 200;
		box.horizontalScrollPolicy = ScrollPolicy.OFF;
		box.verticalScrollPolicy = ScrollPolicy.OFF;
		
		var button:Button = new Button();
		button.label = "button instance";
		
		var label:Label = new Label();
		label.text = "label instance";
		
		box.addChild(button);
		box.addChild(label);
		addChild(box);
	}
}

}