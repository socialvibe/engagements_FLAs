package com.socialvibe.core.ui.controls
{
	import com.socialvibe.core.ui.IStartableControl;
	import com.socialvibe.core.utils.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;
	
	public class SVCountdown extends SVText implements IConfigurableControl, IStartableControl
	{
		static public const COUNTDOWN_DONE:String = 'countdownDone';
		
		protected var _countdownId:Number;
		protected var _countdownSeconds:Number;
		protected var _countdownStr:String;
		protected var _currentSeconds:Number;
		
		protected var _timeFormat:Boolean;
		
		protected var _actions:Array;
		
		public function SVCountdown(text:String = 'Continue in [countdown] seconds...', seconds:Number = 10, fontSize:Number = 12, color:uint = 0x000000, bold:Boolean = false)
		{
			super(text.replace('[countdown]', seconds), 0, 0, fontSize, bold, color);
			
			_countdownStr = text;
			_countdownSeconds = _currentSeconds = seconds;
			
			_fontSize = fontSize;
			_color = color;
			_bold = bold;
			
			setText();
		}
		
		public function start():void
		{
			if (isNaN(_countdownId))
				_countdownId = setInterval(countdown, 1000);
		}
		
		public function stop():void
		{
			clearInterval(_countdownId);
			_countdownId = NaN;
		}
		
		public function restart():void
		{
			stop();
			
			_currentSeconds = _countdownSeconds;
			
			start();
		}
		
		private function countdown():void
		{
			_currentSeconds -= 1;
			
			if (_currentSeconds == 0)
			{
				clearInterval(_countdownId);
				_countdownId = NaN;
				
				dispatchEvent(new Event(COUNTDOWN_DONE, true));
				dispatchEvent(new SVEvent(ConfigurableObjectUtils.TRIGGER_ACTION, _actions, true, true));
			}
			
			setText();
		}
		
		private function setText():void
		{
			var timeStr:String = String(_currentSeconds);
			if (_timeFormat)
			{
				var min:Number = Math.floor(_currentSeconds/60);
				var sec:Number = _currentSeconds % 60;
				timeStr = min + ':' + (sec < 10 ? '0' : '') + sec;
			}
			
			_str = _countdownStr.replace('[countdown]', timeStr);
			
			if (_currentSeconds == 1)
				_str = _str.replace('seconds', 'second');
			
			text = _str;
		}
		
		
		/* ===================================
			Getters & Setters for configurability
		=================================== */
		
		public function set countdown_string(value:String):void
		{
			_countdownStr = value;
			
			setText();
		}
		
		public function set seconds(value:Number):void
		{
			_countdownSeconds = _currentSeconds = value;
			
			setText();
		}
		
		public function set font_size(value:Number):void
		{
			super.size = _fontSize;
			
			_fontSize = value;
		}
		
		override public function set color(value:uint):void
		{
			super.color = value;
			
			_color = value;
		}
		
		override public function set bold(value:Boolean):void
		{
			super.bold = value;
			
			_bold = value;
		}
		
		public function set time_format(value:Boolean):void
		{
			_timeFormat = value;
			
			setText();
		}
		
		/* =================================
			IConfigurableControl functionality
		================================= */
		
		override public function getControlName():String { return 'countdown'; }
		
		override public function getConfigVars():Array
		{
			return [ConfigurableObjectUtils.numberVar('x', x), 
					ConfigurableObjectUtils.numberVar('y', y), 
					ConfigurableObjectUtils.stringVar('countdown_string', _countdownStr, 'Continue in [countdown] seconds...', {desc:'[countdown] is replaced by the countdown time.'}), 
					ConfigurableObjectUtils.numberVar('seconds', _countdownSeconds, 10, {desc:'Number of seconds to start countdown at.'}),
					ConfigurableObjectUtils.numberVar('font_size', _fontSize),
					ConfigurableObjectUtils.colorVar('color', _color),
					ConfigurableObjectUtils.booleanVar('bold', _bold), 
					ConfigurableObjectUtils.booleanVar('time_format', _timeFormat, false, {desc:'If checked, countdown will be in "0:00" format.'}),
					ConfigurableObjectUtils.arrayVar('effects', _effects, null, {hidden:true}),
					ConfigurableObjectUtils.arrayVar('actions', _actions, null, {hidden:true, desc:"when countdown reaches zero."})];
		}
		
		override public function getConfig():Object
		{
			return ConfigurableObjectUtils.getConfigObject(this);
		}
		
		override public function setConfig(config:Object):void
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
					case 'countdown_string':
						countdown_string = config[configName];
						break;
					case 'seconds':
						seconds = config[configName];
						break;
					case 'font_size':
						font_size = config[configName];
						break;
					case 'color':
						color = config[configName];
						break;
					case 'bold':
						bold = config[configName];
						break;
					case 'time_format':
						time_format = config[configName];
						break;
					case 'effects':
						_effects = config[configName];
						break;
					case 'actions':
						_actions = config[configName];
						break;
				}
			}
		}
	}
}