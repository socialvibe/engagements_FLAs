package core.utils { 
	
	public class StringUtil {

		public function StringUtil() {
		
			
		}
		
		// repair enters in text
		
		public static function splitBR(what:String) {
			
			what = (what.split('\n')).join('');
			
			return what;
			
		}
		
		// validate email
		public static function isValidEmail(email:String):Boolean {
			
			var emailExpression:RegExp = /^([a-zA-Z0-9._-]+)@([A-Za-z0-9.-]+)\.([A-Za-z]{2,4})/;
			return emailExpression.test(email);
			
		}
		
		// make friendly ID string
		
		public static function stringToFriendlyID(what:String) {
			
			what = what.toLowerCase();
			what = what.split(" ").join("_");  
			what = what.split("-").join("_");  
			
			var r:RegExp = new RegExp(/[^a-zA-Z_0-9]+/g) ;
			what = what.replace(r, "");
			
			return what;
			
		}		
		
		// parse color in "#xxxxxx" format
		
		public static function parseStringColor(what:String) {
			
			var w = what.substr(1, what.length - 1);
			return parseInt(w, 16);
			
		}
		
		
	}
	
	
}