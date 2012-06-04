package acts.persistence
{
	import acts.factories.Factory;
	import acts.factories.IFactory;
	import acts.factories.PersistenceFactory;
	import acts.factories.registry.Definition;
	import acts.factories.registry.PersistenceRegistry;
	import acts.factories.registry.Registry;
	import acts.system.IPlugin;
	import acts.system.ISystem;
	
	public class Persistence extends Factory implements IPersistence {
		public static const PERSISTENCE_PLUGIN_ID:String = "acts.persistence.Persistence";
		
		public override function get name():String
		{
			return PERSISTENCE_PLUGIN_ID;
		}

		public function Persistence()
		{
			super(PersistenceFactory);
		}
		
		public function save(uid:String):void {
			
		}
		
		/**
		 *  Adds a definition to the objects factory
		 * 
		 */
		public override function addDefinition(definition:Definition):void {
			var factory:IFactory = _system.mainSystem.getPlugin(PERSISTENCE_PLUGIN_ID) as IFactory; 
			factory.registry.addDefinition(definition);
		}
	}
}