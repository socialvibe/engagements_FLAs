package cc.core
{
	import cc.events.StateEvent;
	import cc.utils.StringUtils;
	import cc.core.AbstractState;
	import cc.errors.CCError;
	
	import flash.display.Sprite;
	
	/**
	 * Abstract view
	 * 
	 * Basic utilization of view states.
	 * Each view require that one or more states
	 * are defined ad listeners. When a state
	 * becomes active, all view's listening on the
	 * state will receive an StateEvent.ENTER.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 10.0.0
	 * 
	 * @author Carl Calderon (carl.calderon@gmail.com)
	 * @since  14.01.2011
	 */
	public class AbstractView extends Sprite implements IView
	{
		
		/**
		 * Application reference ( only used for #run(), 
		 * #getProxy() and #listen() )
		 */
		private var _app:AbstractApplication;
		
		/**
		 * @constructor
		 * View entry point.
		 * Please instanciate all objects within #setup()
		 */
		public function AbstractView()
		{
			super();
			
			visible = false;
		}

////////////////////////////////////////////////////////
//
//	Public Methods
//
////////////////////////////////////////////////////////

		/**
		 * @inheritDoc
		 */
		public function initialize(application:AbstractApplication):void
		{
			_app = application;
			setup();
		}

////////////////////////////////////////////////////////
//
//	Protected Methods
//
////////////////////////////////////////////////////////

		/**
		 * View entry (instanciate here!)
		 */
		protected function setup():void
		{ }

		/**
		 *	Executes the specified command
		 * 
		 * 	@param command String	Command id
		 *	@param params Object	Command parameters
		 */
		protected function run(command:String,params:Object):void
		{
			_app.control.run(command,params);
		}
		
		/**
		 *	Jumps back one step in the history
		 * 	if available.
		 */
		protected function back():void
		{
			if(_app.history)
				_app.history.back();
		}
		
		/**
		 *	Jumps forward one step in the history
		 * 	if available.
		 */
		protected function forward():void
		{
			if(_app.history)
				_app.history.forward();
		}
		
		/**
		 *	Moves the view back one step in depth.
		 */
		protected function moveBack():void
		{
			_app.view.moveBack(this);
		}
		
		/**
		 *	Moves the view forward one step in depth.
		 */
		protected function moveForward():void
		{
			_app.view.moveForward(this);
		}
		
		/**
		 *	Places the view behind all other views.
		 */
		protected function sendToBack():void
		{
			_app.view.sendToBack(this);
		}
		
		/**
		 *	Places the view in front of all other views.
		 */
		protected function sendToFront():void
		{
			_app.view.sendToFront(this);
		}
		
		/**
		 *	Retrieves the specified proxy.
		 * 
		 * 	@param proxy String		Proxy id
		 *	@return AbstractProxy
		 */
		protected function getProxy(proxy:String):AbstractProxy
		{
			return _app.proxy.get(proxy);
		}
		
		/**
		 *	Attaches state listeners.
		 * 	
		 *  @see cc.core.AbstractState
		 *  @see cc.core.StateManager
		 *  @see cc.events.StateEvent#ENTER
		 *  @see cc.events.StateEvent#EXIT
		 * 	@param state String			State id
		 *	@param eventType String		Event type (common ENTER, EXIT of StateEvent)
		 *	@param listener Function	Listener method
		 */
		protected function listen(state:String,eventType:String,listener:Function):void
		{
			try
			{
				var target:IState = _app.state.get(state);
				target.addEventListener(eventType,listener);
				target = null;
			}
			catch(e:*)
			{
				throw new CCError('No state with name "'+state+'" found.');
			}
		}
		
		/**
		 *	Removes state listeners.
		 * 	
		 *  @see cc.core.AbstractState
		 *  @see cc.core.StateManager
		 *  @see cc.events.StateEvent#ENTER
		 *  @see cc.events.StateEvent#EXIT
		 * 	@param state String			State id
		 *	@param eventType String		Event type (common ENTER, EXIT of StateEvent)
		 *	@param listener Function	Listener method
		 */
		protected function ignore(state:String,eventType:String,listener:Function):void
		{
			var target:IState = _app.state.get(state);
			target.removeEventListener(eventType,listener);
			target = null;
		}
				
		/**
		 * Defines object positions
		 */
		protected function position():void
		{ }
		
		/**
		 * Defines locale / language
		 */
		protected function language():void
		{ }
		
		/**
		 * Populate entry
		 */
		protected function populate():void
		{ 
			language();
			position();
			visible = true;
		}
		
		/**
		 * Desert point of the view.
		 */
		protected function desert():void
		{ 
			visible = false;
		}
		
		/**
		 * 	State Enters
		 *	@param e StateEvent
		 */
		protected function onStateEnter(e:StateEvent):void
		{ 
			populate();
		}
		
		/**
		 *	State leave 
		 *	@param e StateEvent
		 */
		protected function onStateExit(e:StateEvent):void
		{ 
			desert();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			return StringUtils.formatToString(this,'name');
		}
		
	}

}