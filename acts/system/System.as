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
	import acts.factories.ObjectFactory;
	import acts.factories.registry.Registry;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mx.core.IMXMLObject;
	import mx.events.FlexEvent;
	
	[DefaultProperty("events")]
	public class System extends ASSystem implements IMXMLObject
	{	
		public var objects:Array;
		
		private var document:Object;
		
		private static var mainSystem:System;
		
		public function initialized(document:Object, id:String):void
		{
			this.document = document;
			
			if(!mainSystem) {
				mainSystem = this;
				var dom:ASDocument = new ASDocument(document as DisplayObjectContainer);
				dom.elementAdded.add(elementAddedHandler);
				_finder = new ASFinder(dom);
				
				_factory = new ObjectFactory(new Registry());
			}

			var i:int, len:int;
			if(events) {
				len = events.length;
				var h:acts.system.Event;
				for(i = 0; i < len; i++) {
					h = events[i];					
					if(!h.trigger) {
						document.addEventListener(h.type,createDelegate(h.source,h.method,h.parameters));
					} else {
						mainSystem.addEvent(h.trigger,h.type,h.source,h.method,h.parameters);
					}
				}
			}
			
			if(objects != null) {
				len = objects.length;
				for(i = 0; i < len; i++) {
					mainSystem.factory.registry.addDefinition(objects[i]);
				}
			}
		}
		
		protected override function createDelegate(source:Class, method:String, parameters:Array=null):Function {
			var f:* = super.createDelegate(source,method,parameters);
			f.finder = mainSystem.finder;
			f.factory = mainSystem.factory;
			return f;
		}
	}
}