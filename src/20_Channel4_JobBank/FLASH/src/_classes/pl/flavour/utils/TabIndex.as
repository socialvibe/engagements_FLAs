package pl.flavour.utils { 
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import com.greensock.*; 
	import com.greensock.easing.*;


	public class TabIndex extends MovieClip {

		public function TabIndex() {
		
			
		}
		
		public static function setIndexes(arr:Array) {
			
			
			
			
			for (var i = 0; i < arr.length; i++) {
				
				arr[i].tabEnabled = true;
				arr[i].tabIndex = (i+1);
				
			}
			
		}
		
	}
	
	
}