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
	import acts.factories.IFactoryBase;
	
	import flash.display.DisplayObjectContainer;
	
	import mx.core.IMXMLObject;
	
	[DefaultProperty("plugins")]
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
		
		[ArrayElementType("acts.system.IPlugin")]
		public var plugins:Array;
		/**
		 * Constructor.
		 * 
		 */
		public function System(document:DisplayObjectContainer = null):void {
			var dom:ASDocument = null;
			if(document) {
				dom = new ASDocument(document);
			}
			super(dom);
		}
		
		/**
		 * 
		 * @copy mx.core.IMXMLObject
		 * 
		 */
		public function initialized(document:Object, id:String):void {
			_document = document;
		
			_dom = new ASDocument(document as DisplayObjectContainer);
			_finder = new ASFinder(_dom);

			var i:int, len:int;
			if(plugins) {
				len = plugins.length;
				var plugin:IPlugin;
				for(i = 0; i < len; i++) {
					registryAndStart(plugins[i]);
				}
			}
		}
	}
}