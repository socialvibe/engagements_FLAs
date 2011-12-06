package
{
	/*
	imports
	*/
	import flash.events.Event;
	/*
	class
	*/
	public class ProjectEvent extends Event
	{
		/*
		variables
		*/
//		public static const SOME_EVENT:String = "ProjectEvent.onSomeEvent"
		
		public var params:Object;
		/*
		Constructor
		*/
		
		/**
		 * ProjectEvent constructor
		 * @param $type : the event string 
		 * @param $params : an object containing any number of values to be sent to listeneers
		 * @return : a reference ot the event
		 * 
		 */		
		public function ProjectEvent($type:String, $params:Object = null)
		{
			super($type, true, true);
			this.params = $params
		}
		
		/**
		 * Overrides the flash.events.Event's clone method
		 * @return Event
		 * 
		 */		
		public override function clone():Event
		{
			return new ProjectEvent(this.type, this.params);
		}
		
		/**
		 * Overrides the flash.events.Event's toString method
		 * @return String - Class name
		 * 
		 */		
		override public function toString():String
		{
			return ("[Event ProjectEvent]");
		}
	}

}