package acts.handlers
{
	import acts.core.IContext;
	import acts.display.utils.ContextualSelector;
	import acts.factories.IFactory;
	import acts.system.ASSystem;
	import acts.system.IPlugin;
	import acts.system.ISystem;
	import acts.utils.ClassUtil;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.Dictionary;

	[DefaultProperty("actions")]
	public class Actions implements IPlugin
	{
		public var actions:Array;
		
		protected var system:ISystem;
		
		private var mapActions:Dictionary = new Dictionary();
		
		public function get name():String
		{
			return "acts.handlers.actions";
		}
		
		public function Actions()
		{
		}
		
		public function start(system:ISystem):void
		{
			this.system = system;
			this.system.asDocument.elementAdded.add(elementAddedHandler);
			
			var i:int, len:int;
			if(actions) {
				len = actions.length;
				var action:acts.handlers.Action;
				for(i = 0; i < len; i++) {
					action = actions[i];
					if(!action.trigger)
						action.trigger = system.document;
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
		
		/**
		 *  
		 * @private
		 * 
		 */
		protected function elementAddedHandler(displayObject:DisplayObject):void {
			var actions:Array = getActions(displayObject);
			
			if(actions) {
				var action:Action;
				var len:int = actions.length;
				var selector:ContextualSelector;
				var matched:Boolean = true;
				for(var i:int = 0; i < len; i++) {
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
		
		/**
		 *  
		 * @private
		 * 
		 */
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
		
		/**
		 *  
		 * @private
		 * 
		 */
		protected function createObject(action:Action):Object {
			var instance:Object;
			
			var factory:IFactory = system.mainSystem.getPlugin("acts.factories.factory") as IFactory;
			
			var source:Class = action.source;
			if(source) {
				instance = new source();
			} else if(action.ref && factory) {
				instance = factory.factory.getObject(action.ref);
			}
			
			if(instance is IContext) {
				IContext(instance).finder = system.finder;
				if(factory)
					IContext(instance).factory = factory.factory;
				IContext(instance).document = system.document;
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
	}
}