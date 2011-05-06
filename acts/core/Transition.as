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
package acts.core
{
	import acts.core.State;
	import acts.display.IFinder;
	import acts.display.IViewContext;
	
	import flash.events.Event;
	
	import org.osflash.signals.Signal;

	public class Transition
	{
		public var source:Object;
		public var eventType:String;
		public var target:State;
		public var action:IExecutable;
		
		private var expression:Expression;
		protected var state:State;
		
		public function Transition(state:State, sourceOrExpr:Object, eventType:String, target:State)
		{
			this.state = state;
			this.source = sourceOrExpr;
			this.eventType = eventType;
			this.target = target;
		}
		
		public function setAction(source:Class, methodName:String):void {
			action = new Action(source,methodName);
		}
		
		public function activate():void {
			var trigger:Object = source;
			if(trigger is String) {
				trigger = state.sequencer.finder.getElement(trigger.toString());
			}
			
			if(trigger != null) {
				trigger.addEventListener(eventType,eventHandler);
			}
		}
		
		public function setCondition(sourceOrExp:Object, property:String, operation:String, value:Object):void {
			expression = new Expression(sourceOrExp, property, operation, value);
			expression.finder = state.sequencer.finder;
		}
		
		private function eventHandler(e:flash.events.Event):void {
			if(expression != null && !expression.evaluate())
				return;
			
			if(action != null)
				action.execute(state.sequencer);
			
			// TODO: Faire en sorte que la transition envoi un signal vers le sequenceur avec le nouvel état
			state.sequencer.currentState = target;
		}
	}
}