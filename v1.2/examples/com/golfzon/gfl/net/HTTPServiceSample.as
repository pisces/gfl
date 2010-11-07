package
{
	
import com.golfzon.gfl.core.ApplicationBase;
import com.golfzon.gfl.events.ComponentEvent;
import com.golfzon.gfl.events.FaultEvent;
import com.golfzon.gfl.events.InvokeEvent;
import com.golfzon.gfl.events.ResultEvent;
import com.golfzon.gfl.net.HTTPService;

import flash.net.URLRequestMethod;
import flash.net.URLVariables;

public class HTTPServiceSample extends ApplicationBase
{
	public function HTTPServiceSample() {
		super();
	}
	
	override protected function creationCompleteHandler(event:ComponentEvent):void {
		var httpService:HTTPService = new HTTPService();
		httpService.contentType = HTTPService.CONTENT_TYPE_XML;
		httpService.resultFormat = HTTPService.RESULT_FORMAT_XML;
		httpService.sendMethod = URLRequestMethod.POST;
		
		httpService.addEventListener(FaultEvent.FAULT, faultHandler, false, 0, true);
		httpService.addEventListener(InvokeEvent.INVOKE, invokeHandler, false, 0, true);
		httpService.addEventListener(ResultEvent.RESULT, resultHandler, false, 0, true);
		
		httpService.send(createParameters());
	}
	
	private function createParameters():URLVariables {
		var parameters:URLVariables = new URLVariables();
		parameters.type = 1;
		parameters.id = "pisces";
		return parameters;
	}
	
	private function faultHandler(event:FaultEvent):void {
		trace("faultHandler : " + event.message);
	}
	
	private function invokeHandler(event:InvokeEvent):void {
		trace("invokeHandler : " + event.status);
	}
	
	private function resultHandler(event:ResultEvent):void {
		trace("resultHandler : " + event.result);
	}
}

}