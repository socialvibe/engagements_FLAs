package { 
	
	/* using : 
	 * 
	 * new TimePause(this,2); 
	 * 
	 * */
	
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class TimePause extends MovieClip {
		
		private var _mc:MovieClip;		
		private var tmr:Timer;
		
		public function TimePause(__mc, _time) {
			
			var a_bout:String = " /* flavour.pl . time pause . timeline handy tool class */ ";
			
			_mc = __mc;
			
			_mc.stop();
			
			tmr = new Timer(1000*_time,1); 
			
			tmr.addEventListener(TimerEvent.TIMER, onFinished); 
			tmr.start(); 
			
		}
		
		function onFinished(e:TimerEvent):void { 
			
			_mc.play();
			
			tmr.removeEventListener(TimerEvent.TIMER, onFinished); 			
			tmr = null;
			
		}
		
		
	}
	
}