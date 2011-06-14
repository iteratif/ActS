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
		public var events:Array;
		
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
		
		private var mapEvents:Dictionary = new Dictionary();
		public function addEvent(objectOrExpr:Object, typeEvent:String, source:Class, method:String, parameters:Array = null, eventArgs:Boolean = false):void {
			var element:DisplayObject = finder.document.rootDocument;
			if(objectOrExpr is String) {
				element = getTrigger(objectOrExpr.toString()) as DisplayObject;
			} else if(objectOrExpr is DisplayObject) {
				element = objectOrExpr as DisplayObject;
			}
			
			if(element) {
				if(!mapEvents[element.name])
					mapEvents[element.name] = [];
				
				mapEvents[element.name].push(new MappingEvent(typeEvent,source,method,parameters,null,eventArgs));
				element.addEventListener(typeEvent,firedEventHandler);
			} else {
				var expr:Expression = finder.parseExpression(objectOrExpr.toString());
				var mapEvent:MappingEvent = new MappingEvent(typeEvent,source,method,parameters,expr.step,eventArgs);
				var mapName:String = (expr.name != null) ? expr.name : expr.type;
				if(!mapEvents[mapName])
					mapEvents[mapName] = [];
				mapEvents[mapName].push(mapEvent);
			}
		}
		
		protected function elementAddedHandler(displayObject:DisplayObject):void {
			var maps:Array;
			var type:String = ClassUtil.unqualifiedClassName(displayObject);
			
			if(mapEvents[displayObject.name]) {
				maps = mapEvents[displayObject.name];
			} else if(mapEvents[type]) {
				maps = mapEvents[type];
			} else {
				return;
			}
			
			var mapEvent:MappingEvent;
			var len:int = maps.length;
			for(var i:int = 0; i < len; i++) {
				mapEvent = maps[i];
				if(finder.document.match(displayObject,mapEvent.step))
					displayObject.addEventListener(mapEvent.type,firedEventHandler);
			}
		}
		
		protected function firedEventHandler(e:Event):void {
			var displayObject:DisplayObject = e.target as DisplayObject;
			var type:String = ClassUtil.unqualifiedClassName(displayObject);
			
			var maps:Array;
			if(mapEvents[displayObject.name]) {
				maps = mapEvents[displayObject.name];
			} else if(mapEvents[type]) {
				maps = mapEvents[type];
			}
			
			var len:int = maps.length;
			var mapEvent:MappingEvent;
			var i:int;
			for(i = 0; i < len; i++) {
				mapEvent = maps[i];
				if(mapEvent.type == e.type)
					break;
			}
			
			if(mapEvent.source != null) {
				var args:Array = [];
				if(mapEvent.eventArgs) {
					args.push(e);
				}
				
				if(mapEvent.parameters != null) {
					var value:Object;
					var parameter:Parameter;
					len = mapEvent.parameters.length;
					for(i = 0; i < len; i++) {
						parameter = mapEvent.parameters[i];
						value = getParameterValue(parameter);
						args.push(value);
					}
				}
				
				var instance:Object;
				if(mapEvent.source is String) {
					var cls:Class = ApplicationDomain.currentDomain.getDefinition(String(mapEvent.source)) as Class;
					if(cls != null) {
						instance = new cls();
					}
				} else {
					instance = new mapEvent.source();
				}
				
				if(instance is IContext) {
					IContext(instance).finder = finder;
					IContext(instance).factory = factory;
				}
				var func:Function = instance[mapEvent.method];
				if(func != null) {
					func.apply(null,args);
				}
			}
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

class MappingEvent {
	public var step:Array;
	
	public var type:String;
	public var source:Class;
	public var method:String;
	public var parameters:Array;
	public var eventArgs:Boolean;
	
	public function MappingEvent(type:String = null, source:Class = null, method:String = null, parameters:Array = null, step:Array = null, eventArgs:Boolean = false) {
		this.type = type;
		this.step = step != null ? step : [];
		this.source = source;
		this.method = method;
		this.parameters = parameters;
		this.eventArgs = eventArgs;
	}
}