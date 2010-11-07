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
		return [{name:"김광현", age:30, level:50, power:50, step:-1, temp:25, pie:50},
				{name:"선종훈", age:29, level:40, power:40, step:0, temp:20, pie:80},
				{name:"김현진", age:27, level:30, power:25, step:1, temp:30, pie:40},
				{name:"김기환", age:29, level:20, power:20, step:2, temp:40, pie:5},
				{name:"정성헌", age:25, level:-10, power:10, step:3, temp:20, pie:5}];
	}
}

}