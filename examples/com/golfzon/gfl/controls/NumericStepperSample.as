package
{
	
import com.golfzon.gfl.controls.NumericStepper;
import com.golfzon.gfl.controls.VSlider;
import com.golfzon.gfl.core.ApplicationBase;
import com.golfzon.gfl.events.ComponentEvent;

import flash.events.Event;

public class NumericStepperSample extends ApplicationBase
{
	public function NumericStepperSample() {
		super();
	}
	
	override protected function creationCompleteHandler(event:ComponentEvent):void {
		var ns:NumericStepper = new NumericStepper();
		ns.x = numericStepper.y = 50;
		ns.maximum =  20;
		ns.minimum =  10;
		ns.stepSize = 1.25;
		ns.value = 15;
		
		ns.addEventListener(Event.CHANGE, changeHandler, false, 0, true);
		
		addChild(slider);
	}
	
	private function changeHandler(event:Event):void {
		var ns:NumericStepper = NumericStepper(event.currentTarget);
		trace("ns.value : " + ns.value);
	}
}

}