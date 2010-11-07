package
{
	
import com.golfzon.gfl.controls.Button;
import com.golfzon.gfl.core.ApplicationBase;
import com.golfzon.gfl.events.ComponentEvent;
import com.golfzon.gfl.text.RichTextField;

import flash.events.Event;
import flash.events.MouseEvent;

public class RichTextFieldSample extends ApplicationBase
{
	private var undoButton:Button;
	private var redoButton:Button;
	private var copyButton:Button;
	private var cutButton:Button;
	private var pasteButton:Button;
	
	private var textField:RichTextField;
	
	public function RichTextFieldSample() {
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
		
		textField = new RichTextField();
		textField.width = 400;
		textField.height = 300;
		textField.x = 80;
		
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
		addChild(textField);
	}
	
	private function changeHandler(event:Event):void {
		trace("changeHandler");
	}
	
	private function clickHandler(event:MouseEvent):void {
		switch( event.currentTarget ) {
			case undoButton:
				textField.undo();
				break;
				
			case redoButton:
				textField.redo();
				break;
				
			case copyButton:
				textField.copy();
				break;
				
			case cutButton:
				textField.cut();
				break;
				
			case pasteButton:
				textField.paste();
				break;
		}
	}
}

}