package gr.ictpro.mall.client.authentication.proximity
{
	import gr.ictpro.mall.client.components.Module;
	
	import org.robotlegs.core.IMediatorMap;

	public class Initialize extends Module 
	{
		public function Initialize() 
		{
		}
		
		[Inject]
		public function set mediatorMap(mediatorMap:IMediatorMap):void {
			mediatorMap.mapView(ProximityRegistration, ProximityRegistrationMediator);
			mediatorMap.mapView(ProximityAuthentication, ProximityAuthenticationMediator);
		}
	}
}