package acts.process
{
	public class Async implements IAsync
	{
		private var _host:Task;
		
		public function get host():Task
		{
			return _host;
		}
		
		public function set host(value:Task):void
		{
			_host = value;
		}
	}
}