package com.toyota.prius.puzzle.utils 
{
	
	/**
	 * ...
	 * @author jin
	 */
	public class Vector3D extends Object
	{
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _z:Number = 0;
		
		private var _rotationX:Number = 0;
		private var _rotationY:Number = 0;
		private var _rotationZ:Number = 0;
		
		public function Vector3D( __x:Number=0, __y:Number=0, __z:Number=0, __rx:Number=0, __ry:Number=0, __rz:Number=0 ) 
		{
			_x = __x;
			_y = __y;
			_z = __z;
		
			_rotationX = __rx;
			_rotationY = __ry;
			_rotationZ = __rz;
		}
		
		public function get x():Number { return _x;  };
		public function get y():Number { return _y;  };
		public function get z():Number { return _z;  };
		public function get rotationX():Number { return _rotationX;  };
		public function get rotationY():Number { return _rotationY;  };
		public function get rotationZ():Number { return _rotationZ;  };
		
		public function set x( value:Number ):void { _x = value;  };
		public function set y( value:Number ):void { _y = value; };
		public function set z( value:Number ):void { _z = value;  };
		public function set rotationX( value:Number ):void { _rotationX = value;  };
		public function set rotationY( value:Number ):void { _rotationY = value;  };
		public function set rotationZ( value:Number ):void { _rotationZ = value;  };
		
	}
	
}