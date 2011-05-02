package acts.display
{
	public class Expression
	{
		public var name:String;
		public var step:Array;
		public var type:String;
		
		public function Expression(name:String, type:String, step:Array)
		{
			this.name = name;
			this.type = type;
			this.step = step;
		}
	}
}