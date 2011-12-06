package pl.flavour.amf 
{
	import flash.events.Event;

	public class AMFEvent extends Event {

		public static const SUCCESS : String = "AMF_SUCCESS";  
		public static const ERROR : String = "AMF_ERROR";  

		public var request : AMFRequest;

		public function AMFEvent(request : AMFRequest, type : String, bubbles : Boolean = false, cancelable : Boolean = false) 
		{
			super(type, bubbles, cancelable);
			this.request = request;
		}
	}
}
