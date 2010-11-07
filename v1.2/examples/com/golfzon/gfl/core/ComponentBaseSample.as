package
{
	
import com.golfzon.gfl.core.ComponentBase;

public class ComponentBaseSample extends ComponentBase
{
	public function ComponentBaseSample() {
		super();
	}
	
	override protected function commitProperties():void {
		super.commitProperties();
		
		// TODO : Implements the proccess for property changing.
	}
	
	override protected function createChildren():void {
		// TODO : Implements the creation of children.
	}
	
	override protected function measure():void {
		super.measure();
		
		// TODO : Set up the default size of component.
		
		measureWidth = 100;
		measureHeight = 100;
		
		// Set acture size of component without live cycle of component.
		setActualSize(unscaledWidth, unscaledHeight);
	}

	override protected function setStateToChangeEnabled():void {
		super.setStateToChangeEnabled();
	}
	
	override public function styleChanged(styleProp:String):void {
		super.styleChanged(styleProp);
		
		// TODO : Implements the proccess for style changing.
	}
	
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		// TODO : Implements the proccess for display changing.
	}
}

}