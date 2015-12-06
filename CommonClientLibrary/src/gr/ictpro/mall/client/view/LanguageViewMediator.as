package gr.ictpro.mall.client.view
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.collections.ArrayList;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import gr.ictpro.mall.client.model.Channel;
	import gr.ictpro.mall.client.model.Translation;
	import gr.ictpro.mall.client.service.RemoteObjectService;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	import gr.ictpro.mall.client.utils.ui.UI;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class LanguageViewMediator extends Mediator
	{
		[Inject]
		public var view:LanguageView;
		
		[Inject]
		public var addView:AddViewSignal;

		[Inject]
		public var channel:Channel;
		
		private var translationsXml:String;
		
		override public function onRegister():void
		{
			view.cancel.add(cancelHandler);
			view.back.add(backHandler);
			view.ok.add(saveHandler);
			view.deleteLang.add(deleteLanguageHandler);
			view.getAllTranslations.add(allTranslationsHandler);
			view.getUntranslated.add(untranslatedHandler);
			view.uploadTranslations.add(uploadTranslationsHandler);
			if(view.parameters.language.code == 'en') {
				view.disableDelete();
				view.btnGetUntranslated.enabled = false;
				view.btnUploadTranslations.enabled = false;
			}
			if(view.parameters.language.code=="") {
				view.currentState = "new";
				view.disableDelete();
			} else {
				view.currentState = "edit";
			}
		}
		
		private function allTranslationsHandler():void 
		{
			var arguments:Object = new Object();
			arguments.language_code = view.parameters.language.code;
			arguments.untranslated = false;
			var ro:RemoteObjectService = new RemoteObjectService(channel, "languageRemoteService", "getTranslationsXML", arguments, handleGetTranslations, handleGetTranslationsError);
		}
		
		private function untranslatedHandler():void 
		{
			var arguments:Object = new Object();
			arguments.language_code = view.parameters.language.code;
			arguments.untranslated = true;
			var ro:RemoteObjectService = new RemoteObjectService(channel, "languageRemoteService", "getTranslationsXML", arguments, handleGetTranslations, handleGetTranslationsError);
		}

		private function handleGetTranslations(event:ResultEvent):void
		{
			translationsXml = String(event.result);
			var xmlFile:File = new File(File.documentsDirectory.nativePath + File.separator + view.parameters.language.code +".xml");
			xmlFile.browseForSave(Translation.getTranslation("Save Transalations"));
			xmlFile.addEventListener(Event.SELECT, saveTranslationsXML);
		}
		
		
		private function saveTranslationsXML(event:Event):void {
			var file:File = File(event.target);
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(translationsXml);
			stream.close();
		}
		
		private function handleGetTranslationsError(event:FaultEvent):void
		{
			UI.showError(view,Translation.getTranslation('Cannot Get Translations.'));
		}
		
		
		private function uploadTranslationsHandler():void 
		{
			//TODO:
		}
		
		private function deleteLanguageHandler(language:Object):void 
		{
			if(view.parameters.language.code == null || view.parameters.language.code =='') {
				UI.showError(view,Translation.getTranslation('Cannot Delete Language with Empty Code.'));
			} else {
				var ro:RemoteObjectService = new RemoteObjectService(channel, "languageRemoteService", "deleteLanguage", view.parameters.language, handleDelete, handleDeleteError);
			}
		}
		
		private function handleDelete(event:ResultEvent):void
		{
			backHandler();	
		}
		
		private function handleDeleteError(event:FaultEvent):void
		{
			UI.showError(view,Translation.getTranslation('Cannot Delete Language.'));
		}
		
		private function saveHandler():void
		{
			if(view.parameters.language.code != null && view.parameters.language.code != ''
				&& view.parameters.language.englishName != null && view.parameters.language.englishName != ''
				&& view.parameters.language.localName != null && view.parameters.language.localName != ''
			) {
				if(view.currentState == 'new' && ArrayList(view.parameters.languageCodes).getItemIndex(view.parameters.language.code) != -1)
				{
					UI.showError(view,Translation.getTranslation('A Language with Code "{0}" Already Exist.', view.parameters.language.code));
					
				} else 
				{
					var ro:RemoteObjectService = new RemoteObjectService(channel, "languageRemoteService", "updateLanguage", view.parameters.language, handleSave, handleSaveError);
				}
			} else {
				UI.showError(view,Translation.getTranslation('Please Complete all Fields.'));
			}
		}

		private function handleSave(event:ResultEvent):void
		{
			backHandler();	
		}
		
		private function handleSaveError(event:FaultEvent):void
		{
			UI.showError(view,Translation.getTranslation('Cannot Save Language.'));
		}
		

		private function backHandler():void
		{
			view.cancel.removeAll();
			view.back.removeAll();
			view.ok.removeAll();
			view.deleteLang.removeAll();
			view.dispose();
			if(view.masterView == null) {
				addView.dispatch(new MainView());	
			} else {
				addView.dispatch(view.masterView);
			}
		}

		private function cancelHandler():void
		{
			backHandler();
		}

	}
}