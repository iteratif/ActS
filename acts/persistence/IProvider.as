package acts.persistence
{
	public interface IProvider
	{
		function load(o:Object = null):void;
		function save(o:Object):void;
	}
}