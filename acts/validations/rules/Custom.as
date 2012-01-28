package acts.validations.rules
{
	import acts.validations.Rule;
	
	import mx.core.ClassFactory;
	import mx.validators.RegExpValidator;
	import mx.validators.Validator;
	
	public class Custom extends Rule
	{
		public var expression:String;
		
		public function Custom()
		{
			itemValidator = new ClassFactory(RegExpValidator);
		}
		
		protected override function initialize(validator:Validator):void {
			var v:RegExpValidator = validator as RegExpValidator;
			v.expression = expression;
		}
	}
}