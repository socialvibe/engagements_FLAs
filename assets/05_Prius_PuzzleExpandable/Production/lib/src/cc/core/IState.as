package cc.core
{
	import flash.events.IEventDispatcher;
	
	/**
	 * State Interface
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 10.0.0
	 * 
	 * @author Carl Calderon (carl.calderon@gmail.com)
	 * @since  29.01.2011
	 */
	public interface IState extends IEventDispatcher
	{
		/**
		 *	Adds a child to the current state.
		 *  
		 *	@param state AbstractState	Child-state
		 */
		function addChild(state:IState):void;
		
		/**
		 *	Orphan's a previously defined child and null's it.
		 *  
		 *	@param state AbstractState	Child to kill.
		 */
		function removeChild(state:IState):void;
		
		/**
		 * Removed all children in the current state.
		 */
		function removeAllChildren():void;
		
		/**
		 * Execute on state entry.
		 */
		function enter():void;
		
		/**
		 * Execute on state re-entry.
		 */
		function reenter():void;
		
		/**
		 * Execute on child state entry.
		 */
		function childEnter():void;
		
		/**
		 * Execute on state exit
		 */
		function exit():void;
		
		/**
		 * Execute on child state exit.
		 */
		function childExit():void;
		
		/**
		 * State name
		 */
		function get name():String;
		
		/**
		 * State parent
		 */
		function get parent():IState;
		
		/**
		 * State parent
		 */
		function get active():Boolean;
		
		/**
		 * Returns true if the state has children
		 */
		function get hasChildren():Boolean;
		
		/**
		 * Returns all children as a Vector.
		 */
		function get children():Vector.<IState>;
		
		/**
		 * Number of child states
		 */
		function get numChildren():int;
		
		/**
		 * String representation of the current state
		 */
		function toString():String;
		
	}

}