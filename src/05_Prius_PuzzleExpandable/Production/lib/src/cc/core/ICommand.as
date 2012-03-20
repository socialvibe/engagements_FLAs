package cc.core
{

	/**
	 * ICommand
	 * 
	 * Command Interface (required methods and args.)
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 10.0.0
	 * 
	 * @author Carl Calderon (carl.calderon@gmail.com)
	 * @since  14.01.2011
	 */
	public interface ICommand
	{
		
		/**
		 * Object containing parameters, both optional and required.
		 * Common paramerters include onComplete and onError.
		 */
		function get params():Object;
		
		/**
		 * Sets the parameters for the command, both optional and required.
		 */
		function set params(value:Object):void;
		
		/**
		 *	Initializes the command and register the 
		 * 	current application.
		 * 
		 *	@param app AbstractApplication	Current AbstractApplication
		 */
		function initialize(application:AbstractApplication):void;
		
		/**
		 *	Executes the command with the specified parameters.
		 *  
		 *	@param params Object 		Exec parameters.
		 *  @throws cc.errors.CCError 	May throw ANY error if failed due 
		 * 								to parameter faults.
		 */
		function execute():void;
		
		/**
		 * String represenation of the current command.
		 */
		function toString():String;
		
	}

}

