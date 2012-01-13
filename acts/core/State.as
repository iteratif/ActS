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
	import acts.core.Event;
	import acts.display.IViewContext;
	import acts.events.StateEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeMappedSignal;

	[Event(name="entry",type="acts.events.StateEvent")]
	[Event(name="exit",type="acts.events.StateEvent")]
	public class State extends EventDispatcher
	{
		public static const START:String = "start";
		public static const FINAL:String = "final";
		
		public var transitions:Array;
		public var events:Array;
		
		public var sequencer:Sequencer;
		
		public var entry:Signal;
		public var exit:Signal;
		
		public var name:String;
		
		public function State(name:String = null)
		{
			this.name = name;
			transitions = [];
			events = [];
			entry = new Signal(Sequencer);
			exit = new Signal(Sequencer);
		}
		
		/**
		 * Add an action 
		 * @param sourceOrExpr	reference object or expression component
		 * @param eventType		type event (example: MouseEvent.CLICK)
		 * @param source		Class reference of action
		 * @param methodName	String
		 * 
		 */
		public function addAction(sourceOrExpr:Object, eventType:String, source:Class, methodName:String):void {
			var a:Action = new Action(source,methodName);
			var event:acts.core.Event = new acts.core.Event(sourceOrExpr,eventType,a);
			events.push(event);
		}
		
		/**
		 * Add an action when entering state 
		 * @param source
		 * @param methodName
		 * 
		 */
		public function addEntryAction(source:Class, methodName:String):void {
			var a:Action = new Action(source,methodName);
			entry.add(a.execute);
		}
		
		/**
		 * Add an action when exiting state 
		 * @param source
		 * @param methodName
		 * 
		 */
		public function addExitExtry(source:Class, methodName:String):void {
			var a:Action = new Action(source,methodName);			
			exit.add(a.execute);
		}
		
		/**
		 * Add a transition from an other state
		 * @param sourceOrExpr
		 * @param eventType
		 * @param target
		 * @return 
		 * 
		 */
		public function addTransition(sourceOrExpr:Object, eventType:String, target:State):Transition {
			var t:Transition = new Transition(this,sourceOrExpr,eventType,target);
			transitions.push(t);
			return t;
		}
		
		private var signals:Array = [];
		public function initialize():void {
			var numEvents:int = events.length;
			var e:acts.core.Event;
			var trigger:*;
			for(var i:int = 0; i < numEvents; i++) {
				e = events[i];
				trigger = e.trigger;
				if(trigger is String) {
					trigger = sequencer.finder.getElement(trigger.toString());
				}
				
				var signal:NativeMappedSignal = new NativeMappedSignal(trigger,e.type,null,Action).mapTo(e.action);
				signal.add(executeAction);
				signals.push(signal);				
			}
			
			// Managing the transitions of currentState
			//var transitions:Array = currentState.transitions;
			var t:Transition;
			var len:int = transitions.length;
			for(i = 0; i < len; i++) {
				t = transitions[i];
				t.activate();
			}
		}
		
		public function destroy():void {
			var numSignals:int = signals.length;
			var signal:Signal;
			for(var i:int = 0; i < numSignals; i++) {
				signal = signals[i];
				signal.remove(executeAction);
			} 
			
			signals = [];
		}
		
		private function executeAction(exec:IExecutable):void {
			exec.execute(sequencer);
		}
	}
}