package com.socialvibe.core.utils
{
	import flash.events.Event;

	public class SVEvent extends Event
	{
		public static const CHANGE_PAGE_HEIGHT:String		= "changePageHeight";
		
		public var data:Object;
	
	    public function SVEvent(type:String,
	    						value:Object = null,
	                            bubbles:Boolean = false,
	                            cancelable:Boolean = false)
	    {
	        super(type, bubbles, cancelable);
	        data = value;
	    }
	}
}