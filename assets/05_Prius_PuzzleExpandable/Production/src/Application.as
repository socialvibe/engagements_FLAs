//AS3///////////////////////////////////////////////////////////////////////////
// 
// Copyright 2011 
// 
////////////////////////////////////////////////////////////////////////////////

package
{

	import cc.core.AbstractApplication;
	import cc.proxies.GlossaryProxy;
	import cc.commands.InitCommand;
	import cc.text.TextFormats;
	import cc.text.Text;

	import com.nesium.logging.TrazzleLogger;

	import flash.events.Event;
	import flash.display.Sprite;
	import flash.text.Font;
	import flash.text.TextFormat;
	
	import com.toyota.commands.*;
	import com.toyota.proxies.*;
	import com.toyota.views.*;

	/**
	 * Application entry point for ToyotaPrius.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @author Carl Calderon (carl.calderon@gmail.com)
	 * @since 28.03.2011
	 */
	[SWF(width='300', height='250', backgroundColor='#FFFFFF', frameRate='24')]
	public class Application extends AbstractApplication
	{
	
		/*
		Uppercase: 		U+0020,U+0041-U+005A
		Lowercase: 		U+0020,U+0061-b+007A
		Numerals: 		U+0030-U+0039,U+002E
		Punctuation: 	U+0020-U+002F,U+003A-U+0040,U+005B-U+0060,U+007B-U+007E
		Basic Latin: 	U+0020-U+002F, U+0030-U+0039, U+003A-U+0040, U+0041-U+005A, U+005B-U+0060, U+0061-U+007A, U+007B-U+007E
		Parts (½⅓⅔¼¾⅕⅖⅗⅘⅙⅚⅛⅜⅝⅞): U+00BD U+2153 U+2154 U+00BC U+00BE U+2155 U+2156 U+2157 U+2158 U+2159 U+215A U+215B U+215C U+215D U+215E
		ÅåÄäÖöÆæÜüÁáÉéÀàÈèÊêÎî’‵′“”°™®©: U+00C5 U+00E5 U+00C4 U+00E4 U+00D6 U+00F6 U+00C6 U+00E6 U+00DC U+00FC U+00C1 U+00E1 U+00C9 U+00E9 U+00C0 U+00E0 U+00C8 U+00E8 U+00CA U+00EA U+00CE U+00EE U+2019 U+2035 U+2032 U+201C U+201D U+00B0 U+2122 U+00AE U+00A9
		*/
		
		[Embed(source="../ttf/HelveticaNeueLTStd-Md.ttf", embedAsCFF="false", fontName="_HelveticaNeue", mimeType="application/x-font", unicodeRange="U+0020-U+002F, U+0030-U+0039, U+003A-U+0040, U+0041-U+005A, U+005B-U+0060, U+0061-U+007A, U+007B-U+007E, U+00C5, U+00E5, U+00C4, U+00E4, U+00D6, U+00F6, U+00C9, U+00E9, U+2022")]
		private static var HelveticaNeueMedium: Class;
		Font.registerFont( HelveticaNeueMedium );
		
		[Embed(source="../ttf/HelveticaNeueLTStd-Bd.ttf", embedAsCFF="false", fontWeight="bold", fontName="_HelveticaNeue", mimeType="application/x-font", unicodeRange="U+0020-U+002F, U+0030-U+0039, U+003A-U+0040, U+0041-U+005A, U+005B-U+0060, U+0061-U+007A, U+007B-U+007E, U+00C5, U+00E5, U+00C4, U+00E4, U+00D6, U+00F6, U+00C9, U+00E9, U+2022")]
		private static var HelveticaNeueBold: Class;
		Font.registerFont( HelveticaNeueBold );
		
		[Embed(source="../ttf/HelveticaNeueLTPro-BlkCnO.ttf", embedAsCFF="false", fontWeight="bold", fontName="_HelveticaNeueProBold", mimeType="application/x-font", unicodeRange="U+0020-U+002F, U+0030-U+0039, U+003A-U+0040, U+0041-U+005A, U+005B-U+0060, U+0061-U+007A, U+007B-U+007E, U+00C5, U+00E5, U+00C4, U+00E4, U+00D6, U+00F6, U+00C9, U+00E9, U+2022")]
		private static var HelveticaNeueBoldCondensedOblique: Class;
		Font.registerFont( HelveticaNeueBoldCondensedOblique );
		
		[Embed(source="../ttf/HelveticaNeueLTPro-MdCn.ttf", embedAsCFF="false", fontName="_HelveticaNeueProMedium", mimeType="application/x-font", unicodeRange="U+0020-U+002F, U+0030-U+0039, U+003A-U+0040, U+0041-U+005A, U+005B-U+0060, U+0061-U+007A, U+007B-U+007E, U+00C5, U+00E5, U+00C4, U+00E4, U+00D6, U+00F6, U+00C9, U+00E9, U+2022")]
		private static var HelveticaNeueMediumCondensed: Class;
		Font.registerFont( HelveticaNeueMediumCondensed );
		
		[Embed(source="../ttf/HelveticaNeueLTPro-MdCnO.ttf", embedAsCFF="false", fontStyle="italic", fontName="_HelveticaNeueProMedium", mimeType="application/x-font", unicodeRange="U+0020-U+002F, U+0030-U+0039, U+003A-U+0040, U+0041-U+005A, U+005B-U+0060, U+0061-U+007A, U+007B-U+007E, U+00C5, U+00E5, U+00C4, U+00E4, U+00D6, U+00F6, U+00C9, U+00E9, U+2022")]
		private static var HelveticaNeueMediumCondensedOblique: Class;
		Font.registerFont( HelveticaNeueMediumCondensedOblique );
		
		/**
		 * @constructor
		 */
		public function Application()
		{
			super();
			
			fonts();
			
			stage.align		= 'TL';
			stage.scaleMode = 'noScale';
			
			TrazzleLogger.instance().setParams(stage, "Toyota - Prius");
			
			// states
			state.add('root',	'load');
			state.add('root',	'away');
			
			// controls
			control.add('init', 		new InitCommand());
			control.add('goto', 		new GotoCommand());
			control.add('load', 		new LoadCommand());
			control.add('shuffle', 		new ShuffleCommand());
			control.add('solve', 		new SolveCommand());
			
			// proxies
			proxy.add('glossary',		new GlossaryProxy());
			proxy.add('asset',			new AssetProxy());
			proxy.add('game',			new GameProxy());
			
			// views
			view.add(new LoadView());
			view.add(new Away3DView());
			
			// > expose
			
			log(state);
			
			// < expose
			
			// go!
			state.activate('load');
		}
		
		protected function fonts(): void {
			var txt: TextFormat 		= new TextFormat("_HelveticaNeueProMedium", 11, 0x222222);
			TextFormats.addFormat("text", txt);
		}
		
	}

}