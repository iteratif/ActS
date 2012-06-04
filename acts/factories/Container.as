package acts.factories
{
	import acts.persistence.IProvider;
	
	import flash.events.IEventDispatcher;
	
	import mx.events.PropertyChangeEvent;

	[ExcludeClass]
	public class Container
	{
		private var _instance:Object;
		
		public function get instance():Object {
			return _instance;
		}
		
		public function set instance(value:Object):void {
			if(value != _instance) {
				if(_instance is IEventDispatcher) {
					IEventDispatcher(_instance).removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,updateHandler);
				}
				
				_instance = value;
				
				if(_instance is IEventDispatcher) {
					IEventDispatcher(_instance).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,updateHandler);
				}
			}
		}
		
		// Définir une interface IProvider
		public var provider:IProvider;
		
		public function Container()
		{
		}
		
		public function load():void {
			trace("Container::load()");
			
			provider.load(_instance);	
		}
		
		private function updateHandler(e:PropertyChangeEvent):void {
			trace(e.property+":"+e.newValue);
		}
	}
}