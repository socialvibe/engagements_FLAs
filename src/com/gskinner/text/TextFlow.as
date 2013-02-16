﻿/*** TextFlow by Grant Skinner. Sep 9, 2007* Visit www.gskinner.com/blog for documentation, updates and more free code.*** Copyright (c) 2007 Grant Skinner* * Permission is hereby granted, free of charge, to any person* obtaining a copy of this software and associated documentation* files (the "Software"), to deal in the Software without* restriction, including without limitation the rights to use,* copy, modify, merge, publish, distribute, sublicense, and/or sell* copies of the Software, and to permit persons to whom the* Software is furnished to do so, subject to the following* conditions:* * The above copyright notice and this permission notice shall be* included in all copies or substantial portions of the Software.* * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR* OTHER DEALINGS IN THE SOFTWARE.**/package com.gskinner.text {	import flash.text.TextField;	public class TextFlow {		public var orphans:uint = 2; // minimum lines left at end of field		public var widows:uint = 2; // minimum lines left at top of field				private var _textFields:Array;		private var textObjects:Array; // generic objects to store string info.		private var _text:String; // stores original string				public function TextFlow(textFields:Array, text:String=null) {			_text = (text == null) ? textFields[0].text : text;			this.textFields = textFields;		}				public function get text():String {			return _text;		}				public function set text(value:String):void {			_text = value;			reflow();		}				public function set textFields(value:Array):void {			_textFields = (value == null) ? [] : value;			textObjects = [];			for (var i:uint=0;i<value.length;i++) {				textObjects[i] = {};			}			reflow();		}				public function get textFields():Array {			return _textFields;		}				public function reflow():void {			var l:uint = _textFields.length;			var lastIndex:Number = 0;			var endOfText:Boolean = false;						for (var i:uint=0;i<l;i++) {				var fld:TextField = _textFields[i];				var obj:Object = textObjects[i];				fld.text = ltrim(_text.substr(lastIndex) );								// find end:				fld.scrollV = 1;								// get the index of the first line of the next field (bottomScrollV is 1-based):				var nextLineIndex:uint = fld.bottomScrollV;				// use try/catch to find when we've reached the end of our text (maxScrollV is unreliable):				try {					var offset:uint = fld.getLineOffset(nextLineIndex);				} catch (e:*) {					obj.end = lastIndex = _text.length;					fld.text = rtrim(fld.text.substr(0));					continue;				}								if (orphans > 1 && widows > 1) {					// find start and end line index of last paragraph in field:					var pstart:uint = fld.getLineIndexOfChar(fld.getFirstCharInParagraph(offset));					var pend:uint = fld.getLineIndexOfChar(fld.getFirstCharInParagraph(offset)+fld.getParagraphLength(offset));										// check if the paragraph straddles the field break:					if (pend > nextLineIndex && pstart < nextLineIndex) {						if ((nextLineIndex-pstart) < orphans) { offset = fld.getFirstCharInParagraph(offset); }						else if ((pend-nextLineIndex) < widows) { offset = fld.getLineOffset(pend-widows); } // need to grab at least widows lines					}				}								fld.text = rtrim(fld.text.substr(0,offset));								lastIndex += offset;				obj.end = lastIndex;			}		}				public function getOverflow(textFieldIndex:int=-1,trim:Boolean=true):String {			if (textFieldIndex < 0) { textFieldIndex = _textFields.length+textFieldIndex%_textFields.length; }			var str:String = _text.substr(textObjects[textFieldIndex].end);			return (trim) ? ltrim(str) : str;		}				// standard rtrim:		private function rtrim(string:String):String {			return string.replace(/\s+$/,'');		}				// ltrim that strips leading empty lines, but leaves leading whitespace:		private function ltrim(string:String):String {			return string.replace(/^\s*[\n\r]/, '');		}					}}