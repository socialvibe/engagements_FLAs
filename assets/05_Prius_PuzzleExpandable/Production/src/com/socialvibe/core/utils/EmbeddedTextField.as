package com.socialvibe.core.utils
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.text.*;
	import flash.utils.*;
	
	public class EmbeddedTextField extends TextField
	{
		public static const CMTEmeddedFont:String = "MyriadSemiBold";
		public static const CMTEmeddedBoldFont:String = "MyriadBold";
		public static const EMBEDDED_FONT_LOADED:String = "embedded_font_loaded";
		public static var embeddedFontLoaded:Boolean = false;
		public static var fontLoadDispatcher:EventDispatcher = new EventDispatcher();
		
		private var _text:String;
		private var _size:Number;
		private var _color:uint;
		private var _bold:Boolean;
		private var _isHTML:Boolean;
		
		public function EmbeddedTextField(text:String, fontName:String, size:Number, color:uint, bold:Boolean, isHTML:Boolean = false)
		{
			super();
			
			_text = text;
			_size = size;
			_color = color;
			_bold = bold;
			_isHTML = isHTML;
			
			if (embeddedFontLoaded)
			{
				this.embedFonts = true;
				this.defaultTextFormat = new TextFormat(_bold ? CMTEmeddedBoldFont : CMTEmeddedFont, _size, _color, _bold);
				if (_isHTML)
					this.htmlText = _text;
				else
					this.text = _text;
			}
			else
			{
				this.embedFonts = false;
				this.defaultTextFormat = new TextFormat(fontName, _size, _color, _bold);
				fontLoadDispatcher.addEventListener(EMBEDDED_FONT_LOADED, onEmbeddedFontLoaded, false, 999, true);
			}
		}
		
		private function onEmbeddedFontLoaded(e:Event):void
		{
			fontLoadDispatcher.removeEventListener(EMBEDDED_FONT_LOADED, onEmbeddedFontLoaded);
			this.embedFonts = true;
			
			if (this.styleSheet != null)
			{
				var style:StyleSheet = this.styleSheet;
				this.styleSheet = null;
			}
			
			this.defaultTextFormat = new TextFormat(_bold ? CMTEmeddedBoldFont : CMTEmeddedFont, _size, _color, _bold);
			
			if (style)
			{
				this.styleSheet = style;
			}
			
			if (_isHTML)
				this.htmlText = _text;
			else
				this.text = _text;
			
			this.height = this.textHeight+this.getLineMetrics(0).height;
		}
		
		override public function setTextFormat(format:TextFormat, beginIndex:int=-1.0, endIndex:int=-1.0):void
		{
			if (embedFonts)
			{
				format.font = _bold ? CMTEmeddedBoldFont : CMTEmeddedFont;
				super.setTextFormat(format, beginIndex, endIndex);
			}
			else
			{
				_size = Number(format.size);
				_color = Number(format.color);
				_bold = Boolean(format.bold);
				super.setTextFormat(format, beginIndex, endIndex);
			}
		}
		
		override public function set text(value:String):void
		{
			if (value != null)
			{
				super.text = value;
				_text = value;
			}
		}
	}
}