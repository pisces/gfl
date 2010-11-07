package
{
	
import com.golfzon.gfl.controls.Alert;
import com.golfzon.gfl.core.ApplicationBase;
import com.golfzon.gfl.events.ComponentEvent;

public class AlertSample extends ApplicationBase
{
	public function AlertSample() {
		super();
	}
	
	override protected function creationCompleteHandler(event:ComponentEvent):void {
		Alert.buttonWidth = 80;
		Alert.buttonHeight = 20;
		Alert.yesLabel = "Yes";
		Alert.noLabel = "No";
		
		
		var closeHandler:Function = function():void {
			trace("alert closed");
		}
		
		var alert:Alert = Alert.show("얼럿입니다.", "알림", Alert.YES | Alert.NO, closeHandler);
		alert.buttonMode = true;
	}
}

}