package core.utils {

	import flash.xml.XMLDocument;
	
	public class HTMLUtil {
		
		// unscape html entities
		
		public static function htmlUnescape(str:String):String
		{
			return new XMLDocument(str).firstChild.nodeValue;
		}
		
		
		// remove html tags
		
		public static function removeHTMLTags(what:String):String 
		{
			
			var removeHtmlRegExp:RegExp = new RegExp("<[^<]+?>", "gi");
			return what.replace(removeHtmlRegExp, "");
			
		}
		
		public static function makeClickableURL(what:String, prefix:String="", postfix:String="", cutString="http://") {
			
			// link to <a href>
			what = what.replace(/(((f|ht){1}tp:\/)[-a-zA-Z0-9@:%_\+.~#?&\/=]+)/g, prefix + "<a target='_blank' href='$1'>$1</a>" + postfix);
			
			// removes http:// from href
			what = what.replace(/(?<!href=["\'])http:\/\//, "");
			
			
			return what;
			
		}
		
		// make clickable emails in texts
		
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
			
				for (i = 0; i < arr.length; i++) {
					
					if (StringUtil.isValidEmail(arr[i]))
					oo=oo+"<a href=\"mailto:"+arr[i]+"\">"+arr[i]+"</a>";
					else
					oo = oo + HTMLUtil.makeClickableEmails(arr[i]);
				
				}
				
				return oo;
				
			} else return what;
			
			// find valid email address
			
			function findValidEmailAddress($str:String):String {
			
			var pattern:RegExp = /([a-zA-Z0-9._-]+)@([A-Za-z0-9.-]+)\.([A-Za-z]{2,4})/;
			var result:Object = pattern.exec($str);
			
			return ((result == null) ? "" : result[0]);
			
			}
		
	}

	}

}
