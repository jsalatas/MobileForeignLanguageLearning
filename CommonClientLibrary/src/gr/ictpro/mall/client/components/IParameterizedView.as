package gr.ictpro.mall.client.components
{
	import gr.ictpro.mall.client.model.ViewParameters;

	public interface IParameterizedView
	{
		function set parameters(parameters:ViewParameters):void;
		function get parameters():ViewParameters;
	}
}