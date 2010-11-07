////////////////////////////////////////////////////////////////////////////////
//
//  GOLFZON
//  Copyright(c) GOLFZON.CO.,LTD.
//  All Rights Reserved.
//
//  NOTICE: GOLFZON permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.golfzon.gfl.text
{

import com.golfzon.gfl.events.RichTextFieldEvent;
import com.golfzon.gfl.text.command.DeleteTextCommand;
import com.golfzon.gfl.text.command.InsertTabCommand;
import com.golfzon.gfl.text.command.RemoveTabCommand;
import com.golfzon.gfl.text.command.WriteTextCommand;

import flash.events.ContextMenuEvent;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.TextEvent;
import flash.system.System;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;
import flash.ui.Keyboard;
import flash.utils.setTimeout;

import pcl.command.ICommand;
import pcl.managers.CommandManager;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *	dispatch when text is changed.
 */
[Event(name="textChange", type="com.golfzon.gfl.events.RichTextFieldEvent")]

/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.10.22
 *	@Modify
 *	@Description
 * 	@includeExample		RichTextFieldSample.as
 */
public class RichTextField extends TextField
{
    //--------------------------------------------------------------------------
	//
	//	Class variables
	//
    //--------------------------------------------------------------------------
	
	/**
	 *	Group of context menu item.
	 */
	private static var CONTEXT_MENU_ITEMS:Array = [ "Undo\t\tCtrl+Z", "Redo\t\tCtrl+Y" ];
	
	/**
	 *	Global selected text for clipboard.
	 */
	private static var SELECTED_TEXT:String;
	
    //--------------------------------------------------------------------------
	//
	//	Instance variables
	//
    //--------------------------------------------------------------------------
	
	public var changedText:String;
	public var changedType:String;
	public var origineText:String;
	
	/**
	 *	Tab string of above at selected line.
	 */
	private var _newline:String = "";
	
	/**
	 *	Instance of CommandManager.
	 */
	private var commandManager:CommandManager;
	
	/**
	 *	@Constructor
	 */
	public function RichTextField() {
		super();
		
		initialize();
		commitProperties();
		configureListeners();
	}

    //--------------------------------------------------------------------------
	//
	//	Instance methods
	//
    //--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------
    //  Public
    //--------------------------------------------------------------------------
	
	/**
	 *	선택된 텍스트를 복사하여 클립보드에 저장한다.
	 */
	public function copy():void {
		stage.focus = this;
		setClipboard();
	}
	
	/**
	 *	선택된 텍스트에 잘라내기를 실행하여 클립보드에 저장한다.
	 */
	public function cut():void {
		if( !selectedText )
			return;
		
		stage.focus = this;
		changedText = selectedText;
		commandManager.run(new DeleteTextCommand(this));
		setClipboard();
		replaceSelectedText('');
		setSelection(selectionBeginIndex, selectionBeginIndex);
		dispatchEvent(new Event(Event.CHANGE));
	}
	
	/**
	 *	redo 버퍼가 비어있는지 아닌지에 대한 부울값
	 */
	public function isEmptyRedoBuffer():Boolean {
		return commandManager.isEmptyRedoBuffer();
	}
	
	/**
	 *	undo 버퍼가 비어있는지 아닌지에 대한 부울값
	 */
	public function isEmptyUndoBuffer():Boolean {
		return commandManager.isEmptyUndoBuffer();
	}
	
	/**
	 *	클립보드에 저장된 텍스트를 붙여넣기 한다.
	 */
	public function paste():void {
		if( !SELECTED_TEXT )
			return;
		
		stage.focus = this;
		dispatchEvent(new TextEvent(TextEvent.TEXT_INPUT, false, false, SELECTED_TEXT));
		replaceText(selectionBeginIndex, selectionEndIndex, SELECTED_TEXT);
		setSelection(selectionBeginIndex, selectionBeginIndex + SELECTED_TEXT.length);
		dispatchEvent(new Event(Event.CHANGE));
	}
	
	/**
	 *	다시 실행
	 */
	public function redo():void {
		stage.focus = this;
		commandManager.redo();
		dispatchEvent(new Event(Event.CHANGE));
		dispatchTextChange(false, true);
	}
	
	/**
	 *	선택된 텍스트를 지운다.
	 */
	public function remove():void {
		if( !selectedText )
			return;
		
		stage.focus = this;
		changedText = selectedText;
		commandManager.run(new DeleteTextCommand(this));
		replaceSelectedText("");
		setSelection(selectionBeginIndex, selectionBeginIndex);
		dispatchEvent(new Event(Event.CHANGE));
	}
	
	/**
	 *	모든 텍스트를 선택한다.
	 */
	public function selectAll():void {
		stage.focus = this;
		setSelection(0, length);
	}
	
	/**
	 *	실행 취소
	 */
	public function undo():void {
		stage.focus = this;
		commandManager.undo();
		dispatchEvent(new Event(Event.CHANGE));
		dispatchTextChange(true);
	}
	
	/**
	 *	탭을 넣는다
	 */
	public function insertTab(
		selectionBeginIndex:int, selectionEndIndex:int,
		selectionBeginLineIndex:int, selectionEndLineIndex:int):void {
		var n:int = 0;
		var offset:int;
		var endIndex:int;
		var beginIndex:int = selectionBeginIndex;
		var substring:String = text.substring(selectionBeginIndex, selectionEndIndex);
		var tab:String = "\t";
		
		if( substring.indexOf("\r") > -1 ) {
			var lines:Array = substring.split("\r");
			for each( var line:String in lines ) {
				offset= getLineOffset(selectionBeginLineIndex + (n++));
				replaceText(offset, offset, tab);
			}
			beginIndex++;
			endIndex = selectionEndIndex + n;
		} else {
			var hasLine:Boolean =
				selectionBeginLineIndex > -1 &&
				(getWhitespaceRemovedStr(getLineText(selectionBeginLineIndex)).length > 0) &&
				(getLineLength(selectionBeginLineIndex) == (substring.length + 1));
			if( hasLine ) {
				offset = getLineOffset(selectionBeginLineIndex + (n++));
				replaceText(offset, offset, tab);
				endIndex = selectionEndIndex + n;
			} else {
				if( selectedText.length < 1 ) {
					replaceText(caretIndex, caretIndex, tab);
					n++;
					beginIndex = endIndex = (selectionEndIndex + n);
				} else {
					if( getWhitespaceRemovedStr(selectedText) ) {
						origineText = substring;
						replaceText(selectionBeginIndex, selectionEndIndex, '');
						endIndex = selectionBeginIndex;
					} else {
						beginIndex = selectionEndIndex;
						endIndex = selectionEndIndex;
					}
				}
			}
		}
		
		setTimeout(setFocus, 1, beginIndex, endIndex);
		dispatchEvent(new Event(Event.CHANGE));
		dispatchTextChange();
	}
	
	/**
	 *	탭을 삭제한다.
	 */
	public function removeTab(
		selectionBeginIndex:int, selectionEndIndex:int,
		selectionBeginLineIndex:int, selectionEndLineIndex:int):void {
		var n:int = 0;
		var offset:int;
		var beginIndex:int = selectionBeginIndex;
		var endIndex:int = selectionEndIndex;
		var substring:String = text.substring(selectionBeginIndex, selectionEndIndex);
		var char:String = "";
	
		if( substring.indexOf("\r") > -1 ) {
			var lines:Array = substring.split("\r");
			for each( var line:String in lines ) {
				offset= getLineOffset(selectionBeginLineIndex + (n++));
				
				if( (text.charAt(offset) == "\t") ) {
					replaceText(offset, offset+1, char);
					endIndex--;
				}
			}

			if( (selectionBeginIndex > getLineOffset(selectionBeginLineIndex)) &&
				((substring.charAt(0) == "\t") || (substring.charAt(0) != "\r")) ) {
				beginIndex--;
			}
			
		} else {
			offset = getLineOffset(selectionBeginLineIndex + (n++));
			
			if( (text.charAt(offset) == "\t") && (text.charAt(offset) != "\r") ) {
				if( (selectionBeginIndex != offset) && ((substring.charAt(0) == "\t") || (substring.charAt(0) != "\r")) )
					beginIndex--;
				
				replaceText(offset, offset+1, char);
				endIndex--;
			}
		}

		setTimeout(setFocus, 1, beginIndex, endIndex);
		dispatchEvent(new Event(Event.CHANGE));
		dispatchTextChange();
	}
	
	/**
	 *	beginIndex부터 endIndex까지의 텍스트를 선택한다.
	 */
	public function setFocus(beginIndex:int=-1, endIndex:int=-1):void {
		stage.focus = this;
		setSelection((beginIndex > -1) ?
			beginIndex : selectionBeginIndex, (endIndex > -1) ? endIndex :
			selectionEndIndex);
	}
	
    //--------------------------------------------------------------------------
    //  Internal
    //--------------------------------------------------------------------------
	
	/**
	 *	@private
	 */
	private function commitProperties():void {
		type = (enabled && editable) ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
	}

	/**
	 *	@private
	 */
	private function configureListeners():void {
		addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, false, 0, true);
		addEventListener(TextEvent.TEXT_INPUT, textInputHandler, false, 0, true);
	}
	
	/**
	 *	@private
	 */
	private function dispatchTextChange(undo:Boolean=false, redo:Boolean=false):void {
		dispatchEvent(new RichTextFieldEvent(RichTextFieldEvent.TEXT_CHANGE, undo, redo));
	}
    
    /**
     *	@private
     */
    private function createContextMenu():ContextMenu {
    	var contextMenu:ContextMenu = new ContextMenu();
    	contextMenu.hideBuiltInItems();
    	pushMenuItems(contextMenu);
    	return contextMenu;
    }
		
    /**
     *	@private
     */
	private function getWhitespaceRemovedStr(str:String):String {
		return str.replace(/\s/g, "");
	}
	
	/**
	 *	@private
	 */
	private function initialize():void {
		commandManager = new CommandManager();
		contextMenu = createContextMenu();
		focusRect = false;
        tabEnabled = useRichTextClipboard = true;
	}

    /**
     *	@private
     */
    private function pushMenuItems(contextMenu:ContextMenu):void {
    	for each( var name:String in CONTEXT_MENU_ITEMS ) {
			var item:ContextMenuItem = new ContextMenuItem(name);
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
    		contextMenu.customItems.push(item);
    	}
    }
	
	/**
	 *	@private
	 */
	private function removeListeners():void {
		removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		removeEventListener(TextEvent.TEXT_INPUT, textInputHandler);
	}
	
	/**
	 *	@private
	 */
	private function setClipboard():void {
		if( selectedText && !displayAsPassword ) {
			SELECTED_TEXT = selectedText.replace(/\r/g, '\n');
			System.setClipboard(SELECTED_TEXT);
		}
	}
	
    //--------------------------------------------------------------------------
	//
	//	Event handlers
	//
    //--------------------------------------------------------------------------
    
	/**
	 *	@private
	 */
	private function controlKeyDownHandler(event:KeyboardEvent):void {
		switch( event.keyCode ) {
			// Ctrl + C
			case 67:
				setClipboard();
				break;
			
			// Ctrl + X
			case 88:
				setClipboard();
				
				if( selectedText ) {
					changedType = "remove";
					changedText = selectedText;
					commandManager.run(new WriteTextCommand(this));
				}
				break;
			
			// Ctrl + Z
			case 90:
				undo();
				break;
				
			// Ctrl + Y
			case 89:
				redo();
				break;
		}
	}
	
	/**
	 *	@private
	 */
	private function controlKeyNotDownHandler(event:KeyboardEvent):void {
		switch( event.keyCode ) {
			case Keyboard.BACKSPACE:
				changedType = "remove";
				
				if( selectionBeginIndex == selectionEndIndex )
					changedText = text.substring(selectionBeginIndex-1, selectionEndIndex);
				else
					changedText = text.substring(selectionBeginIndex, selectionEndIndex);

				commandManager.run(new WriteTextCommand(this));
				changedText = null;
				break;
				
			case Keyboard.DELETE:
				if( selectionBeginIndex == selectionEndIndex )
					changedText = text.substring(selectionBeginIndex, selectionEndIndex + 1);
				else
					changedText = text.substring(selectionBeginIndex, selectionEndIndex);

				commandManager.run(new DeleteTextCommand(this));
				break;
				
			case Keyboard.ENTER:
				break;

			case Keyboard.TAB:
				// previous caches.
				var data:Object = {};
				data.selectionBeginIndex = selectionBeginIndex;
				data.selectionEndIndex = selectionEndIndex;
				data.selectionBeginLineIndex = selectionBeginLineIndex;
				data.selectionEndLineIndex = selectionEndLineIndex;
				data.selectedText = selectedText;
				
				var run:Function = function(command:ICommand):void {
					commandManager.run(command);
					origineText = null;
				}
				
				if( event.shiftKey ) {
					removeTab(selectionBeginIndex, selectionEndIndex,
						selectionBeginLineIndex, selectionEndLineIndex);
					setTimeout(run, 1, new RemoveTabCommand(this, data));
				} else {
					insertTab(selectionBeginIndex, selectionEndIndex,
						selectionBeginLineIndex, selectionEndLineIndex);
					setTimeout(run, 1, new InsertTabCommand(this, data));
				}
				break;
		}
	}

	/**
	 *	@private
	 */
	private function keyDownHandler(event:KeyboardEvent):void {
		if( event.ctrlKey )
			controlKeyDownHandler(event);
		else
			controlKeyNotDownHandler(event);
	}
	
	/**
	 *	@private
	 */
	private function menuItemSelectHandler(event:ContextMenuEvent):void {
		this[ContextMenuItem(event.currentTarget).caption.toLowerCase().split("\t")[0]]();
	}
	
	/**
	 * 
	 *	@private
	 * 
	 */
	private function textInputHandler(event:TextEvent):void {
		changedType = "add";
		changedText = event.text;
		origineText = selectedText;
		
		if( maxChars < 1 || text.length < maxChars )
			commandManager.run(new WriteTextCommand(this));
		
		if( changedText == "\n" )
			dispatchEvent(new RichTextFieldEvent(RichTextFieldEvent.TEXT_CHANGE));
	}

	//----------------------------------------------------------------
	//
	//	getter / setter
	//
	//----------------------------------------------------------------
	
	//--------------------------------------
	//  editable
	//--------------------------------------
	
	private var _editable:Boolean = true;
	
	/**
	 *	@read/write
	 */
	public function get editable():Boolean {
		return _editable;
	}
	
	public function set editable(value:Boolean):void {
		if( value == _editable ) return;
		
		_editable = value;
		
		commitProperties();
	}
	
	//--------------------------------------
	//  enabled
	//--------------------------------------
	
	private var _enabled:Boolean = true;
	
	/**
	 *	@read/write
	 */
	public function get enabled():Boolean {
		return _enabled;
	}
	
	public function set enabled(value:Boolean):void {
		if( value == _enabled ) return;
		
		_enabled = value;
		mouseEnabled = value;
		
		commitProperties();
	}
	
	//--------------------------------------
	//  selectionBeginLineIndex
	//--------------------------------------
	
	/**
	 *	@read only
	 */
	public function get selectionBeginLineIndex():int {
		return getLineIndexOfChar(selectionBeginIndex) > -1?
			getLineIndexOfChar(selectionBeginIndex):
			getLineIndexOfChar(selectionBeginIndex + 1);
	}
	
	//--------------------------------------
	//  selectionEndLineIndex
	//--------------------------------------
	
	/**
	 *	@read only
	 */
	public function get selectionEndLineIndex():int {
		return getLineIndexOfChar(selectionEndIndex) > -1?
			getLineIndexOfChar(selectionEndIndex):
			getLineIndexOfChar(selectionEndIndex - 1);
	}
}

}