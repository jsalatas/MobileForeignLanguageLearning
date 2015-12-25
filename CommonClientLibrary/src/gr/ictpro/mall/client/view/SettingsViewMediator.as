package gr.ictpro.mall.client.view
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	
	import spark.collections.SortField;
	
	import gr.ictpro.mall.client.components.FormItem;
	import gr.ictpro.mall.client.components.TextInput;
	import gr.ictpro.mall.client.model.SaveLocation;
	import gr.ictpro.mall.client.model.ServerConfiguration;
	import gr.ictpro.mall.client.runtime.RuntimeSettings;
	import gr.ictpro.mall.client.runtime.Translation;
	
	
	public class SettingsViewMediator extends TopBarDetailViewMediator
	{
		[Inject]
		public var settings:RuntimeSettings; 
		
		private var settingsMap:Object = new Object();
		
		override public function onRegister():void
		{
			super.onRegister();
			
			setSaveHandler(saveHandler);
			setSaveSuccessHandler(saveSuccessHandler);
			setSaveErrorMessage(Translation.getTranslation("Cannot Save Server Configuration."));
			
			view.title = Translation.getTranslation("Server Settings");
			if(settings.serverConfiguration.persistentData != null) {
				initView();
			}
		}
		
		private function initView():void
		{
			var items:ArrayCollection = parseServerConfiguration(settings.serverConfiguration.persistentData); 
			var category:String = "";
			
			for(var i:int =0; i<items.length; i++) {
				var o:Object = items.getItemAt(i);
				var formItem:FormItem = new FormItem();
				formItem.label = o.name;
				var textInput:TextInput = new TextInput();
				textInput.setStyle("textAlign", "left");
				textInput.text = o.value;
				settingsMap[o.name]=textInput;
				formItem.addElement(textInput);
				SettingsView(view).settings.addElement(formItem);
				formItem.percentWidth = 100;
				textInput.percentWidth = 100;
			}
		}
		
		private function parseServerConfiguration(p:Object):ArrayCollection 
		{
			var res:ArrayCollection = new ArrayCollection();

			for(var name:String in p) {
				var o:Object = new Object();
				o.name = name as String; 
				o.value = p[name];
				res.addItem(o);
			}
			
			var sort:Sort = new Sort();
			sort.fields = [new SortField("name")];
			res.sort = sort;
			res.refresh();

			
			return res;
		}
		
		private function saveHandler():void
		{
			var p:Object = new Object();
			for(var setting:String in settingsMap) {
				p[setting]=(settingsMap[setting] as TextInput).text;
			}
			
			saveData(SaveLocation.SERVER, p, "configRemoteService", "saveConfig");
		}
		
		private function saveSuccessHandler(event:Event):void
		{
			// Reread settings from server
			settings.serverConfiguration = new ServerConfiguration(channel);
		}
		

	}
}