package acts.process
{
	import acts.core.IContext;
	import acts.display.IFinder;
	import acts.factories.IFactory;
	
	public class AsyncContext extends Async implements IContext
	{
		private var _factory:IFactory;
		private var _finder:IFinder;
		
		private var _document:Object;
		
		public function get document():Object
		{
			return _document;
		}
		
		public function set document(value:Object):void
		{
			_document = value;
		}
		
		public function get factory():IFactory
		{
			return _factory;
		}
		
		public function set factory(value:IFactory):void
		{
			_factory = value;
		}
		
		public function get finder():IFinder
		{
			return _finder;
		}
		
		public function set finder(value:IFinder):void
		{
			_finder = value;
		}
		
		public function find(selector:String):Object {
			if (selector.charAt(0)=="*") {
				return _finder.getElements(selector.substring(1));
			} else if (selector.charAt(0)=="+") {
				return _factory.getObject(selector.substring(1));
			} else {
				return _finder.getElement(selector);
			}
		}
		
		public function finds(selector:String):Array {
			return _finder.getElements(selector);
		}
		
		public function getObject(uid:String):Object {
			return _factory.getObject(uid);
		}
		
		public function setObject(uid:String, value:Object):void {
			return _factory.setObject(uid,value);
		}
	}
}