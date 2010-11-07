package
{
	
import com.golfzon.gfl.chart.BarChart;
import com.golfzon.gfl.chart.legend.Legend;
import com.golfzon.gfl.core.ApplicationBase;
import com.golfzon.gfl.events.ComponentEvent;

public class BarChartSample extends ApplicationBase
{
	public function BarChartSample() {
		super();
	}
	
	override protected function creationCompleteHandler(event:ComponentEvent):void {
		var barChart:BarChart = new BarChart();
		barChart.x = 20;
		barChart.y = 20;
		barChart.width = 310;
		barChart.height = 310;
		barChart.minimum = -10;
		barChart.maximum = 50;
		barChart.xDataField = ["age", "level", "age"];
		barChart.yDataField = ["name"];
		barChart.dataProvider = createDataProvider();
		barChart.xStepSize = 5;
		
		var barChartLegend:Legend = new Legend();
		barChartLegend.x = 20;
		barChartLegend.y = 330;
		barChartLegend.dataProvider = barChart;
		
		addChild(barChart);
		addChild(barChartLegend);
	}
	
	private function createDataProvider():Array {
		return [{name:"Player1", age:30, level:50, power:50, step:-1, temp:25, pie:50},
				{name:"Player2", age:29, level:40, power:40, step:0, temp:20, pie:80},
				{name:"Player3", age:27, level:30, power:25, step:1, temp:30, pie:40},
				{name:"Player4", age:29, level:20, power:20, step:2, temp:40, pie:5},
				{name:"Player5", age:25, level:-10, power:10, step:3, temp:20, pie:5}];
	}
}

}