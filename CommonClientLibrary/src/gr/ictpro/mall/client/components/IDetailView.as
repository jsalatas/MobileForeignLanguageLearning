package gr.ictpro.mall.client.components
{
	import mx.core.IVisualElement;

	public interface IDetailView
	{
		function set masterView(masterView:IVisualElement):void;
		function get masterView():IVisualElement;
	}
}