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
package acts.core
{
	import acts.display.IFinder;
	import acts.display.IViewContext;
	import acts.factories.IBaseFactory;
	import acts.factories.IFactory;
	import acts.factories.IFactoryContext;
	import acts.persistence.IPersistence;
	import acts.system.ISystem;
	
	use namespace acts_internal;
	
	public class Context extends BaseContext
	{
		private var _factory:IBaseFactory;
		private var _pFactory:IBaseFactory;
		private var _persistence:IPersistence;

		public function get document():Object
		{
			return systemContext.document;
		}
		
		public function get finder():IFinder
		{
			return systemContext.finder;
		}
		
		public function get persistence():IPersistence {
			if(!_persistence) {
				_persistence = systemContext.getPlugin("acts.persistence.Persistence") as IPersistence;
			}
			return _persistence;
		}
		
		public function Context():void {
			
		}
		
		public function find(selector:String):Object {
			if (selector.charAt(0)=="*") {
				return systemContext.finder.getElements(selector.substring(1));
			} else if (selector.charAt(0)=="+") {
				return _factory.getObject(selector.substring(1));
			} else {
				return systemContext.finder.getElement(selector);
			}
		}
		
		public function finds(selector:String):Array {
			return systemContext.finder.getElements(selector);
		}
		
		public function getEntity(uid:String):Object {
			if(!_pFactory) {
				var plugin:IPersistence = systemContext.getPlugin("acts.persistence.Persistence") as IPersistence;
				_pFactory = plugin.factory;
			}
			return _pFactory.getObject(uid);
		}
		
		public function getObject(uid:String):Object {
			if(!_factory) {
				var plugin:IFactory = systemContext.getPlugin("acts.factories.factory") as IFactory;
				_factory = plugin.factory;
			}
			return _factory.getObject(uid);
		}
	
		public function setObject(uid:String, value:Object):void {
			if(!_factory) {
				var plugin:IFactory = systemContext.getPlugin("acts.factories.factory") as IFactory;
				_factory = plugin.factory;
			}
			return _factory.setObject(uid,value);
		}
	}
}