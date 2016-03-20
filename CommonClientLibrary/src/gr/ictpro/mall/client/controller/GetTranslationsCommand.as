package gr.ictpro.mall.client.controller
{
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	
	import gr.ictpro.mall.client.components.menu.MainMenu;
	import gr.ictpro.mall.client.model.vo.GenericServiceArguments;
	import gr.ictpro.mall.client.runtime.Device;
	import gr.ictpro.mall.client.runtime.RuntimeSettings;
	import gr.ictpro.mall.client.signal.GenericCallErrorSignal;
	import gr.ictpro.mall.client.signal.GenericCallSignal;
	import gr.ictpro.mall.client.signal.GenericCallSuccessSignal;
	import gr.ictpro.mall.client.utils.date.DateUtils;
	import gr.ictpro.mall.client.utils.ui.UI;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class GetTranslationsCommand extends SignalCommand
	{
		[Inject]
		public var runtimeSettings:RuntimeSettings;

		[Inject]
		public var mainMenu:MainMenu;
		

		[Inject]
		public var genericCallSignal:GenericCallSignal;

		[Inject]
		public var genericCallSuccessSignal:GenericCallSuccessSignal;

		[Inject]
		public var genericCallErrorSignal:GenericCallErrorSignal;


		override public function execute():void
		{
			var arguments:Object = new Object();
			
			arguments.language_code = Device.language;
			if(runtimeSettings.user != null && runtimeSettings.user.currentClassroom != null) {
				arguments.classroom_id = runtimeSettings.user.currentClassroom.id;
			}
			
			var args:GenericServiceArguments = new GenericServiceArguments;
			args.type = "getTranslations";
			args.destination = "languageRemoteService";
			args.method = "getTranslations"
			args.arguments = arguments;
			genericCallSuccessSignal.add(success);
			genericCallErrorSignal.add(error);
			genericCallSignal.dispatch(args);

		}

		private function success(type:String, result:Object):void
		{
			if(type == "getTranslations") {
				Device.translations.translations = ArrayCollection(result);
				if(runtimeSettings.user != null) {
					runtimeSettings.menu = mainMenu.getMenu(runtimeSettings.user);
				}
				DateUtils.reload();
			}
		}
		
		private function error(type:String, event:FaultEvent):void
		{
			if(type == "getTranslations") {
				UI.showError("Cannot Connect to Server.");
			}
		}

	}
}