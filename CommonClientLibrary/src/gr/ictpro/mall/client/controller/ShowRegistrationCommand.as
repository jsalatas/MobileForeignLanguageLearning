package gr.ictpro.mall.client.controller
{
	import gr.ictpro.mall.client.service.RegistrationProvider;
	import gr.ictpro.mall.client.model.Settings;
	import gr.ictpro.mall.client.service.ExternalModuleLoader;
	import gr.ictpro.mall.client.service.RegistrationProviders;
	import gr.ictpro.mall.client.signal.ShowRegistrationSignal;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class ShowRegistrationCommand extends SignalCommand
	{
		[Inject]
		public var registrationProviders:RegistrationProviders;
		
		[Inject]
		public var showRegistration:ShowRegistrationSignal;
		
		[Inject]
		public var settings:Settings;
		
		[Inject]
		public var registrationProvider:RegistrationProvider;
		
		private var loader:ExternalModuleLoader ;
		override public function execute():void
		{
			if(!registrationProviders.isInitialized) {
				registrationProviders.setupRegistrationProviders();
			} else {
				if(registrationProvider.provider == null) {
					showRegistration.dispatch(registrationProviders.getNextProvider(null));	
				} else {
					loader= new ExternalModuleLoader("https://"+settings.getSetting(Settings.SERVER_URL)+ ":8443/" + settings.getSetting(Settings.MODULES_PATH)+ "/"+ registrationProvider.provider);
					injector.injectInto(loader);
					loader.load();
				}
			}
		}
	}
}