package { 
	import flash.display.Sprite;
	
	public class Arrange {

		public static function bringToFront(what) {
			
			what.parent.setChildIndex(what, what.parent.numChildren-1);
		}
		
		public static function sendToBack(what) {
			
			what.parent.setChildIndex(what, 0);
		}

		public static function bringForward(what) {
			
			var currentDepth = what.parent.getChildIndex(what);
			
			if (currentDepth < what.parent.numChildren - 1) {
				
				what.parent.setChildIndex(what, currentDepth + 1); 
				
			}
			
		}

		public static function sendBackward(what) {
			
			var currentDepth = what.parent.getChildIndex(what);
			
			if (currentDepth > 0) {
				what.parent.setChildIndex(what, currentDepth-1); 
			}
			
		}
		
		
		public static function removeAllChildrens(_container) {
			
			var i : Number = _container.numChildren;
			if(i > 0) {
				while (i--) {
					_container.removeChildAt(i);
				}
			}
			
		}
		
		
	}
	
	
}