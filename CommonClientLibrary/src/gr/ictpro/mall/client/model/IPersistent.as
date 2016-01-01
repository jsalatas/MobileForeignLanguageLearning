package gr.ictpro.mall.client.model
{
	public interface IPersistent extends IModel
	{
		function get saveErrorMessage():String;
		function get deleteErrorMessage():String;
		function get listErrorMessage():String;
		function get idField():String;
		function idIsNull(vo:Object):Boolean;
	}
}