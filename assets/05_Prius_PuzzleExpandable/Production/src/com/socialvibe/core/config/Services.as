package com.socialvibe.core.config
{
	import flash.system.*;
	
	import org.rubyamf.remoting.ssr.RemotingService;
	
	public class Services
	{
		public static var VERSION_NUM:String = "5.0.14";
		public static var BUILDER_VERSION:String = "v3";
		public static var CURRENT_APP_ID:int = 4;
		
		public static var FACEBOOK_APP_LINK_URL:String = "http://apps.facebook.com/socialvibe/link";
		public static var BEBO_APP_LINK_URL:String = "http://apps.bebo.com/socialvibe/link";
		public static var MYSPACE_ADD_URL:String = "http://www.myspace.com/Modules/PostTo/Pages/";
		public static var FACEBOOK_CANVAS_URL:String = "http://apps.facebook.com/socialvibe";
		public static var SERVICES_URL:String = "http://www.socialvibe.com";
		public static var ALT_SERVICES_URL:String = "http://www2.socialvibe.com";
		public static var PARTNER_URL:String = "http://partners.socialvi.be";
		public static var S3_URL:String = "http://media.socialvibe.com/";
		public static var AD_URL:String = "http://sv1.socialvibe.com/";
		public static var AD_BACKUP_URL:String = "http://sv1.socialvibe.com.s3.amazonaws.com/";
		public static var YOUTUBE_VIDEO_URL:String = "http://www.youtube.com/watch?v=aVbUNe21pis";
		public static var COMSCORE_TRACKING_PIXEL:String = "http://b.scorecardresearch.com/p?c1=8&c2=8030913&c3=1&c4=&c5=&c6=&c15=&cv=2.0&cj=1";
		
		//public static var GATEWAY_URL:String = SERVICES_URL + "/rubyamf/gateway";
		//public static var ALT_GATEWAY_URL:String = ALT_SERVICES_URL + "/rubyamf/gateway";
		//public static var PHOTO_UPLOAD_URL:String = SERVICES_URL + "/user_photos";
		
		public static var BLOGGER_KEYS:Array			= ["tLTg0uWzBHS73WWXunZCw", "vpliTV9DB345xvZfIaQGrw", "beGKstlF9hM2Xp9AmjyNg"];
		public static var BLOGGER_SECRETS:Array			= ["MSbbTMmyXXs1JCxBch2ILM37YCyYgsrO1Dj1DgA3x3M", "9gdUJgfRpxvYlhNUTu0KoMVNSjZhjh06DjJ90czJoY", "bxnjjfqrHFCsir01p8G3Iag7LsJ5jYFvbNq7P3ppExA"];
		public static var WORDPRESS_KEYS:Array			= ["H2eSlyCH86KfBE6KK0w", "bOaN9QP8K9ZccwbeW2uYGA", "94YVNcLtkCFvmsX6adSg"];
		public static var WORDPRESS_SECRETS:Array		= ["mxoG9UuQazG31ud0UurlP67sUhlbiKom2q7PfWviIg", "Mt18uU4QE17DFd6zsgGRRCaCNrmcY7MWW4xzfgNCM", "4r9YkKDi9pR2AOlQZNvGfeyJPR0FJ1rZVOTgWk1mOw"];
		
		public static var OAUTH_CONSUMER_KEY:String 	= 'H2eSlyCH86KfBE6KK0w';
		public static var OAUTH_CONSUMER_SECRET:String 	= 'mxoG9UuQazG31ud0UurlP67sUhlbiKom2q7PfWviIg';
		
		public static var FB_CONNECTION_NAME:String;
		public static var FB_FEED_TEMPLATE_ID:String	= '156851457187';
		
		public static var DEBUG:Boolean;
		public static var BUILDER_MODE:Boolean = false;
		public static var ALLOW_CURSOR_CHANGE:Boolean = true;
		
		public static const FB_APP_ID:int = 1;
		public static const WP_APP_ID:int = 2;
		public static const BLOGGER_APP_ID:int = 3;
		public static const SV_APP_ID:int = 4;
		
		public static const COOKIE_NAME:String = "sv1";
		
		public static const MAX_NUM_SPONSORS:Number = 2;
		public static const POINT_CONVERSION_FACTOR:Number = 1000;
		
		public static const LEVELS:Object = {'Gold':0, 'Platinum':1, 'Diamond':2, 'Pink':3, 'Black':4};
		public static const LEVEL_NAMES:Object = ['Gold', 'Platinum', 'Diamond', 'Pink', 'Black'];
		public static const MAX_LEVEL:int = 1;
		
		public static const NETWORKS:Object = {'MySpace':1, 'Facebook':2, 'Friendster':3, 'Hi5':4,
			 'BlackPlanet':5, 'Blogger':6, 'Xanga':7, 'Freewebs':8, 'TypePad':9, 'Tagged':10, 'LiveJournal':11, 'Other':12, 'MyYearbook': 13, 'Bebo':14, 'Ning':15};
		
		// SERVICE RESPONSE CODES
		public static const STATUS_ERROR:int = 0;
		public static const STATUS_EXCEPTION:int = 1;
		public static const STATUS_OK:int = 2;
		public static const STATUS_AUTH_EXCEPTION:int = 3;
		
		// SERVICE EXCEPTION CODES
		public static const LOGIN_REQUIRED:int = 0;
		public static const INVALID_USERNAME_OR_PASSWORD:int = 2;
		public static const ACCOUNT_NOT_ACTIVATED:int = 3;
		public static const NOT_AUTHORIZED:int = 4; //insufficient permissions; i.e. not owner for delete
		public static const UNKNOWN_USERNAME:int = 5;
		public static const MAX_SPONSORSHIPS:int = 6;
		public static const UNQUALIFIED_SPONSORSHIP_OFFER:int = 7;
		public static const DUPLICATE_EMAIL:int = 8;
		public static const ACCOUNT_SUSPENDED:int = 9;
		public static const ADMIN_REQUIRED:int = 10;
		public static const USER_HAS_TOO_MANY_FRIENDS:int = 13;
		public static const FRIEND_HAS_TOO_MANY_FRIENDS:int = 14;
		public static const FRIENDSHIP_ALREADY_REQUESTED:int = 15;
		public static const FRIENDSHIP_REQUESTS_DISABLED:int = 16;
		public static const ACCOUNT_DELETED:int = 17;
		
		// FACEBOOK Exceptions
		public static const APP_LOGIN_REQUIRED:int = 18;
		public static const APP_USER_ALREADY_LINKED:int = 19;
		public static const ENGAGEMENT_LIMIT_REACHED:int = 20;
		public static const BUDGET_EXCEEDED:int = 21;
		public static const EXTENDED_PERMISSION_REQUIRED:int = 22;
		public static const GENERAL_EXCEPTION:int = 23;
		public static const EMAIL_ALREADY_SUBMITTED:int = 24;
		
		// OAUTH Exceptions
		public static const OAUTH_TOKEN_ALREADY_GRANTED:int = 25;
		
		public static function configureServices(parameters:Object):void
		{
			if (parameters.v && parameters.v != "")
				VERSION_NUM = parameters.v;
			
			if (parameters.app_id && parameters.app_id != "")
				CURRENT_APP_ID = Number(parameters.app_id);
			
			if (parameters.serviceURL && parameters.serviceURL != "")
				SERVICES_URL = String(parameters.serviceURL);
			
			if (parameters.partner_url && parameters.partner_url != "")
				PARTNER_URL = String(parameters.partner_url);
			
			if (parameters.fb_app_url && parameters.fb_app_url != "")
				configureFacebook(parameters);
			
			if (isStaging(S3_URL))
			{
				Services.ALT_SERVICES_URL = Services.SERVICES_URL;
				Services.FACEBOOK_APP_LINK_URL = "http://apps.facebook.com/socialvibeqa/link";
				Services.AD_URL = "http://sv1-stg.socialvibe.com.s3.amazonaws.com/";
			}
			else if (isDev(S3_URL))
			{
				Services.ALT_SERVICES_URL = Services.SERVICES_URL;
			}
			
			if (Security.sandboxType == Security.LOCAL_TRUSTED)
			{
				DEBUG = true;
			}
		}
		
		private static function configureFacebook(parameters:Object):void
		{
			FB_CONNECTION_NAME = parameters.flash_name;
			FACEBOOK_CANVAS_URL = parameters.fb_app_url;
			if (parameters.session_id && parameters.session_id != "")
				RemotingService.SESSION_ID = parameters.session_id;
			
			configureOAuth(S3_URL, CURRENT_APP_ID);
		}
		
		public static function configureOAuth(url:String, app_id:Number):void
		{
			CURRENT_APP_ID = app_id;
			
			if (isStaging(url))
			{
				OAUTH_CONSUMER_KEY	= app_id == BLOGGER_APP_ID ? BLOGGER_KEYS[1] : WORDPRESS_KEYS[1];
				OAUTH_CONSUMER_SECRET = app_id == BLOGGER_APP_ID ? BLOGGER_SECRETS[1] : WORDPRESS_SECRETS[1];
			}
			else if (isDev(url))
			{
				OAUTH_CONSUMER_KEY	= app_id == BLOGGER_APP_ID ? BLOGGER_KEYS[2] : WORDPRESS_KEYS[2];
				OAUTH_CONSUMER_SECRET = app_id == BLOGGER_APP_ID ? BLOGGER_SECRETS[2] : WORDPRESS_SECRETS[2];
			}
			else
			{
				OAUTH_CONSUMER_KEY	= app_id == BLOGGER_APP_ID ? BLOGGER_KEYS[0] : WORDPRESS_KEYS[0];
				OAUTH_CONSUMER_SECRET = app_id == BLOGGER_APP_ID ? BLOGGER_SECRETS[0] : WORDPRESS_SECRETS[0];
			}
		}
		
		public static function isStaging(url:String):Boolean
		{
			return (url.indexOf("media-stg") != -1 || url.indexOf("qa.media.socialvi.be") != -1);
		}
		
		public static function isDev(url:String):Boolean
		{
			return (url.indexOf("media_qa") != -1);
		}
	}
}