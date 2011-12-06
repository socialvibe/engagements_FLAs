package 
{
	import flash.net.navigateToURL;	
	import flash.net.URLRequest;
	
	public class Web
	{
		public static function getURL(url:String, window:String = "_self"):void
		{
			
			var req:URLRequest = new URLRequest(url);
			try 
			{
				navigateToURL(req, window);
			} 
			catch (e:Error) 
			{
				Trace.add("Navigate to URL failed", e.message);
			}
		}
	}
}