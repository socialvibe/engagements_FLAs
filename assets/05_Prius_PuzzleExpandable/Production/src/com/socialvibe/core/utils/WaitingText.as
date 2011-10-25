package com.socialvibe.core.utils
{
	import com.socialvibe.core.ui.controls.SVText;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.text.*;
	import flash.utils.*;

	public class WaitingText extends SVText
	{
		public static const SAVING:int = 0;
		public static const LOADING:int = 1;
		public static const REGISTERING:int = 2;
		public static const SENDING:int = 3;
		public static const GENERATING:int = 4;
		public static const SEARCHING:int = 5;
		public static const SORTING:int = 6;
		public static const ADDING:int = 7;
		public static const CUSTOM:int = 8;
		
		public static const STRINGS:Array = ["Saving", "Loading", "Registering", "Sending", "Generating", "Searching", "Sorting", "Adding", ""];
		
		private var _text:String;
		private var _dots:int;
		private var _timer:Timer;
		
		public function WaitingText(type:int, x:Number, y:Number, fontSize:Number = 11, fontColor:uint = 0x8B8B8B, w:Number = 100)
		{
			super(STRINGS[type], x, y, fontSize, false, fontColor);
			
			_text = STRINGS[type];
			visible = false;
		}
		
		public function startWaiting():void
		{
			if (_timer == null)
			{
				_timer = new Timer(250);
				_timer.addEventListener(TimerEvent.TIMER, timerHandler, false, 0, true);
			}
			
			if(_timer.running == false)
			{
				text = _text + '...';
				_dots = 3;
				visible = false;
				_timer.reset();
				_timer.start();
			}
		}
		
		public function endWaiting(hide:Boolean = true):void
		{
			if(_timer && _timer.running)
			{
				_timer.stop();
			}
			visible = !hide;
			
			if (hide && parent && parent.contains(this))
				parent.removeChild(this);
		}
		
		private function timerHandler(e:TimerEvent):void
		{
			switch (_dots)
			{
				case 0:
					visible = true;
				case 1:
				case 2:
					appendText('.');
					_dots += 1;
        			break;
        		default:
        			text = _text;
        			_dots = 0;
			}
		}
		
		public function isLoading():Boolean
		{
			return _timer.running;
		}
		
		public function set msg(value:String):void
		{
			text = _text = value;
		}
		
		public function kill():void
		{
			if (parent && parent.contains(this))
				parent.removeChild(this);
			
			if (_timer && _timer.running)
				_timer.stop();
			
			if (_timer)
			{
				_timer.removeEventListener(TimerEvent.TIMER, timerHandler);
				_timer = null;
			}
		}
	}
}