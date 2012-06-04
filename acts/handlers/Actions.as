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
package acts.handlers
{
	import acts.core.BaseContext;
	import acts.core.IContext;
	import acts.core.acts_internal;
	import acts.display.utils.ContextualSelector;
	import acts.factories.IFactory;
	import acts.system.ASSystem;
	import acts.system.IPlugin;
	import acts.system.ISystem;
	import acts.utils.ClassUtil;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import mx.states.State;
	
	import org.osflash.signals.Signal;
	
	use namespace acts_internal;

	[DefaultProperty("actions")]
	public class Actions implements IActions
	{
		public static const ACTIONS_PLUGIN_ID:String = "acts.handlers.actions";
		
		public var actions:Array;
		
		protected var system:ISystem;
		protected var preExecute:Signal;
		protected var postExecute:Signal;
		protected var stopped:Boolean = false;
		
		private var mapActions:Dictionary = new Dictionary();
		
		private var states:Array;
		
		public function get name():String
		{
			return ACTIONS_PLUGIN_ID;
		}
		
		public function Actions()
		{
			preExecute = new Signal(String,Object,IActions);
			postExecute = new Signal();
			states = [];
		}
		
		public function start(system:ISystem):void
		{
			this.system = system;
			this.system.asDocument.elementAdded.add(elementAddedHandler);
			
			addActions(actions);
		}
		
		public function addActions(actions:Array, document:Object = null):void {
			var doc:Object = this.system.document;
			if(document)
				doc = document;
			
			doc.addEventListener("preinitialize",initializeStates);
			
			var i:int, len:int;
			if(actions) {
				len = actions.length;
				var action:acts.handlers.Action;
				for(i = 0; i < len; i++) {
					action = actions[i];
					
					if(action.state) {
						states.push(action);
						continue;
					}
					
					if(!action.trigger)
						action.trigger = doc;
					
					addAction(action);
				}
			}
		}
		
		/**
		 *  Adds a action object to this system
		 * 
		 */
		public function addAction(action:Action):void {
			var trigger:Object = action.trigger;
			
			if(trigger is String) {
				var expr:ContextualSelector = system.finder.parsePattern(trigger.toString());
				trigger = (expr.name != null) ? expr.name : expr.type;
			} else if(trigger is IEventDispatcher) {
				IEventDispatcher(trigger).addEventListener(action.event,firedEventHandler);	
			}
			
			var arr:Array = mapActions[trigger];
			if(!arr) {
				arr = [];
				mapActions[trigger] = arr;
			}
			arr.push(action);
		}
		
		public function postExecuting(listener:Function):void
		{
			postExecute.add(listener);
		}
		
		public function preExecuting(listener:Function):void
		{
			preExecute.add(listener);
		}
		
		public function stopExecution():void
		{
			stopped = true;
		}
		
		/**
		 *  
		 * @private
		 * 
		 */
		protected function elementAddedHandler(displayObject:DisplayObject):void {
			var actions:Array = getActions(displayObject);
			
			if(actions) {
				var action:Action;
				var selector:ContextualSelector;
				var matched:Boolean = true;
				for(var i:int = actions.length - 1; i >= 0; --i) {
					action = actions[i];
					if(action.trigger is String) { 
						selector = system.finder.parsePattern(action.trigger.toString());
						matched = system.finder.document.match(displayObject,selector.selectors);
					}
				
					if(matched)
						displayObject.addEventListener(action.event,firedEventHandler);
				}
			}
		}
		
		
		/**
		 *  
		 * @private
		 * 
		 */
		protected function firedEventHandler(e:Event):void {
			var actions:Array = getActions(e.currentTarget);
			if(actions) {
				var action:Action;
				var instance:Object;
				for(var i:int = actions.length - 1; i >= 0; --i) {
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
								for(i = action.parameters.length - 1; i >= 0; --i) {
									parameter = action.parameters[i];
									value = getParameterValue(parameter);
									args.push(value);
								}
							}
							
							stopped = false;
							preExecute.dispatch(e.type,e.currentTarget,this);
							if(!stopped) {
								func.apply(null,args);
								postExecute.dispatch();
							}
						}
					}
				}
			}
		}
		
		/**
		 *  
		 * @private
		 * 
		 */
		protected function getActions(value:Object):Array {
		
			var actions:Array = mapActions[value];
			if(!actions) {
				actions = mapActions[value.name];
			}
			
			if(!actions) {
				var type:String = ClassUtil.unqualifiedClassName(value);
				actions = mapActions[type];
			}
			return actions;
		}
		
		/**
		 *  
		 * @private
		 * 
		 */
		protected function createObject(action:Action):Object {
			var instance:Object;
			
			var plugin:IFactory = system.mainSystem.getPlugin("acts.factories.factory") as IFactory;
			
			var source:Class = action.source;
			if(source) {
				instance = new source();
			} else if(action.ref && plugin) {
				instance = plugin.factory.getObject(action.ref);
			}
			
			if(instance is BaseContext) {
				BaseContext(instance).systemContext = system.mainSystem;
				BaseContext(instance).initialize();
			}
			
			return instance;
		}
			
		private function getParameterValue(parameter:Parameter):Object {
			if(parameter.value !== null) return parameter.value;
			
			var target:String = parameter.target;
			var property:String = parameter.property;
			var element:Object = system.finder.getElement(target);
			if(element != null) {
				if(element.hasOwnProperty(property))
					return element[property];
			}
			
			return null;
		}
		
		private function getState(stateName:String):State {
			var states:Array = system.document.states;
			for(var i:int = states.length - 1; i >= 0; --i) {
				if(states[i].name == stateName)
					return states[i];
			}
			
			return null;
		}
		
		private function initializeStates(e:Event):void {
			for(var i:int = states.length - 1; i >= 0; --i) {
				states[i].trigger = getState(states[i].state);
				
				addAction(states[i]);
			}
		}
	}
}