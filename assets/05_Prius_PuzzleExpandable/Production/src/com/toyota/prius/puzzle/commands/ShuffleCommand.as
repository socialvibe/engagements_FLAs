package com.toyota.prius.puzzle.commands
{
	import flash.events.Event;
	import com.toyota.prius.puzzle.proxies.AssetProxy;
	import com.toyota.prius.puzzle.models.Orientation;
	import org.osflash.signals.Signal;
	
	public class ShuffleCommand extends Object
	{
		private const STRENGTH:uint = 3;
		
		private var _proxy:AssetProxy;
		private var _step:int = 0;
		private var _complete:Signal;
		private var _arr:Array;
		
		public function ShuffleCommand()
		{
			_complete = new Signal();
		}
		
		public function reset():void
		{
			_step = 0;
			_arr = new Array();
		}
		
		public function execute( proxy:AssetProxy ):void
		{
			_proxy = proxy;
			
			reset();
			rotate();
		}
		
		//private var testArr:Array = [ { side:"top", clockwise:false }, { side:"back", clockwise:false }, { side:"front", clockwise:true }, { side:"left", clockwise:false } ];
		//private var testArr:Array = [ { side:"right", clockwise:true }, { side:"left", clockwise:true }, { side:"right", clockwise:false }, { side:"right", clockwise:false } ];
		//private var testArr:Array = [ { side:"right", clockwise:false }, { side:"front", clockwise:true }, { side:"back", clockwise:false }, { side:"back", clockwise:false } ];
		private var testArr:Array = [ { side:"right", clockwise:false }, { side:"left", clockwise:true }, { side:"right", clockwise:false }, { side:"left", clockwise:true } ];

		private function rotate():void
		{
			var newSideRotation:Object = sideRotate;// testArr[_arr.length];// ;sideRotate;// 
			
			// do not rotate to its previous pos
			if ( _arr.length > 0 )
			{
				var lastSide:Object = _arr[ _arr.length - 1 ];
				while ( lastSide.side == newSideRotation.side && lastSide.clockwise != newSideRotation.clockwise )
					newSideRotation = sideRotate;
			}
			
			// Sometimes shuffles Solved. make sure the puzzle is not solved. ex) 'testArr' gets solved 
			if ( _arr.length == STRENGTH )
			{
				// virtual rotate
				var tempSide:String = newSideRotation.side;
				_proxy.rotateSide(newSideRotation.side, newSideRotation.clockwise, 0, null, false );
				if ( _proxy.solved ) newSideRotation.side = Orientation.getRandomOtherSide( newSideRotation.side );
				// virtual rotate back
				_proxy.rotateSide(tempSide, !newSideRotation.clockwise, 0, null, false );
			}
			
			_arr.push( newSideRotation );
			
			traceout( 'rotating ' + newSideRotation.side + '\t' + (newSideRotation.clockwise?'true':'false'));
			
			_proxy.rotateSide(newSideRotation.side, newSideRotation.clockwise, .5, onComplete);
		}
		
		private function onComplete():void
		{
			if ( _step++ < STRENGTH )
			{
				rotate();
				
			}else {
				
				_complete.dispatch();
			}
		}
		
		public function get complete():Signal { return _complete; };
		
		private function get sideRotate():Object
		{
			var ob:Object = _arr.length > 0 ? _arr[ _arr.length - 1 ] : null;
			
			var side:String 		= Orientation.getRandomSide();
			var clockwise:Boolean 	= Boolean(Math.round(Math.random()));
			
			if ( ob ) 
			{
				if 		( side == Orientation.LEFT && ob.side == Orientation.RIGHT && ob.clockwise != clockwise ) clockwise = !clockwise;
				else if ( side == Orientation.RIGHT && ob.side == Orientation.LEFT && ob.clockwise != clockwise ) clockwise = !clockwise;
				else if ( side == Orientation.FRONT && ob.side == Orientation.BACK && ob.clockwise != clockwise ) clockwise = !clockwise;
				else if ( side == Orientation.BACK && ob.side == Orientation.FRONT && ob.clockwise != clockwise ) clockwise = !clockwise;
				else if ( side == Orientation.TOP && ob.side == Orientation.BOTTOM && ob.clockwise != clockwise ) clockwise = !clockwise;
				else if ( side == Orientation.BOTTOM && ob.side == Orientation.TOP && ob.clockwise != clockwise ) clockwise = !clockwise;
			}
			
			return  { side:side, clockwise:clockwise };
		}
		
		private function traceout( str:String ):void
		{
			trace( this, str );
		}
	}

}