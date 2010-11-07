package
{
	
import com.golfzon.gfl.chart.PieChart;
import com.golfzon.gfl.chart.legend.Legend;
import com.golfzon.gfl.core.ApplicationBase;
import com.golfzon.gfl.events.ComponentEvent;

public class BarChartSample extends ApplicationBase
{
	public function BarChartSample() {
		super();
	}
	
	override protected function creationCompleteHandler(event:ComponentEvent):void {
		var pieChart:PieChart = new PieChart();
		pieChart.x = 400;
		pieChart.y = 390;
		pieChart.width = 310;
		pieChart.height = 310;
		pieChart.nameField = "name";
		pieChart.dataField = "pie";
		pieChart.dataProvider = createDataProvider();
		pieChart.xStepSize = 5;
		addChild(pieChart);
		
		var pieChartLegend:Legend = new Legend();
		pieChartLegend.x = 400;
		pieChartLegend.y = 700;
		pieChartLegend.dataProvider = pieChart;
		addChild(pieChartLegend);
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