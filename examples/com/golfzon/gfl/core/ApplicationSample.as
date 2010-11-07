package
{
	
import com.golfzon.gfl.core.ApplicationBase;
import com.golfzon.gfl.events.ComponentEvent;
  
[SWF(percentWidth="100%", percentHeight="100%", backgroundColor="0xFFFFFF")]
public class ApplicationSample extends ApplicationBase
{
	public function ApplicationSample() {
		super();
		
		// load external css file
		css = "assets/test.css";
	}
	
	// Application entry point
	override protected function creationCompleteHandler(event:ComponentEvent):void {
	}
}

}

 External css file sample
 
 @font-yoon550 {
 	url: "assets/Yoon550.swf";
 	font-class: "Yoon550";
 }
 
 @font-yoon350 {
 	url: "assets/Yoon350.swf";
 	font-class: "Yoon350";
 }
 
 @skin-GZSkin {
 	url: "assets/GZSkin.swf";
 }
 
 @skin-SampleSkin {
 	url: "assets/SampleSkin.swf";
 }
 
 .button-style1 {
 	padding-left: 30;
 	padding-right: 30;
 	corner-radius: 10;
 	up-icon: @class("Button_upIcon");
 	over-icon: @class("Button_overIcon");
 	down-icon: @class("Button_downIcon");
 }
 
 .button-style2 {
 	color: #333333;
 	anti-alias-type: advanced;
 	font-family: -윤고딕350;
 	font-size: 11;
 	text-selected-color: #FFFFFF;
 	text-roll-over-color: #000000;
 	
 	up-skin: @class("ProgressBar_backgroundSkin");
 	over-skin: @class("ProgressBar_backgroundSkin");
 	down-skin: @class("ProgressBar_barSkin");
 }
 
 .btn-style {
 	up-skin: @class("topBackground", 10, 10, 5, 5);
 	over-skin: @class("topBackground", 10, 10, 5, 5);
 	down-skin: @class("topBackground", 10, 10, 5, 5);
 }
 
 .button-style3 {
 	up-skin: @class("topBackground", 10, 10, 5, 5);
 	over-skin: @class("topBackground", 10, 10, 5, 5);
 	down-skin: @class("topBackground", 10, 10, 5, 5);
 }
 
 .button-style4 {
 	color: 0x000000;
 	cornerRadius: 5;
 	horizontalGap: 10;
 }
 
 .button-style5 {
 	up-skin: @class("topBackground", 10, 10, 5, 5);
 	over-skin: @class("topBackground", 11, 11, 2, 2);
 	down-skin: @class("topBackground", 10, 10, 5, 5);
 	horizontalGap: 10;
 }
 
 .container-style {
 	background-image: @class("SampleBitmap", 10, 10, 5, 5);
 }
 
 Button {
 	class-name: com.golfzon.gfl.controls.Button;
 	anti-alias-type: normal;
 	color: #FFFFFF;
 	font-family: dotum;
 	font-size: 11;
 	font-weight: bold;
 	text-roll-over-color: #FFFFFF;
 	text-selected-color: #FFFFFF;
 }
 
 Container {
 	class-name: com.golfzon.gfl.core.Container;
 	font-size: 15;
 	color: 0x5a5a5a;
 	anti-alias-type: advanced;
 	font-family: -윤고딕350;
 	border-thickness: 1;
 }
 
 ToolTip {
 	class-name: com.golfzon.gfl.controls.ToolTip;
 	border-thickness: 1;
 }
 
 .label-style {
 	anti-alias-type: normal;
 	font-family: verdana;
 	font-weight: bold;
 	font-size: 12;
 	color: 0x333333;
 }
 
 List {
 	class-name: com.golfzon.gfl.controls.List;
 	font-family: verdana;
 	color: 0x5a5a5a;
 	text-roll-over-color: #fff000;
 	text-selected-color: #ffffff;
 	border-thickness: 1;
 }
 
 Alert {
 	class-name: com.golfzon.gfl.controls.Alert;
 	color: 0x999999;
 	font-size: 11;
 	title-label-style-name: label-style;
 }
 
 .video-controller-style {
 	fullscreen-btn-disabled-skin: @class("topBackground", 10, 10, 5, 5);
 	fullscreen-btn-down-skin: @class("topBackground", 10, 10, 5, 5);
 	fullscreen-btn-over-skin: @class("topBackground", 10, 10, 5, 5);
 	fullscreen-btn-up-skin: @class("topBackground", 10, 10, 5, 5);
 	
 	pause-btn-disabled-skin: @class("topBackground", 10, 10, 5, 5);
 	pause-btn-down-skin: @class("topBackground", 10, 10, 5, 5);
 	pause-btn-over-skin: @class("topBackground", 10, 10, 5, 5);
 	pause-btn-up-skin: @class("topBackground", 10, 10, 5, 5);
 	
 	play-btn-disabled-skin: @class("topBackground", 10, 10, 5, 5);
 	play-btn-down-skin: @class("topBackground", 10, 10, 5, 5);
 	play-btn-over-skin: @class("topBackground", 10, 10, 5, 5);
 	play-btn-up-skin: @class("topBackground", 10, 10, 5, 5);
 	
 	stop-btn-disabled-skin: @class("topBackground", 10, 10, 5, 5);
 	stop-btn-down-skin: @class("topBackground", 10, 10, 5, 5);
 	stop-btn-over-skin: @class("topBackground", 10, 10, 5, 5);
 	stop-btn-up-skin: @class("topBackground", 10, 10, 5, 5);
 	
 	volume-btn-disabled-skin: @class("topBackground", 10, 10, 5, 5);
 	volume-btn-down-skin: @class("topBackground", 10, 10, 5, 5);
 	volume-btn-over-skin: @class("topBackground", 10, 10, 5, 5);
 	volume-btn-up-skin: @class("topBackground", 10, 10, 5, 5);
 	
 	time-line-style-name: time-line-style;
 }
  
 .time-line-style {
 	thumb-style-name: button-style3;
 	data-tip-style-name: time-line-data-tip-style;
 	track-skin: @class("topBackground", 10, 10, 5, 5);
 }
  
 .time-line-data-tip-style {
 	anti-alias-type: normal;
 	font-family: verdana;
 	font-weight: bold;
 	font-size: 12;
 	color: 0x333333;
 	border-skin: @class("topBackground", 10, 10, 5, 5);
 }