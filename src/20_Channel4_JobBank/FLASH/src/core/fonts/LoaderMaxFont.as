package core.fonts {

/*

		new LoaderMaxFont("globalFont","ExternalFont");

------------------------------------------------------------------------------

	import flash.text.TextFormat;
	import core.fonts.LoaderMaxFont;

		
			var myFormat:TextFormat = new TextFormat();
			
			//myFormat.color = 0x000000;
			//myFormat.size = 10;
			myFormat.font = LoaderMaxFont.fontRealNames["globalFont"];
			
			mytf.embedFonts = true;
			mytf.setTextFormat(myFormat);
		
		
*/
		
 	import flash.events.EventDispatcher;
	import flash.text.Font;
	import flash.utils.Dictionary;
	
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;
	
 	public class LoaderMaxFont extends EventDispatcher {
		
		public static var fontRealNames:Dictionary = new Dictionary();
		
 	 	public function LoaderMaxFont(fontID:String, fontClassName:String):void {
			
			/* get font definition class */
			var lm:SWFLoader = LoaderMax.getLoader(fontID);
			var fontClass:Class = lm.getClass(fontClassName);
			
			/* register font */
			Font.registerFont(fontClass);
			
			/* put realname into dictionary */
			fontRealNames[fontID] = new fontClass().fontName;
 	 	 	
 	 	}
	
 	}
}