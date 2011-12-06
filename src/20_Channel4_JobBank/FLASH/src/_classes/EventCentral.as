package 
{
	/*
	imports
	*/
	import flash.events.EventDispatcher
	import flash.events.Event;
	/*
	class
	*/
	public class EventCentral extends EventDispatcher
	{
		/*
		variables
		*/
		private static var instance:EventCentral = new EventCentral();
		
		/*
		constructor
		*/
		public function EventCentral():void
		{
			super();
			if (instance){
				throw new Error("EventCentral is a Singleton and can only be accessed through EventCentral.getInstance()");
			}
			//trace("[EventCentral] : constructed")
		}
		public static  function getInstance():EventCentral
		{
			return instance;
		}
		
		/**
		 * Overrides the dispatchEvent method in flash.events.EventDispatcher
		 * @param $event : any qualified event
		 * @return Boolean
		 * 
		 */		
		public override function dispatchEvent($event:Event):Boolean
		{
			return super.dispatchEvent($event);
		}
	}
}