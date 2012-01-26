package acts.system
{
	import acts.display.ASDocument;
	import acts.display.IFinder;

	public interface ISystem
	{
		function get document():Object;
		function get asDocument():ASDocument;
		function get mainSystem():ISystem;
		function get finder():IFinder;
		function getPlugin(name:String):IPlugin;
	}
}