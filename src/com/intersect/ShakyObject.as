package com.intersect
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public dynamic class ShakyObject extends MovieClip
	{
		public var shakiness:Number = 0.5;
		public var frequency:Number = 0.5;
		private var baseX:Number;
		private var baseY:Number;
		private var bShaking:Boolean = false;
		
		public function ShakyObject()
		{
			addEventListener(Event.ENTER_FRAME, tick);
			baseX = x;
			baseY = y;
			bShaking = true;
		}
		
		public function tick(evt)
		{
			if (Math.random() < frequency)
			{
				this.x = baseX + (Math.random() - 0.5) * shakiness;
				this.y = baseY+(Math.random() - 0.5) * shakiness;
			}
		}
		
		public function stopShake()
		{
			removeEventListener(Event.ENTER_FRAME, tick);
			bShaking = false;
		}
		
		public function startShake()
		{
			if (!bShaking)
			{
				addEventListener(Event.ENTER_FRAME, tick);
				bShaking = true;
			}
		}
	}
}