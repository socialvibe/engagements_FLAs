package com.socialvibe.core.config
{
	public class UserPreferences
	{
		private static const SHOW_WELCOME_BOX:int		= 2;
		private static const SURVEY_USER:int			= 4;
		private static const LIST_DISPLAY_MODE:int		= 8;
		
		public static function isWelcomeBoxShown(user:Object):Boolean
		{
			return ((user.preferences_mask & SHOW_WELCOME_BOX) == SHOW_WELCOME_BOX);
		}
		
		public static function setWelcomeBoxShown(user:Object, on:Boolean):void
		{
			togglePref(SHOW_WELCOME_BOX, user, on);
		}
		
		public static function isSurveyUser(user:Object):Boolean
		{
			return ((user.preferences_mask & SURVEY_USER) == SURVEY_USER);
		}
		
		public static function setSurveyUser(user:Object, on:Boolean):void
		{
			togglePref(SURVEY_USER, user, on);
		}
		
		public static function isListDisplayMode(user:Object):Boolean
		{
			return ((user.preferences_mask & LIST_DISPLAY_MODE) == LIST_DISPLAY_MODE);
		}
		
		public static function setListDisplayMode(user:Object, on:Boolean):void
		{
			togglePref(LIST_DISPLAY_MODE, user, on);
		}
		
		private static function togglePref(pref:int, user:Object, on:Boolean):void
		{
			if (on)
				user.preferences_mask |= pref;
			else
				user.preferences_mask &= ~pref;
		}
	}
}