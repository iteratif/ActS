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
package acts.process
{
	import acts.core.Action;
	import acts.core.IContext;
	import acts.core.IExecutable;
	
	public class Task implements IExecutable
	{
		public var inputs:Array;
		
		public var transitions:Array;
		
		public var paramTypes:Array;
		
		public var source:Class;
		public var methodName:String;
		
		public function Task(source:Class = null, methodName:String = null)
		{
			inputs = [];
			transitions = [];
			paramTypes = [];
			this.source = source;
			this.methodName = methodName;
		}
		
		public function addTransition(dest:Task):Transition {
			var t:Transition = new Transition(dest);
			transitions.push(t);
			return t;
		}
		
		public function setInput(type:Class):void {
			paramTypes.push(type);
		}
		
		public function assignInput(value:*):void {
			inputs.push(value);
		}
		
		public function execute(context:IContext, ...args):void {
				var numInputs:int = inputs.length;
				var numParameters:int = paramTypes.length;
				
				if(numInputs < numParameters) {
					throw new ArgumentError("Incorrect number of arguments. Expected at least " + numInputs + " but received " + numParameters + ".");
				}
				
				var input:*;
				var type:Class;
				var params:Array = [];
				for(var i:int = 0; i < numParameters; i++) {
					input = inputs[i];
					type = paramTypes[i];
					
					if (input === null || input is type) {
						params.push(input);
						continue;	
					}
					
					throw new ArgumentError("Value object <" + input +"> is not an instance of <" + type + ">.");
				}
				
				if(source != null) {
					// TODO get class from ApplicationDomain
					var instance:Object = new source();
					if(instance.hasOwnProperty(methodName)) {
						if(instance is IContext) {
							IContext(instance).finder = context.finder;
							IContext(instance).factory = context.factory;
						}
						
						var f:Function = instance[methodName];
						f.apply(null,params);
					}
				}
		}
	}
}