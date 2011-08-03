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
	import acts.utils.ClassUtil;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import org.osflash.signals.Signal;
	
	public class ASDocument extends EventDispatcher
	{
		public var elementAdded:Signal;
		
		private var typedElements:Dictionary;
		private var namedElements:Dictionary;
		
		private var container:DisplayObjectContainer;
		
		public function get rootDocument():DisplayObjectContainer {
			return container;
		}
		
		public function ASDocument(container:DisplayObjectContainer)
		{
			if(!container)
				throw new ArgumentError();
			
			elementAdded = new Signal(DisplayObject);
			this.container = container;
			
			typedElements = new Dictionary();
			namedElements = new Dictionary();
			
			addBehaviors(this.container);
			getChildren();
		}
		
		public function getElementsByType(typeName:String):Array {
			if(typedElements[typeName])
				return typedElements[typeName].slice();
			return null;
		}
		
		public function getElementByName(name:String):Object {
			var results:Array = getElementsByName(name);
			if(results)
				return results[0];
			return null;
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
					if(ClassUtil.unqualifiedClassName(o) == selector) {
						count++;
						checked = true;
					}
					o = o.parent;
				}
			}
			
			return count == selectors.length;
		}
		
		public function getChildren():void {
			var container:DisplayObjectContainer = container as DisplayObjectContainer;
			
			if(container != null) {
				var len:int = container.numChildren;
				for(var i:int = 0; i < len; i++) {
					insertElement(container.getChildAt(i));
				}
			}
		}
		
		protected function addBehaviors(dispatcher:DisplayObject):void {
			dispatcher.addEventListener(Event.ADDED,addedHandler);
			dispatcher.addEventListener(Event.REMOVED,removedHandler);
		}
		
		protected function addedHandler(e:Event):void {
			if(e.target != container)
				e.stopImmediatePropagation();
			insertElement(e.target);
		}
		
		protected function insertElement(elt:Object):void {
			var className:String = ClassUtil.unqualifiedClassName(elt);
			
			// trace("insert",elt,container);
			
			var types:Array = typedElements[className];
			if(!types) {
				types = new Array();
				typedElements[className] = types; 
			}
			if(types.indexOf(elt) == -1)
				types.push(elt);
			
			var names:Array = namedElements[elt.name];
			if(!names) {
				names = new Array();
				namedElements[elt.name] = names;
			}
			if(names.indexOf(elt) == -1)
				names.push(elt);
			
			elementAdded.dispatch(elt);
		}
		
		protected function removedHandler(e:Event):void {
			var elt:Object = e.target;
			var className:String = ClassUtil.unqualifiedClassName(elt);
			
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
		
	}
}