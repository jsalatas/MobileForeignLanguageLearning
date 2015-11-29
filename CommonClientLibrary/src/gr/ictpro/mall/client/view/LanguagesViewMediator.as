package gr.ictpro.mall.client.view
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import assets.fxg.languages;
	
	import gr.ictpro.mall.client.components.Button;
	import gr.ictpro.mall.client.components.Group;
	import gr.ictpro.mall.client.components.HorizontalLayout;
	import gr.ictpro.mall.client.components.PopupNotification;
	import gr.ictpro.mall.client.components.TextInput;
	import gr.ictpro.mall.client.model.Channel;
	import gr.ictpro.mall.client.model.GenericServerPersistentObject;
	import gr.ictpro.mall.client.model.PersistentObjectWrapper;
	import gr.ictpro.mall.client.model.Translation;
	import gr.ictpro.mall.client.service.RemoteObjectService;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	import gr.ictpro.mall.client.signal.PersistSignal;
	import gr.ictpro.mall.client.utils.ui.UI;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class LanguagesViewMediator extends Mediator
	{
		[Inject]
		public var view:LanguagesView;

		[Inject]
		public var addView:AddViewSignal;
		
		[Inject]
		public var channel:Channel;

		[Inject]
		public var persist:PersistSignal;
		
		override public function onRegister():void
		{
			view.title = Translation.getTranslation("Languages");
			view.save.add(saveHandler);
			view.cancel.add(cancelHandler);
			view.back.add(backHandler);
			view.add.add(addLanguageHandler);
			var ro:RemoteObjectService = new RemoteObjectService(channel, "languageRemoteService", "getLanguages", null, handleGetLanguages, getLanguagesError); 

		}
		
		private function handleGetLanguages(event:ResultEvent):void
		{
			var items:ArrayCollection = ArrayCollection(event.result);
			for(var i:int=0; i<items.length; i++) {
				var o:Object = items.getItemAt(i);
				var lang:Group = createLanguageGroup(o, i);
				view.languages.addElement(lang);
				if(o.code == 'en') {
					lang.enabled = false;
				}
			}
		}
		
		private function createLanguageGroup(item:Object, id:int): Group
		{
			var lang:Group = new Group();
			lang.id="lang_"+id;
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.gap = 5;
			layout.verticalAlign = "middle";
			lang.layout = layout;
			
			var code:TextInput = new TextInput();
			code.id = "code_" + id;
			code.width = 50;
			code.text = item.code;
			lang.addElement(code);

			var englishName:TextInput = new TextInput();
			englishName.id = "englishName_" + id;
			englishName.width = 100;
			englishName.text = item.englishName;
			lang.addElement(englishName);

			var localName:TextInput = new TextInput();
			localName.id = "localName_" + id;
			localName.width = 100;
			localName.text = item.localName;
			lang.addElement(localName);
			
			var del:Button = new Button();
			del.id="del_"+id;
			del.width = 100;
			del.label = Translation.getTranslation('Delete');
			del.addEventListener(MouseEvent.CLICK, deleteLanguage);
			lang.addElement(del);
			return lang;
		}
		
		private function deleteLanguage(event:MouseEvent):void {
			var target:Button = Button(event.currentTarget);
			target.removeEventListener(MouseEvent.CLICK, deleteLanguage);
			var id:int = Number(target.id.substr(4));
			var lang:Group = Group(UI.getElementById(view.languages, "lang_"+id));
			view.languages.removeElement(lang);
		}
		
		private function getLanguagesError(event:FaultEvent):void
		{
			var languagesErrorPopup:PopupNotification = new PopupNotification();
			languagesErrorPopup.message = Translation.getTranslation("Cannot Get Languages.");
			
			languagesErrorPopup.open(view, true);
		}
		
		private function addLanguageHandler():void
		{
			var id:int=-1;
			//Find an unused id
			var found:Boolean = false;
			do {
				id++;
				if(UI.getElementById(view.languages, "lang_"+id) == null) {
					found = true;
				}
				
			} while (!found);
			var o:Object = new Object();
			o.code =Translation.getTranslation("Code");
			o.englishName=Translation.getTranslation("English Name");
			o.localName=Translation.getTranslation("Local Name");
			view.languages.addElement(createLanguageGroup(o, id));
		}
		
		private function saveHandler():void
		{
			var languages:ArrayList= new ArrayList();
			for(var i:int=0;i<view.languages.numChildren; i++) {
				var lang:Group = Group(view.languages.getChildAt(i));
				
				var o:Object = new Object();
				for(var j:int=0;j<lang.numChildren;j++) {
					var displayObject:DisplayObject = lang.getChildAt(j);
					if(displayObject is TextInput) {
						var textInput:TextInput = TextInput(displayObject);
						o[textInput.id.substr(0, textInput.text.indexOf("_")-1)] = textInput.text;
					}
				}
				if(o.code != null && o.code != '') {
					languages.addItem(o);
				}
			}
			var persistentObject:GenericServerPersistentObject = new GenericServerPersistentObject("languageRemoteService", "updateLanguages");
			persistentObject.persistentData.addValue("languages", languages);
			
			persist.dispatch(new PersistentObjectWrapper(persistentObject, persistSuccessHandler, persistErrorHandler));
		}
		
		
		private function persistSuccessHandler(event:Event):void
		{
			backHandler();
		}
		
		private function persistErrorHandler(event:FaultEvent):void
		{
			var saveErrorPopup:PopupNotification = new PopupNotification();
			saveErrorPopup.message = Translation.getTranslation("Cannot Save Languages.");
			
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
			if(view.masterView == null) {
				addView.dispatch(new MainView());	
			} else {
				addView.dispatch(view.masterView);
			}
}
	}
}