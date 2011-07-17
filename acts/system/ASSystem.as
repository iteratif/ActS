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
	import acts.core.IContext;
	import acts.display.ASDocument;
	import acts.display.ASFinder;
	import acts.display.Expression;
	import acts.display.IFinder;
	import acts.factories.Factory;
	import acts.factories.ObjectFactory;
	import acts.factories.registry.IRegistry;
	import acts.utils.ClassUtil;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	public class ASSystem
	{	
		protected var _finder:IFinder;
		protected var _factory:Factory;
		
		public function get finder():IFinder {
			return _finder;
		}
		
		public function get factory():Factory {
			return _factory;
		}

		public function ASSystem(dom:ASDocument = null, registry:IRegistry = null)
		{
			if(dom) {
				_finder = new ASFinder(dom);
				dom.elementAdded.add(elementAddedHandler);
			}
			
			if(registry) {
				_factory = new ObjectFactory(registry);
			}
		}
		
		public function getTrigger(expr:String):Object {
			return finder.getElement(expr);
		}
		
		private var mapActions:Dictionary = new Dictionary();
		public function addAction(action:Action):void {
			var trigger:Object = action.trigger;
			
			if(trigger is String) {
				var expr:Expression = finder.parseExpression(trigger.toString());
				trigger = (expr.name != null) ? expr.name : expr.type;
			} else if(trigger is DisplayObject) {
				DisplayObject(trigger).addEventListener(action.event,firedEventHandler);
				trigger = DisplayObject(trigger).name;	
			}
			
			var arr:Array = mapActions[trigger];
			if(!arr) {
				arr = [];
				mapActions[trigger] = arr;
			}
			arr.push(action);
		}
		
		protected function elementAddedHandler(displayObject:DisplayObject):void {
			var actions:Array = mapActions[displayObject.name];
			if(!actions) {
				var type:String = ClassUtil.unqualifiedClassName(displayObject);
				actions = mapActions[type];
			}
			
			if(actions) {
				var action:Action;
				var len:int = actions.length;
				for(var i:int = 0; i < len; i++) {
					action = actions[i];
					displayObject.addEventListener(action.event,firedEventHandler);
				}
			}
		}
		
		protected function firedEventHandler(e:Event):void {
			var displayObject:DisplayObject = e.target as DisplayObject;
			var actions:Array = mapActions[displayObject.name];
			if(actions) {
				var action:Action;
				var instance:Object;
				var len:int = actions.length;
				for(var i:int = 0; i < len; i++) {
					action = actions[i];
					if(action.event == e.type) {
						instance = createObject(action);
						
						if(instance is IContext) {
							IContext(instance).finder = finder;
							IContext(instance).factory = factory;
						}
						var func:Function = instance[action.method];
						if(func != null) {
							func();
						}
					}
				}
			}
		}
		
		protected function createObject(action:Action):Object {
			var instance:Object = new action.source();
			return instance;
		}
		
		private function getParameterValue(parameter:Parameter):Object {
			if(parameter.value !== null) return parameter.value;
			
			var target:String = parameter.target;
			var property:String = parameter.property;
			var element:Object = finder.getElement(target);
			if(element != null) {
				if(element.hasOwnProperty(property))
					return element[property];
			}
			
			return null;
		}
		
	}
}