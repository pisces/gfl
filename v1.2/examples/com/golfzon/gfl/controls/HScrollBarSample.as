package
{
	
import com.golfzon.gfl.containers.Box;
import com.golfzon.gfl.controls.HScrollBar;
import com.golfzon.gfl.core.ApplicationBase;
import com.golfzon.gfl.events.ComponentEvent;
import com.golfzon.gfl.events.ScrollEvent;

public class HScrollBarSample extends ApplicationBase
{
	private var scrollTarget:Box;
	private var scrollBar:HScrollBar;
	
	public function HScrollBarSample() {
		super();
	}
	
	override protected function creationCompleteHandler(event:ComponentEvent):void {
		scrollTarget = new Box();
		scrollTarget.width = 500;
		scrollTarget.height = 100;
		
		scrollBar = new HScrollBar();
		scrollBar.width = 100;
		scrollBar.y = 100;
		scrollBar.lineScrollSize = 20;
		
		scrollBar.addEventListener(ScrollEvent.SCROLL, scrollHandler, false, 0, true);
		
		addChild(scrollTarget);
		addChild(scrollBar);
	}
	
	private function scrollHandler(event:ScrollEvent):void {
		trace("event.position : " + event.position);
		scrollTarget.x = event.position * -1;
	}
}

}