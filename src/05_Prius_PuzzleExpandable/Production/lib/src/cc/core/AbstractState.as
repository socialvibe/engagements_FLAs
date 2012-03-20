package cc.core
{
	import cc.utils.StringUtils;
	import cc.events.StateEvent;
	
	import flash.events.EventDispatcher;
	
	/**
	 * Abstract State
	 * 
	 * States are used to define Application states.
	 * This class utilize the basic functionallity
	 * required by the framework to work within states.
	 * 
	 * A state tells Application-attached Views to enter
	 * or exit pending on the active state. All states
	 * above this state will be entered if this state is
	 * activated (family notice, child -> parent).
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 10.0.0
	 * 
	 * @author Carl Calderon (carl.calderon@gmail.com)
	 * @since  14.01.2011
	 */
	public dynamic class AbstractState extends EventDispatcher implements IState
	{
		
		/**
		 * State name
		 */
		private var _name		:String;
		
		/**
		 * Parent state (single)
		 */
		private var _parent		:IState;
		
		/**
		 * Activity
		 */
		private var _active		:Boolean;
		
		/**
		 * Child states (muliple)
		 */
		private var _children	:Vector.<IState>;

////////////////////////////////////////////////////////
//
//	Constructor
//
////////////////////////////////////////////////////////

		/**
		 * @constructor
		 * Constructs an AbstractState.
		 * 
		 * @param parent IState 	Every state has one defined parent.
		 * @param name String			State name
		 */
		public function AbstractState(parent:IState,name:String)
		{
			super();
			_name 	= name;
			_parent = parent;
		}

////////////////////////////////////////////////////////
//
//	Public Methods
//
////////////////////////////////////////////////////////
		
		/**
		 *	@inheritDoc
		 */
		public function addChild(state:IState):void
		{
			if(!_children)	_children = new Vector.<IState>();
			_children.push(state);
		}
		
		/**
		 *	@inheritDoc
		 */
		public function removeChild(state:IState):void
		{
			var child:IState = _children.splice(_children.indexOf(state),1)[0];
			child = null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeAllChildren():void
		{
			for (var i:int = 0; i < _children.length; i++)
			{
				(_children[i] as IState).removeAllChildren();
				_children[i] = null;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function enter():void
		{
			_active = true;
			dispatchEvent(new StateEvent(StateEvent.ENTER,this));
		}
		
		/**
		 * @inheritDoc
		 */
		public function reenter():void
		{
			_active = true;
			dispatchEvent(new StateEvent(StateEvent.REENTER,this));
		}
		
		/**
		 * @inheritDoc
		 */
		public function childEnter():void
		{
			_active = true;
			dispatchEvent(new StateEvent(StateEvent.CHILD_ENTER,this));
		}
		
		/**
		 * @inheritDoc
		 */
		public function exit():void
		{
			//log(name + ' :: exit');
			_active = false;
			dispatchEvent(new StateEvent(StateEvent.EXIT,this));
		}
		
		/**
		 * @inheritDoc
		 */
		public function childExit():void
		{
			//log(name + ' :: childExit');
			dispatchEvent(new StateEvent(StateEvent.CHILD_EXIT,this));
		}

////////////////////////////////////////////////////////
//
//	Getter Setters
//
////////////////////////////////////////////////////////
	
		/**
		 * @inheritDoc
		 */
		public function get name():String
		{
			return _name;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get parent():IState
		{
			return _parent;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get active():Boolean
		{
			return _active;
		}
		
		/**
		 * Returns true if the state has children
		 */
		public function get hasChildren():Boolean
		{
			if(!_children) return false;
			return _children.length > 0;
		}
		
		/**
		 * Returns all children as a Vector.
		 */
		public function get children():Vector.<IState>
		{
			return _children;
		}
		
		/**
		 * Number of child states
		 */
		public function get numChildren():int
		{
			if(!_children) return 0;
			return _children.length;
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
