package gr.ictpro.mall.client.controller
{
	import gr.ictpro.mall.client.model.ClientSettingsModel;
	import gr.ictpro.mall.client.model.vo.ClientSetting;
	import gr.ictpro.mall.client.runtime.RuntimeSettings;
	import gr.ictpro.mall.client.service.ExternalModuleLoader;
	import gr.ictpro.mall.client.service.RegistrationProvider;
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
		public var clientSettingsModel:ClientSettingsModel;
		
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
					loader= new ExternalModuleLoader(ClientSetting(clientSettingsModel.getItemById(RuntimeSettings.SERVER_URL)).value + "/" + ClientSetting(clientSettingsModel.getItemById(RuntimeSettings.MODULES_PATH)).value + "/"+ registrationProvider.provider, registrationProvider.className);
					injector.injectInto(loader);
					loader.load();
				}
			}
		}
	}
}