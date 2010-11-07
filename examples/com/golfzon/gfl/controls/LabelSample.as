package
{
	
import com.golfzon.gfl.controls.Label;
import com.golfzon.gfl.core.ApplicationBase;
import com.golfzon.gfl.events.ComponentEvent;

public class LabelSample extends ApplicationBase
{
	public function LabelSample() {
		super();
	}
	
	override protected function creationCompleteHandler(event:ComponentEvent):void {
		var label:Label = new Label();
		label.width = 100;
		label.height = 20;
		label.selectable = false;
		label.text = "label instance";
		
		addChild(label);
	}
}

}