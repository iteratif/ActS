package acts.factories
{
	import acts.factories.Container;
	import acts.factories.registry.Definition;
	import acts.factories.registry.IRegistry;
	
	internal class PersistenceFactoryImpl extends ObjectFactoryImpl
	{
		public function PersistenceFactoryImpl(registry:IRegistry)
		{
			super(registry);
		}
		
		public override function getObject(uid:String):Object {
			var container:Container = super.getObject(uid+"Container") as Container;
			return container.instance;
		}
	}
}