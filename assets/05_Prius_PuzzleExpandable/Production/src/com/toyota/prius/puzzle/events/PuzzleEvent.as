package com.toyota.events
{

	import flash.events.Event;

	public class PuzzleEvent extends Event
	{
	
		public static const SOLVED:String = "puzzle::solved";
	
		public function PuzzleEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	
		override public function clone():Event
		{
			return new PuzzleEvent(type, bubbles, cancelable);
		}
	
	}

}

