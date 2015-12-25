package gr.ictpro.mall.client.view
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.collections.ArrayList;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import gr.ictpro.mall.client.model.SaveLocation;
	import gr.ictpro.mall.client.runtime.Translation;
	import gr.ictpro.mall.client.service.RemoteObjectService;
	import gr.ictpro.mall.client.utils.ui.UI;
	
	public class LanguageViewMediator extends TopBarDetailViewMediator
	{
		
		private var translationsXml:String;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			setSaveHandler(saveHandler);
			setDeleteHandler(deleteLanguageHandler);
			setSaveErrorMessage(Translation.getTranslation('Cannot Delete Language.'));
			setDeleteErrorMessage(Translation.getTranslation('Cannot Save Language.'));
			
			LanguageView(view).getAllTranslations.add(allTranslationsHandler);
			LanguageView(view).getUntranslated.add(untranslatedHandler);
			LanguageView(view).uploadTranslations.add(uploadTranslationsHandler);
			if(view.parameters.language.code == 'en') {
				view.disableDelete();
				LanguageView(view).btnGetUntranslated.enabled = false;
				LanguageView(view).btnUploadTranslations.enabled = false;
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
			var xmlFile:File = new File();
			xmlFile.browseForOpen(Translation.getTranslation("Select Transalations"), [new FileFilter(Translation.getTranslation("Translation XML Files"), "*.xml")]);
			xmlFile.addEventListener(Event.SELECT, openTranslationsXML);
		}

		private function openTranslationsXML(event:Event):void {
			var file:File = File(event.target);
			var textLoader:URLLoader = new URLLoader();
			textLoader.addEventListener(Event.COMPLETE, loadedTranslationsXML);
			textLoader.load(new URLRequest(file.nativePath));
		}
		
		private function loadedTranslationsXML(event:Event):void {
			var xml:String = event.target.data;
			var ro:RemoteObjectService = new RemoteObjectService(channel, "languageRemoteService", "updateTranslations", xml, handleUpdateTranslations, handleUpdateTranslationsError);
		}
		
		private function handleUpdateTranslations(event:ResultEvent):void
		{
			back();
		}

		private function handleUpdateTranslationsError(event:ResultEvent):void
		{
			UI.showError(view,Translation.getTranslation('Cannot Update Translations.'));
		}
		
		private function deleteLanguageHandler():void 
		{
			if(view.parameters.language.code == null || view.parameters.language.code =='') {
				UI.showError(view,Translation.getTranslation('Cannot Delete Language with Empty Code.'));
			} else {
				deleteData(SaveLocation.SERVER, view.parameters.language, "languageRemoteService", "deleteLanguage");
			}
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
					saveData(SaveLocation.SERVER, view.parameters.language, "languageRemoteService", "updateLanguage");
				}
			} else {
				UI.showError(view,Translation.getTranslation('Please Complete all Fields.'));
			}
		}


	}
}