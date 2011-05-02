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
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

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
			}
			
			if(registry) {
				_factory = new ObjectFactory(registry);
			}
		}
		
		public function getTrigger(expr:String):Object {
			return finder.getElement(expr);
		}
		
		private var mapEvents:Dictionary = new Dictionary();
		public function addEvent(objectOrExpr:Object, typeEvent:String, source:Class, method:String, parameters:Array = null):void {
			var element:EventDispatcher = finder.document.rootDocument;
			if(objectOrExpr is String) {
				element = getTrigger(objectOrExpr.toString()) as EventDispatcher;
			} else {
				element = objectOrExpr as EventDispatcher;
			}
			
			if(element) {
				element.addEventListener(typeEvent,createDelegate(source,method,parameters));
			} else {
				var expr:Expression = finder.parseExpression(objectOrExpr.toString());
				var mapEvent:MappingEvent = new MappingEvent(typeEvent,source,method,parameters,expr.step);
				if(expr.name != null) {
					mapEvents[expr.name] = mapEvent;
				} else {
					mapEvents[expr.type] = mapEvent;
				}
			}
		}
		
		protected function elementAddedHandler(displayObject:DisplayObject):void {
			var mapEvent:MappingEvent;
			if(mapEvents[displayObject.name]) {
				mapEvent = mapEvents[displayObject.name];
				if(finder.document.match(displayObject,mapEvent.step))
					displayObject.addEventListener(mapEvent.type,createDelegate(mapEvent.source,mapEvent.method,mapEvent.parameters));
				return;
			}
			
			var type:String = finder.document.unqualifiedClassName(displayObject);
			if(mapEvents[type]) {
				mapEvent = mapEvents[type];
				if(finder.document.match(displayObject,mapEvent.step))
					displayObject.addEventListener(mapEvent.type,createDelegate(mapEvent.source,mapEvent.method,mapEvent.parameters));
			}
		}
		
		protected function createDelegate(source:Class, method:String, parameters:Array = null):Function {
			var f:* = function(e:flash.events.Event = null):void {
				// var start:int = getTimer();
				if(source != null) {
					var args:Array = [];
					if(parameters != null) {
						var value:Object;
						var parameter:Parameter;
						var len:int = parameters.length;
						for(var i:int = 0; i < len; i++) {
							parameter = parameters[i];
							value = getParameterValue(parameter.target,parameter.property);
							args.push(value);
						}
					}
					
					var instance:Object;
					if(source is String) {
						var cls:Class = ApplicationDomain.currentDomain.getDefinition(String(source)) as Class;
						if(cls != null) {
							instance = new cls();
						}
					} else {
						instance = new source();
					}
					
					if(instance is IContext) {
						IContext(instance).finder = arguments.callee.finder;
						IContext(instance).factory = arguments.callee.factory;
					}
					var func:Function = instance[method];
					if(func != null) {
						func.apply(null,args);
					}
					// trace(getTimer() - start,"ms");
				}
			};
			f.finder = finder;
			f.factory = factory;
			return f;
		}
		
		private function getParameterValue(target:String, property:String):Object {
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
	
	public function MappingEvent(type:String = null, source:Class = null, method:String = null, parameters:Array = null, step:Array = null) {
		this.type = type;
		this.step = step;
		this.source = source;
		this.method = method;
		this.parameters = parameters;
	}
}