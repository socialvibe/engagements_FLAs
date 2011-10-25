package cc.utils
{
	
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Set of String Utilities
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 10.0.0
	 * 
	 * @author Carl Calderon (carl.calderon@gmail.com)
	 * @since  14.01.2011
	 */
	public class StringUtils
	{
		
		private static const EMAIL_REGEX : RegExp = /^[A-Z0-9._%+-]+@(?:[A-Z0-9-]+\.)+[A-Z]{2,4}$/i;
		
		/**
		 * Returns a well formated string represenation of the
		 * specified object and it's keys.
		 * 
		 * @return String	Beautiful string of object
		 */
		public static function formatToString(object:*,...keys):String
		{
			var nme:String 	= getQualifiedClassName(object);
				nme 		= nme.substr(nme.indexOf('::')+2);
			var str:String 	= '['+nme;
			for (var i:int = 0; i < keys.length; i++)
			{
				try
				{
					str += ' '+keys[i]+'='+object[keys[i]];
				}
				catch(e:Error) { }
				
			}
			return str+']';
		}
		
		/**
		 * Returns true if the specified string is a URL.
		 * Match is made agains "://" and whitespace.
		 * 
		 * @return Boolean	Validation result
		 */
		public static function isURL(string:String):Boolean
		{
			var s:Boolean = string.match(/\w/mgi).length > 0;
			if(!s)
				s = string.match(/(:\/\/{0,3})/mgi).length > 0
			return s;
		}
		
		/**
		 * Validates the specified email address.
		 * 
		 * @return Boolean	Validation result
		 */
		public static function isValidEmail(string:String):Boolean
		{
			return Boolean(string.match(EMAIL_REGEX));
		}
		
		/**
		 * Validates multiple email addresses.
		 * 
		 * @return Boolean	Validation result
		 */
		public static function isValidEmailList(array:Array):Boolean
		{
			for each (var email:String in array)
			{
				if(!isValidEmail(email))
					return false;
			}
			return true;
		}
		
		/**
		 * Validates a string
		 * 
		 * @return Boolean	Validation result
		 */
		public static function isValidString(string:String,defaultText:String,minimumChars:int=-1,maximumChars:int=-1):Boolean
		{
			if(string==defaultText)								return false;
			if(minimumChars>-1 && string.length<minimumChars)	return false;
			if(maximumChars>-1 && string.length>maximumChars)	return false;
			return true;
		}

	}
	
	
}