package acts.factories
{
	import acts.factories.registry.Registry;

	public const ObjectFactory:ObjectFactoryImpl = new ObjectFactoryImpl(new Registry());
}