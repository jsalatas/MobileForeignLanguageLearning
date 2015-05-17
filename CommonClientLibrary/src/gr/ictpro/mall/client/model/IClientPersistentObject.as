package gr.ictpro.mall.client.model
{
	public interface IClientPersistentObject extends IPersistentObject
	{
		function get tableName():String;
	}
}