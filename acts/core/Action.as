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
	public class Action implements IExecutable
	{
		public var source:Class;
		public var methodName:String;
		
		public function Action(source:Class = null, methodName:String = null)
		{
			this.source = source;
			this.methodName = methodName;
		}
		
		public function execute(context:IContext,...args):void {
			if(source != null) {
				// TODO get class from ApplicationDomain
				var instance:Object = new source();
				if(instance.hasOwnProperty(methodName)) {
					if(instance is IContext) {
						IContext(instance).finder = context.finder;
						IContext(instance).factory = context.factory;
					}
					
					var f:Function = instance[methodName];
					f.apply(null,args);
				}
			}
		}
	}
}