package
{
	
import com.golfzon.gfl.controls.DataGrid;
import com.golfzon.gfl.controls.gridClasses.DataGridColumn;
import com.golfzon.gfl.core.ApplicationBase;
import com.golfzon.gfl.events.ComponentEvent;
import com.golfzon.gfl.events.ListEvent;
import com.golfzon.gfl.styles.StyleProp;

public class DataGridSample extends ApplicationBase
{
	private var dataGrid:DataGrid;
	
	public function DataGridSample(){
		super();
	}
	
	override protected function creationCompleteHandler(event:ComponentEvent):void {
		dataGrid = new DataGrid();
		dataGrid.x = 100;
		dataGrid.height = 500;
		dataGrid.width = 350;
		dataGrid.allowMultipleSelection = true;
		dataGrid.selectedIndices = [4,11];
		
		var column1:DataGridColumn = new DataGridColumn();
		column1.headerText = "text";
		column1.dataField = "text";
		
		var column2:DataGridColumn = new DataGridColumn();
		column2.headerText = "number";
		column2.dataField = "number";
		
		var column3:DataGridColumn = new DataGridColumn();
		column3.headerText = "source";
		column3.dataField = "source";
		
		dataGrid.columns = [column1, column2, column3];
		dataGrid.dataProvider = createGridDataProvider();
		
		dataGrid.addEventListener(ListEvent.ITEM_CLICK, clickHandler, false, 0, true);
		dataGrid.addEventListener(ListEvent.ITEM_CHANGE, clickHandler, false, 0, true);
		dataGrid.addEventListener(ListEvent.ITEM_ROLL_OVER, rollOverHandler, false, 0, true);
		dataGrid.addEventListener(ListEvent.ITEM_ROLL_OUT, rollOutHandler, false, 0, true);
		
		addChild(dataGrid);
		setStyles();
	}
	
	private function createGridDataProvider():Array {
		var result:Array = [];
		var max:int = 500;
		for (var i:int=0; i<max; i++) {
			var str:String = "text"+i.toString();
			result.push({text:str, number:int(max - i), source:"assets/aaa.jpg"});
		}
		return result;
	}
	
	private function setStyles():void {
		dataGrid.setStyle(StyleProp.TEXT_ALIGN, "center");
		
		dataGrid.setStyle(StyleProp.ROLL_OVER_COLOR, 0x0000FF);
		dataGrid.setStyle(StyleProp.SELECTION_COLOR, 0x00FF00);
		
		dataGrid.setStyle(StyleProp.PADDING_LEFT, 10);
		dataGrid.setStyle(StyleProp.PADDING_RIGHT, 10);
		dataGrid.setStyle(StyleProp.PADDING_TOP, 10);
		dataGrid.setStyle(StyleProp.PADDING_BOTTOM, 10);
		
		dataGrid.setStyle(StyleProp.BACKGROUND_COLOR, 0xEEEEEE);
		
		dataGrid.setStyle(StyleProp.GUIDE_BORDER_THICKNESS, 3);
		dataGrid.setStyle(StyleProp.GUIDE_COLOR, 0xFF0000);
		
		dataGrid.setStyle(StyleProp.DRAG_GUIDE_BORDER_THICKNESS, 3);
		dataGrid.setStyle(StyleProp.DRAG_GUIDE_COLOR, 0x0000FF);
		dataGrid.setStyle(StyleProp.DRAG_SHAPE_COLOR, 0x0000FF);
		
		dataGrid.setStyle(StyleProp.RESIZE_GUIDE_BORDER_THICKNESS, 5);
		dataGrid.setStyle(StyleProp.RESIZE_GUIDE_COLOR, 0xFF00FF);
		dataGrid.setStyle(StyleProp.HEADER_ROLL_OVER_COLOR, 0x0000FF);
	}
	
	private function rollOverHandler(event:ListEvent):void {
		trace("rollOverHandler");
	}
	
	private function rollOutHandler(event:ListEvent):void {
		trace("rollOutHandler");
	}
		
	private function clickHandler(event:ListEvent):void {
		trace(dataGrid.selectedIndex);
		trace(dataGrid.selectedItem.text);
		trace("indics : " + dataGrid.selectedIndices);
		trace("items : " + ObjectUtil.toString(dataGrid.selectedItems)); 
	}
}
}