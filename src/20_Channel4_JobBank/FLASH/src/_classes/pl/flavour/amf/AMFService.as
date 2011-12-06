package pl.flavour.amf
{
	import flash.events.EventDispatcher;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;	

	public class AMFService extends EventDispatcher {

		private var _gatewayURL : String;
		private var _connection : NetConnection;

		public function AMFService(gatewayURL : String = null) 
		{
			super(null);
			_gatewayURL = gatewayURL;
		}

		public function getConnection() : NetConnection 
		{
			if (_connection == null) {
				_connection = new NetConnection();
				_connection.objectEncoding = ObjectEncoding.AMF0;
				_connection.connect(_gatewayURL);
			}			
			return _connection;	
		}

		public function call(onSuccess : Function, onFailure : Function, name : String, ...params : Array) : AMFRequest 
		{
			var connection : NetConnection = getConnection();
			var request : AMFRequest = new AMFRequest(this, connection, name, params, onSuccess, onFailure);
			request.call();
			return request;
		}

		public static function getResult(result : Object) : Object 
		{
			if (result == null) return null;
			return result['results'];
		}

		public static function getResultErrors(result : Object) : Array 
		{
			var errors : Array = result['errors'];
			if (errors == null) return new Array();
		
			return errors;		
		}

		public static function getResultErrorsString(result : Object, join : String = "\n") : String 
		{
			var s : String = "";
			var errors : Array = getResultErrors(result);
			for each (var error:Object in errors) {
				if (s.length > 0) s += join;
				s += error;
			}
			return s;
		}

		public static function gotResultErrors(result : Object) : Boolean 
		{
			return result['errors'] && result['errors'].length > 0;	
		}
	}
}
