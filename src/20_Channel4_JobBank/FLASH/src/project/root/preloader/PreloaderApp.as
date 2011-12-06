package project.root.preloader { 
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import core.InitProject;
	import com.greensock.loading.data.SWFLoaderVars;
	import com.greensock.loading.SWFLoader;
	import com.greensock.events.LoaderEvent;
	
	public class PreloaderApp extends MovieClip {

		public var swfContener;
		public var prl;
		
		public function PreloaderApp() {
			
			new InitProject(this);

			new Config();
			
			prl = addChild(new Preloader());
			
			var swfLoaderVars = new SWFLoaderVars().onComplete(_onSWFComplete).onProgress(_onSWFProgress);
			
			var swfLoader:SWFLoader = new SWFLoader(FlashVars.getFV("mainSWF") || "bankjob_main.swf", swfLoaderVars);
			swfLoader.load();
			
			Stager.getStage().addEventListener(Event.RESIZE, onResize);
			onResize();
			
		}
		
		private function _onSWFComplete(e:LoaderEvent) {
			
			swfContener = addChild(e.target.content);
			
			removeChild(prl);
			
			onResize();
			
			//e.target.content.gotoAndPlay(2);
			
		}
		
		private function _onSWFProgress(e:LoaderEvent) {
		
			//Trace.add(e.target.progress);
		
		}
		
		
		public function onResize(e:Event = null) {
			
			prl.x = Math.ceil(Stager.getStage().stageWidth / 2);
			prl.y = Math.ceil(Stager.getStage().stageHeight / 2);
			
		}
		
	}
	
	
}