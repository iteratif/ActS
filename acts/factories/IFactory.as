package acts.factories
{
	import acts.factories.registry.IRegistry;
	import acts.system.IPlugin;
	
	public interface IFactory extends IPlugin
	{
		function get registry():IRegistry;
		function get factory():IFactoryBase;
	}
}