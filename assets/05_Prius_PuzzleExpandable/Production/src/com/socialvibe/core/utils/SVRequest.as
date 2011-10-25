package com.socialvibe.core.utils
{
	import flash.display.DisplayObject;
	
	public class SVRequest extends SVEvent
	{
		public var callback:Function;
		public var requester:DisplayObject;
		
		public function SVRequest(type:String, value:Object=null, callback:Function=null, requester:DisplayObject=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, value, bubbles, cancelable);
			
			this.callback = callback;
			this.requester = requester;
		}
	}
}