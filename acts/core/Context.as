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
	import acts.factories.IFactory;
	import acts.factories.IFactoryContext;
	
	public class Context implements IContext
	{
		private var _finder:IFinder;
		private var _factory:IFactory;
		private var _document:Object;

		public function get document():Object
		{
			return _document;
		}

		public function set document(value:Object):void
		{
			_document = value;
		}

		public function get factory():IFactory
		{
			return _factory;
		}

		public function set factory(value:IFactory):void
		{
			_factory = value;
		}

		
		public function get finder():IFinder
		{
			return _finder;
		}
		
		public function set finder(value:IFinder):void
		{
			if(value != _finder) {
				_finder = value;
			}
		}
		
		public function find(selector:String):Object {
			if (selector.charAt(0)=="*") {
				return _finder.getElements(selector.substring(1));
			} else if (selector.charAt(0)=="+") {
				return _factory.getObject(selector.substring(1));
			} else {
				return _finder.getElement(selector);
			}
		}
		
		public function finds(selector:String):Array {
			return _finder.getElements(selector);
		}
		
		public function getObject(uid:String):Object {
			return _factory.getObject(uid);
		}
	}
}