package acts.core
{
	import acts.system.IPlugin;
	import acts.system.ISystem;
	
	use namespace acts_internal;

	public class BaseContext implements IContext
	{	
		acts_internal var systemContext:ISystem;
		
		public function BaseContext()
		{
			
		}
		
		public function initialize():void {
			
		}
	}
}