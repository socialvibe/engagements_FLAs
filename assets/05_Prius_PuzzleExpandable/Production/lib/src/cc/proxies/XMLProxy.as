package cc.proxies
{

	import cc.core.AbstractProxy;
	import cc.utils.StringUtils;
	import cc.errors.CCError;
	
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.ProgressEvent;

	public class XMLProxy extends AbstractProxy
	{
	
		protected var _source:XML;
		protected var _loader:URLLoader;
	
		public function XMLProxy()
		{
			super();
		}
		
		public function load(asset:String):void
		{
			if(!asset) if(asset.length < 1)
				throw new CCError('XMLProxy#load() received invalid asset: ' + asset);
			if(StringUtils.isURL(asset) == true)
			{
				construct();
				_loader.load(new URLRequest(asset));
			}
			else
			{
				parse(XML(asset));
			}
		}
		
		protected function parse(data:XML):void
		{
			// parse data
			_source = data;
			
		}
		
		protected function construct():void
		{
			if(!_loader)
			{
				_loader = new URLLoader();
				_loader.addEventListener(Event.COMPLETE, 					onLoadComplete	);
				_loader.addEventListener(ProgressEvent.PROGRESS,			onLoadProgress	);
				_loader.addEventListener(IOErrorEvent.IO_ERROR, 			onIOError		);
				_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError	);
			}
		}
		
		protected function onLoadProgress(e:ProgressEvent):void
		{
			// progress
		}
		
		protected function onLoadComplete(e:Event):void
		{
			parse(XML(_loader.data));
			dispatchEvent(e.clone());
		}
		
		protected function onIOError(e:IOErrorEvent):void
		{
			// io error
			trace(e);
		}
		
		protected function onSecurityError(e:SecurityErrorEvent):void
		{
			// security error
			trace(e);
		}
		
	}

}