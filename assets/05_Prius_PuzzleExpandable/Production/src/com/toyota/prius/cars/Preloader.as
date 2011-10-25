package com.toyota.prius.cars
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	
	import com.toyota.prius.interfaces.IPriusExpandableCars
	
	/**
	 * ...
	 * @author jin
	 */
	public class Preloader extends MovieClip implements IPriusExpandableCars
	{
		
		public function Preloader() 
		{
			addEventListener(Event.ADDED_TO_STAGE, initListener);
		}
		
		private function initListener(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initListener);
			loaderInfo.addEventListener(Event.COMPLETE, complete);
		}
		
		private function complete(e:Event):void 
		{
			loaderInfo.removeEventListener(Event.COMPLETE, complete);
			startup();
		}
		
		private function startup():void 
		{
			/*viewInfo.addEventListener( MouseEvent.ROLL_OVER, onBtnOver );
			viewInfo.addEventListener( MouseEvent.ROLL_OUT, onBtnOut );*/
		}
		
		public function showBtns():void
		{
			
		}
		
		private function onBtnOver( e:MouseEvent ):void
		{
			var btn:MovieClip = e.currentTarget as MovieClip;
			btn.gotoAndPlay( "over" );
		}
		
		private function onBtnOut( e:MouseEvent ):void
		{
			var btn:MovieClip = e.currentTarget as MovieClip;
			btn.gotoAndPlay( "out" );
		}
	}
	
}