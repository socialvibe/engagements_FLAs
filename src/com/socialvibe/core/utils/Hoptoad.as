package com.socialvibe.core.utils
{
	import com.socialvibe.core.config.Services;
	
	import flash.display.*;
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.net.*;
	import flash.system.Capabilities;
	import flash.system.Security;
	
	import org.rubyamf.remoting.ssr.RemotingService;
	
	public class Hoptoad
	{
		public static const API_VERSION : String = '2.0';
		public static const API_KEY : String = '675fb6cb9521e3a0f1bcc31c2922a6a1'; // this is a secret key for SocialVibe -- share accordingly!
		
		public static const NOTIFIER_NAME : String = 'SVAS3Hoptoad';
		public static const NOTIFIER_VERSION : String = '2.1.0';
		public static const NOTIFIER_URL : String = 'http://www.svnetwork.com';		
		
		public function Hoptoad(singletonEnforcer:SingletonEnforcer) {
		}
		
		
		/* =================================
			Public functions
		================================= */
		public static function initializeGlobalErrorHandling(caller:DisplayObject):void
		{
			if( caller.loaderInfo.hasOwnProperty("uncaughtErrorEvents") ){
				IEventDispatcher(caller.loaderInfo["uncaughtErrorEvents"]).addEventListener("uncaughtError", globalErrorHandler);
			}
		}
		
		public static function addErrorHandlingToLoadedAsset(loader:Loader, assetUrl:String = 'Unknown'):void
		{
			if( loader.hasOwnProperty("uncaughtErrorEvents") ){					
				IEventDispatcher(loader["uncaughtErrorEvents"]).addEventListener("uncaughtError", globalErrorHandlerGenerator(getAssetNameFromUrl(assetUrl)) );
			}
		}
		
		public static function sendToHoptoad (msg:String, errorLocation:String = 'Internal', action:String = 'Unknown', infoHash:Object = null, frequency:Number = 0.05):void
		{
			if(Security.sandboxType == Security.LOCAL_TRUSTED) {
				throw new Error('Error caught in Hoptoad');
				return;	
			}
			
			if ( stifleError(frequency) ) return;
			notifyHoptoad( msg, "Error", errorLocation, action, infoHash, null);
		}
		
		public static function sendErrorToHoptoad(e:Error, errorLocation:String = 'Internal', action:String = 'Unknown', infoHash:Object = null, frequency:Number = 0.05):void
		{			
			if(Security.sandboxType == Security.LOCAL_TRUSTED){
				throw e;
				return;
			}
			
			if ( stifleError(frequency, e) ) return;
			notifyHoptoad( e.message, e.name, errorLocation, action, infoHash, e);
		}
		
		
		/* =================================
			Internal functions
		================================= */
		protected static function globalErrorHandler(errorEvent:Event):void {			
			var caughtError:Error = errorEvent['error'] as Error;
			
			if (caughtError != null)
				sendErrorToHoptoad( caughtError, 'SVShell', 'GlobalErrorHandler', null, 0.01);
		}
		
		protected static function globalErrorHandlerGenerator(assetName:String = 'UnknownModule'):Function {	
			
			return function(errorEvent:Event):void {
				var caughtError:Error = errorEvent['error'] as Error;
				
				if (caughtError != null)
					sendErrorToHoptoad( caughtError, assetName, 'GlobalErrorHandler', null, 0.01);				
			}
		}
		
		protected static function notifyHoptoad(errorMessage:String = '', errorClass:String = '', errorLocation:String = '', errorAction:String = '', infoHash:Object = null, error:Error = null):void
		{
			if( Security.sandboxType == Security.LOCAL_TRUSTED || Services.S3_URL.indexOf('media_qa.socialvibe.com') >= 0){
				trace("Hoptoad Error caught, not sent because being run locally");
				throw new Error( errorMessage );
				return;
			}
			
			
			// initialize xml object
			var xmlData:XML = <notice version={API_VERSION}></notice>;
			xmlData['api-key'] = API_KEY;
			xmlData.notifier.name = NOTIFIER_NAME;
			xmlData.notifier.version = NOTIFIER_VERSION;
			xmlData.notifier.url = NOTIFIER_URL;
			
			
			// parse backtrace for more info, and add it to XML
			var accurateClassAndMethod:Array = addBacktraceData(xmlData, error);
						
			// determine whether or not to use backtrace data
			if ( errorLocation == 'Internal' || errorAction == 'GlobalErrorHandler' || errorAction == 'Unknown' )
			{
				errorLocation = accurateClassAndMethod[0] || errorLocation;
				errorAction = accurateClassAndMethod[1] || errorAction;
			}
			
			
			// add rest of the data
			addRequestData(xmlData, errorMessage, errorClass, errorLocation, errorAction, infoHash);
			addSessionData(xmlData);
			addEnvironmentData(xmlData);
			
			trace( xmlData.toXMLString() );
			
			var req:URLRequest = new URLRequest("http://hoptoadapp.com/notifier_api/v2/notices");
			req.method = URLRequestMethod.POST;
			req.data = xmlData;
			req.contentType = "text/xml";
			
			var loader:URLLoader = new URLLoader(req);
			
			loader.addEventListener(Event.COMPLETE, function (e:Event):void {
				trace("Error tracker response: " + (URLLoader(e.target).data));
			});
			
			loader.addEventListener(IOErrorEvent.IO_ERROR, function (e:IOErrorEvent):void {
				trace("Failed to send error report. Failure message: " + e);
			});
			
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, function (e:HTTPStatusEvent):void {
				trace("HTTP Status: " + e);
			});
			
			loader.load(req);			
			
		}
		
		protected static function addRequestData( x:XML, errorMessage:String = '', errorClass:String = '', errorLocation:String = "Internal", action:String = "Unknown", infoHash:Object = null):void
		{
			x.error['class'] = errorClass;
			x.error['message'] = errorMessage;
			
			x.request.action = action;
			x.request.component = errorLocation;
			
			if (infoHash) {
				var i:int = 0;
				for(var key:String in infoHash){
					x.request.params['var'][i++] = generateVar( key, infoHash[key] ? infoHash[key].toString() : null );
				}
			}
		}
		
		protected static function addEnvironmentData( x:XML ) :void
		{
			// set environment name
			if ( Services.S3_URL && (Services.S3_URL.indexOf('media.socialvibe.com') >= 0 || Services.S3_URL.indexOf('media.socialvi.be') >= 0 ) )
				x['server-environment']['environment-name'] = 'production';
			else if ( Services.S3_URL && (Services.S3_URL.indexOf('media-stg.socialvibe.com') >= 0 || Services.S3_URL.indexOf('qa.media.socialvi.be') >= 0) )
				x['server-environment']['environment-name'] = 'staging';
			else
				x['server-environment']['environment-name'] = 'unknown';

			var i:int = 0;
			
			x.request.url = ExternalInterface.call('window.location.href.toString');
			x.request['cgi-data']['var'][i++] = generateVar( "USER_AGENT", ExternalInterface.call('window.navigator.userAgent.toString') );
			x.request['cgi-data']['var'][i++] = generateVar( "FLASH_VERSION", Capabilities.version );
			x.request['cgi-data']['var'][i++] = generateVar( "FLASH_DEBUGGER", Capabilities.isDebugger.toString() );
			x.request['cgi-data']['var'][i++] = generateVar( "PAGE_PLATFORM", ExternalInterface.call('window.navigator.platform.toString') );
//			x.request['cgi-data']['var'][i++] = generateVar( "referrer", ExternalInterface.call('window.document.referrer.toString') );
			x.request['cgi-data']['var'][i++] = generateVar( "previous_page", ExternalInterface.call('window.history.previous.toString') );
			x.request['cgi-data']['var'][i++] = generateVar( "services_version", Services.VERSION_NUM );
			x.request['cgi-data']['var'][i++] = generateVar( "services_current_app_id", Services.CURRENT_APP_ID.toString() );
			x.request['cgi-data']['var'][i++] = generateVar( "services_services_url", Services.SERVICES_URL );			
			x.request['cgi-data']['var'][i++] = generateVar( "services_s3_url", Services.S3_URL );			
			
			
			if (Services.CURRENT_APP_ID == Services.FB_APP_ID)
				x.request['cgi-data']['var'][i++] = generateVar( "services_facebook_canvas_url", Services.FACEBOOK_CANVAS_URL );			

			if (RemotingService.CURRENT_USER_ID)
				x.request['cgi-data']['var'][i++] = generateVar( "CURRENT_USER_ID", RemotingService.CURRENT_USER_ID.toString() );			

			if (RemotingService.SESSION_ID)
				x.request['cgi-data']['var'][i++] = generateVar( "SESSION_ID", RemotingService.SESSION_ID.toString() );			
				
		}
		
		protected static function addSessionData( x:XML ) :void
		{
			var i:int = 0;
			
			if (RemotingService.CURRENT_USER_ID) {
				x.request.session['var'][i++] = generateVar( 'CURRENT_USER_ID', RemotingService.CURRENT_USER_ID.toString() );
			}
			
			if (RemotingService.SESSION_ID) {
				x.request.session['var'][i++] = generateVar( 'SESSION_ID', RemotingService.SESSION_ID.toString() );
			}			
		}
		
		protected static function addBacktraceData( x:XML, e:Error = null ):Array
		{
			var i:int = 0;
			var error:Error = e || new Error();
			
			// these are the programmer created files and methods that cause the error,
			// as opposed to the specific system file/function that raised the error
			var actualErroringMethod:String = '';
			var actualErroringClass:String = '';

			
			if ( error.getStackTrace() )
			{
				try
				{
					var backTrace:Array = error.getStackTrace().split("\n");
					
					for (var j:Number= e ? 1 : 4; j<backTrace.length; j++) {
						var line:String = backTrace[j] as String;
						
						var method:String = 'Unknown';
						var file:String = 'Unknown';
						var klass:String = 'Unknown';
						var lineNumber:Number = 0;
	
						var matchResult:Array;
						var matchedString:String = '';
	
						// match method
						matchResult	= line.match(/at ([a-zA-Z0-9\s.:\/<>]+) \(\)/gxm );
						if (matchResult) {
							matchedString = matchResult[0] as String;
							method = matchedString.substring( 3, matchedString.length );
							klass = (matchedString.substring( 3, matchedString.length ).split('/').shift() as String).split('::').pop();
						}
						
						// match file and line number
						matchResult	= line.match(/\[.+:.+]/g );
						if (matchResult && matchResult.length > 0) {
							matchedString = (matchResult[0] as String);
							matchedString = matchedString.substring( 1, matchedString.length-1 );
							file = matchedString.split(':')[0];
							lineNumber = int(matchedString.split(':')[1]);
							
							actualErroringMethod ||= method.split('/').pop();
							actualErroringClass ||= klass;
						}
						
						x.error.backtrace.line[i++] = generateLine( method, file, lineNumber );
					}
				}
				catch ( e:Error )
				{
					x.error.backtrace.line[i++] = generateLine( 'Unknown', 'Unknown', 0 );						
				}
			}
			else
			{
				x.error.backtrace.line[i++] = generateLine( 'Unknown', 'Unknown', 0 );
			}			
			
			return [actualErroringClass, actualErroringMethod];
		}
		

		
		/* =================================
			Utility functions
		================================= */
		protected static function stifleError(errorFrequencyThreshold:Number, error:Error = null ):Boolean
		{
			if ( Services.S3_URL && (Services.S3_URL.indexOf('media.socialvibe.com') >= 0 || Services.S3_URL.indexOf('media.socialvi.be') >= 0 ) )
			{
				if ( (Capabilities.isDebugger && error) || Math.random() <= errorFrequencyThreshold )
					return false;
				else
					return true;
			}
			
			return false;
		}
		
		protected static function generateVar( key:String, value:String ):XML
		{
			return <var key={key}>{value}</var>;
		}
		
		protected static function generateLine( method:String, file:String, number:Number ):XML
		{
			return <line method={method} file={file} number={number} />;
		}		
		
		protected static function getAssetNameFromUrl( assetUrl:String ):String
		{
			var assetName:String = assetUrl.split('/').pop();
			assetName = assetName.split( '?' ).shift();
			assetName = assetName.split( '.' ).shift();
			return assetName;
		}
	}
}

class SingletonEnforcer{}