package
{
	
import com.golfzon.gfl.containers.Box;
import com.golfzon.gfl.controls.VScrollBar;
import com.golfzon.gfl.core.ApplicationBase;
import com.golfzon.gfl.events.ComponentEvent;
import com.golfzon.gfl.events.ScrollEvent;

public class VScrollBarSample extends ApplicationBase
{
	private var scrollTarget:Box;
	private var scrollBar:VScrollBar;
	
	public function VScrollBarSample() {
		super();
	}
	
	override protected function creationCompleteHandler(event:ComponentEvent):void {
		scrollTarget = new Box();
		scrollTarget.width = 100;
		scrollTarget.height = 500;
		
		scrollBar = new VScrollBar();
		scrollBar.height = 100;
		scrollBar.x = 100;
		scrollBar.lineScrollSize = 20;
		
		scrollBar.addEventListener(ScrollEvent.SCROLL, scrollHandler, false, 0, true);
		
		addChild(scrollTarget);
		addChild(scrollBar);
	}
	
	private function scrollHandler(event:ScrollEvent):void {
		trace("event.position : " + event.position);
		scrollTarget.y = event.position * -1;
	}
}

}