package
{
	
import com.golfzon.gfl.controls.TileList;
import com.golfzon.gfl.core.ApplicationBase;
import com.golfzon.gfl.events.ComponentEvent;
import com.golfzon.gfl.events.ListEvent;

public class TileListSample extends ApplicationBase
{
	public function TileListSample() {
		super();
	}
	
	override protected function creationCompleteHandler(event:ComponentEvent):void {
		var list:TileList = new TileList();
		list.width = 400;
		list.height = 400;
		list.dragEnabled = true;
		list.dropEnabled = true;
		list.dropImageScale = 1.5;
		list.doubleClickEnabled = true;
		list.dataProvider = createDataProvider();
		
		list.addEventListener(ListEvent.ITEM_CHANGE, itemChangeHandler, false, 0, true);
		list.addEventListener(ListEvent.ITEM_CLICK, itemClickHandler, false, 0, true);
		list.addEventListener(ListEvent.ITEM_DOUBLE_CLICK, itemDoubleClickHandler, false, 0, true);
		list.addEventListener(ListEvent.ITEM_ROLL_OUT, itemRollOutHandler, false, 0, true);
		list.addEventListener(ListEvent.ITEM_ROLL_OVER, itemRollOverHandler, false, 0, true);
		
		addChild(list);
	}
		
	private function createDataProvider():Array {
		var arr:Array = [];
		for( var i:int=0; i<50; i++ ) {
			arr[arr.length] = { label:"sample data " + i.toString() };
		}
		return arr;
	}
	
	private function itemChangeHandler(event:ListEvent):void {
		trace("itemChangeHandler");
	}
	
	private function itemClickHandler(event:ListEvent):void {
		trace("itemClickHandler");
	}
	
	private function itemDoubleClickHandler(event:ListEvent):void {
		trace("itemDoubleClickHandler");
	}
	
	private function itemRollOutHandler(event:ListEvent):void {
		trace("itemRollOutHandler");
	}
	
	private function itemRollOverHandler(event:ListEvent):void {
		trace("itemRollOverHandler");
	}
}

}