package gr.ictpro.mall.client.controller
{
	import gr.ictpro.mall.client.service.RegistrationProvider;
	import gr.ictpro.mall.client.runtime.RuntimeSettings;
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
		public var settings:RuntimeSettings;
		
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
					loader= new ExternalModuleLoader(settings.getClientSetting(RuntimeSettings.SERVER_URL)+ "/" + settings.getClientSetting(RuntimeSettings.MODULES_PATH)+ "/"+ registrationProvider.provider, registrationProvider.className);
					injector.injectInto(loader);
					loader.load();
				}
			}
		}
	}
}