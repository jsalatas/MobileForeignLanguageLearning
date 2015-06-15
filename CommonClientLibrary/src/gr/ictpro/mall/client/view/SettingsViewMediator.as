package gr.ictpro.mall.client.view
{
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import gr.ictpro.mall.client.components.FormItem;
	import gr.ictpro.mall.client.model.Channel;
	import gr.ictpro.mall.client.model.PersistentData;
	import gr.ictpro.mall.client.model.PersistentObjectWrapper;
	import gr.ictpro.mall.client.model.ServerConfiguration;
	import gr.ictpro.mall.client.model.Settings;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	import gr.ictpro.mall.client.signal.PersistSignal;
	import gr.ictpro.mall.client.utils.string.StringCapitalize;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.collections.Sort;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	import spark.collections.SortField;
	import spark.components.TextInput;
	import gr.ictpro.mall.client.components.Notification;
	
	public class SettingsViewMediator extends Mediator
	{
		[Inject]
		public var view:SettingsView;
		
		[Inject]
		public var persist:PersistSignal;

		[Inject]
		public var addView:AddViewSignal;
		
		[Inject]
		public var settings:Settings; 
		
		private var settingsMap:Object = new Object();
		
		override public function onRegister():void
		{
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
			}

		}
		
		private function parseServerConfiguration(p:PersistentData):ArrayCollection 
		{
			var res:ArrayCollection = new ArrayCollection();

			for(var name:Object in p) {
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
			var p:PersistentData = settings.serverConfiguration.persistentData;
			for(var name:Object in p) {
				p[name]=(settingsMap[name] as TextInput).text;
			}
			persist.dispatch(new PersistentObjectWrapper(settings.serverConfiguration, persistSuccessHandler, persistErrorHandler));
			
		}
		
		private function persistSuccessHandler(event:Event):void
		{
			backHandler();
		}
		
		private function persistErrorHandler(event:FaultEvent):void
		{
			var saveErrorPopup:Notification = new Notification();
			saveErrorPopup.message = "Cannot Save Server Configuration.";
			
			saveErrorPopup.open(view, true);
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
			addView.dispatch(new MainView());
		}

	}
}