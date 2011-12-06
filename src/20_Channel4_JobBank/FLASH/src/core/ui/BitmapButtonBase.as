package core.ui { 
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import com.greensock.*; 
	import com.greensock.easing.*;

	public class BitmapButtonBase extends MovieClip {

	private var _harea:MovieClip;
	private var mcHolderOver;
	private var mcHolderOut;
	
		public function BitmapButtonBase(doOut, doOver) {
		
			mcHolderOver = addChild(doOver);
			mcHolderOut = addChild(doOut);
			mcHolderOver.visible = false;
			
			_harea = this;
			
			enable();
			
		}
		
		public function buttonOver(e:MouseEvent = null):void {
			
			mcHolderOver.visible = true;
			mcHolderOut.visible = false;
			
		}
		
		public function buttonOut(e:MouseEvent = null):void {
			
			mcHolderOver.visible = false;
			mcHolderOut.visible = true;
			
		}		
		
		public function buttonClick(e:MouseEvent = null):void {
			
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