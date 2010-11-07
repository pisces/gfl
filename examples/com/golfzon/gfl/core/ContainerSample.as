package
{
	
import com.golfzon.gfl.controls.Button;
import com.golfzon.gfl.controls.Label;
import com.golfzon.gfl.core.ApplicationBase;
import com.golfzon.gfl.core.Container;
import com.golfzon.gfl.core.ScrollPolicy;
import com.golfzon.gfl.events.ComponentEvent;

public class ContainerSample extends ApplicationBase
{
	public function ContainerSample() {
		super();
	}
	
	override protected function creationCompleteHandler(event:ComponentEvent):void {
		var container:Container = new Container();
		container.width = 400;
		container.height = 300;
		container.horizontalScrollPolicy = ScrollPolicy.AUTO;
		container.verticalScrollPolicy = ScrollPolicy.AUTO;
		
		var button:Button = new Button();
		button.label = "button instance";
		
		var label:Label = new Label();
		label.y = 40;
		label.text = "label instance";
		
		container.setStyle("backgroundColor", 0xFFFFFF);
		container.setStyle("paddingLeft", 0);
		
		container.addChild(button);
		container.addChild(label);
		addChild(container);
	}
}

}