package core.base { 
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import com.greensock.*; 
	import com.greensock.easing.*;

	public class ButtonBase extends MovieClip {

	private var _mc:MovieClip;
	public var clickCallback:Function;

		public function () {
		
			_mc = this;
			_mc.mouseChildren = false;
			
			enable();
			
		}
		
		public function buttonOver(e:MouseEvent = null):void {
			
			TweenMax.to(_mc, .5, { colorMatrixFilter: { brightness:1.4 }} );
			

		}
		
		public function buttonOut(e:MouseEvent = null):void {
			
			TweenMax.to(_mc, .5, { colorMatrixFilter: { brightness:1 }} );
			

		}		
		
		public function buttonClick(e:MouseEvent = null):void {
			
			clickCallback();
			
		}

		public function enable() {
			
			_mc.buttonMode = true;
			
			if (!_mc.hasEventListener(MouseEvent.ROLL_OVER))
			_mc.addEventListener(MouseEvent.ROLL_OVER, buttonOver);
			
			if (!_mc.hasEventListener(MouseEvent.ROLL_OUT))
			_mc.addEventListener(MouseEvent.ROLL_OUT, buttonOut);
			
			if (!_mc.hasEventListener(MouseEvent.CLICK))
			_mc.addEventListener(MouseEvent.CLICK, buttonClick);
			
		}

		public function disable() {
			
			_mc.buttonMode = false;
			_mc.removeEventListener(MouseEvent.ROLL_OVER, buttonOver);
			_mc.removeEventListener(MouseEvent.ROLL_OUT, buttonOut);
			_mc.removeEventListener(MouseEvent.CLICK, buttonClick);
			
		}
		
	}	
	
}