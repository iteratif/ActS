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
	
	public class ExecutableNode extends ActivityNode
	{
		public var action:Action;
		public var inputs:Array;
		
		public function ExecutableNode(action:Action)
		{
			super();
			this.action = action;
			inputs = [];
		}
		
		public function assignParameter(name:String, value:*):void {
			inputs.push(new Value(name,value));
		}
		
		public function execute(context:IContext):void {
			if(action) {
				var numInputs:int = inputs.length;
				var numParameters:int = action.parameters.length;
				
				if(numInputs < numParameters) {
					throw new ArgumentError("Incorrect number of arguments. Expected at least " + numInputs + " but received " + numParameters + ".");
				}
				
				var input:Value;
				var parameter:Parameter;
				var params:Array = [context];
				for(var i:int = 0; i < numParameters; i++) {
					input = inputs[i];
					parameter = action.parameters[i];
					
					if (input.value === null || (input.value is parameter.type && input.name == parameter.name)) {
						params.push(input.value);
						continue;	
					}
					
					throw new ArgumentError("Value object <" + input.value +"> is not an instance of <" + parameter.type + ">.");
				}
				
				action.execute.apply(null,params);
			}
		}
	}
}