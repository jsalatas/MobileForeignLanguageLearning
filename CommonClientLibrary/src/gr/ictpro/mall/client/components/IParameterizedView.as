package gr.ictpro.mall.client.components
{
	import mx.utils.ObjectProxy;

	public interface IParameterizedView
	{
		function set parameters(parameters:ObjectProxy):void;
		function get parameters():ObjectProxy;
	}
}