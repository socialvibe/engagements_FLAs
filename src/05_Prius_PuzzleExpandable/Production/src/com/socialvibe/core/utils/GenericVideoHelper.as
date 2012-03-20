package com.socialvibe.core.utils
{
	import com.socialvibe.core.config.Services;
	import com.socialvibe.core.utils.SVEvent;
	
	import flash.events.EventDispatcher;
	import flash.net.*;

	public class GenericVideoHelper extends EventDispatcher
	{
		public static const INFO_READY : String = "infoReady";
		public static const YOUTUBE : String = "youtube";
		public static const FACEBOOK : String = "facebook";
		public static const SOCIALVIBE : String = "socialvibe";
		
		public function GenericVideoHelper() { }
		
		public function getInfo(url:String, highQuality:Boolean = false):void
		{
			var type:String = getVideoType(url);
			
			switch (type)
			{
				case FACEBOOK:
					var fbHelper:FBVideoHelper = new FBVideoHelper();
					
					fbHelper.addEventListener(FBVideoHelper.INFO_READY, onFBInfoReady)
					fbHelper.getVideo(url);
					break;
				case YOUTUBE:
					var ytHelper:YouTubeHelper = new YouTubeHelper();
				
					ytHelper.addEventListener(YouTubeHelper.FLV_READY, onYTInfoReady)
					ytHelper.getVideo(url, highQuality);
					break;
			}
		}
		
		private function onFBInfoReady( e:SVEvent ):void{
			var resultObject:Object = e.data as Object;
			
			var iframeSource:String = Services.SERVICES_URL + '/facebook/fb_video?';
			
			var vars:URLVariables = new URLVariables;
			vars.src = resultObject.video_src;
			vars.width = resultObject.video_width;
			vars.height =resultObject.video_height;
			vars.rotation = resultObject.video_rotation;
			
			iframeSource += vars.toString();
			
			resultObject.owner = FACEBOOK;
			resultObject.iframeSrc = iframeSource;
			resultObject.previewURL = resultObject.thumb_url;
			resultObject.width = resultObject.video_width;
			resultObject.height = resultObject.video_height;
		
			dispatchEvent( new SVEvent( INFO_READY, resultObject, false) );
		}
		
		private function onYTInfoReady( e:SVEvent ):void{
			
			var resultObject:Object = e.data as Object;
			var iframeSource:String = Services.SERVICES_URL + '/facebook/yt_video?';
			
			var vars:URLVariables = new URLVariables;
			vars.id = (resultObject.flvURL as String).split("get_video?video_id=")[1].split("&t=")[0];
			
			iframeSource += vars.toString();
			
			resultObject.owner = YOUTUBE;
			resultObject.iframeSrc = iframeSource;
			resultObject.previewURL = resultObject.previewURL;
			resultObject.width = 425;
			resultObject.height = 344;
		
			dispatchEvent( new SVEvent( INFO_READY, resultObject, false) );
		}

		public static function getVideoType(url:String):String
		{
			if (url.indexOf("facebook") > -1)
				return FACEBOOK;
			else if (url.indexOf("youtube.com") > -1)
				return YOUTUBE;
			else if (url.indexOf("socialvibe.com") > -1)
				return SOCIALVIBE;

			return null;
		}
	}
}