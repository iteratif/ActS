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
package acts.system {
	import acts.display.ASDocument;
	import acts.display.ASFinder;
	import acts.display.IFinder;

	/**
	 * the ASSystem class is the class base that implement the logic for connecting the views and the action classes.
	 * Inside the ASSystem uses the ASDocument and ASFinder class for make the connections.
	 * 
	 * @see acts.system.System
	 * @see acts.display.ASDocument
	 * @see acts.display.ASFinder
	 * 
	 */
	public class ASSystem implements ISystem {
		protected var _finder:IFinder;
		protected var _document:Object;
		protected var _dom:ASDocument;
		protected var registry:Object;
		
		/**
		 * Specify the component that uses this ASSystem class.  
		 * 
		 */
		public function get document():Object {
			return _document;
		}
		
		public function get asDocument():ASDocument {
			return _dom;
		}
		
		internal var _mainSystem:ISystem;
		
		/**
		 * A reference to the top-level System.
		 * 
		 */
		public function get mainSystem():ISystem {
			return _mainSystem;
		}
		
		/**
		 * The ASSystem class uses the ASFinder object which finds the view elements.
		 * 
		 */
		public function get finder():IFinder {
			return _finder;
		}
		
		
		/**
		 * Constructor.
		 * 
		 */
		public function ASSystem(dom:ASDocument = null) {
			registry = {};
			
			if(!_mainSystem)
				_mainSystem = this; 
			
			if(dom) {
				_document = dom.rootDocument;
				_finder = new ASFinder(dom);
				_dom = dom;
			}
		}
		
		public function getPlugin(name:String):IPlugin
		{
			return registry[name];
		}
		
		public function registryAndStart(plugin:IPlugin):void {
			registry[plugin.name] = plugin;
			plugin.start(this);
		}
	}
}