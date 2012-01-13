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
	import acts.display.ASDocument;
	import acts.display.ASFinder;
	import acts.factories.IFactory;
	import acts.factories.ObjectFactory;
	import acts.factories.registry.Registry;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mx.core.IMXMLObject;
	import mx.events.FlexEvent;
	
	[DefaultProperty("actions")]
	/**
	 * the System class is core of ActS architecture and contains the logic for connect the views on the behaviors.
	 * The behaviors are classes that implement the action methods.
	 * 
	 * The system class provides an action collection for defined the relation between the commands and the methods action.
	 * 
	 * @mxml
	 * 
	 * Example :
	 * 
	 * <pre>
	 * 		&lt;s:Declarations&gt;
	 * 			&lt;System&gt;
	 * 				&lt;Action trigger="#btn" event="click" source="managers.AppManager" method="execute" /&gt;
	 * 				&lt;Action trigger="#txt" event="enter" source="managers.AppManager" method="search" /&gt;
	 * 			&lt;/System&gt;
	 * 		&lt;/s:Declarations&gt;
	 * </pre>
	 * 
	 * @see acts.system.Action
	 */
	public class System extends ASSystem implements IMXMLObject
	{	
		/**
		 * The array of definition objects for the objects factory.
		 */
		public var objects:Array;
		
		/**
		 * The array of actions for this system.
		 */
		public var actions:Array;
		
		/**
		 * Constructor.
		 * 
		 */
		public function System(document:DisplayObjectContainer = null, factory:IFactory = null):void {
			var dom:ASDocument = null;
			if(document) {
				dom = new ASDocument(document);
			}
			super(dom,factory);
		}
		
		/**
		 * 
		 * @copy mx.core.IMXMLObject
		 * 
		 */
		public function initialized(document:Object, id:String):void {
			_document = document;
		
			var dom:ASDocument = new ASDocument(document as DisplayObjectContainer);
			dom.elementAdded.add(elementAddedHandler);
			_finder = new ASFinder(dom);

			var i:int, len:int;
			if(actions) {
				len = actions.length;
				var action:acts.system.Action;
				for(i = 0; i < len; i++) {
					action = actions[i];
					if(!action.trigger)
						action.trigger = document;
					addAction(action);
				}
			}
			
			if(objects != null) {
				len = objects.length;
				for(i = 0; i < len; i++) {
					addDefinition(objects[i]);
				}
			}
		}
	}
}