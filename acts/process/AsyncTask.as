package acts.process
{
	import acts.core.IContext;

	public class AsyncTask extends Task
	{
		public function AsyncTask(source:Class=null, methodName:String=null)
		{
			super(source, methodName);
		}
		
		protected override function createObject(context:IContext):Object {
			var instance:Object = super.createObject(context);
			if(instance is IAsync)
				IAsync(instance).host = this;
			return instance;
		}
		
		protected override function callMethod(method:Function, params:Array):void {
			method.apply(null,params);
		}
	}
}