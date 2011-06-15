package acts.process
{
	import acts.core.IContext;
	import acts.display.IFinder;
	import acts.factories.Factory;
	
	public class AsyncContext extends Async implements IContext
	{
		private var _factory:Factory;
		private var _finder:IFinder;
		
		public function get factory():Factory
		{
			return _factory;
		}
		
		public function set factory(value:Factory):void
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
	}
}