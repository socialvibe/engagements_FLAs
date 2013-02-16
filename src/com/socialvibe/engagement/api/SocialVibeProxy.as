package com.socialvibe.engagement.api
{
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import flash.utils.setTimeout;
	
	/**
	 * The SocialVibeProxy class exposes all necessary functionality for an engagement to communicate with
	 * SocialVibe's servers, interact with the surrounding engagement container, tracking user interactions,
	 * and access utility functions such as popping up external pages.  The proxy
	 * acts as an intermediary between the engagement and the engagement API.
	 * 
	 */
	dynamic public class SocialVibeProxy extends Proxy
	{
		private var _unconnectedMode:Boolean = true;
		
		private var EngagemantAPI:Class;
		private var EngagemantAPI_instance:*;
		
		private var FILE_NAME_SPACE:String = "com.socialvibe.engagement.EngagementAPI";
		
		/**
		 * Creates a new SocialVibeProxy instance.
		 * 
		 */
		public function SocialVibeProxy()
		{
			connect();
		}
		
		private function connect():void
		{
			var domain:ApplicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
			
			try {
				EngagemantAPI = (ApplicationDomain.currentDomain.getDefinition(FILE_NAME_SPACE) as Class);
				
				EngagemantAPI_instance = EngagemantAPI['getInstance']();
				
				if (EngagemantAPI_instance)
				{
					EngagemantAPI_instance.startEngage();
					_unconnectedMode = false;
					
					trace ("SocialVibeProxy::API Connected");
				}
			}
			catch (e:Error)
			{
				_unconnectedMode = true;
				
				// retry to connect to API //
				setTimeout(connect, 500);
			}
		}
		
		/**
		 * Indicates whether the proxy is connected to SocialVibe's engagement API.  A value of 'true' means the proxy is not connected.
		 * This is case when running locally outside of the SocialVibe engagement container.
		 *
		 **/
		public function get unconnectedMode():Boolean
		{
			return _unconnectedMode;
		}
		
		
		/**
		 * Signals the completion event for the engagement.  The completion event tells our 
		 * system to grant the user the appropriate user benefit (i.e. Farm Cash on FarmVille).
		 * 
		 * This is a required API call.
		 * 
		 * @param onComplete the callback function that gets called when the user benefit is credited.
		 * 
		 **/
		public function engage(onComplete:Function = null):void
		{
			if (_unconnectedMode)
			{
				trace ("SocialVibeProxy::engage()");
				if (onComplete != null)
				{
					setTimeout(onComplete, 1000);
				}
			}
			else
			{
				EngagemantAPI_instance.engage(onComplete);
			}
		}
		
		/**
		 * Signals the end of the engagement.  This function unloads the engagement creative from
		 * the container and displays to the user a "Congrats &amp; Share" screen.  This function must 
		 * be called after the call to engage().
		 * 
		 * This is a required API call.
		 * 
		 **/
		public function endEngage():void
		{
			if (_unconnectedMode)
				trace ("SocialVibeProxy::endEngage() - Congrats & Share screen should show now.");
			else
				EngagemantAPI_instance.endEngage();
		}
		
		
		/* =================================
		   DATA API
		================================= */
		
		/**
		 * Saves comment data made by the user.  Upon completion of the engagement (i.e. when engage() is called), this comment data
		 * is saved to our system.
		 * 
		 * @param comment a user inputed string of any length.
		 * @param label an identifier for the data (i.e. 'email', 'answer1', etc).
		 *
		 **/
		public function saveCommentData(comment:String, label:String = null):void
		{
			if (_unconnectedMode)
				trace ("SocialVibeProxy::saveCommentData(" + comment + ", " + label + ")");
			else
				EngagemantAPI_instance.saveCommentData(comment, label);
		}
		
		/**
		 * Saves vote data made by the user.  Upon completion of the engagement (i.e. when engage() is called), this vote data
		 * is saved to our system.
		 * 
		 * @param category a number representing the index of the question the user is answering (typically '1' for the first question, '2' for the second question).
		 * @param label a string representation of the answer choice (typically the actual answer choice text).
		 * @param vote a numerical representation of the answer choice.  This number must be unique across all answer choices and all question categories.  For example, 
		 * for a 2-question poll with 4 answer options for each question, the vote value for the first answer on the first question is typically '1' and the first 
		 * answer on the second question is typically '5'.
		 *
		 **/
		public function saveVoteData(category:Number, label:String, vote:Number):void
		{
			if (_unconnectedMode)
				trace ("SocialVibeProxy::saveVoteData(" + category + ", " + label + ", " + vote + ")");
			else
				EngagemantAPI_instance.saveVoteData(category, label, vote);
		}
		
		/**
		 * Retrieves the last 5 comments made by users who have completed this engagement.  Note: there is a 15 minute cache delay on the data.
		 * The structure of the comment data returned is an array of objects with a 'body' and 'ago' fields, like so:
		 * {body:"COMMENT_TEXT", ago:"31 minutes ago"}
		 * 
		 * @return an Array of comment data Objects. 
		 **/
		public function getRecentComments():Array
		{
			if (_unconnectedMode)
			{
				trace ("SocialVibeProxy::getRecentComments()");
				
				// returns placeholder comments //
				return [{body:"last comment text", ago:"31 minutes ago"}, {body:"2nd to last comment text", ago:"36 minutes ago"}, {body:"3rd comment text", ago:"56 minutes ago"}, {body:"4th comment text", ago:"1 hour ago"}, {body:"5th comment text", ago:"2 hours ago"}];
			}
			
			return EngagemantAPI_instance.getRecentComments();
		}
		
		/**
		 * Retrieves all vote data of users who have completed this engagement.  Note: there is a 15 minute cache delay on the data.
		 * The structure of the vote data returned is an array of Objects with a 'category', 'vote', 'label', and 'vote_count' fields, like so:
		 * {category:"1", label:"FIRST ANSWER CHOICE FROM THE FIRST QUESTION", vote:"1", vote_count:"25023"}
		 * 
		 * @return an Array of vote data Objects. 
		 **/
		public function getVoteSummary():Array
		{
			if (_unconnectedMode)
			{
				trace ("SocialVibeProxy::getRecentComments()");
				
				// returns placeholder values for a single question poll with 4 answer choices //
				return [
					{category:"1", label:"First answer choice from first question", vote:"1", vote_count:"25023"}, 
					{category:"1", label:"Second answer choice from first question", vote:"2", vote_count:"18652"}, 
					{category:"1", label:"Third answer choice from first question", vote:"3", vote_count:"15684"}, 
					{category:"1", label:"Fourth answer choice from first question", vote:"4", vote_count:"1568"}
				];
			}
			
			return EngagemantAPI_instance.getVoteSummary();
		}
		
		
		/* =================================
		   CONTAINER API
		================================= */
		
		/**
		 *  Indicates the width of the engagement, in pixels.
		 *
		 **/
		public function get engagement_width():Number
		{
			if (_unconnectedMode)
				return 750;
			else
				return EngagemantAPI_instance.engagement_width;
		}
		
		/**
		 *  Indicates the height of the engagement, in pixels.
		 *
		 **/
		public function get engagement_height():Number
		{
			if (_unconnectedMode)
				return 500;
			else
				return EngagemantAPI_instance.engagement_height;
		}
		
		/**
		 *  Returns the partner ID hash, which is unique to each partner.
		 *
		 **/
		public function get partner_id_hash():String
		{
			if (_unconnectedMode)
				return '';
			else
				return EngagemantAPI_instance.partner_id_hash;
		}
		
		/**
		 *  Returns the amount of the currency granted to the user for completing the engagement.
		 *
		 **/
		public function get currency_amount():Number
		{
			if (_unconnectedMode)
				return 2;
			else
				return EngagemantAPI_instance.currency_amount;
		}
		
		/**
		 *  Returns the name of the currency granted to the user for completing the engagement (i.e. 'Farm Cash').
		 *
		 **/
		public function get currency_label():String
		{
			if (_unconnectedMode)
				return 'Game Cash';
			else
				return EngagemantAPI_instance.currency_label;
		}
		
		/**
		 *  Closes the entire engagement container.  This function is uncommonly used.
		 *
		 **/
		public function closeEngagement():void
		{
			if (_unconnectedMode)
				trace ("SocialVibeProxy::closeEngagement()");
			else
				EngagemantAPI_instance.closeEngagement();
		}
		
		
		/* =================================
		   EXTERNAL API
		================================= */
		
		/**
		 * Opens an external browser window from the engagement.  The URL click interaction is also tracked when this is called.
		 *
		 * @param url the full URL path of the website.  If none is specified, uses the CLICK_TAG.
		 * @param type the type of window to open URL in. Possible values: 'popup', 'popunder', or 'tab'.  Default: 'popup'.
		 * @param width the width of the popup window, in pixels.  Default: 1024 pixels.
		 * @param height the height of the popup window, in pixels.  Default: 800 pixels.
		 * 
		 **/
		public function popupWebsite(url:String = null, type:String = 'popup', width:Number = 1024, height:Number = 800):void
		{
			if (_unconnectedMode)
				trace ("SocialVibeProxy::popupWebsite(" + url + ", " + type + ", " + width + ", " + height + ")");
			else
				EngagemantAPI_instance.popupWebsite(url, type, width, height);
		}
		
		
		/* =================================
		   TRACKING API
		================================= */
		
		/**
		 * Loads a given tracking image pixel URL.
		 * 
		 * @param pixel_url the full URL path to an image pixel.
		 * @param add_timestamp a flag indicating whether or not to add a cache-busting timestamp to the end of the URL.  The default is false.
		 *
		 **/
		public function loadExternalTracking(pixel_url:String, add_timestamp:Boolean = false):void
		{
			if (_unconnectedMode)
				trace ("SocialVibeProxy::loadExternalTracking(" + pixel_url + ", " + add_timestamp + ")");
			else
				EngagemantAPI_instance.loadExternalTracking(pixel_url, add_timestamp);
		}
		
		/**
		 * Tracks a single user interaction.
		 * 
		 * @param category a label that is used in reports to identify the category of this user interaction (i.e. 'map').
		 * @param name a label that is used in reports to identify this user interaction within a category (i.e. 'search').
		 * @param value another label that is used in reports to further identify this interaction (i.e. 'Los Angeles, CA').
		 *
		 **/
		public function trackInteraction(category:String, name:String, value:Object = null):void
		{
			if (_unconnectedMode)
				trace ("SocialVibeProxy::trackInteraction(" + category + ", " + name + ", " + value + ")");
			else
				EngagemantAPI_instance.trackInteraction(category, name, value);
		}
		
		/**
		 * Tracks an aggregate form of user interactions.  A use-case for this is when sometime might generate many integrations, like a game,
		 * and you just want to track how many times a user interacts within the game.
		 * 
		 * @param name a label that is used in reports to identify the type of aggregate interaction (i.e. 'game jumps').
		 * @param interaction_count the total count of user interactions for this aggregate interaction.
		 *
		 **/
		public function trackAggregateInteraction(name:String, interaction_count:Number):void
		{
			if (_unconnectedMode)
				trace ("SocialVibeProxy::trackAggregateInteraction(" + name + ", " + interaction_count + ")");
			else
				EngagemantAPI_instance.trackAggregateInteraction(name, interaction_count);
		}
		
		/**
		 * Proxys all other method calls to the API.
		 * 
		 * @param methodName The name of the method being invoked.
		 * @param ... args arguments to pass to the called method.
		 *
		 **/
		override flash_proxy function callProperty(methodName:*, ... args):*
		{
			try {
				
				if (_unconnectedMode)
					trace ("SocialVibeProxy::" + methodName + "(" + args.join(', ') + ")");
				else
					EngagemantAPI_instance[methodName].apply(EngagemantAPI_instance, args);
				
			} catch (e:Error) {
				trace ("SocialVibeProxy::" + e);
			}
		}
	}
}