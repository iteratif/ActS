package acts.utils
{
	import flash.utils.getQualifiedClassName;

	public class ClassUtil
	{
		public static function unqualifiedClassName(object:Object):String {
			var name:String;
			if (object is String)
				name = object as String;
			else
				name = getQualifiedClassName(object);
			
			var index:int = name.indexOf("::");
			if (index > -1)
				name = name.substr(index + 2);
			
			return name;
		}
	}
}