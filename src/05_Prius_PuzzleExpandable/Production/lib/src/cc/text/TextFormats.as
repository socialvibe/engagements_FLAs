package cc.text
{
	
	import cc.core.HashMap;
	import flash.text.TextFormat;
	
	public class TextFormats extends HashMap
	{
		
		private static var instance:TextFormats;
		
		public function TextFormats()
		{
			super();
			instance = this;
		}
		
		public static function getFormat(id:String):TextFormat
		{
			return instance.get(id);
		}
		
		public static function addFormat(id:String,format:TextFormat):void
		{
			if(!instance)
				instance = new TextFormats();
			
			instance.add(id,format);
		}
		
	}

}