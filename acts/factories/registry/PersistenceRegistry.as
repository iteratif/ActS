package acts.factories.registry
{
	import acts.factories.Container;
	import acts.persistence.PersistenceUnit;

	public class PersistenceRegistry extends Registry
	{
		public function PersistenceRegistry()
		{
			super();
		}
		
		public override function addDefinition(definition:Definition):void {
			// idée : lorsque j'ajoute une définition j'en ajoute deux autre
			var unit:PersistenceUnit = definition as PersistenceUnit;
			if(unit) {
				super.addDefinition(new Definition(unit.uid,unit.type,unit.singleton));
				
				var definition:Definition = new Definition(unit.uid+"Provider",unit.provider,unit.singleton);
				definition.properties = [new Property("destination",unit.dest)];
				super.addDefinition(definition);
				
				var properties:Array = [new Property("instance",null,unit.uid),new Property("provider",null,unit.uid+"Provider")];
				var defContainer:Definition = new Definition(unit.uid+"Container",Container,unit.singleton);
				defContainer.initMethod = "load";
				defContainer.properties = properties;
				super.addDefinition(defContainer);
			}
		}
	}
}