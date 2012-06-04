/*

The contents of this file are subject to the Mozilla Public License Version
1.1 (the "License"); you may not use this file except in compliance with
the License. You may obtain a copy of the License at 

http://www.mozilla.org/MPL/ 

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
for the specific language governing rights and limitations under the License. 

The Original Code is Acts (Actionscript Activity).

The Initial Developer of the Original Code is
Olivier Bugalotto (aka Iteratif) <olivier.bugalotto@iteratif.net>.
Portions created by the Initial Developer are Copyright (C) 2008-2011
the Initial Developer. All Rights Reserved.

Contributor(s) :

*/
package acts.factories
{
	import acts.factories.registry.Definition;
	import acts.factories.registry.IRegistry;
	import acts.factories.registry.Property;
	
	import flash.utils.Dictionary;

	internal class ObjectFactoryImpl extends BaseFactory
	{
		public function ObjectFactoryImpl(registry:IRegistry)
		{
			super(registry);
		}
		
		protected override function createObject(definition:Definition):Object {
			var type:Class = definition.type;
			var instance:Object = new type();
			setProperties(instance,definition.properties);
			return instance;
		}
		
		protected function setProperties(instance:Object, properties:Array):void {
			var len:int = properties.length;
			var property:Property;
			for(var i:int = 0; i < len; i++) {
				property = properties[i];
				if(instance.hasOwnProperty(property.name)) {
					if(property.ref)
						instance[property.name] = super.getObject(property.ref);
					else
						instance[property.name] = property.value;
				}
			}
		}
	}
}