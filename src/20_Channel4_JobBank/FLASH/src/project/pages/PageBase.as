package project.pages { 
	
	import flash.display.MovieClip;
	import flash.events.Event;

	public class PageBase extends MovieClip {

		public function PageBase() {
			
			Stager.getStage().addEventListener(Event.RESIZE, onResize);
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, onSWFAddressChange);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
		}
		
		public function get contentStageHeight():Number {
			
			return Config.stageHeight;
			
		}		
		
		public function get contentStageWidth():Number {
			
			return Config.stageWidth;
			
		}			
		
		public function onAddedToStage(e:Event) {
			
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			onResize();
			
		}
		
		public function onResize(e:Event = null) {
			
			
		}
		
		public function onSWFAddressChange(e:SWFAddressEvent = null) {
			
			
		}
		
		public function onRemovedFromStage(e:Event) {
			
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			SWFAddress.removeEventListener(SWFAddressEvent.CHANGE, onSWFAddressChange);
			Stager.getStage().removeEventListener(Event.RESIZE, onResize);
			
			
		}		
		
	}
	
	
}