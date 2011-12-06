package pl.flavour.utils {

	public class Strng {

		public static function isValidEmail(email:String):Boolean {
			
			//var emailExpression:RegExp = /^[a-z][\w.-]+@\w[\w.-]+\.[\w.-]*[a-z][a-z]$/i;
			
//			var emailExpression:RegExp = /([a-z0-9._-]+)@([a-z0-9.-]+)\.([a-z]{2,4})/;
			var emailExpression:RegExp = /^([a-zA-Z0-9._-]+)@([A-Za-z0-9.-]+)\.([A-Za-z]{2,4})/;
			
			return emailExpression.test(email);
			
		}
		
	}

}
