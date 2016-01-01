package gr.ictpro.mall.client.view
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import gr.ictpro.mall.client.model.AbstractModel;
	import gr.ictpro.mall.client.model.LanguageModel;
	import gr.ictpro.mall.client.model.vo.GenericServiceArguments;
	import gr.ictpro.mall.client.model.vo.Language;
	import gr.ictpro.mall.client.runtime.Translation;
	import gr.ictpro.mall.client.signal.GenericCallErrorSignal;
	import gr.ictpro.mall.client.signal.GenericCallSignal;
	import gr.ictpro.mall.client.signal.GenericCallSuccessSignal;
	import gr.ictpro.mall.client.utils.ui.UI;
	
	public class LanguageViewMediator extends TopBarDetailViewMediator
	{
		private static var GET_TRANSLATIONS:String = "getTranslations";
		private static var UPDATE_TRANSLATIONS:String = "updateTranslations";
			
		private var translationsXml:String;
		
		[Inject]
		public var genericCall:GenericCallSignal;
		
		[Inject]
		public var genericCallSuccess:GenericCallSuccessSignal;
		
		[Inject]
		public var genericCallError:GenericCallErrorSignal;
		

		[Inject]
		public function set languageModel(model:LanguageModel):void
		{
			super.model = model as AbstractModel;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			addToSignal(LanguageView(view).getTranslations, getTranslations);
			addToSignal(LanguageView(view).uploadTranslations, uploadTranslationsHandler);
			if(Language(view.parameters.vo).code == 'en') {
				view.disableDelete();
				LanguageView(view).btnGetUntranslated.enabled = false;
				LanguageView(view).btnUploadTranslations.enabled = false;
			}
		}
		
		private function getTranslations(untranslated:Boolean):void 
		{
			var args:GenericServiceArguments = new GenericServiceArguments();
			args.arguments = new Object();
			args.arguments.language_code = Language(view.parameters.vo).code;
			args.arguments.untranslated = untranslated;
			args.destination = "languageRemoteService";
			args.method = "getTranslationsXML";
			args.type = GET_TRANSLATIONS;
			genericCallSuccess.add(success);
			genericCallError.add(error);
			genericCall.dispatch(args);
		}

		private function success(type:String, result:Object):void
		{
			if(type == GET_TRANSLATIONS) {
				removeSignals();

				translationsXml = String(result);
				var xmlFile:File = new File(File.documentsDirectory.nativePath + File.separator + Language(view.parameters.vo).code +".xml");
				xmlFile.browseForSave(Translation.getTranslation("Save Transalations"));
				xmlFile.addEventListener(Event.SELECT, saveTranslationsXML);
			} else if (type == UPDATE_TRANSLATIONS) {
				back();
			}
		}
		
		
		private function saveTranslationsXML(event:Event):void {
			var file:File = File(event.target);
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(translationsXml);
			stream.close();
		}
		
		private function error(type:String, event:FaultEvent):void
		{
			if(type == GET_TRANSLATIONS) {
				removeSignals();

				UI.showError(view,Translation.getTranslation('Cannot Get Translations'));
			} else if (type == UPDATE_TRANSLATIONS) {
				UI.showError(view,Translation.getTranslation('Cannot Update Translations.'));
			}
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
			
			var args:GenericServiceArguments = new GenericServiceArguments();
			args.arguments = xml;
			args.destination = "languageRemoteService";
			args.method = "updateTranslations";
			args.type = UPDATE_TRANSLATIONS;
			genericCallSuccess.add(success);
			genericCallError.add(error);
			genericCall.dispatch(args);
		}
		
		override protected function validateSave():Boolean
		{
			var language:Language = Language(view.parameters.vo);
			if(language.code == null || language.code == '') {
				UI.showError(view,Translation.getTranslation("Language Code Cannot be Empty"));
				return false;
			}
			if(language.englishName == null || language.englishName == '') {
				UI.showError(view,Translation.getTranslation("English Name Cannot be Empty"));
				return false;
			}
			if(language.localName == null || language.localName == '') {
				UI.showError(view,Translation.getTranslation("Local Name Cannot be Empty"));
				return false;
			}
			return true;
		}
		
		private function removeSignals():void
		{
			genericCallSuccess.remove(success);
			genericCallError.remove(error);
		}

	}
}