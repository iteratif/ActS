package acts.factories
{
	import acts.factories.registry.Definition;
	import acts.factories.registry.IRegistry;

	public interface IFactory
	{
		function get registry():IRegistry;
		function getObject(uid:String):Object;
		// Remove dependency at Definition
		function createObject(definition:Definition):Object;
	}
}