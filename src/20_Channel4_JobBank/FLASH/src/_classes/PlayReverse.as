package { 
	
	/* using : 
	 * 
	 * new PlayReverse(this,2,function() { }); 
	 * 
	 * */
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class PlayReverse extends MovieClip {
		
		private var _mc:MovieClip;		
		private var framer:MovieClip;
		private var destFrame:Number;
		private var counter:Number;
		private var callback:Function;
		private var startFrame:Number;
		
		public function PlayReverse(__mc, _destFrame, _callback:Function = null) {
			
			var a_bout:String = " /* flavour.pl . play backward . timeline handy tool class */ ";
			
			_mc = __mc;
			destFrame = _destFrame;
			
			callback = _callback;
			
			startFrame = _mc.currentFrame;
			
			if (startFrame > destFrame) {
				
				_mc.stop();
				
				counter = _mc.currentFrame-destFrame-1;
				_mc.addEventListener(Event.ENTER_FRAME, onEnterFrameCounter); 
				
			}
			
		}
		
		public function onEnterFrameCounter(event : Event):void { 
			
			_mc.gotoAndStop(counter + destFrame);
			if (counter > 0) counter--;
			else clearAndGo();
			
		}
		
		public function clearAndGo() {
			
			_mc.removeEventListener(Event.ENTER_FRAME, onEnterFrameCounter); 			
			
			if (callback != null) callback();
			
		}
		
		
	}
	
	
}