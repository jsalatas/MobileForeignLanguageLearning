package gr.ictpro.mall.client.potato
{
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IMediatorMap;
	import gr.ictpro.mall.client.components.Module;
	import gr.ictpro.mall.client.components.SharedBoard;
	
	public class Initialize
	{
		public function Initialize()
		{
			super();
		}
		
		[Inject]
		public function set mediatorMap(mediatorMap:IMediatorMap):void {
			mediatorMap.mapView(PotatoBoard, PotatoBoardMediator, SharedBoard);
		}
		
	}
}