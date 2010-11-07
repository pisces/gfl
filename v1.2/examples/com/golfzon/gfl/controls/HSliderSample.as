package
{
	
import com.golfzon.gfl.controls.HSlider;
import com.golfzon.gfl.core.ApplicationBase;
import com.golfzon.gfl.events.ComponentEvent;

import flash.events.Event;

public class HSlierSample extends ApplicationBase
{
	public function HSlierSample() {
		super();
	}
	
	override protected function creationCompleteHandler(event:ComponentEvent):void {
		var slider:HSlider = new HSlider();
		slider.value = 150;
		slider.maximum = 1000;
		slider.minimum = -100;
		slider.y = 50;
		slider.width = 300;
		slider.snapInterval = 1;
		slider.liveDragging = false;
		
		slider.addEventListener(Event.CHANGE, changeHandler, false, 0, true);
		
		addChild(slider);
	}
	
	private function changeHandler(event:Event):void {
		var slider:HSlider = HSlider(event.currentTarget);
		trace("slider.value : " + slider.value);
	}
}

}