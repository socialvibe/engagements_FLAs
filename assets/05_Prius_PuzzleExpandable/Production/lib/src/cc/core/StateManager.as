package cc.core
{
	/**
	 * StateManager class.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 * 
	 * @author Carl Calderon
	 * @since  06.01.2011
	 */
	public class StateManager
	{
		
		private var _lookup		:Vector.<IState>;
		private var _root		:IState;
		private var _active		:IState;
		private var _history	:History;
		
		/**
		 * Creates a new StateManager instance.
		 * <p>first state must always have <code>"root"</code> as parent.</p>
		 *  
		 * @constructor
		 */
		public function StateManager()
		{
			super();
			
			_lookup = new Vector.<IState>();
			_root = new AbstractState(null,'root');
			_lookup.push(_root);
		}
		
		/**
		 *	Sets the specified state as the active one and
		 * 	dispatches enter and exit events for each affected state.
		 *  
		 *	@param state String			State to activate
		 *	@return Boolean				Success
		 */
		public function activate(state:String):Boolean
		{
			if(!has(state))
			{
				return false;
			}
			
			var current:IState = _active;
			
			if(_active==null)
				_active = find(state);
			else
			{
				if(_active.name == state)
				{
					_active.reenter();
					return true;
				}
				var next:IState = find(state);
				var p:IState = _active;
				var isParent:Boolean = isParentOfChild(p.name,next.name);
				
				while(p!=null)
				{
					if(isParent)
						p.childExit();
					else if(p.parent!=null)
						p.exit();
						
					if(p.parent != next && p.parent != next.parent)
						p = p.parent;
					else
						p = null;
				}
				_active = next;
			}
			
			// history
			if(_history)
				_history.add(_active);
			
			// enter
			var pa:IState = _active.parent;
			while(pa!=null)
			{
				if(!pa.active)
					pa.enter();
				else
					pa.childEnter();
				pa = pa.parent;
			}
			_active.enter();
			return true;
		}
		
		/**
		 *	Adds a new state to the state-tree.
		 *  
		 *	@param parent String	State parent name
		 *	@param state String		State name
		 *	@return Boolean			Success
		 */
		public function add(parent:String,state:String):Boolean
		{
			if(has(parent) && !has(state))
			{
				var p:IState = find(parent);
				var c:AbstractState = new AbstractState(p,state);
				p.addChild(c);
				_lookup.push(c);
				return true;
			}
			return false;
		}
		
		/**
		 *	Adds a custom IState to the state-tree.
		 *  
		 *	@param parent String	Parent name
		 *	@param state IState		Custom state
		 *	@return Boolean			Success
		 */
		public function addCustom(parent:String,state:IState):Boolean
		{
			if(has(parent) && !has(state.name))
			{
				var p:IState = find(parent);
				p.addChild(state);
				_lookup.push(state);
				return true;
			}
			return false;
		}
		
		/**
		 *	Removes the specified state from the state-tree. 
		 * 
		 *	@param state String			State to remove
		 *	@param recursive Boolean	Specifies if the state should be removed 
		 * 								even if it has children. If it has children
		 * 								and recursive is set to false, response of
		 * 								this call will be false.
		 *	@return Boolean				Success
		 */
		public function remove(state:String,recursive:Boolean=false):Boolean
		{
			if(!has(state)) return false;
			var s:IState = find(state);
			if(!recursive && s.hasChildren)
				return false;
			else if(recursive) s.removeAllChildren();
			_lookup.splice(_lookup.indexOf(s),1)[0];
			s = null;
			return true;
		}
		
		/**
		 * 	Returns true if the spcified state exists [within the parent].
		 * 
		 *	@param state String			State name
		 *	@param parent Object		Parent name
		 *	@return Boolean				Existance
		 */
		public function has(state:String,parent:Object=null):Boolean
		{
			if(parent==null)
			{
				for (var i:int = 0; i < _lookup.length; i++)
					if(_lookup[i].name == state)
						return true;
				return false;
			}
			return !parent[state]==false;
		}
		
		/**
		 *  Retrieves the specified state.
		 *  
		 *	@param state String			State name
		 *	@return Object				State or null
		 */
		public function get(state:String):IState
		{
			return find(state);
		}
		
		public function set history(value:History):void
		{
			_history = value;
		}
		
		/**
		 *	@internal Finds the specified state [within the parent]. 
		 *	@param state String			State name
		 *	@param parent Object		Parent state
		 *	@return Object				State or null
		 */
		private function find(state:String):IState
		{
			for (var i:int = 0; i < _lookup.length; i++)
				if(_lookup[i].name == state)
					return _lookup[i];
			return null;
		}
		
		/**
		 *	@internal Checks if the parent has the child or grand-child (infinity). 
		 *	@param parent String		Parent name
		 *	@param child String			Child name
		 *	@return Boolean				Is parent or not
		 */
		private function isParentOfChild(parent:String,child:String):Boolean
		{
			var p:IState = find(parent);
			if(p.numChildren==0) return false;
			for (var i:int = 0; i < p.children.length; i++)
			{
				if(p.children[i].name==child) 	return true;
				else
				{
					if(isParentOfChild(p.children[i].name,child))
						return true;
				}
			}
			return false;
		}
		
		/**
		 *  String representation of the current object.
		 */
		public function toString():String
		{
			function s(d:int=0):String{var r:String='';for (var i:int = 0; i < d-1; i++){ r+='. . '; }return r;}
			
			function e(p:IState,d:int=0):String
			{
				var r:String = '';
				for each(var child:IState in p.children)
				{
					r += '\n'+s(d)+child.name + ' ('+child.numChildren+')' + e(child,d+1);
				}
				return r;
			}
			return '[StateManager]'+e(_root,1);			
		}
		
	}

}

