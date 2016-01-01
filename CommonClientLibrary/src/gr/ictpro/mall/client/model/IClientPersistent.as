package gr.ictpro.mall.client.model
{
	public interface IClientPersistent extends IPersistent
	{
		function get tableName():String;
	}
}