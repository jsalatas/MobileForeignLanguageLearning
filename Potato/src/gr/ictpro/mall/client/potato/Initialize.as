package gr.ictpro.mall.client.potato
{
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IMediatorMap;
	import gr.ictpro.mall.client.components.Module;
	
	public class Initialize
	{
		public function Initialize()
		{
			super();
			trace("@@@@@ Initializer Created");
		}
		
		[Inject]
		public function set mediatorMap(mediatorMap:IMediatorMap):void {
			trace("@@@@@ Injecting PotatoBoard");
			mediatorMap.mapView(PotatoBoard, PotatoBoardMediator);
		}
		
	}
}