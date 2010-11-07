package
{
	
import com.golfzon.gfl.chart.LineChart;
import com.golfzon.gfl.chart.legend.Legend;
import com.golfzon.gfl.core.ApplicationBase;
import com.golfzon.gfl.events.ComponentEvent;

public class BarChartSample extends ApplicationBase
{
	public function BarChartSample() {
		super();
	}
	
	override protected function creationCompleteHandler(event:ComponentEvent):void {
		var lineChart:LineChart = new LineChart();
		lineChart.x = 20;
		lineChart.y = 390;
		lineChart.width = 310;
		lineChart.height = 310;
		lineChart.minimum = -10;
		lineChart.maximum = 50;
		lineChart.xDataField = ["step"];
		lineChart.yDataField = ["power", "age", "temp"];
		lineChart.dataProvider = createDataProvider();
		lineChart.xStepSize = 5;
		
		var lineChartLegend:Legend = new Legend();
		lineChartLegend.align = Legend.LEGEND_ALIGN_VERTICAL;
		lineChartLegend.x = 20;
		lineChartLegend.y = 700;
		lineChartLegend.dataProvider = lineChart;
		
		addChild(lineChart);
		addChild(lineChartLegend);
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