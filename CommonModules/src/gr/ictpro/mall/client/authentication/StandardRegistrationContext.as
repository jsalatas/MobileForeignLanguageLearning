package gr.ictpro.mall.client.authentication
{
	import flash.display.DisplayObjectContainer;
	import flash.system.ApplicationDomain;
	
	import org.robotlegs.core.IInjector;
	import org.robotlegs.utilities.modular.core.IModule;
	import org.robotlegs.utilities.modular.mvcs.ModuleContext;
	
	public class StandardRegistrationContext extends ModuleContext
	{
		public function StandardRegistrationContext(contextView:DisplayObjectContainer,  injector:IInjector)
		{
			super(contextView, true, injector);
		}

		override public function startup():void
		{
			mediatorMap.mapView(StandardRegistration, StandardRegistrationMediator);
		}
		
		override public function dispose():void
		{
			mediatorMap.removeMediatorByView(contextView);
			super.dispose();
		}
	}
}