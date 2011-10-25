package com.toyota.prius.expanded
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	import com.toyota.prius.interfaces.IPriusExpandable
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author jin
	 */
	
	public class Preloader extends MovieClip implements IPriusExpandable
	{
		private var mainClass:ExtendedMain;
		
		public function Preloader() 
		{
			addEventListener(Event.ADDED_TO_STAGE, initListener);
		}
		
		private function initListener(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initListener);
			
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(Event.COMPLETE, complete);
		}
		
		private function progress(e:ProgressEvent):void 
		{
			var p:uint =  ( e.bytesLoaded / e.bytesTotal ) * 100;
			trace( "p:"+ p );
			//per.text = p.toString() + "%";
		}
		
		private function complete(e:Event):void 
		{
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(Event.COMPLETE, complete);
			
			startup();
		}
		
		private function startup():void 
		{
			mainClass = new ExtendedMain();
			this.addChild( mainClass );
		}
		
			
		public function playEveryoneAnim( short:Boolean = false ):void
		{
			if( mainClass ) mainClass.playEveryoneAnim( short );
		}
		
		public function hideCopy():void
		{
			if( mainClass ) mainClass.hideCopy();
		}
		
		public function cubePlayOutro():void
		{
			if( mainClass ) mainClass.cubePlayOutro();
		}
		public function get playVid():Signal
		{
			return mainClass.playVid;
		}
		public function get replay():Signal
		{
			return mainClass.replay;
		}
		public function get clickthru():Signal
		{
			return mainClass.replay;
		}
	}
	
}