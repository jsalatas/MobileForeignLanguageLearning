package gr.ictpro.mall.client.view
{
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.utils.ObjectUtil;
	
	import spark.collections.SortField;
	
	import gr.ictpro.mall.client.components.FormItem;
	import gr.ictpro.mall.client.components.TextInput;
	import gr.ictpro.mall.client.model.ConfigModel;
	import gr.ictpro.mall.client.model.IServerPersistent;
	import gr.ictpro.mall.client.model.vo.Config;
	import gr.ictpro.mall.client.model.vo.GenericServiceArguments;
	import gr.ictpro.mall.client.signal.GenericCallErrorSignal;
	import gr.ictpro.mall.client.signal.GenericCallSignal;
	import gr.ictpro.mall.client.signal.GenericCallSuccessSignal;
	import gr.ictpro.mall.client.signal.ListSignal;
	import gr.ictpro.mall.client.signal.ListSuccessSignal;
	import gr.ictpro.mall.client.signal.SaveSignal;
	import gr.ictpro.mall.client.utils.ui.UI;
	
	
	public class SettingsViewMediator extends TopBarCustomViewMediator
	{
		private static var UPDATE_CONFIG:String = "updateConfig";
		
		[Inject]
		public var listSuccess:ListSuccessSignal;
		
		[Inject]
		public var listConfigSignal:ListSignal;

		[Inject]
		public var saveSignal:SaveSignal;
		
		[Inject]
		public var genericCallSignal:GenericCallSignal;

		[Inject]
		public var genericCallSuccessSignal:GenericCallSuccessSignal;
		
		[Inject]
		public var genericCallErrorSignal:GenericCallErrorSignal;
		
		[Inject]
		public var model:ConfigModel;
		
//		[Inject]
//		public var saveSuccessSignal:SaveSuccessSignal;
//		
//		[Inject]
//		public var saveErrorSignal:SaveErrorSignal;
		

		
		private var settingsMap:Object = new Object();
		
		override public function onRegister():void
		{
			super.onRegister();

			addToSignal(listSuccess, listChanged);
			listConfigSignal.dispatch(Config);
		}
		
		private function listChanged(classType:Class):void
		{
			if(classType == Config) {
				var configs:ArrayCollection = model.getSortedListByFields([new SortField("name")]);
				
				var category:String = "";
				
				for each (var c:Config in configs) {
					var formItem:FormItem = new FormItem();
					formItem.label = c.name;
					var textInput:TextInput = new TextInput();
					textInput.setStyle("textAlign", "left");
					textInput.text = c.value;
					formItem.addElement(textInput);
					settingsMap[c.name.replace(".", "_")] = textInput;
					SettingsView(view).settings.addElement(formItem);
					formItem.percentWidth = 100;
					textInput.percentWidth = 100;
				}
			}
		}
		
		override protected function cancelHandler():void
		{
			super.back();
		}
		
		override protected function okHandler():void
		{
			var list:ArrayCollection = new ArrayCollection();
			for each (var c:Config in model.list) {
				var config:Config = Config(ObjectUtil.copy(c));
				config.value=settingsMap[c.name.replace(".", "_")].text;
				list.addItem(config);
			}

			var args:GenericServiceArguments = new GenericServiceArguments;
			args.type = UPDATE_CONFIG;
			args.destination = IServerPersistent(model).destination;
			args.method = IServerPersistent(model).saveMethod;
			args.arguments = list;
			addToSignal(genericCallSuccessSignal, success);
			addToSignal(genericCallErrorSignal, error);
			genericCallSignal.dispatch(args);
		}
		
		private function success(type:String, result:Object):void
		{
			if(type == UPDATE_CONFIG) {
				
				if(view.parameters != null && view.parameters.notification != null) {
					saveSignal.dispatch(view.parameters.notification);
				}

				super.back();
			}
		}

		private function error(type:String, event:FaultEvent):void
		{
			if(type == UPDATE_CONFIG) {
				UI.showError(ConfigModel(model).saveErrorMessage);
			}
		}

	}
}