package cc.core
{
	
	import cc.utils.StringUtils;	
	
	/**
	 * Abstract Command.
	 * All commands that may be registered to the control
	 * manager must extend this class or implement the
	 * ICommand interface to be able to compile.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 10.0.0
	 * 
	 * @author Carl Calderon (carl.calderon@gmail.com)
	 * @since  14.01.2011
	 */
	public class AbstractCommand implements ICommand
	{
		
		private var _params:Object;
		
		/**
		 * Application reference.
		 */
		protected var _app:AbstractApplication;

////////////////////////////////////////////////////////
//
//	Constructor
//
////////////////////////////////////////////////////////

		/**
		 * @constructor
		 * Abstract Command entry point
		 */
		public function AbstractCommand()
		{
			super();
			setup();
		}

////////////////////////////////////////////////////////
//
//	Protected Methods
//
////////////////////////////////////////////////////////

		/**
		 * Command setup method.
		 * First method called tr construct.
		 */
		protected function setup():void
		{ }
		
		/**
		 *	Sets the Application state to the specified
		 *  state id.
		 *  
		 *	@param state String	State id
		 *	@return Boolean		Success
		 */
		protected function setState(state:String):Boolean
		{
			return _app.state.activate(state);
		}
		
		/**
		 *	Retrieves the desired proxy. Proxy must be
		 * 	registered in the Proxy Hash Map.
		 *  
		 *	@param proxy String		Proxy id
		 *	@return AbstractProxy
		 */
		protected function getProxy(proxy:String):AbstractProxy
		{
			return _app.proxy.get(proxy);
		}
		
////////////////////////////////////////////////////////
//
//	Public Methods
//
////////////////////////////////////////////////////////

		/**
		 * @inheritDoc
		 */
		public function initialize(app:AbstractApplication):void
		{
			_app = app;
		}
		
		/**
		 * @inheritDoc
		 */
		public function execute():void
		{
			
		}
		
////////////////////////////////////////////////////////
//
//	Getter Setter
//
////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function get params():Object
		{
			return _params;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set params(value:Object):void
		{
			_params = value;
		}	
		
		/**
		 * @inheritDoc
		 */
		public function toString():String
		{
			return StringUtils.formatToString(this);
		}
		
	}

}