package cc.errors
{

	/**
	 * Basic Error class of cc framework
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 10.0.0
	 * 
	 * @author Carl Calderon (carl.calderon@gmail.com)
	 * @since  14.01.2011
	 */
	public class CCError extends Error
	{
		
		/**
		 * Singleton error message
		 * 
		 * @return error
		 */
		public static function SINGLETON():CCError
		{
			return new CCError('Class is singleton. Multiple instances are forbidden.');
		}
		
		/**
		 * Range error message
		 * 
		 * @param from	Number
		 * @param to	Number
		 * @return error
		 */
		public static function RANGE(from:Number=0,to:Number=1):CCError
		{
			return new CCError('Requested index is out of range ('+from+'..'+to+'). ');
		}
		
		/**
		 * Not found error
		 * 
		 * @param what What was not found?
		 * @return error
		 */
		public static function NOT_FOUND(what:String='the item you where looking for'):CCError
		{
			return new CCError('Could not find '+what+'.');
		}
		
		/**
		 * Crash error
		 * 
		 * @see #INFINITY()
		 * @param reason	String	What caused the crash?
		 * @return error
		 */
		public static function CRASH(reason:String):CCError
		{
			return new CCError('Crash. Reason: ' + reason);
		}
		
		/**
		 * Infinity error
		 * 
		 * @return error
		 */
		public static function INFINITY():CCError
		{
			return new CCError('Unhandled infinity. Forced interrupt performed.');
		}
				
		/**
		 * @constructor
		 * Constructs a new CCError object
		 * @param message Error message
		 */
		public function CCError(message:String)
		{
			super(message);
			name = 'CCError';
		}
	
	}

}

