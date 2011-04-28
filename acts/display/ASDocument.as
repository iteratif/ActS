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
package acts.display
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	public class ASDocument extends EventDispatcher
	{
		private var typedElements:Dictionary;
		private var namedElements:Dictionary;
		
		private var displayObject:DisplayObject;
		
		public function get rootDocument():DisplayObject {
			return displayObject;
		}
		
		public function ASDocument(displayObject:DisplayObject)
		{
			typedElements = new Dictionary();
			namedElements = new Dictionary();
			
			this.displayObject = displayObject;
			addBehaviors(this.displayObject);
		}
		
		public function getElementsByType(typeName:String):Array {
			if(typedElements[typeName])
				return typedElements[typeName].slice();
			return null;
		}
		
		public function getElementByName(name:String):Object {
			var elt:Object = getElementsByName(name);
			return elt;
		}
		
		public function getElementsByName(name:String):Array {
			if(namedElements[name])
				return namedElements[name].slice();
			return null;
		}
		
		public function match(instance:Object, selectors:Array):Boolean {
			var selector:String;
			var o:Object = instance;
			var checked:Boolean;
			var count:int = 0;
			
			var index:int = selectors.length - 1;
			while(index > -1) {
				checked = false;
				selector = selectors[index--];
				
				while(o != null && !checked) {
					if(unqualifiedClassName(o) == selector) {
						count++;
						checked = true;
					}
					o = o.parent;
				}
			}
			
			return count == selectors.length;
		}
		
		protected function addBehaviors(dispatcher:DisplayObject):void {
			if(dispatcher.stage) {
				dispatcher.stage.addEventListener(Event.ADDED_TO_STAGE,addedToStageHandlerEx,true);
				dispatcher.stage.addEventListener(Event.REMOVED_FROM_STAGE,removedHandler,true);
			} else {
				dispatcher.addEventListener(Event.ADDED,addedHandler,true);
				dispatcher.addEventListener(Event.REMOVED,removedHandler,true);
				dispatcher.addEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
			}
		}
		
		protected function addedToStageHandlerEx(e:Event):void {			
			var elt:Object = e.target;
			insertElement(elt);
		}
		
		protected function addedToStageHandler(e:Event):void {			
			var elt:Object = e.target;
			displayObject.removeEventListener(Event.ADDED,addedHandler,true);
			displayObject.removeEventListener(Event.REMOVED,removedHandler,true);
			displayObject.removeEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
			
			insertElement(elt);		
			
			elt.stage.addEventListener(Event.ENTER_FRAME,nextFrameHandler);
		}
		
		protected function nextFrameHandler(e:Event):void {
			var elt:Object = e.target;
			elt.removeEventListener(Event.ENTER_FRAME,nextFrameHandler);
			
			elt.addEventListener(Event.ADDED_TO_STAGE,addedHandler,true);
			elt.addEventListener(Event.REMOVED_FROM_STAGE,removedHandler,true);
		}
		
		protected function addedHandler(e:Event):void {	
			var elt:Object = e.target;
			insertElement(elt);
		}	
		
		private function insertElement(elt:Object):void {
			var className:String = unqualifiedClassName(elt);
			
			// trace("insert",className,elt.name);
			
			var types:Array = typedElements[className];
			if(!types) {
				types = new Array();
				typedElements[className] = types; 
			}
			types.push(elt);
			
			var names:Array = namedElements[elt.name];
			if(!names) {
				names = new Array();
				namedElements[elt.name] = names;
			}
			names.push(elt);
		}
		
		protected function removedHandler(e:Event):void {
			var elt:Object = e.target;
			var className:String = unqualifiedClassName(elt);
			
			// trace(e.type,className,elt.name);
			
			var len:int, i:int;
			var types:Array = typedElements[className];
			if(types) {
				len = types.length;
				if(len > 0) {
					for(i = 0; i < len; i++) {
						if(types[i] == elt) {
							types.splice(i,1);
						}
					}
				}
				
				if(types.length == 0) {
					delete typedElements[className];
				}
			}
			
			var names:Array = namedElements[elt.name];
			if(names) {
				len = names.length;
				if(len > 0) {
					for(i = 0; i < len; i++) {
						if(names[i] == elt) {
							names.splice(i,1);
						}
					}
				}
				
				if(names.length == 0) {
					delete namedElements[elt.name];
				}
			}
		}
		
		private function unqualifiedClassName(object:Object):String {
			var name:String;
			if (object is String)
				name = object as String;
			else
				name = getQualifiedClassName(object);
			
			var index:int = name.indexOf("::");
			if (index > -1)
				name = name.substr(index + 2);
			
			return name;
		}
	}
}