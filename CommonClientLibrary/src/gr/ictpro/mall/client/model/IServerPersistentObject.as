package gr.ictpro.mall.client.model
{
	public interface IServerPersistentObject extends IPersistentObject
	{
		function get destination():String;
		function get methodName():String;
	}
}