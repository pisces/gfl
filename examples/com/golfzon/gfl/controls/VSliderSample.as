package
{
	
import com.golfzon.gfl.controls.HSlider;
import com.golfzon.gfl.controls.VSlider;
import com.golfzon.gfl.core.ApplicationBase;
import com.golfzon.gfl.events.ComponentEvent;

import flash.events.Event;

public class VSlierSample extends ApplicationBase
{
	public function VSlierSample() {
		super();
	}
	
	override protected function creationCompleteHandler(event:ComponentEvent):void {
		var slider:VSlider = new VSlider();
		slider.value = 150;
		slider.maximum = 1000;
		slider.minimum = -100;
		slider.y = 100;
		slider.width = 100;
		slider.height = 200;
		slider.snapInterval = 1;
		slider.liveDragging = false;
		
		slider.addEventListener(Event.CHANGE, changeHandler, false, 0, true);
		
		addChild(slider);
	}
	
	private function changeHandler(event:Event):void {
		var slider:VSlider = VSlider(event.currentTarget);
		trace("slider.value : " + slider.value);
	}
}

}