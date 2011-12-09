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
package acts.display
{
	import acts.display.utils.ContextualSelector;
	import acts.display.utils.Selector;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;

	public class ASFinder implements IFinder
	{
		private var dom:ASDocument;
		
		public function get document():ASDocument {
			return dom;
		}
	
		public function ASFinder(dom:ASDocument)
		{
			if(!dom) {
				throw new ArgumentError();
			}
			
			this.dom = dom;
		}
		
		public function getElement(selector:String):Object {
			var element:Object;
			var elements:Array = getElements(selector);
			if(elements && elements.length > 0)
				element = elements[0];
			return element;
		}
		
		public function getElements(pattern:String):Array {
			var elements:Array = [];
			var context:ContextualSelector = parsePattern(pattern);
			
			if(context.name != null) {
				elements = dom.getElementsByName(context.name);
			} else {
				elements = dom.getElementsByType(context.type);
			}
			
			if(elements != null && context.selectors.length > 1) {
				var l:int = elements.length;
				var element:Object;
				var elts:Array = [];
				for(var i:int = 0; i < l; i++) {
					element = elements[i];
					if(dom.match(element,context.selectors)) {
						elts.push(element);
					}
				}
				elements = elts;
			}
			return elements;
		}
		
		public function parsePattern(pattern:String):ContextualSelector {
			var steps:Array = pattern.split(" ");
			var len:int = steps.length;
			var context:ContextualSelector = new ContextualSelector(len - 1);
			var lastIndex:int = len - 1;
			
			for(var i:int = 0; i < lastIndex; i++) {
				context.selectors[i] = parseSelector(steps[i]);
			}
			
			var s:Selector = parseSelector(steps[lastIndex]);
			context.name = s.name;
			context.type = s.type;
			
			return context;
		}
		
		private function parseSelector(pattern:String):Selector {
			var s:Selector = new Selector();
			s.type = pattern;
			var index:int = pattern.indexOf("#");
			if(index > 0) {
				s.name = pattern.substring(index+1);
				s.type = pattern.substring(0,index);
			} else if(index == 0) {
				s.name = pattern.substring(1);
				s.type = null;
			}
			return s;
		}
	}
}