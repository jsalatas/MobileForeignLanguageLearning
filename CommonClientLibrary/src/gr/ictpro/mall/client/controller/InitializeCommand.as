package gr.ictpro.mall.client.controller
{
	import flash.system.Capabilities;
	
	import gr.ictpro.mall.client.model.AuthenticationProvider;
	import gr.ictpro.mall.client.model.Settings;
	import gr.ictpro.mall.client.service.AuthenticationProviders;
	import gr.ictpro.mall.client.service.Channel;
	import gr.ictpro.mall.client.service.MessagingService;
	import gr.ictpro.mall.client.service.Storage;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	import gr.ictpro.mall.client.signal.ShowAuthenticationSignal;
	import gr.ictpro.mall.client.view.ServerNameView;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class InitializeCommand extends SignalCommand
	{

		[Inject]
		public var showAuthentication:ShowAuthenticationSignal;

		[Inject]
		public var settings:Settings;
		
		[Inject]
		public var channel:Channel;

		[Inject]
		public var authenticationProviders:AuthenticationProviders;
		
		[Inject]
		public var addView:AddViewSignal;

		[Inject]
		public var messagingService:MessagingService;

		override public function execute():void
		{
			settings.settings = Storage.loadSettings();
			// Get locale settings
			settings.settings.lang = Capabilities.languages[0]; 
			
			if(settings.getSetting(Settings.SERVER_URL) == null) {
				addView.dispatch(new ServerNameView());
			} else {
				channel.setupChannel(settings.getSetting(Settings.SERVER_URL), settings.getSetting(Settings.APP_PATH));
				showAuthentication.dispatch(new AuthenticationProvider(null));
			}
			
		}
		
	}
}