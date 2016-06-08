package gr.ictpro.mall.client.authentication.standard
{
	import gr.ictpro.mall.client.components.Module;
	
	import org.robotlegs.core.IMediatorMap;

	public class Initialize extends Module 
	{
		public function Initialize() 
		{
			super();
		}
		
		[Inject]
		public function set mediatorMap(mediatorMap:IMediatorMap):void {
			mediatorMap.mapView(StandardRegistration, StandardRegistrationMediator);
			mediatorMap.mapView(StandardAuthentication, StandardAuthenticationMediator);
		}
	}
}