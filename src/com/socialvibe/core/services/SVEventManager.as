package com.socialvibe.core.services
{
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	
	import org.rubyamf.remoting.ssr.*;
	
	public class SVEventManager
	{
		private static var _instance : SVEventManager;
		private static var _loggedOut : Boolean;
		private static var _currOrigin : String;

		private var _inactivityTimer:Timer;
		private var _batchTimer:Timer;
		
		// event types
		public static const BRAND_I:int				= 1;
		public static const SPONSOR_PAGE_I:int		= 2;
		public static const SPONSOR_CONFIG_I:int	= 3;
		public static const SPONSOR_SELECT:int		= 4;
		public static const SPONSORSHIP_I:int		= 5;
		
		// origin types
		public static const STANDARD_TYPE:String	= 'standard';
		public static const FEATURED_TYPE:String	= 'featured';
		public static const HOMEPAGE_TYPE:String	= 'homepage';
		public static const SIGNUP_TYPE:String		= 'signup';
		public static const EDIT_TYPE:String		= 'edit';
		public static const USER_PROFILE_TYPE:String= 'user_profile';
		public static const OTHER_TYPE:String		= 'other';
		
		// external origin types
		public static const EXT_WORDPRESS_TYPE:String 	= 'wordpress';
		
		private var _brandICounter:Object;
		private var _sPageICounter:Object;
		private var _sConfigICounter:Object;
		private var _sSelectCounter:Object;
		private var _sponsorshipICounter:Object;
		
		public static function getInstance() : SVEventManager 
		{
			if ( _instance == null )
			{
				_instance = new SVEventManager();
			}

			return _instance;
  		}
  		
  		public static function set loggedOutMode(value:Boolean):void
  		{
  			_loggedOut = value;
  		}
  		
  		public function SVEventManager():void
  		{
  			initEventManager();
  		}
  		
  		private function initEventManager():void
      	{
      		_brandICounter 		= { 'standard':{}, 'featured':{}, 'homepage':{}, 'signup':{} };
      		_sPageICounter 		= { 'standard':{}, 'featured':{}, 'homepage':{}, 			  			 'other':{} };
      		_sConfigICounter 	= { 'standard':{}, 'featured':{}, 'homepage':{}, 'signup':{}, 'edit':{}, 'other':{} };
      		_sSelectCounter 	= { 'standard':{}, 'featured':{}, 'homepage':{}, 'signup':{}, 'edit':{}, 'other':{}, 'wordpress':{} };
      		_sponsorshipICounter= { 'user_profile':{} };
      		
      		_currOrigin = OTHER_TYPE;
      		
      		_inactivityTimer = new Timer(10000);  //check for inactivity every 10 seconds
			_inactivityTimer.addEventListener(TimerEvent.TIMER, batchHandler);
            _inactivityTimer.start();
      		
      		_batchTimer = new Timer(120000);  //send batch event every 2 mins
			_batchTimer.addEventListener(TimerEvent.TIMER, batchHandler);
            _batchTimer.start();
      	}
  		
      	private function batchHandler(e:TimerEvent):void
        {
        	flushEventsBatch();
        }
        
        public function throwEvent(type:int, origin:String, objectId:Number):void
		{
			if (_loggedOut) return;
			
			trace ('event thrown: ' + type + ' from ' + origin + ' for ' + objectId);
			switch (type)
			{
				case BRAND_I:
					_brandICounter[origin][objectId] = (_brandICounter[origin][objectId] ? _brandICounter[origin][objectId]+1 : 1);
					break;
				case SPONSOR_PAGE_I:
					_sPageICounter[origin][objectId] = (_sPageICounter[origin][objectId] ? _sPageICounter[origin][objectId]+1 : 1);
					break;
				case SPONSOR_CONFIG_I:
					_sConfigICounter[origin][objectId] = (_sConfigICounter[origin][objectId] ? _sConfigICounter[origin][objectId]+1 : 1);
					break;
				case SPONSOR_SELECT:
					_sSelectCounter[origin][objectId] = (_sSelectCounter[origin][objectId] ? _sSelectCounter[origin][objectId]+1 : 1);
					_currOrigin = OTHER_TYPE; //reset origin after selection
					break;
				case SPONSORSHIP_I:
					_sponsorshipICounter[origin][objectId] = (_sponsorshipICounter[origin][objectId] ? _sponsorshipICounter[origin][objectId]+1 : 1);
					break;
			}
			
			/*
			switch (type)
			{
				case BRAND_I:
					_brandICounter[objectId] = (_brandICounter[objectId] ? _brandICounter[objectId]+1 : 1);
					break;
				case OFFER_I:
					_offerICounter[objectId] = (_offerICounter[objectId] ? _offerICounter[objectId]+1 : 1);
					break;
				case CREATIVE_I:
					_creativeICounter[objectId] = (_creativeICounter[objectId] ? _creativeICounter[objectId]+1 : 1);
					break;
				case REWARD_I:
					_rewardICounter[objectId] = (_rewardICounter[objectId] ? _rewardICounter[objectId]+1 : 1);
					break;
			}
			*/
			
			_inactivityTimer.reset();
      		_inactivityTimer.start();
		}
		
		public function flushEventsBatch():void
		{
			var bundledEvents:Array = [];
			for (var origin:Object in _brandICounter)
			{
				for (var offerId:Object in _brandICounter[origin])
				{
				    bundledEvents.push( { 'etype':'sponsor_brand_impression', 'origin':origin, 'o_id':offerId, 'quantity':_brandICounter[origin][offerId] } );
				    delete _brandICounter[origin][offerId];
				}
			}
			
			for (origin in _sPageICounter)
			{
				for (offerId in _sPageICounter[origin])
				{
				    bundledEvents.push( { 'etype':'sponsor_page_impression', 'origin':origin, 'o_id':offerId, 'quantity':_sPageICounter[origin][offerId] } );
				    delete _sPageICounter[origin][offerId];
				}
			}
			
			for (origin in _sConfigICounter)
			{
				for (offerId in _sConfigICounter[origin])
				{
				    bundledEvents.push( { 'etype':'sponsor_configurator_impression', 'origin':origin, 'o_id':offerId, 'quantity':_sConfigICounter[origin][offerId] } );
				    delete _sConfigICounter[origin][offerId];
				}
			}
			
			for (origin in _sSelectCounter)
			{
				for (offerId in _sSelectCounter[origin])
				{
				    bundledEvents.push( { 'etype':'sponsor_selection', 'origin':origin, 'o_id':offerId, 'quantity':_sSelectCounter[origin][offerId] } );
				    delete _sSelectCounter[origin][offerId];
				}
			}
			
			for (origin in _sponsorshipICounter)
			{
				for (var sponsorshipId:Object in _sponsorshipICounter[origin])
				{
				    bundledEvents.push( { 'etype':'sponsorship_impression', 'origin':origin, 'o_id':sponsorshipId, 'quantity':_sponsorshipICounter[origin][sponsorshipId] } );
				    delete _sponsorshipICounter[origin][sponsorshipId];
				}
			}
			
			if (bundledEvents.length > 0)
			{
				ServiceLocator.getInstance().getService("EventsController").bundled_events
					([ {'bundle':bundledEvents} ], null, null);
			}
			
			if (_inactivityTimer != null)
				_inactivityTimer.stop();
		}
		
		public static function get currOrigin():String { return _currOrigin; }
		public static function set currOrigin(origin:String):void { _currOrigin = origin; }
	}
}