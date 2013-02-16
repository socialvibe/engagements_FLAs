package com.socialvibe.core.ui.controls
{
	import com.socialvibe.core.utils.ConfigurableObjectUtils;
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;
	
	public class SVText extends TextField implements IConfigurableControl
	{
		public static const NON_EMBEDDED_FONT:String 	= "Lucida Grande, Tahoma, Verdana, Arial, sans-serif";
		public static const EMBEDDED_FONT:String 		= "MyriadSemiBold";
		public static const EMBEDDED_BOLD_FONT:String 	= "MyriadBold";
		public static const EMBEDDED_ITALIC_FONT:String = "MyriadBoldIt";
		public static const EMBEDDED_FONT_LOADED:String = "embedded_font_loaded";
		
		public static var embeddedFontLoaded:Boolean = true;
		public static var fontLoadDispatcher:EventDispatcher = new EventDispatcher();
		public static var defaultCustomFont:String;
		
		protected var _str:String;
		protected var _fontSize:Number;
		protected var _bold:Boolean;
		protected var _italic:Boolean;
		protected var _color:uint;
		protected var _centered:Boolean;
		protected var _width:Number;
		protected var _x:Number;
		protected var _customFontName:String;
		
		protected var _effects:Array;
		
		public function SVText(text:String = '[text]', x:Number = 0, y:Number = 0, size:Number = 12, bold:Boolean = false, color:uint = 0x000000, width:Number = NaN)
		{
			super();
			
			_str = text ? text : '';
			_fontSize = size;
			_bold = bold;
			_color = color;
			_width = width;
			
			enableEmbeddedFont();
			
			this.text = text;
			
			this.mouseEnabled = false;
			this.selectable = false;
			this.x = x;
			this.y = y;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded, false, 0, true);
		}
		
		public function get font_name():String
		{
			if (this.embedFonts)
			{
				if (_customFontName)
					return _customFontName;
				return (_italic ? EMBEDDED_ITALIC_FONT : (_bold ? EMBEDDED_BOLD_FONT : EMBEDDED_FONT));
			}
			else
			{
				return NON_EMBEDDED_FONT;
			}
		}
		
		public function set customEmbeddedFont(fontName:String):void
		{
			_customFontName = fontName;
			
			if (SVText.fontLoadDispatcher.hasEventListener(EMBEDDED_FONT_LOADED))
				SVText.fontLoadDispatcher.removeEventListener(EMBEDDED_FONT_LOADED, onEmbeddedFontLoaded);
			
			this.embedFonts = true;
			this.defaultTextFormat = new TextFormat(font_name, getTextFormat().size, getTextFormat().color, getTextFormat().bold, 
				getTextFormat().italic, getTextFormat().underline, null, null, null, null, null, null, getTextFormat().leading);
			
			text = _str;
		}
		
		protected function enableEmbeddedFont():void
		{
			if (embeddedFontLoaded)
			{
				this.embedFonts = true;
				this.defaultTextFormat = new TextFormat(font_name, _fontSize, _color, _bold);
			}
			else
			{
				this.embedFonts = false;
				this.defaultTextFormat = new TextFormat(font_name, _fontSize, _color, _bold);
			}
		}
		
		public function disableEmbeddedFont():void
		{
			if (this.embedFonts == false) return;
			
			if (SVText.fontLoadDispatcher.hasEventListener(EMBEDDED_FONT_LOADED))
				SVText.fontLoadDispatcher.removeEventListener(EMBEDDED_FONT_LOADED, onEmbeddedFontLoaded);
			
			this.embedFonts = false;
			this.setTextFormat(new TextFormat(font_name, getTextFormat().size, getTextFormat().color, getTextFormat().bold, 
				getTextFormat().italic, getTextFormat().underline, null, null, null, null, null, null, getTextFormat().leading));
			this.defaultTextFormat = getTextFormat();
			
			adjustDimensions();
		}
		
		protected function onEmbeddedFontLoaded(e:Event):void
		{
			SVText.fontLoadDispatcher.removeEventListener(EMBEDDED_FONT_LOADED, onEmbeddedFontLoaded);
			this.embedFonts = true;
			
			if (this.styleSheet != null)
			{
				var style:StyleSheet = this.styleSheet;
				this.styleSheet = null;
			}
			
			this.defaultTextFormat = new TextFormat(font_name, getTextFormat().size, _color, _bold, getTextFormat().italic, null, null, null, null, null, null, null, getTextFormat().leading);
			
			if (style)
			{
				this.styleSheet = style;
			}
			
			this.text = _str;
			
			adjustDimensions();
			
			if (autoSize == TextFieldAutoSize.CENTER)
				this.x = (_width-textWidth)/2;
		}
		
		protected function onAdded(e:Event):void
		{
			if (defaultCustomFont && _customFontName == null)
			{
				var checkParent:DisplayObject = parent;
				while (checkParent)
				{
					if (getQualifiedClassName( checkParent ) == 'com.socialvibe.tools.builder.view.panels::EngagementStep')
						this.customEmbeddedFont = defaultCustomFont;

					checkParent = checkParent.parent;
				}
			}
		}
		
		static public function setDefaultCustomFont(fontName:String):void
		{
			defaultCustomFont = fontName;
		}
		
		public function setMaxLines( maxLines:Number ):void
		{
			this.multiline = true;
			
			if (this.numLines <= maxLines)
				return;
			
			var newText:String = this.text.substr( 0, this.getLineOffset(maxLines-1));
			var lastLine:String = this.getLineText( maxLines-1);
			
			lastLine = (lastLine.length > 3) ? lastLine.substr(0, lastLine.length - 3) + "..." : lastLine + "...";
			this.text = newText + lastLine;
			this.height = this.textHeight+this.getLineMetrics(0).height;
		}
		
		public function truncate( maxLength:Number ):Boolean
		{
			if (this.multiline)
				return false;
			
			if ( this.textWidth <= maxLength ) {
				return false;
			}
			
			this.text = '...' + this.text;
			
			while (textWidth > maxLength)
			{
				text = text.substr(0, this.length-1);
			}
			
			text = text.substr(3) + '...';
			return true;
		}
		
		public function fitWidth( maxLength:Number ):void
		{
			if (this.multiline)
				return;
			
			if ( this.textWidth <= maxLength ) {
				return;
			}
			
			var oldTextHeight:Number = this.textHeight;
			
			while (textWidth > maxLength && _fontSize > 5)
			{
				_fontSize -= 1;
				
				var tf:TextFormat = getTextFormat();
				tf.size = _fontSize;
				setTextFormat(tf);
				
				width = _width;
				this.height = this.getLineMetrics(0).height+this.getLineMetrics(0).descent+2;
			}
			
			y += (oldTextHeight - this.textHeight)/2;
		}
		
		public function toHTML():SVText
		{
			htmlText = _str;
			return this;
		}
		
		/* =================================
		   Setters
		================================= */
		public function set letterSpacing(n:Number):void
		{
			var tf:TextFormat = getTextFormat();
			tf.letterSpacing = n;
			setTextFormat(tf);
		}
		
		public function set italic(value:Boolean):void
		{
			_italic = value;
			var format:TextFormat = new TextFormat(font_name, getTextFormat().size, getTextFormat().color, getTextFormat().bold, value, 
												   getTextFormat().underline, null, null, null, null, null, null, value);
			setTextFormat(format);
		}
		
		public function set leading(value:Number):void
		{
			var format:TextFormat = new TextFormat(font_name, getTextFormat().size, getTextFormat().color, getTextFormat().bold, 
												   getTextFormat().italic, getTextFormat().underline, null, null, null, null, null, null, value);
			setTextFormat(format);
		}
		
		public function set centered(value:Boolean):void
		{
			_centered = value;
			
			if (_centered)
			{
				if (this.multiline)
				{
					super.htmlText = "<p align='center'>" + _str + "</p>";
				}
				else
				{
					if (!isNaN(_width))
						width = _width;
					this.autoSize = TextFieldAutoSize.CENTER;
					
					// when centering the 'x' var changes
					dispatchEvent(new Event( ConfigurableObjectUtils.VARIABLE_CHANGED, true ));
				}
			}
			else
			{
				this.autoSize = isNaN(_width) || _width == 0 ? TextFieldAutoSize.LEFT : TextFieldAutoSize.NONE;
				x = _x;
				super.htmlText = _str;
			}
		}
		
		override public function set type(value:String):void
		{
			super.type = value;
			
			if (value == TextFieldType.INPUT)
			{
				this.mouseEnabled = this.selectable = true;
				this.styleSheet = null;
				this.addEventListener(KeyboardEvent.KEY_UP, checkType, false, 0, true);
			}
			else
			{
				if (this.hasEventListener(KeyboardEvent.KEY_UP))
					this.removeEventListener(KeyboardEvent.KEY_UP, checkType);
			}
		}
		
		protected function checkType(e:KeyboardEvent = null):void
		{
			if (!embeddedFontLoaded) return;
			
			var hasSpecialChar:Boolean = (super.text.search(/[^\u0020-\u007E\u00A9-\u00BB\u2013-\u201D\u00E0-\u00FC\u2122\n\r\t]/m) != -1);
			
			if (e != null && !hasSpecialChar)
				hasSpecialChar = !(e.charCode <= 126 || (e.charCode >= 169 && e.charCode <= 187) || (e.charCode >= 224 && e.charCode <= 252) || (e.charCode >= 8211 && e.charCode <= 8221) || e.charCode == 8482);
			
			if (e != null)
				_str = text;
			
			if (hasSpecialChar)
			{
				if (embedFonts)
				{
					disableEmbeddedFont();
					if (e != null)
					{
						this.replaceText(this.caretIndex, this.caretIndex, String.fromCharCode(e.charCode));
						this.setSelection(this.caretIndex+1, this.caretIndex+1);
						_str = text;
					}
				}
			}
			else
			{
				if (!embedFonts)
				{
					embedFonts = true;
					customEmbeddedFont = font_name;
				}
			}
			
			if (_centered && multiline)
				centered = true;
		}
		
		protected function adjustDimensions(directSet:Boolean = false):void
		{
			if (!_centered || directSet)
				super.width = isNaN(_width) ? this.textWidth+4 : _width;
			
			if (multiline)
				this.height = this.textHeight+this.getLineMetrics(0).height;
			else
				this.height = this.getLineMetrics(0).height+this.getLineMetrics(0).descent+2;
		}
		
		override public function set multiline(value:Boolean):void
		{
			super.multiline = wordWrap = value;
			
			if (multiline)
			{
				if (this.autoSize == TextFieldAutoSize.CENTER)
					centered = true;
				
				if (!isNaN(_width))
					this.width = _width;
				this.height = this.textHeight+this.getLineMetrics(0).height;
			}
		}
		
		override public function set htmlText(value:String):void
		{
			if (value == null) return;
			
			_str = value;
			
			super.htmlText = _str;
			
			checkType();
			
			adjustDimensions();
		}
		
		override public function set text(value:String):void
		{
			if (value == null) return;
			
			_str = value;
			
			super.text = _str;
			
			checkType();
			
			adjustDimensions();
		}
		
		
		/* ===================================
		Getters & Setters for configurability
		=================================== */
		
		public function set size(value:uint):void
		{
			_fontSize = value;
			
			this.defaultTextFormat = new TextFormat(font_name, _fontSize, _color, _bold);
			text = _str;
		}
		
		public function set bold(value:Boolean):void
		{
			_bold = value;
			
			this.defaultTextFormat = new TextFormat(font_name, _fontSize, _color, _bold);
			text = _str;
		}
		
		public function set color(value:uint):void
		{
			_color = value;
			
			this.textColor = _color;
		}
		
		override public function set width(value:Number):void
		{
			_width = value;
			
			x = _x;
			
			adjustDimensions(true);
		}
		
		override public function set x(value:Number):void
		{
			super.x = _x = value;
		}
		
		
		/* =================================
		   IConfigurableControl functionality
		================================= */
		
		public function getControlName():String { return 'text'; }
		
		public function getConfigVars():Array
		{
			return [ConfigurableObjectUtils.stringVar('text', _str),
					ConfigurableObjectUtils.numberVar('x', x), 
					ConfigurableObjectUtils.numberVar('y', y), 
					ConfigurableObjectUtils.numberVar('size', _fontSize, 12), 
					ConfigurableObjectUtils.colorVar('color', _color, '000000'), 
					ConfigurableObjectUtils.booleanVar('bold', _bold), 
					ConfigurableObjectUtils.booleanVar('multiline', super.multiline), 
					ConfigurableObjectUtils.booleanVar('centered', _centered), 
					ConfigurableObjectUtils.numberVar('width', _width),
					ConfigurableObjectUtils.arrayVar('effects', _effects, null, {hidden:true})];
		}
		
		public function getConfig():Object
		{
			return ConfigurableObjectUtils.getConfigObject(this);
		}
		
		public function setConfig(config:Object):void
		{
			config = ConfigurableObjectUtils.decodeConfig( config, this );
			
			for (var configName:Object in config)
			{
				switch (configName)
				{
					case 'text':
						text = config[configName];
						break;
					case 'x':
						x = config[configName];
						break;
					case 'y':
						y = config[configName];
						break;
					case 'size':
						size = config[configName];
						break;
					case 'color':
						color = config[configName];
						break;
					case 'bold':
						bold = config[configName];
						break;
					case 'multiline':
						multiline = config[configName];
						break;
					case 'centered':
						centered = config[configName];
						break;
					case 'width':
						width = config[configName];
						break;
					case 'effects':
						_effects = config[configName];
						break;
				}
			}
		}
	}
}