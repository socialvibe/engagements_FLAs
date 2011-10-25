package cc.proxies
{
	import cc.core.Glossary;
	
	import cc.proxies.XMLProxy;
	
	public class GlossaryProxy extends XMLProxy
	{
		
		public function GlossaryProxy()
		{
			super();
		}
		
		override protected function parse(data:XML):void
		{
			var glossary:Glossary = new Glossary();
			for each(var term:XML in data..term)
			{
				glossary.add(term.@id,term.text().toString().replace(/\\n/gim,"\n"));
			}
			
			// replaces ${key} reference terms.
			var t:String;
			var k:String;
			for (var i:int = 0; i < glossary.length; i++)
			{
				k = glossary.getHashAt(i).key;
				t = glossary.getHashAt(i).value;
				var idx:int = t.indexOf('${');
				var f:String;
				while(idx>-1)
				{
					f = t.substring(idx+2,t.indexOf('}',idx+2));
					if(glossary.has(f))
					{
						t = t.split('${'+f+'}').join(glossary.get(f));
					}
					idx = t.indexOf('${');
				}
				glossary.removeAt(i);
				glossary.addAt(k,t,i);
			}
		}
		
		override public function toString():String
		{
			return '[GlossaryProxy]';
		}
		
	}

}

