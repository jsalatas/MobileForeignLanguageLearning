package gr.ictpro.mall.client.controller
{
	
	import gr.ictpro.mall.client.model.ClientSettingsModel;
	import gr.ictpro.mall.client.model.vo.ClientSetting;
	import gr.ictpro.mall.client.runtime.RuntimeSettings;
	import gr.ictpro.mall.client.service.AuthenticationProvider;
	import gr.ictpro.mall.client.service.AuthenticationProviders;
	import gr.ictpro.mall.client.service.ExternalModuleLoader;
	import gr.ictpro.mall.client.signal.ShowAuthenticationSignal;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class ShowAuthenticationCommand extends SignalCommand
	{
		[Inject]
		public var showAuthentication:ShowAuthenticationSignal;

		[Inject]
		public var settings:RuntimeSettings;

		[Inject]
		public var clientSettingsModel:ClientSettingsModel;
		
		[Inject]
		public var authenticationProviders:AuthenticationProviders;

		[Inject]
		public var authenticationProvider:AuthenticationProvider;
		
		private var loader:ExternalModuleLoader;
		
		override public function execute():void
		{
			if(!authenticationProviders.isInitialized) {
				authenticationProviders.setupAuthenticationProviders();
			} else {
				if(authenticationProvider.provider == null) {
					showAuthentication.dispatch(authenticationProviders.getNextProvider(null));	
				} else {
					var serverURL:String = ClientSetting(clientSettingsModel.getItemById(RuntimeSettings.SERVER_URL)).value;
					if(serverURL.charAt(serverURL.length-1) != "/") {
						serverURL = serverURL + "/";
					}
					loader = new ExternalModuleLoader(serverURL+"/" + ClientSetting(clientSettingsModel.getItemById(RuntimeSettings.MODULES_PATH)).value+ "/"+ authenticationProvider.provider, authenticationProvider.className);
					injector.injectInto(loader);
					loader.load();
				}
			}
		}
	}
}