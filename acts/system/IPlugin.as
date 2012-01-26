package acts.system
{
	public interface IPlugin
	{
		function get name():String;
		function start(system:ISystem):void;
	}
}