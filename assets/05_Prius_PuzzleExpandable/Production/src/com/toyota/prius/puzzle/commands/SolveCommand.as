package com.toyota.prius.puzzle.commands
{
	import flash.events.Event;
	import com.toyota.prius.puzzle.proxies.AssetProxy;
	import com.toyota.prius.puzzle.models.Orientation;
	import org.osflash.signals.Signal;
	
	public class SolveCommand extends Object
	{
		private var _proxy:AssetProxy;
		private var _step:int = 0;
		private var _length:int = 0;
		private var _speed:Number = 0;
		private var _isHint:Boolean;
		private var _isFirstHint:Boolean;
		private var _hintDone:Signal;
		
		public function SolveCommand()
		{
			_hintDone = new Signal();
		}
		
		public function execute( proxy:AssetProxy, solve:Boolean=false, firstHint:Boolean=false, speed:Number=.4 ):void
		{
			_proxy 			= proxy;
			_isHint 		= !solve;
			_isFirstHint 	= firstHint;
			_speed			= speed;
			
			_length = _proxy.history.length;
			_step 	= _length - 1;
			
			rotate();
			
			//if ( _isHint ) _proxy.history.pop();
		}
		
		/**
		 *	@private
		 * 	Cleans the history from clockwise to counter-clockwise turns.
		 * 
		 * 	@param history Array
		 *	@return Array
		 */
		
		private function clean(history:Array):Array
		{
			var arr:Array = [];
			for (var i:int = 1; i < history.length; i++)
			{
				if(history[i-1].side == history[i].side && !history[i-1].clockwise == history[i].clockwise)
				{}
				else
				{
					arr.push(history[i-1]);
					arr.push(history[i]);
				}
			}
			return arr;
		}
		
		/**
		 *	@private
		 *  Rotates the cube
		 */
		private function rotate():void
		{
			if ( _proxy == null ) return;
			
			if(_proxy.solved)
			{
				onComplete();
			}
			else
			{
				var item:Object = _proxy.history[_step];
				trace(this, 'rotating ' + item.side + '\t' + ((!item.clockwise)?'true':'false'));
				_proxy.rotateSide(item.side, !item.clockwise, _speed, onRotateComplete, false);
				_proxy.history.pop();
			}
		}
		
		/**
		 *	@private
		 * 	Executed after each turn checking if solution is complete.
		 */
		private function onRotateComplete():void
		{
			if ( _isHint )
			{
				var len:uint = _proxy.history.length;
				var targetLen:uint = _isFirstHint ? 3 : 2;
			
				if ( len <= targetLen )
				{
					trace( "hint done" );
					_hintDone.dispatch();
					return;
				}
				else
				{
					trace( "hint - kepp rotate!" );
				}
			}
			
			if ( _step-- > -1 )
			{
				rotate();
			}
			else
				onComplete();
		}
		
		/**
		 *	@private
		 * 	Executed when solution is complete.
		 */
		private function onComplete():void
		{
			_proxy.history = [];
				
		}
		
		public function get hintDone():Signal { return _hintDone; };
		
	}

}