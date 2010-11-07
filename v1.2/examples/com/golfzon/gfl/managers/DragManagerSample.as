package
{
	
import com.golfzon.gfl.containers.Box;
import com.golfzon.gfl.core.ApplicationBase;
import com.golfzon.gfl.events.ComponentEvent;
import com.golfzon.gfl.managers.DragManager;
import com.golfzon.gfl.utils.BitmapDataUtil;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.MouseEvent;

public class DragManagerSample extends ApplicationBase
{
	private var dragTarget:Box;
	private var dragDropTarget:Box;
	
	public function DragManagerSample() {
		super();
	}
	
	override protected function creationCompleteHandler(event:ComponentEvent):void {
		dragTarget = new Box();
		dragTarget.width = 100;
		dragTarget.height = 100;
		
		dragDropTarget = new Box();
		dragDropTarget.width = 200;
		dragDropTarget.height = 200;
		dragDropTarget.y = 400;
		
		dragTarget.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
		
		addChild(dragTarget);
		addChild(dragDropTarget);
	}
	
	private function createDragImage():DisplayObject {
		var bitmapData:BitmapData = BitmapDataUtil.generate(dragTarget);
		var bitmap:Bitmap = new Bitmap(bitmapData);
		bitmap.x = dragTarget.x;
		bitmap.y = dragTarget.y;
		return bitmap;
	}
	
	private function mouseDownHandler(event:MouseEvent):void {
		DragManager.doDrag(dragTarget, createDragImage(), null, 0, 0, 1.5, 0.6);
		DragManager.acceptDragDrop(dragDropTarget);
	}
}

}