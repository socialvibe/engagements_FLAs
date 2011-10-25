package cc.core
{
	
	import cc.errors.CCError;
	import cc.core.HashMap;
	import RegExp;
	
	/**
	 * Application Glossary
	 * NOT locale based dictionary.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 10.0.0
	 * 
	 * @author Carl Calderon (carl.calderon@gmail.com)
	 * @since  14.01.2011
	 */
	public class Glossary extends HashMap
	{
		
		/**
		 * @private
		 * Singleton reference
		 */
		private static var glossary:Glossary;
		
////////////////////////////////////////////////////////
//
//	Constructor
//
////////////////////////////////////////////////////////

		/**
		 * @constructor
		 * Creates the Glossary singleton
		 * @throws cc.errors.CCError If singleton violation
		 */
		public function Glossary()
		{
			super();
			if(glossary)
				throw new CCError('Glossary is already instanciated (singleton).');
			glossary = this;
		}
		
		/**
		 * Retrieves a Term based on specified id
		 * @param id String 	Term id
		 * @param args Array	All additional arguments will be replacing
		 * 						#{n} in the requested string.
		 * @return Term
		 */
		public static function getTerm(id:String,...args:Array):String
		{
			var term:String = glossary.get(id);
			var regexp:RegExp;
			if(args)
			{
				for (var i:int = 0; i < args.length; i++)
				{
					regexp = new RegExp('#[{]'+i+'[}]','g');
					term = term.replace(regexp,args[i]);
				}
			}
			return term || id;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			return '[Glossary length='+length+']';
		}
		
		/**
		 * Exposes all terms within the Glossary
		 * Evaluated version of #toString()
		 */
		public static function expose():String
		{
			var str:String = '[Glossary]';
			var hash:Object;
			for (var i:int = 0; i < length; i++)
			{
				hash = glossary.getHashAt(i);
				str += '\n'+hash.key+'='+hash.value;
			}
			return str;
		}
		
		/**
		 * String represenation of the Glossary
		 */
		public static function toString():String
		{
			return '[Glossary length='+length+']';
		}
	}

}