package gr.ictpro.mall.client.model
{
	import mx.collections.ArrayCollection;
	
	import gr.ictpro.mall.client.model.vomapper.DetailMapper;

	public interface IPersistent extends IModel
	{
		function get saveErrorMessage():String;
		function get deleteErrorMessage():String;
		function get listErrorMessage():String;
		function get idField():String;
		function idIsNull(vo:Object):Boolean;
	}
}