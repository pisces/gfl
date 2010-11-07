package
{
	
import com.golfzon.gfl.controls.Image;
import com.golfzon.gfl.core.ApplicationBase;
import com.golfzon.gfl.events.ComponentEvent;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;

public class ImageSample extends ApplicationBase
{
	public function ImageSample() {
		super();
	}
	
	override protected function creationCompleteHandler(event:ComponentEvent):void {
		var image:Image = new Image();
		image.width = 100;
		image.height = 100;
		image.scaleContent = true;
		image.showProgressBar = true;
		image.source = "assets/testImage.jpg";
		
		image.addEventListener(Event.COMPLETE, completeHandler, false, 0, true);
		image.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
		image.addEventListener(ProgressEvent.PROGRESS, progressHandler, false, 0, true);
		image.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
		
		addChild(image);
	}
	
	private function completeHandler(event:Event):void {
		var image:Image = Image(event.currentTarget);
		trace("completeHandler : " + image.content);
	}
	
	private function ioErrorHandler(event:IOErrorEvent):void {
		trace("ioErrorHandler : " + event.text);
	}
	
	private function progressHandler(event:ProgressEvent):void {
		trace("progressHandler : " + event.bytesLoaded + " / " + event.bytesTotal);
	}
	
	private function securityErrorHandler(event:SecurityErrorEvent):void {
		trace("securityErrorHandler : " + event.text);
	}
}

}