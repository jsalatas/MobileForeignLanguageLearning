package gr.ictpro.mall.client.view.components
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.rpc.events.FaultEvent;
	
	import gr.ictpro.mall.client.model.vo.Classroom;
	import gr.ictpro.mall.client.model.vo.GenericServiceArguments;
	import gr.ictpro.mall.client.model.vo.Language;
	import gr.ictpro.mall.client.runtime.Device;
	import gr.ictpro.mall.client.signal.GenericCallErrorSignal;
	import gr.ictpro.mall.client.signal.GenericCallSignal;
	import gr.ictpro.mall.client.signal.GenericCallSuccessSignal;
	import gr.ictpro.mall.client.utils.ui.UI;
	
	import org.robotlegs.mvcs.SignalMediator;
	
	public class TranslationManagerComponentMediator extends SignalMediator
	{
		private static var GET_TRANSLATIONS:String = "getTranslationsXML";
		private static var UPDATE_TRANSLATIONS:String = "updateTranslations";

		private var translationsXml:String;

		[Inject]
		public var view:TranslationManagerComponent; 
		
		[Inject]
		public var genericCall:GenericCallSignal;
		
		[Inject]
		public var genericCallSuccess:GenericCallSuccessSignal;
		
		[Inject]
		public var genericCallError:GenericCallErrorSignal;
		override public function onRegister():void
		{
			super.onRegister();

			addToSignal(view.getTranslations, getTranslations);
			addToSignal(view.uploadTranslations, uploadTranslationsHandler);
		}
		
		private function getTranslations(untranslated:Boolean):void 
		{
			var args:GenericServiceArguments = new GenericServiceArguments();
			args.arguments = new Object();
			if(view.vo is Language) {
				args.arguments.language_code = view.vo.code;
			} else if (view.vo is Classroom) {
				args.arguments.classroom_id = view.vo.id;
			}
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
				
				var filename:String = "";
				if(view.vo is Language) {
					filename = view.vo.code;
				} else if (view.vo is Classroom) {
					filename = view.vo.language.code +"_" +view.vo.id;
				}
					
				
				var xmlFile:File = new File(File.documentsDirectory.nativePath + File.separator + filename +".xml");
				xmlFile.browseForSave(Device.translations.getTranslation("Save Transalations"));
				xmlFile.addEventListener(Event.SELECT, saveTranslationsXML);
			} else if (type == UPDATE_TRANSLATIONS) {
				UI.showInfo(Device.translations.getTranslation("Translations Successfully Uploaded"));
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
				
				UI.showError('Cannot Get Translations');
			} else if (type == UPDATE_TRANSLATIONS) {
				UI.showError('Cannot Update Translations.');
			}
		}

		private function uploadTranslationsHandler():void 
		{
			var xmlFile:File = new File();
			xmlFile.browseForOpen(Device.translations.getTranslation("Select Transalations"), [new FileFilter(Device.translations.getTranslation("Translation XML Files"), "*.xml")]);
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

		private function removeSignals():void
		{
			genericCallSuccess.remove(success);
			genericCallError.remove(error);
		}

	}
}