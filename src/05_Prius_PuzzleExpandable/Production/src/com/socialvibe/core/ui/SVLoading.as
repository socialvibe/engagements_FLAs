package com.socialvibe.core.ui
{
	import com.socialvibe.core.config.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;

	public class SVLoading extends Sprite
	{
		protected var _radius:Number;
		
		protected var _circleColor:uint;
		protected var _circles:uint;
		protected var _circleSize:uint;
		protected var _fadeRatio:Number;
		
		protected var _offset:Number;
		protected var _timer:Timer;
		
		public function SVLoading(x:Number, y:Number, r:Number = 32, c:Number = 7, large:Boolean = true)
		{
			_radius = r;
			
			_circleColor = Style.pink;
			_circles = c;
			if (large)
			{
				_circleSize = 11;
			}
			else
			{
				_circleSize = 7;
			}
			_fadeRatio = 1/(_circles + 1);
			
			this.x = x;
			this.y = y;
			this.alpha = 0.75;
			
			_offset = 0;
		}
		
		private function timerHandler(e:Event):void
		{
			if (!visible)
			{
				visible = true;
				_timer.delay = 60;
			}
			
			drawCircles();
			_offset = (_offset + 1) % _circles;
		}
		
		protected function initCircles():void
		{
			for (var i:int=0; i<_circles; i++)
			{
				var cx:Number = this.x + Math.sin(((i+_offset) * (360/_circles)) * (Math.PI/180)) * _radius;
				var cy:Number = this.y + Math.cos(((i+_offset) * (360/_circles)) * (Math.PI/180)) * _radius;
				var circle:LoadingCircle = new LoadingCircle(cx, cy, _circleColor, _circleSize, 1 - (i * _fadeRatio));
				addChild(circle);
			}
		}
		
		protected function drawCircles():void
		{
			for (var i:int=0; i<numChildren; i++)
			{
				var circle:LoadingCircle = getChildAt(i) as LoadingCircle;
				circle.draw(1 - (((i+_offset)%_circles) * _fadeRatio));
			}
		}
		
		public function startLoading():void
		{
			if (_timer == null)
			{
				_timer = new Timer(350);
				_timer.addEventListener(TimerEvent.TIMER, timerHandler, false, 0, true);
				initCircles();
			}
			
			if(_timer.running == false)
			{
				visible = false;
				_timer.reset();
				_timer.start();
			}
		}
		
		public function endLoading():void
		{
			if(_timer && _timer.running)
			{
				_timer.stop();
			}
			visible = false;
			_timer.delay = 350;
			
			if (parent && parent.contains(this))
				parent.removeChild(this);
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

import flash.display.*;

class LoadingCircle extends Sprite
{
	private var _cx:Number;
	private var _cy:Number;
	private var _color:uint;
	private var _size:uint;
	
	public function LoadingCircle(cx:Number, cy:Number, color:uint, size:uint, startAlpha:Number)
	{
		_cx = cx;
		_cy = cy;
		_color = color;
		_size = size;
		
		draw(startAlpha);
	}
	
	public function draw(alpha:Number):void
	{
		var g:Graphics = this.graphics;
		g.clear();
		g.beginFill(_color, alpha);
		g.drawCircle(_cx, _cy, _size);
	}
}