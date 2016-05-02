package gr.ictpro.mall.client.view
{
	import gr.ictpro.mall.client.model.ClientSettingsModel;
	import gr.ictpro.mall.client.model.vo.ClientSetting;
	import gr.ictpro.mall.client.runtime.RuntimeSettings;
	import gr.ictpro.mall.client.signal.InitializeSignal;
	import gr.ictpro.mall.client.signal.ListErrorSignal;
	import gr.ictpro.mall.client.signal.ListSignal;
	import gr.ictpro.mall.client.signal.ListSuccessSignal;
	import gr.ictpro.mall.client.signal.SaveErrorSignal;
	import gr.ictpro.mall.client.signal.SaveSignal;
	import gr.ictpro.mall.client.signal.SaveSuccessSignal;
	import gr.ictpro.mall.client.utils.ui.UI;
	
	import org.robotlegs.mvcs.SignalMediator;
	
	public class ServerNameViewMediator extends SignalMediator
	{
		[Inject]
		public var view:ServerNameView;
		
		[Inject]
		public var saveSignal:SaveSignal;

		[Inject]
		public var saveSuccessSignal:SaveSuccessSignal;
		
		[Inject]
		public var saveErrorSignal:SaveErrorSignal;

//		[Inject]
//		public var listSignal:ListSignal;
//		
//		[Inject]
//		public var listSuccessSignal:ListSuccessSignal;
//		
//		[Inject]
//		public var listErrorSignal:ListErrorSignal;
		
		[Inject]
		public var model:ClientSettingsModel;

		[Inject]
		public var initialize:InitializeSignal;
		
		private var allDone:Boolean = false;
		private var settingsReloaded:Boolean = false;

		override public function onRegister():void
		{
			addToSignal(view.okClicked, handleOK);
			addToSignal(saveErrorSignal, error);
//			addToSignal(listErrorSignal, error);
//			addToSignal(listSuccessSignal, success);
		}
		
		protected function handleOK():void
		{
			addToSignal(saveSuccessSignal, success);
			var setting:ClientSetting = new ClientSetting();
			setting.name = RuntimeSettings.SERVER_URL;
			setting.value = view.serverName.text;
			saveSignal.dispatch(setting);

			setting = new ClientSetting();
			setting.name = RuntimeSettings.APP_PATH;
			setting.value = view.applicationPath.text;
			saveSignal.dispatch(setting);

			setting = new ClientSetting();
			setting.name = RuntimeSettings.MODULES_PATH;
			setting.value = view.modulesPath.text;

			allDone = true;
			saveSignal.dispatch(setting);
		}
		
		private function success(classType:Class):void
		{
			if(classType == model.getVOClass() && allDone) {
				view.dispose();
				initialize.dispatch();
			}
		}

		private function error(classType:Class, errorMessage:String):void
		{
			if(classType == model.getVOClass()) {
				if(errorMessage != null)
					UI.showError(errorMessage);
			}
		}
		
	}
	
	
}