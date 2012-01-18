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
	import acts.display.IFinder;
	import acts.events.StateEvent;
	import acts.factories.IFactory;
	
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	[Event(name="finished",type="acts.events.StateEvent")]
	public class Sequencer extends EventDispatcher implements IContext
	{
		private var _initialState:State;
		private var _currentState:State;
		
		private var _lastState:State;

		private var _finder:IFinder;
		private var _factory:IFactory;
		
		private var _document:Object;
		
		public function get document():Object
		{
			return _document;
		}
		
		public function set document(value:Object):void
		{
			_document = value;
		}
		
		public function get lastState():State {
			return _lastState;
		}

		public function get factory():IFactory
		{
			return _factory;
		}

		public function set factory(value:IFactory):void
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
		
		public function find(selector:String):Object {
			if (selector.charAt(0)=="*") {
				return _finder.getElements(selector.substring(1));
			} else if (selector.charAt(0)=="+") {
				return _factory.getObject(selector.substring(1));
			} else {
				return _finder.getElement(selector);
			}
		}
		
		public function finds(selector:String):Array {
			return _finder.getElements(selector);
		}
		
		public function getObject(uid:String):Object {
			return _factory.getObject(uid);
		}
		
		public function setObject(uid:String, value:Object):void {
			return _factory.setObject(uid,value);
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
			
			var timer:Timer = new Timer(50,1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,nextFrameHandler);
			timer.start();
		}
		
		public function initialize():void {
			
		}
		
		public function setCurrentState(newState:State):void {
			if(currentState) {
				currentState.exit.dispatch(this);
				currentState.destroy();
			}	
			
			_lastState = currentState;
			_currentState = newState;
			
			currentState.entry.dispatch(this);
			
			currentState.initialize();
			
			if(currentState is FinalState) {
				dispatchEvent(new StateEvent(StateEvent.FINISHED));
			}
		}
		
		private function nextFrameHandler(e:TimerEvent):void {
			currentState = initialState;
		}
	}
}