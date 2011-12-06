package core.base { 
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class InputTextFieldBase extends MovieClip {
		
		public function InputTextFieldBase() {
			
			this['mytf'].text = "";
			gotoAndStop(1);
			
		}

		public function setValue(what) {
			
			return this['mytf'].text = what;
			
		}
		
		public function getValue() {
			
			return this['mytf'].text;
			
		}
		
		public function getTextFieldReference() {
			
			return this['mytf'];
			
		}
		
		public function mark() {
			
			this['border'].gotoAndStop(2);
			
		}
		
		public function unmark() {
			
			this['border'].gotoAndStop(1);
			
		}
		
		
	}
	
	
}