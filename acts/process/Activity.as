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
	import acts.core.Context;
	import acts.core.IContext;
	import acts.display.IFinder;
	import acts.errors.InitialNodeError;
	import acts.factories.Factory;
	
	import flash.utils.getTimer;
	
	import org.osflash.signals.Signal;

	public class Activity extends Task implements IContext
	{
		public var startTask:Task;
		private var _currentTask:Task;
		
		private var _finder:IFinder;
		private var _factory:Factory;
		
		public function get factory():Factory {
			return _factory;
		}
		
		public function set factory(value:Factory):void {
			_factory = value;
		}
		
		public function get finder():IFinder {
			return _finder;
		}
		
		public function set finder(value:IFinder):void {
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

		public function get currentTask():Task {
			return _currentTask;
		}

		public function set currentTask(value:Task):void {
			if(value != null && value != _currentTask) {
				setCurrentTask(value);
			}
		}
		
		public function Activity() {
			super();
			completed = new Signal();
		}
		
		public function start():void {
			if(!startTask)
				throw new InitialNodeError();
			
			currentTask = startTask;
		}
		
		public function setCurrentTask(node:Task):void {
			_currentTask = node;
			
			if(currentTask is FinalTask) {
				completed.dispatch();
				return;
			}
			
			currentTask.completed.add(taskCompleted);
			currentTask.execute(this);
			
		}
		
		protected function taskCompleted():void {
			var transitions:Array = currentTask.transitions;
			var len:int = transitions.length;
			var t:Transition;

			for(var i:int = 0; i < len; i++) {
				t = transitions[i];
				if(t.executeCondition()) {
					currentTask = t.dest;
					break;
				}
			}
		}
	}
}