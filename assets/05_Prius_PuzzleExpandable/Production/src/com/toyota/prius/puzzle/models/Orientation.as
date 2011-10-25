package com.toyota.prius.puzzle.models
{
	
	import cc.utils.StringUtils;
	
	public class Orientation
	{
		
		public static const LEFT	:String = 'left';
		public static const RIGHT	:String = 'right';
		public static const TOP		:String = 'top';
		public static const BOTTOM	:String = 'bottom';
		public static const FRONT	:String = 'front';
		public static const BACK	:String = 'back';
		
		public static const SIDES:Array 	= ['left', 'right', 'top', 'bottom', 'front', 'back'];
		public static const SIDES_V:Array 	= ['left', 'right', 'front', 'back'];
		public static const SIDES_H:Array 	= ['top', 'bottom'];
		
		public static function getRandomSide():String
		{
			return SIDES[Math.round(Math.random()*(SIDES.length-1))];
		}
		
		public static function getRandomOtherSide( side:String ):String
		{
			var arr:Array = ( side == SIDES_H[0] || side == SIDES_H[1] ) ? SIDES_V : SIDES_H
			return arr[Math.round(Math.random() * (arr.length - 1))];
		}
		
		public var _top		:Boolean = false;
		public var _bottom	:Boolean = false;
		public var _left	:Boolean = false;
		public var _right	:Boolean = false;
		public var _front	:Boolean = false;
		public var _back	:Boolean = false;
		
		public function Orientation(options:Object)
		{
			super();
			
			for (var key:String in options)
			{
				this['_'+key] = true;
			}
		}
		
		public function get top():Boolean
		{
			return _top;
		}
		
		public function get bottom():Boolean
		{
			return _bottom;
		}
		
		public function get left():Boolean
		{
			return _left;
		}
		
		public function get right():Boolean
		{
			return _right;
		}
		
		public function get front():Boolean
		{
			return _front;
		}
		
		public function get back():Boolean
		{
			return _back;
		}
		
		public function get topLeft():Boolean
		{
			return _top && _left;
		}
		
		public function get topRight():Boolean
		{
			return _top && _right;
		}
		
		public function get bottomLeft():Boolean
		{
			return _bottom && _left;
		}
		
		public function get bottomRight():Boolean
		{
			return _bottom && _right;
		}
		
		
		// ***********************************************************
		// GET ROTATION
		// ***********************************************************
		
		public static function getRotation( mouseSide:Orientation, possibleRotation:Orientation, horizontal:Number, vertical:Number, cam:Object ):Array
		{
			var params:Array;
			
			// -----------------------
			// top & bottom movement
			// -----------------------
			if( mouseSide.top || mouseSide.bottom )
			{
				var reverse:Boolean = false;
				var topDir:Number = horizontal * vertical;
				
				var frontBack:Boolean;
				
				// turn 1
				if ( ( mouseSide.top && cam.x < 0 && cam.y > 0 && cam.z > 0 ) || ( mouseSide.bottom && cam.x < 0 && cam.y < 0 && cam.z > 0 ) )
				{
					frontBack 	= topDir > 0;
					reverse 	= frontBack ? false : true;
					//if ( mouseSide.bottom ) reverse 	= !reverse;
				}
				// turn 2
				else if ( ( mouseSide.top && cam.x < 0 && cam.y > 0 && cam.z < 0 ) || ( mouseSide.bottom && cam.x < 0 && cam.y < 0 && cam.z < 0 ) )
				{
					frontBack 	= topDir < 0;
					reverse 	= true;
					if ( mouseSide.bottom ) reverse 	= !reverse;
				}
				// turn 3
				else if ( ( mouseSide.top  && cam.x > 0 && cam.y > 0 && cam.z < 0 ) || ( mouseSide.bottom && cam.x > 0 && cam.y < 0 && cam.z < 0 ) )
				{
					frontBack 	= topDir > 0;
					reverse 	= frontBack ? true : false;
				}
				// turn 4
				else 
				{
					frontBack 	= topDir < 0;
					if ( mouseSide.bottom ) reverse 	= !reverse;
				}
				
				if ( mouseSide.bottom ) frontBack 	= !frontBack;
					
				//trace(this, "frontBack: "+ frontBack + " reverse : " + reverse + ' cam: '+ cam );
				
				if( frontBack )
				{
					if (possibleRotation.front) params = [ Orientation.FRONT,	reverse ? horizontal > 0 : horizontal < 0 ];
					if (possibleRotation.back) 	params = [ Orientation.BACK,	reverse ? horizontal < 0 : horizontal > 0 ];
				}
				else
				{	
					if (possibleRotation.left)	params = [ Orientation.LEFT,	reverse ? horizontal < 0 : horizontal > 0 ];
					if (possibleRotation.right)	params = [ Orientation.RIGHT,	reverse ? horizontal > 0 : horizontal < 0 ];
				}
				
				return params;
			}
			
			// -----------------------
			// horizontal movement
			// -----------------------
			else if( Math.abs(horizontal) > Math.abs(vertical) && !mouseSide.top && !mouseSide.bottom )
			{
				trace('horizontal: left' + (horizontal < 0) );
				
				// horizontal < 0 --> horizontal: left
				// horizontal > 0 --> horizontal: right
				
				if (possibleRotation.bottom) 	params = [ Orientation.BOTTOM,	horizontal < 0 ? true : false];
				if (possibleRotation.top) 		params = [ Orientation.TOP,		horizontal < 0 ? false : true];
				
			}
			// -----------------------
			// vertical movement
			// -----------------------
			else
			{
				trace('vertical: up');
				
				if(mouseSide.front)
				{
					if(possibleRotation.left)	params = [ Orientation.LEFT,	vertical < 0 ? false : true];
					if(possibleRotation.right)	params = [ Orientation.RIGHT,	vertical < 0 ? true : false];
				}
				else if(mouseSide.back)
				{
					if(possibleRotation.left)	params = [ Orientation.LEFT,	vertical < 0 ? true : false];
					if(possibleRotation.right)	params = [ Orientation.RIGHT,	vertical < 0 ? false : true];
				}
				else if(mouseSide.left)
				{
					if(possibleRotation.back)	params = [ Orientation.BACK,	vertical < 0 ? true : false];
					if(possibleRotation.front)	params = [ Orientation.FRONT,	vertical < 0 ? false : true];
				}
				else if(mouseSide.right)
				{
					if(possibleRotation.back)	params = [ Orientation.BACK,	vertical < 0 ? false : true];
					if (possibleRotation.front)params = [ Orientation.FRONT,	vertical < 0 ? true : false];
				}	
			}
			
			return params;
		}
		
		// ***********************************************************
		
		public function toString():String
		{
			return StringUtils.formatToString(this,'front','back','right','left','top','bottom','topLeft','topRight','bottomLeft','bottomRight');
		}
		
	}

}

