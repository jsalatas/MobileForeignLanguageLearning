package gr.ictpro.mall.client.controller
{
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	
	import gr.ictpro.mall.client.components.menu.MainMenu;
	import gr.ictpro.mall.client.model.ClientSettingsModel;
	import gr.ictpro.mall.client.model.vo.ClientSetting;
	import gr.ictpro.mall.client.model.vo.GenericServiceArguments;
	import gr.ictpro.mall.client.runtime.Device;
	import gr.ictpro.mall.client.runtime.RuntimeSettings;
	import gr.ictpro.mall.client.service.ExternalModuleLoader;
	import gr.ictpro.mall.client.signal.GenericCallErrorSignal;
	import gr.ictpro.mall.client.signal.GenericCallSignal;
	import gr.ictpro.mall.client.signal.GenericCallSuccessSignal;
	import gr.ictpro.mall.client.utils.date.DateUtils;
	import gr.ictpro.mall.client.utils.ui.UI;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class GetExternalModulesCommand extends SignalCommand
	{
		[Inject]
		public var runtimeSettings:RuntimeSettings;
		
		[Inject]
		public var clientSettingsModel:ClientSettingsModel;
		
		[Inject]
		public var mainMenu:MainMenu;
		
		[Inject]
		public var genericCallSignal:GenericCallSignal;
		
		[Inject]
		public var genericCallSuccessSignal:GenericCallSuccessSignal;
		
		[Inject]
		public var genericCallErrorSignal:GenericCallErrorSignal;

		private var loader:ExternalModuleLoader;
		
		override public function execute():void
		{
			var args:GenericServiceArguments = new GenericServiceArguments;
			args.type = "getExternalModules";
			args.destination = "externalModulesRemoteService";
			args.method = "getExternalModules"
			args.arguments = null;
			genericCallSuccessSignal.add(success);
			genericCallErrorSignal.add(error);
			genericCallSignal.dispatch(args);

		}
		
		private function success(type:String, result:Object):void
		{
			if(type == "getExternalModules") {
				var serverURL:String = ClientSetting(clientSettingsModel.getItemById(RuntimeSettings.SERVER_URL)).value;
				if(serverURL.charAt(serverURL.length-1) != "/") {
					serverURL = serverURL + "/";
				}

				for each (var module:String in result) {
					loader = new ExternalModuleLoader(serverURL+"/" + ClientSetting(clientSettingsModel.getItemById(RuntimeSettings.MODULES_PATH)).value+ "/"+ module, null, false);
					injector.injectInto(loader);
					loader.load();
				}
				

				if(runtimeSettings.user != null) {
					runtimeSettings.menu = mainMenu.getMenu(runtimeSettings.user);
				}
			}
		}
		
		private function error(type:String, event:FaultEvent):void
		{
			if(type == "getExternalModules" && !Device.isInitializing) {
				UI.showError("Cannot Connect to Server.");
			}
		}

	}
}