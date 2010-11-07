package
{
	
import com.golfzon.gfl.controls.ProgressBar;
import com.golfzon.gfl.controls.progressBarClasses.ProgressBarMode;
import com.golfzon.gfl.core.ApplicationBase;
import com.golfzon.gfl.events.ComponentEvent;

public class ProgressBarSample extends ApplicationBase
{
	private var progressBar:ProgressBar;
	
	public function ProgressBarSample() {
		super();
	}
	
	override protected function creationCompleteHandler(event:ComponentEvent):void {
		progressBar = new ProgressBar();
		progressBar.width = 200;
		progressBar.mode = ProgressBarMode.MANUAL;
		
		addChild(progressBar);
		
		progressBar.setProgress(20, 100);
	}
}

}