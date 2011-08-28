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
package acts.system
{
	[DefaultProperty("parameters")]
	public class Action
	{
		public var event:String;
		public var trigger:Object;
		public var source:Class;
		public var method:String;
		public var eventArgs:Boolean;
		public var ref:String
		
		public var parameters:Array;
		
		public function Action(trigger:Object = null, event:String = null, source:Class = null, method:String = null, eventArgs:Boolean = false)
		{
			this.trigger = trigger;
			this.event = event;
			this.source = source;
			this.method = method;
			this.eventArgs = eventArgs;
			parameters = [];
		}
	}
}