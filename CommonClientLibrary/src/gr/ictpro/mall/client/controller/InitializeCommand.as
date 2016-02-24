package gr.ictpro.mall.client.controller
{
	import flash.system.Capabilities;
	
	import spark.events.PopUpEvent;
	
	import gr.ictpro.mall.client.model.ClientSettingsModel;
	import gr.ictpro.mall.client.model.vo.ClientSetting;
	import gr.ictpro.mall.client.runtime.RuntimeSettings;
	import gr.ictpro.mall.client.service.AuthenticationProvider;
	import gr.ictpro.mall.client.service.AuthenticationProviders;
	import gr.ictpro.mall.client.service.Channel;
	import gr.ictpro.mall.client.service.LocalDBStorage;
	import gr.ictpro.mall.client.service.MessagingService;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	import gr.ictpro.mall.client.signal.GetTranslationsSignal;
	import gr.ictpro.mall.client.signal.ListErrorSignal;
	import gr.ictpro.mall.client.signal.ListSignal;
	import gr.ictpro.mall.client.signal.ListSuccessSignal;
	import gr.ictpro.mall.client.signal.ShowAuthenticationSignal;
	import gr.ictpro.mall.client.utils.ui.UI;
	import gr.ictpro.mall.client.view.ServerNameView;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class InitializeCommand extends SignalCommand
	{

		[Inject]
		public var showAuthentication:ShowAuthenticationSignal;

		[Inject]
		public var clientSettingsModel:ClientSettingsModel;

		[Inject]
		public var settings:RuntimeSettings;
		
		[Inject]
		public var channel:Channel;

		[Inject]
		public var runtimeSettings:RuntimeSettings;

		[Inject]
		public var authenticationProviders:AuthenticationProviders;
		
		[Inject]
		public var addView:AddViewSignal;

		[Inject]
		public var listSignal:ListSignal;

		[Inject]
		public var listSuccessSignal:ListSuccessSignal;
		
		[Inject]
		public var listErrorSignal:ListErrorSignal;
		
		[Inject]
		public var messagingService:MessagingService;

		[Inject]
		public var getTranslationsSignal:GetTranslationsSignal;
		

		override public function execute():void
		{
			listSuccessSignal.add(success);
			listErrorSignal.add(error);
			listSignal.dispatch(clientSettingsModel.getVOClass());
			
		}
		
		private function success(classType:Class):void
		{
			if(classType == clientSettingsModel.getVOClass()) {
				if(clientSettingsModel.getItemById(RuntimeSettings.SERVER_URL) == null) {
					addView.dispatch(new ServerNameView());
				} else {
					channel.setupChannel(ClientSetting(clientSettingsModel.getItemById(RuntimeSettings.SERVER_URL)).value, ClientSetting(clientSettingsModel.getItemById(RuntimeSettings.APP_PATH)).value);
					getTranslationsSignal.dispatch();
					showAuthentication.dispatch(new AuthenticationProvider(null, null));
				}
			}
		}

		private function error(classType:Class, errorMessage:String):void
		{
			if(classType == clientSettingsModel.getVOClass()) {
				UI.showError(errorMessage, terminateApp);
			}
		}
		
		private function terminateApp(e:PopUpEvent):void
		{
			runtimeSettings.terminate();
		}
	
	}
}