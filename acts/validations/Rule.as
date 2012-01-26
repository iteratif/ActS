package acts.validations {
	import acts.display.IFinder;
	
	import flash.display.DisplayObject;
	
	import mx.core.UIComponent;
	import mx.events.ValidationResultEvent;
	import mx.validators.EmailValidator;
	import mx.validators.StringValidator;
	import mx.validators.Validator;

	public class Rule {
		public static const NOT_NULL:String = "notNull";
		public static const NULL:String = "null";
		public static const EMAIL:String = "email";
		public static const CUSTOM:String = "custom";
		public static const TRUE:String = "true";
		public static const FALSE:String = "false";
		public static const DATE:String = "date";
		public static const NUMBER:String = "number";
		public static const CURRENCY:String = "currency";
		
		public var source:String;
		public var property:String;
		
		[Inspectable(enumeration="custom,email,notNull,null,true,false,date,number,currency")]
		public var type:String;
		
		public var required:Boolean = true;
		public var errorProperty:String = "errorString";
		
		protected var validators:Object = {"notNull": StringValidator,
										   "email": EmailValidator};
		
		public function Rule() {
			
		}
		
		public function apply(finder:IFinder):Boolean {
			var isValid:Boolean = true;
			var item:UIComponent;
			var result:ValidationResultEvent;
			var validated:Boolean;
			var items:Array = finder.getElements(source);
			var len:int = items.length;
			var i:int;
			var validator:Validator;
			
			for(i = 0; i < len; i++) {
				item = items[i];
				item[errorProperty] = "";
				validator = createValidator(type);
				result = validator.validate(item[property]);
				validated = (result.type == ValidationResultEvent.VALID);
				if(!validated)
					item[errorProperty] = result.message;
				
				isValid &&= validated;
			}
				
			return isValid;
		}
		
		public function createValidator(type:String):Validator {
			var validator:Validator;
			var cls:Class = validators[type];
			if(cls) {
				validator = new cls();
			}
			
			return validator;
		}
	}
}