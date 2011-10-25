package com.socialvibe.core.utils
{
	import com.socialvibe.core.ui.controls.SVText;
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;
	
	public class FrameRater extends Sprite
	{
		private var _timer:Timer;
		private var _frames:uint;
        private var _avgArray:Array;
		private var _textField:SVText;
		
		public function FrameRater(x:Number, y:Number)
		{
			_frames = 0;
			_avgArray = [];
			
			_textField = new SVText('-- FPS ---- AV', 0, 0, 10, false, 0xBBBBBB);
			addChild(_textField);
			
			_timer = new Timer(1000);
            _timer.addEventListener(TimerEvent.TIMER, onTick, false, 0, true);
			
			addEventListener(Event.ENTER_FRAME, onEveryFrame, false, 0, true);

			this.x = x;
			this.y = y;
			
			_timer.start();
		}
		
		private function onEveryFrame(e:Event):void
        {
            _frames += 1;
        }
        
        private function onTick(e:TimerEvent):void
        {
            _avgArray.push(_frames);
			if(_avgArray.length == 4)
			{
				for(var i:int = 1; i<_avgArray.length; i++)
				{
					_avgArray[0] += _avgArray[i];
				}
				_avgArray.splice(1, _avgArray.length-1);
				_avgArray[0] /= 4;
			}
			
			_textField.text = _frames + " FPS " + Math.round(_avgArray[0]) + " AV";
			
            _frames = 0;
        }
	}
}