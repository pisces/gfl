package
{

import com.golfzon.gfl.core.ApplicationBase;
import com.golfzon.gfl.events.ComponentEvent;
import com.golfzon.gfl.video.VideoPlayer;
import com.golfzon.gfl.video.controllerClasses.VideoController;

public class VideoPlayerSample extends ApplicationBase
{
	private var videoPlayer:VideoPlayer;

	public function VideoPlayerSample() {
		super();
	}
	
	override protected function creationCompleteHandler(event:ComponentEvent):void {
		videoPlayer = new VideoPlayer();
		videoPlayer.bufferTime = 5;
		videoPlayer.fitting = true;
		videoPlayer.url = "http://hdgallery.adobe.com/media/SpaceAlone_480.flv";
		
		addChild(videoPlayer);
	}
}

}