package acts.display.utils
{
	public class ContextualSelector extends Selector
	{
		public var selectors:Vector.<Selector>;
		
		public function ContextualSelector(lenght:int = 0)
		{
			selectors = new Vector.<Selector>(lenght);
		}
	}
}