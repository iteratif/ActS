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
	import acts.errors.InitialNodeError;
	
	import org.osflash.signals.Signal;

	public class Activity extends Context
	{
		public var finish:Signal;
		
		private var _currentNode:ActivityNode;

		public function get currentNode():ActivityNode
		{
			return _currentNode;
		}

		public function set currentNode(value:ActivityNode):void
		{
			if(value != null && value != _currentNode) {
				setCurrentNode(value);
			}
		}

		private var startNode:ActivityNode;
		
		public function Activity()
		{
			finish = new Signal();
		}
		
		public function addNode(node:ActivityNode, started:Boolean = false):void {
			if(started)
				startNode = node;
		}
		
		public function start():void {
			if(!startNode)
				throw new InitialNodeError();
			
			currentNode = startNode;
		}
		
		public function setCurrentNode(node:ActivityNode):void {
			_currentNode = node;
			
			if(currentNode is FinalNode) {
				finish.dispatch();
				return;
			}
			
			if(currentNode is ExecutableNode)
				ExecutableNode(currentNode).action.execute(this);
			
			var transitions:Array = currentNode.transitions;
			var len:int = transitions.length;
			var t:Transition;
			for(var i:int = 0; i < len; i++) {
				t = transitions[i];
				currentNode = t.dest;
			}
		}
	}
}