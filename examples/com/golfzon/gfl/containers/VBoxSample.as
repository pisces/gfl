package
{
	
import com.golfzon.gfl.containers.VBox;
import com.golfzon.gfl.controls.Button;
import com.golfzon.gfl.controls.Label;
import com.golfzon.gfl.core.ApplicationBase;
import com.golfzon.gfl.core.ScrollPolicy;
import com.golfzon.gfl.events.ComponentEvent;

public class VBoxSample extends ApplicationBase
{
	public function VBoxSample() {
		super();
	}
	
	override protected function creationCompleteHandler(event:ComponentEvent):void {
		var box:VBox = new VBox();
		box.width = 200;
		box.height = 200;
		box.horizontalScrollPolicy = ScrollPolicy.OFF;
		box.verticalScrollPolicy = ScrollPolicy.OFF;
		
		var button:Button = new Button();
		button.label = "button instance";
		
		var label:Label = new Label();
		label.text = "label instance";
		
		box.setStyle("verticalGap", 10);
		
		box.addChild(button);
		box.addChild(label);
		addChild(box);
	}
}

}