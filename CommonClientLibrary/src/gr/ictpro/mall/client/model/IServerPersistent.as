package gr.ictpro.mall.client.model
{
	public interface IServerPersistent  extends IPersistent
	{
		function get destination():String;
		function get saveMethod():String;
		function get deleteMethod():String;
		function get listMethod():String;
	}
}