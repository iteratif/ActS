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
	
	import flash.utils.Dictionary;

	public class BaseFactory implements IBaseFactory
	{
		private var _registry:IRegistry;
		protected var instances:Dictionary;
		
		public function get registry():IRegistry {
			return _registry;
		}
		
		public function BaseFactory(registry:IRegistry)
		{
			_registry = registry;
			instances = new Dictionary();
		}
		
		public function getObject(uid:String):Object {
			/*if(!registry.hasDefinition(uid))
				return null;*/
			
			var instance:Object = instances[uid];
			if(!instance) {
				var definition:Definition = registry.getDefinition(uid);
				instance = createObject(definition);
				if(definition.singleton) {
					instances[definition.uid] = instance;
				}
				
				if(definition.initMethod) {
					instance[definition.initMethod]();
				}
			}
			
			return instance;
		}
		
		public function setObject(uid:String, value:Object):void {
			instances[uid] = value;
		}
		
		protected function createObject(definition:Definition):Object {
			return null;
		}
	}
}