package com.toyota.prius.initial
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	//import com.carlcalderon.arthropod.Debug;
	
	/**
	 * ...
	 * @author jin
	 */
	
	public class Preloader extends MovieClip 
	{
		private var autoExpand:Boolean;
		private var loadDone:Boolean = false;
		private var expandTypeSet:Boolean = false;
		
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
			//var p:uint =  ( e.bytesLoaded / e.bytesTotal ) * 100;
		}
		
		private function complete(e:Event):void 
		{
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(Event.COMPLETE, complete);
			loadDone = true;
			
			if( expandTypeSet ) startup();
		}
		
		private function startup():void 
		{
			if ( autoExpand ) 
			{
				//Debug.log("EWBase.getFlashParameter(\"autoFreqCap\") : " + EWBase.getFlashParameter("autoFreqCap"));
				
				// check cookie - autoplay once per day
				if ( EWBase.getFlashParameter("autoFreqCap") ) {
					var result:String = EWBase.getFlashParameter("autoFreqCap").toString();
					//Debug.log("result : " + result);
					
					if ( result ) 
					{
						if ( result == "true" || result == true )
						autoExpand = false;
					}
				}
			}
			
			var main:ExpandableMain = new ExpandableMain( autoExpand );
			this.addChild( main );
		}
		
		private function set setAutoExpand( bol:Boolean ):void 
		{
			expandTypeSet = true;
			autoExpand = bol;
			
			if( loadDone ) startup();
		}
		
	}
	
}