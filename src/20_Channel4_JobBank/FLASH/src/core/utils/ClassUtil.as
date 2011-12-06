package core.utils {

	import flash.utils.getQualifiedClassName;
	
	public class ClassUtil {

		
    public static function getClassName(o:Object):String
	{
		
		var fullClassName:String = getQualifiedClassName(o);
		return fullClassName.slice(fullClassName.lastIndexOf("::") + 2);
		
    }			
	
    public static function getSuperClassName(o:Object):String
	{
		
		var fullClassName:String = getQualifiedClassName(o);
		return fullClassName.slice(fullClassName.lastIndexOf("::") + 2);
		
    }			
	

	}


}
