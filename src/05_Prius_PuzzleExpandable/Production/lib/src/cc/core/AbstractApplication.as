package cc.core
{

	import flash.display.Sprite;
	import cc.utils.StringUtils;
	import cc.core.StateManager;
	import cc.core.ViewManager;
	import cc.core.ControlManager;
	import flash.events.Event;
	
	/**
	 * Abstract Application based on 
	 * WesterFreight's design pattern from 2008.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 10.0.0
	 * 
	 * @author Carl Calderon (carl.calderon@gmail.com)
	 * @since  14.01.2011
	 */
	public class AbstractApplication extends Sprite
	{	
		/**
		 * Define if history should be used.
		 * Default 'true'
		 */
		public var useHistory	:Boolean = true;
		
		/**
		 * @private
		 * Proxy holder.
		 */
		private var _proxy		:HashMap;
		
		/**
		 * @private
		 * Command holder.
		 */
		private var _control	:ControlManager;
		
		/**
		 * @private
		 * View holder.
		 */
		private var _view		:ViewManager;
		
		/**
		 * @private
		 * State holder.
		 */
		private var _state		:StateManager;
		
		/**
		 * @private
		 * History holder.
		 */
		private var _history	:History;

////////////////////////////////////////////////////////
//
//	Constructor
//
////////////////////////////////////////////////////////

		/**
		 * @constructor
		 * Application entry point.
		 */
		public function AbstractApplication()
		{
			super();
			
			_proxy		= new HashMap();
			_state	 	= new StateManager();
			_control	= new ControlManager(this);
			_view		= new ViewManager(this);
			if(useHistory)
			{
				_history		= new History(_state);
				_state.history 	= _history;
			}
			
		}
		
////////////////////////////////////////////////////////
//
//	Getter Setters
//
////////////////////////////////////////////////////////
		
		/**
		 * Proxy holder
		 */
		public function get proxy():HashMap
		{
			return _proxy;
		}
		
		/**
		 * Command holder
		 */
		public function get control():ControlManager
		{
			return _control;
		}
		
		/**
		 * State holder
		 */
		public function get state():StateManager
		{
			return _state;
		}
		
		/**
		 * View holder
		 */
		public function get view():ViewManager
		{
			return _view;
		}
		
		/**
		 * History holder.
		 */
		public function get history():History
		{
			return _history;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			return StringUtils.formatToString(this,'control','state','view');
		}
	
	}

}