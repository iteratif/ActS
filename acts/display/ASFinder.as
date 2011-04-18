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
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;

	public class ASFinder
	{
		private var dom:ASDocument;
	
		public function ASFinder(dom:ASDocument)
		{
			this.dom = dom;
		}
		
		public function getElement(selector:String):Object {
			var element:Object;
			var elements:Array = getElements(selector);
			if(elements && elements.length > 0)
				element = elements[0];
			return element;
		}
		
		public function getElements(selector:String):Array {
			var elements:Array = [];
			var tmp:Array = selector.split(" ");
			var type:String = tmp.pop();
			var indexS:int = type.indexOf("#");
			var name:String, typeName:String;
			
			if(indexS > 0) {
				name = type.substring(indexS + 1);
				typeName = type.substring(0,indexS);
				elements = dom.getElementsByName(name);
			} else if(indexS == 0) {
				name = type.substring(1);
				elements = dom.getElementsByName(name);
			} else {
				elements = dom.getElementsByType(type);
			}
			
			
			if(tmp.length > 0) {
				var l:int = elements.length;
				var element:Object;
				var elts:Array = [];
				for(var i:int = 0; i < l; i++) {
					element = elements[i];
					if(dom.match(element,tmp)) {
						elts.push(element);
					}
				}
				elements = elts;
			}
			return elements;
		}
	}
}