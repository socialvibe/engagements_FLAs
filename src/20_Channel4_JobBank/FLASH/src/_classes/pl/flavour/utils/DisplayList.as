package pl.flavour.utils {

	public class DisplayList {

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
