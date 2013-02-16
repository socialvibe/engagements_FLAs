package com.socialvibe.core.utils
{
	import com.adobe.serialization.json.JSON;
	import com.socialvibe.core.config.Services;
	import com.socialvibe.core.utils.SVEvent;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;

	public class FBVideoHelper extends EventDispatcher
	{
		public static const INFO_READY:String = "infoReady";
		
		public function FBVideoHelper() { }

		public function getVideo(url:String):void
		{
			try {
				var videoId1:String = url.split("v=")[1];
				var videoId2:String = url.split("v/")[1];
				
				var videoId:String = videoId1 ? videoId1 : videoId2;
				
			} catch (e:Error){
				throw new Error("FBVideoHelper was passed an invalid Facebook Video url");
			}
			var normalizedURL:String = Services.SERVICES_URL +  "/facebook/get_video_token?video_id=" + videoId; 
            
            var loader:URLLoader = new URLLoader();
            loader.addEventListener(Event.COMPLETE, completeHandler); 
            var request:URLRequest = new URLRequest(normalizedURL);
            
            try {
                loader.load(request);
            } catch (error:Error) {
                trace("Unable to load requested document.");
            }
		}
		
		// EXAMPLE instance of videoInfo returned through SVEvent:
		//=========================================================
		// 	fbt_go_to_video 	=>	"Go to Video"	
		//	fbt_next_video 		=>	"Next Video"	
		//	fbt_play_again	 	=>	"Play Again"	
		//	fbt_share 			=>	"Share"	
		//	thumb_url 			=>	"http://vthumb.ak.facebook.com/vthumb-ak-sf2p/v2336/173/100/1011091206/b1011091206_1045085719992_1072.jpg"	
		//	video_category 		=>	0	
		//	video_height 		=>	324 [0x144]	
		//	video_href 			=>	"http://www.facebook.com/video/video.php?v=1045085719992"	
		//	video_id 			=>	1045085719992 [0xf353f68db8]	
		//	video_is_offsite 	=>	true	
		//	video_length 		=>	40170 [0x9cea]	
		//	video_owner_href 	=>	"http://www.facebook.com/apps/application.php?id=48074459292"	
		//	video_owner_name 	=>	"SocialVibe 2.0"	
		//	video_owner_pic 	=>	"http://photos-e.ak.fbcdn.net/photos-ak-sf2p/v43/216/48074459292/app_1_48074459292_7950.gif"	
		//	video_player_type 	=>	"video_player_offsite"	
		//	video_rotation 		=>	0	
		//	video_seconds 		=>	40 [0x28]	
		//	video_src 			=>	"http://video.ak.facebook.com/video-ak-sf2p/v1182/12/119/1045085719992_27933.mp4"	
		//	video_timestamp 	=>	"Added 3 hours ago"	
		//	video_title 		=>	"Stop the Seal Slaughter"	
		//	video_width 		=>	576 [0x240]	
		
		
		private function completeHandler(event:Event):void {
            var loader:URLLoader = URLLoader(event.target); 
            try {
	            var vars:URLVariables = new URLVariables(loader.data);
	
				var videoInfo:Object = JSON.decode(	vars.video ).content;
            }
            catch (e:Error)
            {
            	videoInfo = {video_width:320, video_height:240};
            }
									
			dispatchEvent( new SVEvent( INFO_READY, videoInfo, false) ); 
        }
		
		
	}

		
}