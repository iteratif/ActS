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
package acts.system
{
	import acts.display.ASDocument;
	import acts.display.ASFinder;
	import acts.factories.IFactory;
	import acts.factories.ObjectFactory;
	import acts.factories.registry.Registry;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mx.core.IMXMLObject;
	import mx.events.FlexEvent;
	
	[DefaultProperty("actions")]
	public class System extends ASSystem implements IMXMLObject
	{	
		public var objects:Array;
		public var actions:Array;
		
		private var document:Object;
		
		public function System(document:DisplayObjectContainer = null, factory:IFactory = null):void {
			var dom:ASDocument = null;
			if(document) {
				this.document = document;
				dom = new ASDocument(document);
			}
			super(dom,factory);
		}
		
		public function initialized(document:Object, id:String):void {
			this.document = document;
		
			var dom:ASDocument = new ASDocument(document as DisplayObjectContainer);
			dom.elementAdded.add(elementAddedHandler);
			_finder = new ASFinder(dom);

			var i:int, len:int;
			if(actions) {
				len = actions.length;
				var action:acts.system.Action;
				for(i = 0; i < len; i++) {
					action = actions[i];
					if(!action.trigger)
						action.trigger = document;
					addAction(action);
				}
			}
			
			if(objects != null) {
				len = objects.length;
				for(i = 0; i < len; i++) {
					addDefinition(objects[i]);
				}
			}
		}
	}
}