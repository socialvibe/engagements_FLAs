package cc.commands
{
	import cc.core.*;
	import cc.utils.StringUtils;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * CommandChain
	 *  
	 * Creates a chain of command that will be executed
	 * in order of addition.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 10.0.0
	 * 
	 * @author Carl Calderon (carl.calderon@gmail.com)
	 * @since  29.01.2011
	 */
	public class CommandChain extends EventDispatcher implements ICommand
	{
		
		private var _index		:int = -1;
		private var _params		:Object;
		private var _chain		:Vector.<ICommand>;
		private var _application:AbstractApplication;

////////////////////////////////////////////////////////
//
//	Constructor
//
////////////////////////////////////////////////////////
			
		/**
		 * @constructor
		 * Creates a new CommandChain object.
		 * 
		 * @param application	Reference to the current Application
		 */
		public function CommandChain()
		{
			_chain = new Vector.<ICommand>();	
		}

////////////////////////////////////////////////////////
//
//	Public Methods
//
////////////////////////////////////////////////////////
		
		public function initialize(application:AbstractApplication):void
		{
			_application = application;
		}
		
		/**
		 *	Adds a command to the end of the chain.
		 * 	Each command added must execute params.onComplete
		 * 	when finished for the whole chain to progress.
		 * 	params.onComplete is required to execute.
		 *  
		 * 	The chain will dispatch Event.COMPLETE when the
		 * 	last command in the chain is complete.
		 * 
		 * 	Each command will receive a reference to the chain
		 * 	through params.chain.
		 * 
		 *	@param command ICommand		Command to add to the chain
		 *	@param params Object		Command parameters
		 * 	@return	The added command
		 */
		public function addNew(command:ICommand,params:Object=null):ICommand
		{
			if(params == null) params = {};
			params.onComplete 	= execute;
			params.chain 		= this;
			command.params 		= params;
			_chain.push(command);
			return command;
		}
		
		/**
		 *	@copy #addNew()
		 *	@param command String		Command to add to the chain
		 *	@param params Object		Command parameters
		 * 	@return	The added command
		 */
		public function add(command:String,params:Object=null):ICommand
		{
			var cmd:ICommand = _application.control.get(command);
			if(params == null) params = {};
			params.onComplete 	= execute;
			params.chain 		= this;
			cmd.params 			= params;
			_chain.push(cmd);
			return cmd;
		}
		
		/**
		 *	Execute the Command chain
		 */
		public function execute():void
		{
			_index++;
			if(_chain.length != _index)
			{
				ICommand(_chain[_index]).initialize(_application);
				ICommand(_chain[_index]).execute();
			}
			else
			{
				if(params.onComplete)
					params.onComplete();
				_index = -1;
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}

////////////////////////////////////////////////////////
//
//	Get Set
//
////////////////////////////////////////////////////////
			
		/**
		 * Chain length
		 */
		public function get length():int
		{
			return _chain.length;
		}
		
		public function set params(value:Object):void
		{
			_params = value;
		}
		
		public function get params():Object
		{
			return _params;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			return StringUtils.formatToString(this,'length')
		}
	
	}

}