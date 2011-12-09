package acts.display
{
	import acts.display.utils.ContextualSelector;
	import acts.display.utils.Selector;

	public interface IFinder
	{
		function get document():ASDocument;
		function getElement(selector:String):Object;
		function getElements(selector:String):Array;
		function parsePattern(pattern:String):ContextualSelector;
	}
}