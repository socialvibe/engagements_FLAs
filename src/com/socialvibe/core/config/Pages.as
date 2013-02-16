package com.socialvibe.core.config
{
	public class Pages
	{
		public static const HOME:String						= "/home/";
		public static const LOGIN:String					= "/login/";
		public static const SIGNUP:String					= "/signup/";
		public static const SIGNUP_SUCCESS:String			= "/youre_in/";
		
		public static const DASH:String						= "/dashboard/";
		public static const CAUSES:String					= "/causes/";
		public static const SPONSORS:String					= "/sponsors/";
		public static const USERS:String					= "/app_users/";
		public static const PHOTOS:String					= "/photos/";
		public static const MESSAGES:String					= "/messages/";
		public static const FRIEND_REQUESTS:String			= "/friend_requests/";
		public static const DISCUSS:String					= "/discuss/";
		public static const ABOUT:String					= "/about/";
		public static const PLATINUM_SURVEY:String			= "/platinum_survey/";
		public static const CONFIGURE_SPONSOR:String		= "/configure_sponsor/";
		public static const EDIT_SPONSORSHIP:String			= "/edit_sponsorship/";
		public static const GET_CODE:String					= "/get_code/";
		public static const MY_SPONSORS:String				= "/my_sponsors/";
		public static const CHOOSE_SPONSOR:String			= "/choose_sponsor/";
		public static const SETTINGS:String					= "/settings/";
		public static const GIVE_FEEDBACK:String			= "/give_feedback/";
		public static const INVITE_FRIENDS:String			= "/invite_friends/";
		public static const MISSING_RECRUIT:String			= "/missing_recruit/";
		public static const INFO_DIALOG:String				= "/dialog/";
		public static const REPORT_ABUSE:String				= "/report_abuse/";
		
		public static const MY_FEED:String					= "/my_feed/";
		public static const MY_FRIENDS:String				= "/my_friends/";
		public static const MY_POINT_HISTORY:String			= "/my_point_history/";
		
		public static const PROFILE:String					= "/profile/";
		public static const USER_FRIENDS:String				= "/member_friends/";
		
		public static const BADGE_PREVIEW_DIALOG:String		= "/sponsorship_preview/";
		
		public static const ABOUT_US:String					= "/about_us/";
		public static const CONTACT_US:String				= "/contact_us/";
		public static const BECOME_A_SPONSOR:String			= "/become_a_sponsor/";
		public static const PRIVACY_POLICY:String			= "/privacy_policy/";
		public static const TERMS_OF_SERVICE:String			= "/terms_of_service/";
		public static const PROMOTION_TERMS:String			= "/promotion_terms/";
		public static const FAQ:String						= "/faq/";
		
		public static const ABOUT_THE_BADGE:String			= "/about_the_badge/";
		public static const ABOUT_PERKS:String				= "/about_perks/";
		public static const ABOUT_TEAM:String				= "/about_the_team/";
		public static const ABOUT_PARTNERS:String			= "/about_partners/";
		public static const ABOUT_PRESS:String				= "/about_press/";
		public static const ABOUT_LEGAL:String				= "/about_legal/";
		
		public static const MODULES:Object = { "home":"com/socialvibe/modules/HomeModule.swf",
											   "dash":"com/socialvibe/modules/DashboardModule.swf",
											   "browse":"com/socialvibe/modules/BrowsingModule.swf",
											   "sponsor":"com/socialvibe/modules/SponsorProfileModule.swf",
											   "cause":"com/socialvibe/modules/CauseProfileModule.swf",
											   "discuss":"com/socialvibe/modules/DiscussionBoardModule.swf",
											   "about":"com/socialvibe/modules/AboutUsModule.swf",
											   "user":"com/socialvibe/modules/UserProfileModule.swf",
											   "survey":"com/socialvibe/modules/SurveyModule.swf",
											   "setting":"com/socialvibe/modules/AccountSettingsModule.swf",
											   "config":"com/socialvibe/modules/ConfiguratorModule.swf",
											   "invite":"com/socialvibe/modules/InviteModule.swf" }
		
		//public static const MAIN_PAGE:Object = { "/my_sponsors/":0, "/choose_sponsor/":1, "/users/":2, "/causes/":3, "/discuss/":4 };
	}
}