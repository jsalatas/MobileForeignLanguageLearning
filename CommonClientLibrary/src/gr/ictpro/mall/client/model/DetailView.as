package gr.ictpro.mall.client.model
{
	import mx.core.IVisualElement;

	public interface DetailView
	{
		function set masterView(masterView:IVisualElement):void;
		function get masterView():IVisualElement;
	}
}