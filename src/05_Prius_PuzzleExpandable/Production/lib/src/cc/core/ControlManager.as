package cc.core
{
	import cc.errors.CCError;
	import cc.core.HashMap;
	import cc.core.AbstractCommand;
	
	/**
	 * Control Manager
	 * 
	 * Instanciates, controls and executes
	 * registered commands.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 10.0.0
	 * 
	 * @author Carl Calderon (carl.calderon@gmail.com)
	 * @since  14.01.2011
	 */
	public class ControlManager extends HashMap
	{
		/**
		 * Application reference
		 */
		private var _app:AbstractApplication;

////////////////////////////////////////////////////////
//
//	Constructor
//
////////////////////////////////////////////////////////

		/**
		 * @constructor
		 * Control manager entry
		 * @param application Current Application
		 */
		public function ControlManager(application:AbstractApplication)
		{
			super();
			_app = application;
		}

////////////////////////////////////////////////////////
//
//	Public Methods
//
////////////////////////////////////////////////////////
	
		/**
		 * @inheritDoc
		 */
		override public function add(key:String,value:*):Boolean
		{
			if(!(value is ICommand) && !(value is Class))
				throw new CCError('Added non-command to ControlManager. ('+value+')');
			
			if(value is ICommand)
				value.initialize(_app);
			return super.add(key,value);
		}
		
		/**
		 *	Executes the specified command
		 *  
		 *	@param id String		Command id
		 *	@param params Object	Command parameters
		 */
		public function run(id:String,params:Object=null):void
		{
			var cmd:ICommand;
			var item:* = get(id);
			if(item is ICommand)
				cmd = item;
			else if(item is Class)
			{
				cmd = new item();
				cmd.initialize(_app);
			}
			if(cmd==null) throw new CCError('No command with id "'+id+'" found.');
			cmd['params'] = params;
			cmd.execute();
		}
	
	}

}

