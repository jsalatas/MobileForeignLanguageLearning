package gr.ictpro.mall.client.authentication.proximity
{
	import gr.ictpro.mall.client.components.Module;
	
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IMediatorMap;

	public class Initialize extends Module 
	{
		public function Initialize() 
		{
			super();
		}

		[Inject]
		public function set mediatorMap(mediatorMap:IMediatorMap):void {
			mediatorMap.mapView(ProximityRegistration, ProximityRegistrationMediator);
			mediatorMap.mapView(ProximityAuthentication, ProximityAuthenticationMediator);
		}
		
		[Inject]
		public function set injector(injector:IInjector):void {
			injector.mapSingleton(LocationUpdater);
			injector.mapSingleton(AddonMenu);
			//Initialize LocationUpdater
			injector.getInstance(LocationUpdater);
		}
	}
}