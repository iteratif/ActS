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
package acts.handlers
{
	[DefaultProperty("parameters")]
	/**
	 *  The Action class defines the relation between the component and the action method.
	 * 
	 */
	public class Action
	{
		/**
		 * The trigger event.
		 */
		public var event:String;
		/**
		 * The search expression. 
		 * 
		 * @see acts.display.ASFinder
		 */
		public var trigger:Object;
		/**
		 * The reference of actions class.
		 */
		public var source:Class;
		/**
		 * The reference of action method. 
		 */
		public var method:String;
		/**
		 * Indicates that the action method receives the event parameter.
		 */		
		public var eventArgs:Boolean;
		/**
		 *  The uid of actions class into the objects factory.
		 */
		public var ref:String
		
		/**
		 * A array of parameters.
		 */
		public var parameters:Array;
		
		/**
		 * 
		 * Constructor.
		 * 
		 */
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