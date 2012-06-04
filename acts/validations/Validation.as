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
package acts.validations {
	import acts.display.utils.ContextualSelector;
	import acts.handlers.IActions;
	import acts.system.IPlugin;
	import acts.system.ISystem;
	import acts.utils.ClassUtil;
	
	import flash.display.DisplayObject;
	
	import mx.validators.DateValidator;
	import mx.validators.EmailValidator;
	import mx.validators.IValidator;
	import mx.validators.RegExpValidator;
	import mx.validators.StringValidator;
	import mx.validators.Validator;
	
	import spark.validators.CurrencyValidator;
	import spark.validators.NumberValidator;
	
	[DefaultProperty("rules")]
	public class Validation implements IPlugin {
		public static const VALIDATION_PLUGIN_ID:String = "acts.validations.validation";
		
		public var rules:Array;
		public var trigger:String;
		public var event:String;
		
		protected var system:ISystem;
		protected var mapRules:Object;
		
		public function get name():String {
			return VALIDATION_PLUGIN_ID;
		}
		
		public function Validation() {
			mapRules = {};
		}
		
		public function start(system:ISystem):void {
			this.system = system;
			this.system.asDocument.elementAdded.add(elementAdded);
			
			if(trigger != null) {
				var plugin:IActions = system.mainSystem.getPlugin("acts.handlers.actions") as IActions;
				plugin.preExecuting(preExecuting);
			}
			
			var len:int = rules.length;
			for(var i:int = 0; i < len; i++) {
				setRule(rules[i]);
			}
		}
		
		public function setRule(rule:Rule):void {
			var source:Object = rule.source;
			
			if(source is String) {
				var selector:ContextualSelector = system.finder.parsePattern(source.toString());
				source = (selector.name != null) ? selector.name : selector.type;
				
				var arr:Array = mapRules[source];
				if(!arr) {
					arr = [];
					mapRules[source] = arr;
				}
				arr.push(rule);
			} else if(source is DisplayObject) {
				rule.apply(source);
			}
		}
		
		protected function getRules(displayObject:DisplayObject):Array {
			var rules:Array = mapRules[displayObject.name];
			if(!rules) {
				rules = mapRules[ClassUtil.unqualifiedClassName(displayObject)];
			}
			
			if(!rules)
				return [];
			return rules;
		}
		
		private function elementAdded(displayObject:DisplayObject):void {
			var rule:Rule;
			var rules:Array = getRules(displayObject);
			var len:int = rules.length;
			for(var i:int = 0; i < len; i++) {
				rule = rules[i];
				rule.apply(displayObject);
			}
		}
		
		private function preExecuting(type:String, o:Object, plugin:IActions):void {
			var item:Object = system.finder.getElement(trigger);
			if(type == event && item == o) {
				var rule:Rule;
				var validators:Array = [];
				var len:int = rules.length;
				for(var i:int = 0; i < len; i++) {
					rule = rules[i];
					validators = validators.concat(rule.validators);
				}
				
				var results:Array = Validator.validateAll(validators);
				if(results.length > 0)
					plugin.stopExecution();
			}
		}
	}
}