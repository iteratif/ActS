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
package acts.factories.registry
{
	import flash.utils.Dictionary;

	public class Registry implements IRegistry
	{
		private var definitions:Dictionary;
		
		private var _numDefinitions:int = 0;
		public function get numDefinitions():int {
			return _numDefinitions;
		}
		
		public function Registry()
		{
			definitions = new Dictionary();
		}
		
		public function hasDefinition(uid:String):Boolean {
			return definitions[uid] != null;
		}
		
		public function getDefinition(uid:String):Definition
		{
			if(definitions[uid])
				return definitions[uid];
			return null;
		}
		
		public function addDefinition(definition:Definition):void {
			if(!definition)
				throw new ArgumentError("definition reference is null",5100);
			
			if(!definitions[definition.uid]) {
				definitions[definition.uid] = definition;
				_numDefinitions++;
			}
		}
	}
}