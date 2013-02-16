package com.socialvibe.core.services
{
	import com.socialvibe.core.config.Services;
	
	import org.rubyamf.remoting.ssr.*;
	
	public class ServiceLocator
	{
		private static var _instance : ServiceLocator;
		private static var _gatewayConnectionPool : Object;
		
		public static function getInstance() : ServiceLocator 
		{
			if ( _instance == null )
			{
				_instance = new ServiceLocator();
			}

			return _instance;
  		}
  		
  		public function ServiceLocator():void
  		{
  			_gatewayConnectionPool = {};
			
			RemotingService.DEBUG = Services.DEBUG;
  		}
  		
  		public function getService( serviceController : String, useAlternate : Boolean = false ) : RemotingService
      	{
      		if (_gatewayConnectionPool[serviceController] != undefined)
      		{
      			return _gatewayConnectionPool[serviceController] as RemotingService;
      		}
      		
         	return createRemotingService(useAlternate ? Services.ALT_SERVICES_URL : Services.SERVICES_URL, serviceController);
      	}
		public function getPartnerService( serviceController : String ) : RemotingService
		{
			if (_gatewayConnectionPool[serviceController] != undefined)
			{
				return _gatewayConnectionPool[serviceController] as RemotingService;
			}
			
			return createRemotingService(Services.PARTNER_URL, serviceController);
		}
		private function createRemotingService( serviceURL : String, serviceController : String ) : RemotingService
		{
			var newService:RemotingService = new RemotingService(serviceURL + "/rubyamf/gateway", serviceController);
			newService.addEventListener(FaultEvent.CONNECTION_ERROR, handleConntectionErr);
			_gatewayConnectionPool[serviceController] = newService;
			
			return newService;
		}
      	private function handleConntectionErr(e:*):void { }
	}
}