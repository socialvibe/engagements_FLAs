package com.socialvibe.core.services
{
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.utils.*;
	
	import org.rubyamf.remoting.ssr.*;
	
	public class SVEventTracker
	{
		public static const TRACK_EVENT:String = 'trackEvent';
		
		private static var _instance : SVEventTracker;
		
		public static function getInstance() : SVEventTracker 
		{
			if ( _instance == null )
			{
				_instance = new SVEventTracker();
			}

			return _instance;
  		}
  		
  		public function SVEventTracker():void { }
        
        public function throwEvent(gid:Object = null, app_id:Number = 0, category:String = null, label:String = null, value:Object = null, bucket:String = null, secondary_bucket:String = null):void
		{
			if (Security.sandboxType == Security.LOCAL_TRUSTED)
				return;
			
			var params:Object = {'app_id':app_id};
			
			if (gid != null)
				params['gid'] = gid;
			if (category != null)
				params['category'] = category;
			if (label != null)
				params['label'] = label;
			if (value != null)
				params['value'] = value;
			if (bucket != null)
				params['bucket'] = bucket;
			if (secondary_bucket != null)
				params['secondary_bucket'] = secondary_bucket;
			
			ServiceLocator.getInstance().getService("EventsController").tracking_event
				([ params ], null, null);
		}
	}
}