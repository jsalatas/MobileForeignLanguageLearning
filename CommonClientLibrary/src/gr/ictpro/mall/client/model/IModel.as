package gr.ictpro.mall.client.model
{
	import mx.collections.ArrayCollection;

	public interface IModel
	{
		function set list(list:ArrayCollection):void;
		function get list():ArrayCollection;
		function getFilteredList(filterFunction:Function):ArrayCollection;
		function getSortedListByFunction(compareFunction:Function):ArrayCollection;
		function getSortedListByFields(fields:Array):ArrayCollection;
		function remove(item:*):void;
		function getIndexByField(field:String, value:Object):int;
		function getIndexById(value:Object):int;
		function getItemByField(field:String, value:Object):Object;
		function getItemById(value:Object):Object;
		function create():Object;
	}
}