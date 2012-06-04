package acts.persistence
{
	import acts.factories.registry.Definition;
	import acts.factories.registry.Property;

	public class PersistenceUnit extends Definition
	{
		public var provider:Class;
		public var dest:String;
		
		public function PersistenceUnit()
		{
			
		}
	}
}