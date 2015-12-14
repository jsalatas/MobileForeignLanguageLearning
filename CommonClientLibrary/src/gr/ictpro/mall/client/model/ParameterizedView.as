package gr.ictpro.mall.client.model
{
	import mx.utils.ObjectProxy;

	public interface ParameterizedView
	{
		function set parameters(parameters:ObjectProxy):void;
		function get parameters():ObjectProxy;
	}
}