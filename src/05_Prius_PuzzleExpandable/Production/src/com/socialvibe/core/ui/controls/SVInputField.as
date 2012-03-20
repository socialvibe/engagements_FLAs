package com.socialvibe.core.ui.controls
{
	import com.socialvibe.core.utils.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.text.*;
	import flash.ui.Keyboard;
	
	public class SVInputField extends Sprite implements IConfigurableControl
	{
		protected var _width:Number;
		protected var _height:Number;
		protected var _cornerSize:Number;
		
		protected var _color:uint;
		protected var _bold:Boolean;
		protected var _fontSize:Number;
		
		protected var _multiline:Boolean;
		protected var _defaultText:String;
		
		protected var _inputField:SVText;
		protected var _labelField:SVText;
		protected var _fieldBackground:Sprite;
		
		protected var _effects:Array;
		
		public function SVInputField(w:Number = 100, h:Number = 22, size:Number = 11, bold:Boolean=false, multiline:Boolean=false)
		{
			_width = w;
			_height = h;
			_color = 0x333333;
			_bold = bold;
			_fontSize = size;
			_multiline = multiline;
			_cornerSize = 12;
			
			init();
		}
		
		protected function init():void
		{
			_fieldBackground = new Sprite();
			//_fieldBackground.x = 3;
			//_fieldBackground.y = (_fontSize > 14 ? 5 : 3);
			addChild(_fieldBackground);
			
			_inputField = new SVText('', 5, 0, _fontSize, _bold, _color, _width-9);
			_inputField.type = TextFieldType.INPUT;
			addChild(_inputField);
			
			this.multiline = _multiline;
			
			drawBackground();
		}
		
		public function set defaultText(text:String):void
		{
			_defaultText = text;
			
			if (_labelField == null)
			{
				_labelField = new SVText(_defaultText, _inputField.x, _inputField.y-1, _fontSize, _bold, 0x000000, _width-9);
				_labelField.alpha = 0.35;
				_labelField.blendMode = BlendMode.INVERT;
			}
			
			if (!_inputField.hasEventListener(KeyboardEvent.KEY_DOWN))
				_inputField.addEventListener(KeyboardEvent.KEY_DOWN, onStartType, false, 0, true);
			
			addChildAt(_labelField, getChildIndex(_inputField));
			_labelField.text = _defaultText;
			
			adjustDimensions();
		}
		
		private function onStartType(e:KeyboardEvent):void
		{
			_inputField.removeEventListener(KeyboardEvent.KEY_DOWN, onStartType);
			_inputField.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut, false, 0, true);
			
			if (_labelField && contains(_labelField))
				removeChild(_labelField);
		}
		
		private function onFocusOut(e:Event):void
		{
			if (_inputField.length == 0)
			{
				_inputField.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
				defaultText = _defaultText;
			}
		}
		
		protected function drawBackground():void
		{
			var g:Graphics = _fieldBackground.graphics;
			g.clear();
			
			g.lineStyle(1, 0x000000, 0.125, true);
			g.beginFill(0xFFFFFF);
			g.drawRoundRect(0, 0, _width, _height, _cornerSize);
			
			var innerGlow:GradientGlowFilter = new GradientGlowFilter( 3, 45, [0, 0], [0.3, 0], [0, 255]);
			_fieldBackground.filters = [innerGlow];
		}
		
		protected function adjustDimensions():void
		{
			_inputField.height = (_inputField.multiline ? _height - 6 : _inputField.getLineMetrics(0).height+_inputField.getLineMetrics(0).descent+1);
			
			if (_inputField.multiline)
				_inputField.y = 5;
			else
				_inputField.y = this.height/2 - (_inputField.height)/2 + 1;
			
			if (_labelField)
				_labelField.y = _inputField.y;
		}
		
		public function addSubmitFunction(func:Function):void
		{
			_inputField.addEventListener (KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void { if (e.keyCode == Keyboard.ENTER) func(e); });
		}
		
		public function lock():void
		{
			var g:Graphics = _fieldBackground.graphics;
			g.clear();		
			
			g.beginFill(0xDDDDDD);
			g.drawRoundRect(0, 0, _width, _height, 10);
			
			_inputField.type = TextFieldType.DYNAMIC;
		}
		
		public function reset():void
		{
			//_inputField.clearText();
			
			var g:Graphics = _fieldBackground.graphics;
			g.clear();		
			
			g.beginFill(0xFFFFFF);
			g.drawRoundRect(0, 0, _width, _height, 10);
			
			_inputField.type = TextFieldType.INPUT;
		}
		
		public function clearBackground():void
		{
			_fieldBackground.graphics.clear();
		}
		
		public function get textField():SVText { return _inputField; }
		public function set textField(tf:SVText):void { _inputField = tf; }
		
		public function get inputText():String { return _inputField.text; }
		public function set inputText(s:String):void
		{
			_inputField.text = s;
			
			if (_inputField.multiline)
				_inputField.height = _height - 6;
		}
		
		
		/* ===================================
		Getters & Setters for configurability
		=================================== */
		
		override public function set width(value:Number):void
		{
			_width = value;
			
			_inputField.width = _width-9;
			
			if (_labelField)
				_labelField.width = _width-9;
			
			drawBackground();
			adjustDimensions();
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
			
			drawBackground();
			adjustDimensions();
		}
		
		public function set font_size(value:uint):void
		{
			_fontSize = value;
			
			_inputField.text = _inputField.text;
			_inputField.size = _fontSize;
			
			if (_labelField)
				_labelField.size = _fontSize;
			
			adjustDimensions();
		}
		
		public function set bold(value:Boolean):void
		{
			_bold = value;
			
			_inputField.bold = _bold;
			
			if (_labelField)
				_labelField.bold = _bold;
			
			adjustDimensions();
		}
		
		public function set font_color(value:uint):void
		{
			_color = value;
			
			_inputField.color = _color;
		}
		
		public function set corner_size(value:uint):void
		{
			_cornerSize = value;
			
			drawBackground();
		}
		
		public function set multiline(value:Boolean):void
		{
			_multiline = _inputField.multiline = value;
			
			adjustDimensions();
		}
		
		public function set default_text(value:String):void
		{
			defaultText = value;
		}
		
		/* =================================
		IConfigurableControl functionality
		================================= */
		
		public function getControlName():String { return 'input_field'; }
		
		public function getConfigVars():Array
		{
			return [ConfigurableObjectUtils.numberVar('x', x), 
					ConfigurableObjectUtils.numberVar('y', y), 
					ConfigurableObjectUtils.numberVar('width', _width), 
					ConfigurableObjectUtils.numberVar('height', _height), 
					ConfigurableObjectUtils.numberVar('font_size', _fontSize, 11), 
					ConfigurableObjectUtils.booleanVar('bold', _bold), 
					ConfigurableObjectUtils.colorVar('font_color', _color, '333333'), 
					ConfigurableObjectUtils.numberVar('corner_size', _cornerSize, 12, {desc:"Radius (in pixels) of the input field's rounded corners."}), 
					ConfigurableObjectUtils.booleanVar('multiline', _inputField.multiline),
					ConfigurableObjectUtils.stringVar('default_text', _defaultText, null, {desc:"Default text that will show in the input field if it is empty. Will auto-clear once user starts inputting text."}),
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
					case 'x':
						x = config[configName];
						break;
					case 'y':
						y = config[configName];
						break;
					case 'width':
						width = config[configName];
						break;
					case 'height':
						height = config[configName];
						break;
					case 'font_size':
						font_size = config[configName];
						break;
					case 'bold':
						bold = config[configName];
						break;
					case 'corner_size':
						corner_size = config[configName];
						break;
					case 'font_color':
						font_color = config[configName];
						break;
					case 'multiline':
						multiline = config[configName];
						break;
					case 'default_text':
						default_text = config[configName];
						break;
					case 'effects':
						_effects = config[configName];
						break;
				}
			}
		}
	}
	
}