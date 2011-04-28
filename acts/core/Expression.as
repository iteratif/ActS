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

	public class Expression
	{
		public var source:Object;
		public var property:Object;
		public var operation:Object;
		public var value:Object;
		public var finder:IFinder;
		
		public function Expression(sourceOrExp:Object, property:String, operation:String, value:Object)
		{
			source = sourceOrExp;
			this.property = property;
			this.operation = operation;
			this.value = value;
		}
		
		public function evaluate():Boolean {
			var src:Object = source;
			var result:Boolean = false;
			if(src is String) {
				src = finder.getElement(src.toString());
			}
			
			if(src!= null && src.hasOwnProperty(property)) {
				switch(operation) {
					case Operators.INF:
						result = (src[property] < value);
						break;
					case Operators.SUP:
						result = (src[property] > value);
						break;
					case Operators.EGAL:
						result = (src[property] == value);
						break;
					case Operators.NOT_EGAL:
						result = (src[property] != value);
						break;
					case Operators.INF_EGAL:
						result = (src[property] <= value);
						break;
					case Operators.SUP_EGAL:
						result = (src[property] >= value);
						break;
				}
			}
			
			return result;
		}
	}
}