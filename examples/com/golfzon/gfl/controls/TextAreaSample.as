package
{
	
import com.golfzon.gfl.controls.TextArea;
import com.golfzon.gfl.core.ApplicationBase;
import com.golfzon.gfl.events.ComponentEvent;

import flash.events.Event;
import flash.events.MouseEvent;

public class TextAreaSample extends ApplicationBase
{
	private var undoButton:Button;
	private var redoButton:Button;
	private var copyButton:Button;
	private var cutButton:Button;
	private var pasteButton:Button;
	
	private var textArea:TextArea;
	
	public function TextAreaSample() {
		super();
	}
	
	override protected function creationCompleteHandler(event:ComponentEvent):void {
		undoButton = new Button();
		undoButton.label = "undo";
		
		redoButton = new Button();
		redoButton.label = "redo";
		redoButton.y = 25;
		
		copyButton = new Button();
		copyButton.label = "copy";
		copyButton.y = 50;
		
		cutButton = new Button();
		cutButton.label = "copy";
		cutButton.y = 75;
		
		pasteButton = new Button();
		pasteButton.label = "paste";
		pasteButton.y = 100;
		
		textArea = new TextArea();
		textArea.width = 400;
		textArea.height = 300;
		textArea.x = 80;
		textArea.text = "TextArea instance";
		
		textArea.setStyle("borderThickness", 1);
		textArea.setStyle("fontFamily", "verdana");
		textArea.setStyle("fontSize", 11);
		
		undoButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		redoButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		copyButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		cutButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		pasteButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		textArea.addEventListener(Event.CHANGE, changeHandler, false, 0, true);
		
		addChild(undoButton);
		addChild(redoButton);
		addChild(copyButton);
		addChild(cutButton);
		addChild(pasteButton);
		addChild(textArea);
	}
	
	private function changeHandler(event:Event):void {
		trace("changeHandler : " + textArea.text);
	}
	
	private function clickHandler(event:MouseEvent):void {
		switch( event.currentTarget ) {
			case undoButton:
				textArea.undo();
				break;
				
			case redoButton:
				textArea.redo();
				break;
				
			case copyButton:
				textArea.copy();
				break;
				
			case cutButton:
				textArea.cut();
				break;
				
			case pasteButton:
				textArea.paste();
				break;
		}
	}
}

}