package gr.ictpro.mall.client.view
{
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	
	import spark.collections.SortField;
	
	import gr.ictpro.mall.client.components.FormItem;
	import gr.ictpro.mall.client.components.TextInput;
	import gr.ictpro.mall.client.model.AbstractModel;
	import gr.ictpro.mall.client.model.ConfigModel;
	import gr.ictpro.mall.client.model.IServerPersistent;
	import gr.ictpro.mall.client.model.vo.Config;
	import gr.ictpro.mall.client.model.vo.GenericServiceArguments;
	import gr.ictpro.mall.client.runtime.Translation;
	import gr.ictpro.mall.client.signal.GenericCallErrorSignal;
	import gr.ictpro.mall.client.signal.GenericCallSignal;
	import gr.ictpro.mall.client.signal.GenericCallSuccessSignal;
	import gr.ictpro.mall.client.signal.ListSignal;
	import gr.ictpro.mall.client.signal.ListSuccessSignal;
	
	
	public class SettingsViewMediator extends TopBarDetailViewMediator
	{
		private static var UPDATE_CONFIG:String = "updateConfig";
		
		[Inject]
		public var listSuccess:ListSuccessSignal;
		
		[Inject]
		public var listConfigSignal:ListSignal;

		[Inject]
		public var genericCallSignal:GenericCallSignal;

		[Inject]
		public var genericCallSuccessSignal:GenericCallSuccessSignal;
		
		[Inject]
		public var genericCallErrorSignal:GenericCallErrorSignal;
		
		[Inject]
		public function set configModel(model:ConfigModel):void
		{
			super.model = model as AbstractModel;
		}
		
		private var settingsMap:Object = new Object();
		
		override public function onRegister():void
		{
			super.onRegister();

			view.title = Translation.getTranslation("Server Settings");
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
		
		override protected function saveHandler():void
		{
			for each (var c:Config in model.list) {
				c.value=settingsMap[c.name.replace(".", "_")].text;
			}

			var args:GenericServiceArguments = new GenericServiceArguments;
			args.type = UPDATE_CONFIG;
			args.destination = IServerPersistent(model).destination;
			args.method = IServerPersistent(model).saveMethod;
			args.arguments = model.list;
			addToSignal(genericCallSuccessSignal, success);
			addToSignal(genericCallErrorSignal, error);
			genericCallSignal.dispatch(args);
		}
		
		private function success(type:String, result:Object):void
		{
			if(type == UPDATE_CONFIG) {
				saveSuccessSignal.dispatch(Config);
			}
		}

		private function error(type:String, event:FaultEvent):void
		{
			if(type == UPDATE_CONFIG) {
				saveErrorSignal.dispatch(Config, IServerPersistent(model).saveErrorMessage);
			}
		}

	}
}