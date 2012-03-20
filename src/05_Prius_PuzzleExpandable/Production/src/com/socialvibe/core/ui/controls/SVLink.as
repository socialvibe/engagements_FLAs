package com.socialvibe.core.ui.controls
{
	import com.socialvibe.core.config.*;
	import com.socialvibe.core.utils.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.text.*;
	import flash.ui.*;
	
	public class SVLink extends Sprite implements IConfigurableControl
	{
		protected var _linkField:SVText;
		protected var _url:String;
		
		protected var _fontSize:Number;
		protected var _bold:Boolean;
		protected var _color:uint;
		protected var _hoverColor:uint;
		protected var _underline:Boolean;
		
		protected var _currentColor:uint;
		
		protected var _linkFormat:TextFormat;
		protected var _hoverFormat:TextFormat;
		protected var _clickFormat:TextFormat;
		
		protected var _actions:Array;
		protected var _effects:Array;
		
		public function SVLink(text:String = '[Link]', x:Number = 0, y:Number = 0, size:Number = 11, bold:Boolean = true, textColor:uint = 0x058bb9, hoverColor:uint = 0x4ed1ff)
		{
			_fontSize = size;
			_bold = bold;
			_color = _currentColor = textColor;
			_hoverColor = hoverColor;
			
			_linkField = new SVText(text, 0, 0, size, bold, textColor);
			addChild(_linkField);
			
			setLinkFormats();
			
			_linkField.mouseEnabled = false;
			_linkField.selectable = false;
			
			this.x = x;
			this.y = y;
			this.buttonMode = true;
			this.useHandCursor = true;
			this.tabEnabled = false;
			this.addEventListener(MouseEvent.ROLL_OVER, onRollOver, false, 0, true);
			this.addEventListener(MouseEvent.ROLL_OUT, onRollOut, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
		}
		
		protected function setLinkFormats(e:Event = null):void
		{
			_linkFormat = new TextFormat(_linkField.font_name, _fontSize, _currentColor, _bold, false, _underline);
			_hoverFormat = new TextFormat(_linkField.font_name, _fontSize, _hoverColor, _bold, false, true);
			_clickFormat = new TextFormat(_linkField.font_name, _fontSize, _currentColor, _bold, false, true);
			
			_linkField.setTextFormat(_linkFormat);
			_linkField.defaultTextFormat = _linkFormat;
		}
		
		public function onRollOver(e:MouseEvent):void
		{
			if (this.mouseEnabled && _hoverFormat != null )
			{
				_linkField.setTextFormat(_hoverFormat);
			}
		}
		
		public function onRollOut(e:MouseEvent):void
		{
			if (this.mouseEnabled && _linkFormat != null)
			{
				_linkField.setTextFormat(_linkFormat);
			}
		}
		
		protected function onMouseDown(e:MouseEvent):void
		{
			if (this.mouseEnabled && _clickFormat != null)
				_linkField.setTextFormat(_clickFormat);
		}
		
		protected function onMouseUp(e:MouseEvent):void
		{
			if (this.mouseEnabled && _hoverFormat != null)
				_linkField.setTextFormat(_hoverFormat);
		}
		
		protected function adjustDimensions():void
		{
			_linkField.width = _linkField.textWidth+4;
			_linkField.height = _linkField.getLineMetrics(0).height+_linkField.getLineMetrics(0).descent+2;
		}
		
		public function set underline(value:Boolean):void
		{
			_underline = value;
			_linkFormat.underline = _underline;
			_linkField.setTextFormat(_linkFormat);
		}
		
		public function disableLink(disableColor:uint = 0xFFFFFF):void
		{
			_currentColor = disableColor;
			setLinkFormats();
			this.mouseEnabled = false;
		}
		
		public function enableLink():void
		{
			_currentColor = _color;
			setLinkFormats();
			this.mouseEnabled = true;
		}
		
		public function addURL(url:String, popup:Boolean = true):void
		{
			_url = url;
			if (popup)
				addEventListener(MouseEvent.CLICK, onPopupClick, false, 0, true);
			else
				addEventListener(MouseEvent.CLICK, onLinkClick, false, 0, true);
		}
		protected function onPopupClick(e:Event):void
		{
			ExternalInterfaceUtil.popup(_url);
		}
		protected function onLinkClick(e:Event):void
		{
			navigateToURL(new URLRequest(_url), "_top");
		}
		
		public function set actions(value:Array):void
		{
			_actions = value;
			
			if (!hasEventListener(MouseEvent.CLICK))
			{
				addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			}
		}
		
		protected function onClick(e:Event):void
		{
			dispatchEvent(new SVEvent(ConfigurableObjectUtils.TRIGGER_ACTION, _actions, true, true));
		}
		
		
		public function get textField():SVText { return _linkField; }
		
		
		
		/* ===================================
		Getters & Setters for configurability
		=================================== */
		
		public function set text(value:String):void
		{
			_linkField.text = value;
			
			adjustDimensions();
		}
		
		public function set font_size(value:uint):void
		{
			_fontSize = value;
			
			setLinkFormats();
			
			adjustDimensions();
		}
		
		public function set bold(value:Boolean):void
		{
			_bold = value;
			_linkField.bold = value;
			
			setLinkFormats();
			
			adjustDimensions();
		}
		
		public function set color(value:uint):void
		{
			_color = _currentColor = value;
			
			setLinkFormats();
		}
		
		public function set rollover(value:uint):void
		{
			_hoverColor = value;
			setLinkFormats();
		}
		
		/* =================================
		IConfigurableControl functionality
		================================= */
		
		public function getControlName():String { return 'link'; }
		
		public function getConfigVars():Array
		{
			return [ConfigurableObjectUtils.stringVar('text', _linkField.text),
					ConfigurableObjectUtils.numberVar('x', x), 
					ConfigurableObjectUtils.numberVar('y', y), 
					ConfigurableObjectUtils.numberVar('font_size', _fontSize, 11), 
					ConfigurableObjectUtils.booleanVar('bold', _bold), 
					ConfigurableObjectUtils.colorVar('color', _color, '058bb9'), 
					ConfigurableObjectUtils.colorVar('rollover', _hoverColor, '4ed1ff'),
					ConfigurableObjectUtils.arrayVar('effects', _effects, null, {hidden:true}),
					ConfigurableObjectUtils.arrayVar('actions', _actions, null, {hidden:true, desc:"clicking on the link"})];
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
					case 'font_size':
						font_size = config[configName];
						break;
					case 'bold':
						bold = config[configName];
						break;
					case 'color':
						color = config[configName];
						break;
					case 'rollover':
						rollover = config[configName];
						break;
					case 'effects':
						_effects = config[configName];
						break;
					case 'actions':
						actions = config[configName];
						break;
				}
			}
		}
	}
}