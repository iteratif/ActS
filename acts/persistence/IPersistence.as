package acts.persistence
{
	import acts.factories.IFactory;
	
	public interface IPersistence extends IFactory
	{
		function save(uid:String):void;
	}
}