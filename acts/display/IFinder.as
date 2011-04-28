package acts.display
{
	public interface IFinder
	{
		function get document():ASDocument;
		function getElement(selector:String):Object;
		function getElements(selector:String):Array;
	}
}