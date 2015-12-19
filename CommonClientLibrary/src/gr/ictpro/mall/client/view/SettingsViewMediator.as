package gr.ictpro.mall.client.view
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.rpc.events.FaultEvent;
	
	import spark.collections.SortField;
	
	import gr.ictpro.mall.client.components.FormItem;
	import gr.ictpro.mall.client.components.TextInput;
	import gr.ictpro.mall.client.model.Channel;
	import gr.ictpro.mall.client.model.ServerConfiguration;
	import gr.ictpro.mall.client.model.Settings;
	import gr.ictpro.mall.client.model.Translation;
	import gr.ictpro.mall.client.service.RemoteObjectService;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	import gr.ictpro.mall.client.signal.ServerNotificationHandledSignal;
	import gr.ictpro.mall.client.utils.ui.UI;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class SettingsViewMediator extends Mediator
	{
		[Inject]
		public var view:SettingsView;
		
		[Inject]
		public var addView:AddViewSignal;
		
		[Inject]
		public var serverNotificationHandle:ServerNotificationHandledSignal;

		[Inject]
		public var settings:Settings; 
		
		[Inject]
		public var channel:Channel;
		
		private var settingsMap:Object = new Object();
		
		override public function onRegister():void
		{
			view.title = Translation.getTranslation("Server Settings");
			view.save.add(saveHandler);
			view.cancel.add(cancelHandler);
			view.back.add(backHandler);
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
				view.settings.addElement(formItem);
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
			
			var ro:RemoteObjectService = new RemoteObjectService(channel, "configRemoteService", "saveConfig", p, saveSuccessHandler, saveErrorHandler); 
			
		}
		
		private function saveSuccessHandler(event:Event):void
		{
			var p:Object = new Object();
			for(var setting:String in settingsMap) {
				p[setting]=(settingsMap[setting] as TextInput).text;
			}
			
			// Reread settings from server
			settings.serverConfiguration = new ServerConfiguration(channel);

			if(view.parameters != null && view.parameters.hasOwnProperty('notification')) {
				serverNotificationHandle.dispatch(view.parameters.notification);
			}

			backHandler();
		}
		
		private function saveErrorHandler(event:FaultEvent):void
		{
			UI.showError(view,Translation.getTranslation("Cannot Save Server Configuration."));
		}
		


		private function cancelHandler():void
		{
			backHandler();
		}

		private function backHandler():void
		{
			view.save.removeAll();
			view.cancel.removeAll();
			view.back.removeAll();
			view.dispose();
			if(view.masterView == null) {
				addView.dispatch(new MainView());	
			} else {
				addView.dispatch(view.masterView);
			}
		}

	}
}