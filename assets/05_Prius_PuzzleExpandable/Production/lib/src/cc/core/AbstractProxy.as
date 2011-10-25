package cc.core
{
	import cc.utils.StringUtils;
	import flash.events.EventDispatcher;
	
	/**
	 * AbstractProxy
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 10.0.0
	 * 
	 * @author Carl Calderon (carl.calderon@gmail.com)
	 * @since  14.01.2011
	 */
	public class AbstractProxy extends EventDispatcher
	{
	
////////////////////////////////////////////////////////
//
//	Constructor
//
////////////////////////////////////////////////////////
			
		/**
		 * @constructor
		 * Basic Proxy setup. (empty)
		 */
		public function AbstractProxy()
		{
			super(); 
		}

////////////////////////////////////////////////////////
//
//	Getter Setter
//
////////////////////////////////////////////////////////
			
		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			return StringUtils.formatToString(this);
		}
	
	}

}