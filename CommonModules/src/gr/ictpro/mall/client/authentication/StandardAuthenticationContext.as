package gr.ictpro.mall.client.authentication
{
	import flash.display.DisplayObjectContainer;
	
	import org.robotlegs.core.IInjector;
	import org.robotlegs.utilities.modular.mvcs.ModuleContext;
	
	public class StandardAuthenticationContext extends ModuleContext
	{
		public function StandardAuthenticationContext(contextView:DisplayObjectContainer,  injector:IInjector)
		{
			super(contextView, true, injector);
		}

		override public function startup():void
		{
			mediatorMap.mapView(StandardAuthentication, StandardAuthenticationMediator);
		}
		
		override public function dispose():void
		{
			mediatorMap.removeMediatorByView(contextView);
			super.dispose();
		}
	}
}