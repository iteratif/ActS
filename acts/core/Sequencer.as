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
	import acts.display.ASFinder;
	import acts.display.IFinder;
	import acts.events.StateEvent;
	import acts.factories.Factory;
	import acts.display.IViewContext;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	[Event(name="finished",type="acts.events.StateEvent")]
	public class Sequencer extends EventDispatcher implements IContext
	{
		private var _initialState:State;
		private var _currentState:State;

		private var _finder:IFinder;
		private var _factory:Factory;

		public function get factory():Factory
		{
			return _factory;
		}

		public function set factory(value:Factory):void
		{
			_factory = value;
		}
		
		public function get finder():IFinder
		{
			return _finder;
		}
		
		public function set finder(value:IFinder):void
		{
			if(value != _finder) {
				_finder = value;
			}
		}

		public function get currentState():State
		{
			return _currentState;
		}

		public function set currentState(value:State):void
		{
			if(value && value != _currentState) {
				setCurrentState(value);
			}
		}
		
		public function get initialState():State {
			return _initialState;
		}
		
		public function set initialState(value:State):void {
			if(value != _initialState) {
				_initialState = value;
			}
		}
		
		public function Sequencer()
		{
			
		}
		
		public function createState(type:String = null):State {
			var s:State;
			
			if(type == State.FINAL) {
				s = new FinalState();
			} else {
				s = new State();
			}
			
			s.sequencer = this;
			
			if(type == State.START) {
				initialState = s;
			}
			
			return s;
		}
		
		public function start():void {
			if(!initialState) {
				throw new ArgumentError("no initialAction set");
			}
			
			currentState = initialState;
		}
		
		public function initialize():void {
			
		}
		
		public function setCurrentState(newState:State):void {
			if(currentState) {
				currentState.exit.dispatch(this);
			}
			
			_currentState = newState;
			
			// Managing the transitions of currentState
			var transitions:Array = currentState.transitions;
			var t:Transition;
			var len:int = transitions.length;
			for(var i:int = 0; i < len; i++) {
				t = transitions[i];
				t.connect();
			}
			
			currentState.entry.dispatch(this);
			
			currentState.initialize();
			
			if(currentState is FinalState) {
				dispatchEvent(new StateEvent(StateEvent.FINISHED));
			}
		}
	}
}