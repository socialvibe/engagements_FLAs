package com.socialvibe.core.utils
{
	import com.socialvibe.core.config.Services;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.system.*;
	import flash.text.*;
	import flash.utils.*;
	
	import mx.events.*;
	import mx.modules.*;
	
	public class ModuleLoader extends EventDispatcher
	{
		public static const MODULE_LOADED:String	= 'moduleLoaded';
		public static const MODULE_FAILED:String	= 'moduleFailed';
		public static const PROGRESS_WIDTH:Number	= 180;
		public var data:Object;
		
		private var _progressBar:Sprite;
        private var _progress:Shape;
        
		private var _retryAttempt:Number = 0;
		
		static private var _moduleCache:Object;
		private var _loaders:Object;
		private var _base:ModuleBase; // needed for module optimization dependency
		
		public function ModuleLoader()
		{
			_moduleCache ||= {};
			_loaders = {};
			
			_progressBar = new Sprite();
			
			_progress = new Shape();
			_progressBar.addChild(_progress);
			
			var progressText:TextField;
			try {
				var svTextClass:Class = getDefinitionByName('com.socialvibe.core.ui.controls::SVText') as Class;
				progressText = new svTextClass('LOADING', 67, 3, 11, false, 0xCCCCCC);
			} catch (e:Error) {
				progressText = new TextField();
				progressText.defaultTextFormat = new TextFormat("Lucida Grande, Tahoma, Verdana, Arial, sans-serif", 11, 0xCCCCCC);
				progressText.mouseEnabled = progressText.selectable = false;
				progressText.text = 'LOADING';
				progressText.x = 67;
				progressText.y = 3;
			}
			_progressBar.addChild(progressText);
		}
		
		public function loadModule(module_url:String, type:String = null, meta:Object = null):void
		{
			if (module_url == null)
			{
				dispatchEvent(new SVEvent( MODULE_FAILED, module_url ));
				return;
			}
			
			var url:String = module_url.toLowerCase().indexOf("http://") == 0 ? module_url : (Security.sandboxType == Security.LOCAL_TRUSTED ? '' : Services.S3_URL) + module_url + '?v=' + Services.VERSION_NUM;
			if (_moduleCache[url])
			{
				endProgress();
				dispatchEvent(new SVEvent( MODULE_LOADED, _moduleCache[url].getContent(type, meta) ));
				return;
			}
			
			clearProgress();
			
			var moduleLoader:IModuleInfo = ModuleManager.getModule(url);
			moduleLoader.data = {'type':type, 'meta':meta};
			_loaders[url] = moduleLoader;
			moduleLoader.addEventListener(ModuleEvent.READY, moduleLoaded);
	   		moduleLoader.addEventListener(ModuleEvent.ERROR, moduleFailed);
	   		moduleLoader.addEventListener(ModuleEvent.PROGRESS, moduleProgress);
	    	moduleLoader.load(ApplicationDomain.currentDomain);
		}
		
		private function moduleLoaded(e:ModuleEvent):void
	    {
	    	var moduleLoader:IModuleInfo = _loaders[e.module.url] as IModuleInfo;
	    	
	    	var module:Object = moduleLoader.factory.create();
	    	
			if ( e.module.factory['loaderInfo'] && e.module.factory['loaderInfo']['loader'] )
				Hoptoad.addErrorHandlingToLoadedAsset( e.module.factory['loaderInfo']['loader'] as Loader, e.module.url );		
				
	    	_moduleCache[e.module.url] = module;
	    	
	    	deleteLoader(e.module.url);
	    	dispatchEvent(new SVEvent( MODULE_LOADED, module.getContent(moduleLoader.data.type, moduleLoader.data.meta) ));
	    }
	    
	    private function moduleFailed(e:ModuleEvent):void
	    {
	    	deleteLoader(e.module.url);
	    	
	    	// retry module load
	    	if (_retryAttempt < 3 && (e.errorText && e.errorText.indexOf("Error #2035") == 0))
	    	{
	    		_retryAttempt += 1;
	    		setTimeout(loadModule, _retryAttempt * 2000, e.module.url);
	    	}
	    	else
	    	{
				Hoptoad.sendToHoptoad("Failed to load module '" + e.module.url + "'", 'ModuleLoader', 'loading_module::' + e.module.url, {'module_url': e.module.url}, 0.002);
	    		dispatchEvent(new SVEvent( MODULE_FAILED, e.module.url ));
	    	}
	    }
		
        protected function moduleProgress(e:ModuleEvent):void
	    {
	    	setProgress(e.bytesLoaded / e.bytesTotal);
        }
        
		private function deleteLoader(module_url:String):void
		{
			var moduleLoader:IModuleInfo = _loaders[module_url] as IModuleInfo;
			
			if (moduleLoader)
			{
				moduleLoader.removeEventListener(ModuleEvent.READY, moduleLoaded);
		    	moduleLoader.removeEventListener(ModuleEvent.ERROR, moduleFailed);
		    	
		    	delete _loaders[module_url];
		 	}
		 	
		 	endProgress();
		}
		
		private function clearProgress():void
		{
			var progressH:Number = 24;
			
			_progressBar.visible = false;
			setTimeout(showProgressBar, 250);
			
			var g:Graphics = _progressBar.graphics;
			g.clear();
			
			g.beginFill(0xCCCCCC, 0.25);
			g.drawRoundRect(0, 0, PROGRESS_WIDTH, progressH, progressH*0.7);
			g.drawRoundRect(2, 2, PROGRESS_WIDTH-4, progressH-4, progressH*0.65);
			
			_progress.graphics.clear();
		}
		
		protected function showProgressBar():void
        {
        	_progressBar.visible = true;
        }
		
		protected function setProgress(percent:Number):void
        {
        	if (isNaN(percent)) return;
        	
        	var g:Graphics = _progress.graphics;
        	g.clear();
        	
        	var progressH:Number = 24;
        	
        	var matr:Matrix = new Matrix();
			matr.createGradientBox(PROGRESS_WIDTH, progressH, Math.PI/2, 0, 0);
			g.beginGradientFill(GradientType.LINEAR, [0x20d1ff, 0x20d1ff], [1, 0.5], [0, 250], matr, SpreadMethod.PAD, InterpolationMethod.LINEAR_RGB);
			g.drawRoundRect(2, 2, Math.ceil((PROGRESS_WIDTH-4)*percent), progressH-4, progressH*0.65);
        }
        
        private function endProgress():void
        {
        	if (_progressBar.parent && _progressBar.parent.contains(_progressBar))
				_progressBar.parent.removeChild(_progressBar);
        }
        
		public static function stringToObject(string:String, initObj:Object = null):Object
	    {
	    	if (string == null || string.length == 0) return (initObj || {});
	    	
	        var obj:Object = (initObj || {});
	        var arr:Array = string.split("@");
	
	        for (var i:int = 0; i < arr.length; i++)
	        {
				var item:String = arr[i] as String;
				if (item.indexOf("=") > 0)
				{
					var name:String = item.substr(0, item.indexOf("="));
					var value:Object = item.substr(item.indexOf("=")+1);
					
					obj[name] = value;
				}
	        }
	
	        return obj;
	    }
	    
	    public function get progressBar():Sprite { return _progressBar; }
	    public function get progressWidth():Number { return PROGRESS_WIDTH; }
	    public function getModule(module_url:String):Object { return _moduleCache[module_url]; }
	}
}