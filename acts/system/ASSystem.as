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
	import acts.factories.IFactory;
	import acts.factories.ObjectFactory;
	import acts.factories.registry.Definition;
	import acts.factories.registry.Registry;
	import acts.utils.ClassUtil;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.Dictionary;

	public class ASSystem
	{
		protected var _finder:IFinder;
		protected var _factory:IFactory;
		
		protected var _document:Object;
		
		public function get document():Object {
			return _document;
		}
		
		internal static var _mainSystem:ASSystem;
		
		public static function get mainSystem():ASSystem {
			return _mainSystem;
		}
		
		public function get finder():IFinder {
			return _finder;
		}
		
		public function get factory():IFactory {
			return _factory;
		}

		public function ASSystem(dom:ASDocument = null, factory:IFactory = null)
		{			
			if(!_mainSystem)
				_mainSystem = this; 
			
			if(dom) {
				_document = dom.rootDocument;
				_finder = new ASFinder(dom);
				dom.elementAdded.add(elementAddedHandler);
			}
			
			if(factory) {
				_factory = factory;
			} else {
				_factory = new ObjectFactory(new Registry());
			}
		}
		
		private var mapActions:Dictionary = new Dictionary();
		public function addAction(action:Action):void {
			var trigger:Object = action.trigger;
			
			if(trigger is String) {
				var expr:Expression = finder.parseExpression(trigger.toString());
				trigger = (expr.name != null) ? expr.name : expr.type;
			} else if(trigger is DisplayObject) {
				DisplayObject(trigger).addEventListener(action.event,firedEventHandler);	
			}
			
			var arr:Array = mapActions[trigger];
			if(!arr) {
				arr = [];
				mapActions[trigger] = arr;
			}
			arr.push(action);
		}
		
		public function addDefinition(definition:Definition):void {
			_mainSystem.factory.registry.addDefinition(definition);
		}
		
		protected function elementAddedHandler(displayObject:DisplayObject):void {
			var actions:Array = getActions(displayObject);
			
			if(actions) {
				var action:Action;
				var len:int = actions.length;
				var expr:Expression;
				var matched:Boolean = true;
				for(var i:int = 0; i < len; i++) {
					action = actions[i];
					if(action.trigger is String) { 
						expr = finder.parseExpression(action.trigger.toString());
						matched = finder.document.match(displayObject,expr.step);
					}
					
					if(matched)
						displayObject.addEventListener(action.event,firedEventHandler);
				}
			}
		}
		
		protected function firedEventHandler(e:Event):void {
			var displayObject:DisplayObject = e.currentTarget as DisplayObject;
			var actions:Array = getActions(displayObject);
			if(actions) {
				var action:Action;
				var instance:Object;
				var len:int = actions.length;
				for(var i:int = 0; i < len; i++) {
					action = actions[i];
					if(action.event == e.type) {
						instance = createObject(action);
						
						var func:Function = instance[action.method];
						if(func != null) {
							var args:Array = [];
							
							if(action.eventArgs)
								args.push(e);
							
							if(action.parameters != null) {
								var value:Object;
								var parameter:Parameter;
								len = action.parameters.length;
								for(i = 0; i < len; i++) {
									parameter = action.parameters[i];
									value = getParameterValue(parameter);
									args.push(value);
								}
							}
							
							func.apply(null,args);
						}
					}
				}
			}
		}
		
		protected function getActions(displayObject:DisplayObject):Array {
			
			var actions:Array = mapActions[displayObject];
			if(!actions) {
				actions = mapActions[displayObject.name];
			}
			
			if(!actions) {
				var type:String = ClassUtil.unqualifiedClassName(displayObject);
				actions = mapActions[type];
			}
			return actions;
		}
		
		protected function createObject(action:Action):Object {
			var instance:Object;
			
			var source:Class = action.source;
			if(source) {
				instance = new source();
			} else if(action.ref) {
				instance = mainSystem.factory.getObject(action.ref);
			}
			
			if(instance is IContext) {
				IContext(instance).finder = finder;
				IContext(instance).factory = mainSystem.factory;
				IContext(instance).document = document;
			}
			
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