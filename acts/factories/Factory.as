package acts.factories
{
	import acts.factories.registry.Definition;
	import acts.factories.registry.IRegistry;
	import acts.factories.registry.Registry;
	import acts.system.IPlugin;
	import acts.system.ISystem;
	
	[DefaultProperty("definitions")]
	public class Factory implements IFactory
	{
		public var definitions:Array;
		
		protected var system:ISystem;
		protected var _registry:IRegistry;
		protected var _factory:IFactoryBase;
		
		public function get name():String
		{
			return "acts.factories.factory";
		}
		
		public function get registry():IRegistry {
			return _registry;
		}
		
		public function get factory():IFactoryBase {
			return _factory;
		}

		public function Factory()
		{
			_registry = new Registry();
			_factory = new ObjectFactory(_registry);
		}
		
		public function start(system:ISystem):void
		{
			this.system = system;
			
			if(definitions != null) {
				var len:int = definitions.length;
				for(var i:int = 0; i < len; i++) {
					addDefinition(definitions[i]);
				}
			}
		}
		
		/**
		 *  Adds a definition to the objects factory
		 * 
		 */
		public function addDefinition(definition:Definition):void {
			var factory:IFactory = system.mainSystem.getPlugin("acts.factories.factory") as IFactory; 
			factory.registry.addDefinition(definition);
		}
	}
}