package cc.utils
{
	
	import flash.utils.describeType;
	import flash.xml.XMLNode;
	
	public class ClassUtils
	{
		
		public static function expose(type:*,immediate:Boolean = true):String
		{
			var str:String='package %PACKAGE%\n{\n\n%IMPORT%\n\n\tpublic %STYLE% class %NAME% %EXTENDS%\n\t{\n\n%VARS%%CONSTRUCTOR%\n\n%METHODS%%ACCESSORS%\n\n\t}\n}';
			function r(s:String,w:String):String
			{
				return str.split(s).join(w);
			}
			function c(s:String):String
			{
				return s.replace(/\:\:/gi,'.');
			}
			function cs(s:String):String
			{
				if(s.indexOf('::')>-1)
					return s.substr(s.lastIndexOf('::')+2);
				return s;
			}
			function imp(s:String):void
			{
				if(imports.indexOf(s)==-1 && s.indexOf('.')>-1)
					imports.push(s);
			}
			var desc:XML = describeType(type);
			
			var style	:Array 	= [];
			var imports	:Array 	= [];
			var vars	:Array 	= [];
			var accs	:Array 	= [];
			var mets	:Array	= [];
			var t		:String = '';
			var params:Array;
			var paramType:String;
			var inc:int;
			if(desc.@isDynamic=='true')	style.push('dynamic');
			if(desc.@isFinal=='true')	style.push('final');
			if(desc.@isStatic=='true')	style.push('static');
			var ext:XML = desc..extendsClass[0]
			var extStr:String = ''
			if(ext) if(ext.@type)
			{
				extStr = c(String(ext.@type));
				imp(extStr);
			}
			
			str = r('%NAME%',cs(String(desc.@name)));
			str = r('%PACKAGE%',String(desc.@name).substr(0,String(desc.@name).indexOf('::')));
			str = r('%STYLE%',style.join(' '));
			if(extStr!='')
			{
				extStr = ' extends '+ cs(desc..extendsClass[0].@type);
			}
			str = r('%EXTENDS%', extStr);
			
			// constructor
			var cstr:String = 'public function '+cs(String(desc.@name))+'() {}';
			if(desc.constructor)
			{
				params = [];
				inc = -1;
				for each (var cparNode:XML in desc.constructor..parameter)
				{
					paramType = cparNode.@type;
					imp(c(String(cparNode.@type)));
					params.push('arg'+String(++inc) + ':' +cs(String(cparNode.@type))); 
				}
			}
			str = r('%CONSTRUCTOR%', '\t\t'+cstr+'\n\n');
			
			// vars
			for each(var varNode:XML in desc..variable)
			{
				t = cs(String(varNode.@type));
				imp(String(varNode.@type));
				vars.push( '\t\tpublic var ' + varNode.@name + ':' + t);
			}
			str = r('%VARS%',vars.join(';\n\n')+((vars.length>0)?';\n\n':''));
			
			// accessors
			for each(var accNode:XML in desc..accessor)
			{
				t = cs(String(accNode.@type));
				var access:String = accNode.@access;
				if(desc.@name==accNode.@type || !immediate)
				{
					imp(c(String(accNode.@type)));
					if(access=='readonly' || access=='readwrite')
					{
						accs.push( '\t\tpublic function get ' + accNode.@name + '():' + t + ' { }');
					}
					if(access=='writeonly' || access=='readwrite')
					{
						accs.push( '\t\tpublic function set ' + accNode.@name + '(value:'+t+') { }');
					}
				}
			}
			str = r('%ACCESSORS%',accs.join('\n\n'));
			
			// methods
			for each(var metNode:XML in desc..method)
			{
				if(desc.@name==metNode.@declaredBy || !immediate)
				{
					params = [];
					t = cs(String(metNode.@returnType));
					imp(c(String(metNode.@returnType)));
					inc = -1;
					for each (var parNode:XML in metNode..parameter)
					{
						paramType = parNode.@type;
						imp(c(String(parNode.@type)));
						params.push('arg'+String(++inc) + ':' +cs(String(parNode.@type))); 
					}
					mets.push( '\t\tpublic function ' + metNode.@name + '('+params.join(', ')+'):' + t + ' { }');
				}
			}
			str = r('%METHODS%',mets.join('\n\n')+'\n\n');
			
			// imports
			imports.sort();
			str = r('%IMPORT%','\timport  '+imports.join(';\n\timport ')+';\n\n');
			return str;
				
		}
		
	}

}