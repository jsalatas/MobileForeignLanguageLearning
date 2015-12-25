package gr.ictpro.mall.client.controller
{
	
	import gr.ictpro.mall.client.service.AuthenticationProvider;
	import gr.ictpro.mall.client.runtime.RuntimeSettings;
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
					loader = new ExternalModuleLoader(settings.getClientSetting(RuntimeSettings.SERVER_URL)+"/" + settings.getClientSetting(RuntimeSettings.MODULES_PATH)+ "/"+ authenticationProvider.provider);
					injector.injectInto(loader);
					loader.load();
				}
			}
		}
	}
}