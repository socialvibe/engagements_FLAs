package cc.events
{

	import flash.events.Event;
	
	import cc.core.IState;
	
	/**
	 * Basic State event
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 * 
	 * @author Carl Calderon (carl.calderon@gmail.com)
	 * @since  14.01.2011
	 */
	public class StateEvent extends Event
	{
	
		/**
		 * State Enter event
		 */
		public static const ENTER:String = "state::enter";
		
		/**
		 * State Re-enter event
		 */
		public static const REENTER:String = "state::reenter";
		
		/**
		 * Child state Enter event
		 */
		public static const CHILD_ENTER:String = "state::child_enter";
		
		/**
		 * State Exit event
		 */
		public static const EXIT:String = "state::exit";
		
		/**
		 * Child state Exit event
		 */
		public static const CHILD_EXIT:String = "state::child_exit";
		
		/**
		 * Current IState holder
		 */
		private var _state:IState;
		
		/**
		 * @inheritDoc
		 */
		public function StateEvent(type:String, state:IState=null, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			_state = state;
			super(type, bubbles, cancelable);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new StateEvent(type, state, bubbles, cancelable);
		}
		
		/**
		 * Current referenced IState
		 */
		public function get state():IState
		{
			return _state;
		}
		
	}

}

