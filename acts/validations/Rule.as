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
package acts.validations {
	import acts.display.IFinder;
	
	import flash.display.DisplayObject;
	
	import mx.core.ClassFactory;
	import mx.core.UIComponent;
	import mx.events.ValidationResultEvent;
	import mx.validators.EmailValidator;
	import mx.validators.StringValidator;
	import mx.validators.Validator;

	public class Rule {
		public var source:String;
		public var property:String;
		public var required:Boolean = true;
		//public var errorProperty:String = "errorString";
		
		protected var itemValidator:ClassFactory;
		
		private var _validators:Array;
		
		public function get validators():Array {
			return _validators;
		}
		
		public function Rule() {
			property = "text";
			_validators = [];
		}
		
		public function apply(source:Object):void {
			var validator:Validator = itemValidator.newInstance();
			validator.source = source;
			validator.property = property;
			validator.required = required;
			_validators.push(validator);
		}
	}
}