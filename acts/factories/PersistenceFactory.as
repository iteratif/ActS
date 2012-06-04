package acts.factories
{
	import acts.factories.registry.PersistenceRegistry;

	public const PersistenceFactory:PersistenceFactoryImpl = new PersistenceFactoryImpl(new PersistenceRegistry());
}