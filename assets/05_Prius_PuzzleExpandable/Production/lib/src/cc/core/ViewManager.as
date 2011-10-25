package cc.core
{
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	
	/**
	 * View Manager
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 10.0.0
	 * 
	 * @author Carl Calderon (carl.calderon@gmail.com)
	 * @since  14.01.2011
	 */
	public class ViewManager extends Sprite
	{
		
		/**
		 * @private
		 * Application reference
		 */
		private var _app:AbstractApplication;
		
		/**
		 * @private
		 * View list
		 */
		private var _views:Vector.<IView>;
		
		/**
		 * @constructor
		 * ViewManager entry point
		 * @param application Current Application
		 */
		public function ViewManager(application:AbstractApplication)
		{
			super();
			
			_app 	= application;
			_views	= new Vector.<IView>();
			_app.addChild(this);
		}
		
		/**
		 *	Adds a view to the view list
		 * 
		 * 	@param view IView	Any IView object
		 */
		public function add(view:IView):void
		{
			view.initialize(_app);
			_views.push(view);
			addChild(view as Sprite);
		}
		
		/**
		 *	Changes the order of the specified IView.
		 *  
		 *	@param view IView	IView to change order of
		 *	@param index uint	New order index (depth)
		 */
		public function order(view:IView,index:uint):void
		{
			setChildIndex(view as DisplayObject,index);
		}
		
		/**
		 *	Orders the view one step back.
		 *  
		 *	@param view IView
		 */
		public function moveBack(view:IView):void
		{
			order(view,getChildIndex(view as DisplayObject)-1);
		}
		
		/**
		 *	Orders the view one step forward.
		 * 
		 * 	@param view IView
		 */
		public function moveForward(view:IView):void
		{
			order(view,getChildIndex(view as DisplayObject)+1);
		}
		
		/**
		 *	Places the view behind all other views.
		 * 
		 * 	@param view IView
		 */
		public function sendToBack(view:IView):void
		{
			order(view,0);
		}
		
		/**
		 *	Places the view in front of all other views.
		 * 
		 * 	@param view IView
		 */
		public function sendToFront(view:IView):void
		{
			order(view,numChildren-1);
		}
		
	}

}