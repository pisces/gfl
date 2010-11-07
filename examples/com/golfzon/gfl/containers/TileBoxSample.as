package
{
	
import com.golfzon.gfl.containers.TileBox;
import com.golfzon.gfl.controls.Button;
import com.golfzon.gfl.controls.Label;
import com.golfzon.gfl.core.ApplicationBase;
import com.golfzon.gfl.core.ScrollPolicy;
import com.golfzon.gfl.events.ComponentEvent;

public class TileBoxSample extends ApplicationBase
{
	public function TileBoxSample() {
		super();
	}
	
	override protected function creationCompleteHandler(event:ComponentEvent):void {
		var button:Button = new Button();
		button.x = 100;
		button.width = 100;
		button.height = 100;
		
		var button2:Button = new Button();
		button2.x = 200;
		button2.y = 200;
		button2.width = 50;
		button2.height = 50;
		
		var button3:Button = new Button();
		button3.x = 200;
		button3.y = 200;
		button3.width = 150;
		button3.height = 50;
		
		var box:TileBox = new TileBox();
		box.width = 200;
		box.height = 200;
		box.columnCount = 2;
		box.horizontalScrollPolicy = ScrollPolicy.OFF;
		box.verticalScrollPolicy = ScrollPolicy.OFF;
		
		box.setStyle("paddingLeft", 10);
		box.setStyle("paddingTop", 10);
		box.setStyle("paddingRight", 10);
		box.setStyle("paddingBottom", 10);
		
		box.addChild(button);
		box.addChild(button2);
		box.addChild(button3);
		addChild(box);
	}
}

}