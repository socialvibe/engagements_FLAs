package { 
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import com.greensock.*; 
	import com.greensock.easing.*;

	public class ButtonBox extends MovieClip {

	public var _mc:MovieClip;
	private var _harea:MovieClip;

		public function ButtonBox() {
		
			_mc = this;
			
			_harea = this;
			
			_mc.mouseChildren = false;
			
			enable();
			
			//alpha = 0;
			
			
		}
		
		public function buttonOver(e:MouseEvent = null):void {
			
			e.currentTarget.gotoAndStop(2);

		}
		
		public function buttonOut(e:MouseEvent = null):void {
		
			e.currentTarget.gotoAndStop(1);
			
		}	
		
		
		public function buttonClick(e:MouseEvent = null):void {
			
			MainApp.track("BankJob", "click box");

			Config.boxNum = this.name.substr(1, 2);
			
			MainApp.instance["LED2"].play();
			
			MainApp.instance.play();
			
			
		}

		public function enable() {
			
			_harea.buttonMode = true;
			
			if (!_harea.hasEventListener(MouseEvent.ROLL_OVER))
			_harea.addEventListener(MouseEvent.ROLL_OVER, buttonOver);
			
			if (!_harea.hasEventListener(MouseEvent.ROLL_OUT))
			_harea.addEventListener(MouseEvent.ROLL_OUT, buttonOut);
			
			if (!_harea.hasEventListener(MouseEvent.CLICK))
			_harea.addEventListener(MouseEvent.CLICK, buttonClick);
			
		}

		public function disable() {
			
			_harea.buttonMode = false;
			_harea.removeEventListener(MouseEvent.ROLL_OVER, buttonOver);
			_harea.removeEventListener(MouseEvent.ROLL_OUT, buttonOut);
			_harea.removeEventListener(MouseEvent.CLICK, buttonClick);
			
		}
		
	}	
	
}