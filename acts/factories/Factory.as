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
	import acts.factories.registry.Registry;
	import acts.system.IPlugin;
	import acts.system.ISystem;
	
	[DefaultProperty("definitions")]
	public class Factory implements IFactory
	{
		public static const FACTORY_PLUGIN_ID:String = "acts.factories.factory";
		
		public var definitions:Array;
		
		protected var _system:ISystem;
		protected var _registry:IRegistry;
		protected var _factory:IBaseFactory;
		
		public function get name():String
		{
			return FACTORY_PLUGIN_ID;
		}
		
		public function get registry():IRegistry {
			return _registry;
		}
		
		public function get factory():IBaseFactory {
			return _factory;
		}

		public function Factory(factory:IBaseFactory = null)
		{
			_factory = factory;
			if(!_factory) {
				_factory = ObjectFactory;
				_registry = ObjectFactory.registry;
			} else {
				_registry = _factory.registry;
			}
		}
		
		public function start(system:ISystem):void
		{
			_system = system;
			
			if(definitions != null) {
				var len:int = definitions.length;
				for(var i:int = 0; i < len; i++) {
					addDefinition(definitions[i]);
				}
			}
		}
		
		/**
		 *  Adds a definition to the objects factory
		 * 
		 */
		public function addDefinition(definition:Definition):void {
			var factory:IFactory = _system.mainSystem.getPlugin(FACTORY_PLUGIN_ID) as IFactory; 
			factory.registry.addDefinition(definition);
		}
	}
}