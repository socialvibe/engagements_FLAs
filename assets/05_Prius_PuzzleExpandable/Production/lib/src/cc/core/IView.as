package cc.core
{
	
	import flash.display.IBitmapDrawable;
	
	/**
	 * View Interface
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 10.0.0
	 * 
	 * @author Carl Calderon (carl.calderon@gmail.com)
	 * @since  29.01.2011
	 */
	public interface IView extends IBitmapDrawable
	{
		/**
		 *	Initializes the view and sets up the Application reference.
		 *  
		 *	@param application AbstractApplication	Current Application
		 */
		function initialize(app:AbstractApplication):void;
		
		/**
		 * String representation of the current view.
		 */
		function toString():String;
	}

}

