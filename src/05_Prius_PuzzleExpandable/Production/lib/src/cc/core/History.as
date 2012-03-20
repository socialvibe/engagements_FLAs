package cc.core
{
	
	/**
	 * History
	 * 
	 * Creates and handles state history.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 10.0.0
	 * 
	 * @author Carl Calderon (carl.calderon@gmail.com)
	 * @since  29.01.2011
	 */
	public class History
	{
		
		private var _track		:Vector.<IState>;
		private var _manager	:StateManager;
		private var _index		:int = -1;

////////////////////////////////////////////////////////
//
//	Constructor
//
////////////////////////////////////////////////////////
	
		/**
		 * @constructor
		 * Creates a new History manager.
		 */
		public function History(manager:StateManager)
		{
			super();
			_track 		= new Vector.<IState>();
			_manager 	= manager;
		}

////////////////////////////////////////////////////////
//
//	Public Methods
//
////////////////////////////////////////////////////////
		
		/**
		 * Jumps one step forward in the history.
		 */
		public function forward():void
		{
			if(index != _track.length-1)
				index += 1;
		}
		
		/**
		 * Jumps one step back in the history
		 */
		public function back():void
		{
			if(index > 0)
				index -= 1;
		}
		
		/**
		 * Jumps back to the origin (first history item)
		 */
		public function origin():void
		{
			index = 0;
		}
		
		/**
		 *	Adds a state to the history
		 *  
		 *	@param state IState	State to be added to history
		 */
		public function add(state:IState):void
		{
			_track = _track.slice(0,_index+1);
			_track.push(state);
			_index = _index + 1;
		}

////////////////////////////////////////////////////////
//
//	Get Set
//
////////////////////////////////////////////////////////
			
		/**
		 * Sets the current history index.
		 * This index must be within the valid length (0 to History#length)
		 */
		public function set index(value:int):void
		{
			_index = value;
			_manager.activate(IState(_track[_index]).name);
		}
		
		/**
		 * Retrieves the current history index
		 */
		public function get index():int
		{
			return _index;
		}
		
		/**
		 *	String representation of the currnet history
		 *	@return String
		 */
		public function toString():String
		{
			var str:String = '[History length='+_track.length+']';
			for (var i:int = 0; i < _track.length; i++)
			{
				str += '\n'+i+'# '+IState(_track[i]).name + ((i==_index)?'()':'');
			}
			return str;
		}
		
	}

}

