package acts.process
{
	public interface IAsync
	{
		function get host():Task;
		function set host(value:Task):void;
	}
}