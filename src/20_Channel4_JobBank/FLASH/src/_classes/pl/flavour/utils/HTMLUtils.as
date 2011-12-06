package pl.flavour.utils {

	import pl.flavour.utils.Strng;
	
	public class HTMLUtils {
		
		
		public static function makeClickableEmails(what:String) {
			
			var ret = findValidEmailAddress(what);
			
			if (ret!="") {
				
			var ss:Array = what.split(ret);
			
			var arr:Array = [];
			
				for (var i=0; i<ss.length; i++) {
					
				arr.push(ss[i]);
				if (i!=ss.length-1)
				arr.push(ret);
				
				}
		
		
		var oo:String = "";
		
		for (i=0; i<arr.length; i++) {
			
			if (Strng.isValidEmail(arr[i]))
			oo=oo+"<a href=\"mailto:"+arr[i]+"\">"+arr[i]+"</a>";
			else
			oo=oo+HTMLUtils.makeClickableEmails(arr[i]);

		}
		
		return oo;
		
	} else return what;
	
	
	
	}
	
	public static function findValidEmailAddress($str:String):String {
	
	var pattern:RegExp = /([a-zA-Z0-9._-]+)@([A-Za-z0-9.-]+)\.([A-Za-z]{2,4})/;
	var result:Object = pattern.exec($str);
	
	return ((result == null) ? "" : result[0]);
	}
	
		

		
	}

}
