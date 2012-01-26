package acts.validations
{
	import acts.system.IPlugin;
	import acts.system.ISystem;
	
	[DefaultProperty("rules")]
	public class Validation implements IPlugin
	{
		public var rules:Array;
		protected var system:ISystem;
		
		public function get name():String
		{
			return "acts.validations.validation";
		}
		
		public function Validation()
		{
		}
		
		public function start(system:ISystem):void
		{
			this.system = system;
		}
		
	}
}