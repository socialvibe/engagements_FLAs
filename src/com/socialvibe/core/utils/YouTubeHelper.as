package com.socialvibe.core.utils
{
	import com.socialvibe.core.config.Services;
	import com.socialvibe.core.ui.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	
	public class YouTubeHelper extends EventDispatcher
	{
		public static const FLV_READY:String	= 'flvReady';
		
		private static var _instance : YouTubeHelper;
		private static var _highQuality : Boolean;
		
		public static function getInstance() : YouTubeHelper 
		{
			if ( _instance == null )
			{
				_instance = new YouTubeHelper();
			}

			return _instance;
  		}
  		
		public function YouTubeHelper() { }

		public function getVideo(url:String, highQuality:Boolean = false):void
		{
			_highQuality = highQuality;
			
			var vars:Array = url.match("v=([^&]*)");
			var result:Object = {'flvURL':Services.SERVICES_URL + '/youtube/get_video?video_id=' + vars[1] + (_highQuality ? '&fmt=18' : ''), 'previewURL':'http://img.youtube.com/vi/' + vars[1] + '/1.jpg'};
			dispatchEvent(new SVEvent(FLV_READY, result));
			
			/* YouTube changed the way this works (6/27/09)
			var normalizedURL:String = url.split("watch?v=").join("v/");
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.INIT, onVidRequestLoad);
			try {
				loader.load(new URLRequest(normalizedURL));
			} catch (e:Error) { }
			*/
		}
		/*
		private function onVidRequestLoad(evt:Event):void
		{
			evt.currentTarget.removeEventListener(Event.INIT, onVidRequestLoad);
			
			var loader:Loader = Loader(evt.target.loader);
			
			var vars:URLVariables = new URLVariables();
			try
			{
				vars.decode(loader.contentLoaderInfo.url.split("?")[1]);
				var	videoId:String = vars.video_id is Array ? vars.video_id[0] : vars.video_id;
				loader.unload();
				
				var result:Object = {'flvURL':Services.SERVICES_URL + '/youtube/get_video?video_id=' + videoId + (_highQuality ? '&fmt=18' : ''), 'previewURL':vars.iurl};
				dispatchEvent(new SVEvent(FLV_READY, result));
				
			}
			catch (e:Error) { }
		}
		*/
	}
}
