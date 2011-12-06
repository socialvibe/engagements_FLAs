package core.loaders { 
	
	import com.greensock.loading.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.display.*;
	import flash.display.Bitmap;
	import flash.events.EventDispatcher;

	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.ImageLoader;
	
	public class XMLLoaderMax extends EventDispatcher {

		// loader instance
		private var loader:XMLLoader;
		
		public function XMLLoaderMax() { }
	
		public function load(_xmlFile:String, _xmlID:String) {
			
			// create & load
			loader = new XMLLoader(_xmlFile, { name:_xmlID, estimatedBytes:50000, onComplete:completeHandler, onProgress:progressHandler } );
			loader.load();
			
		}
		
		private function progressHandler(event:LoaderEvent):void {
			
			// dispatch progress
			dispatchEvent(new LoaderEvent(LoaderEvent.PROGRESS, event.target));
			
		}
 
		private function completeHandler(event:LoaderEvent):void {		
			
			// dispatch complete
			dispatchEvent(event);
			
		}
		
	}
	
	
}