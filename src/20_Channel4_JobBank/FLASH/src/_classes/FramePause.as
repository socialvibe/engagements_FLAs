package { 
	
	/* using : 
	 * 
	 * new FramePause(this,2); 
	 * 
	 * */
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class FramePause extends MovieClip {
		
		private var _mc:MovieClip;		
		private var framer:MovieClip;
		private var counter:Number;
		
		public function FramePause(__mc, _frames) {
			
			var a_bout:String = " /* flavour.pl . frame pause . timeline handy tool class */ ";
			
			_mc = __mc;
			
			counter = Math.abs(_frames);
			
			_mc.stop();
			_mc.addEventListener(Event.ENTER_FRAME, onEnterFrameCounter);
			
		}
		
		public function onEnterFrameCounter(event : Event):void { 
			
			if (counter > 0) counter--;
			else clearAndGo();	
			
		}
		
		public function clearAndGo() {
			
			_mc.removeEventListener(Event.ENTER_FRAME, onEnterFrameCounter);
			_mc.play();
			
		}
		
	}
	
	
}