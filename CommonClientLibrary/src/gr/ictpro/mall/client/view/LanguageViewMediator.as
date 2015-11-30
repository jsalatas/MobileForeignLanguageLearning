package gr.ictpro.mall.client.view
{
	import mx.collections.ArrayList;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import gr.ictpro.mall.client.components.PopupNotification;
	import gr.ictpro.mall.client.model.Channel;
	import gr.ictpro.mall.client.model.Translation;
	import gr.ictpro.mall.client.service.RemoteObjectService;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class LanguageViewMediator extends Mediator
	{
		[Inject]
		public var view:LanguageView;
		
		[Inject]
		public var addView:AddViewSignal;

		[Inject]
		public var channel:Channel;
		
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
			//TODO:
		}
		
		private function untranslatedHandler():void 
		{
			//TODO:
		}

		private function uploadTranslationsHandler():void 
		{
			//TODO:
		}
		
		private function deleteLanguageHandler(language:Object):void 
		{
			if(view.parameters.language.code == null || view.parameters.language.code =='') {
				var deleteLanguageErrorPopup:PopupNotification = new PopupNotification();
				deleteLanguageErrorPopup.message = Translation.getTranslation('Cannot Delete Language with Empty Code.');
				
				deleteLanguageErrorPopup.open(view, true);
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
			var deleteLanguageErrorPopup:PopupNotification = new PopupNotification();
			deleteLanguageErrorPopup.message = Translation.getTranslation('Cannot Delete Language.');
			
			deleteLanguageErrorPopup.open(view, true);
		}
		
		private function saveHandler():void
		{
			if(view.parameters.language.code != null && view.parameters.language.code != ''
				&& view.parameters.language.englishName != null && view.parameters.language.englishName != ''
				&& view.parameters.language.localName != null && view.parameters.language.localName != ''
			) {
				if(view.currentState == 'new' && ArrayList(view.parameters.languageCodes).getItemIndex(view.parameters.language.code) != -1)
				{
					var saveLanguageErrorPopup:PopupNotification = new PopupNotification();
					saveLanguageErrorPopup.message = Translation.getTranslation('A Language with Code "{0}" Already Exist.', view.parameters.language.code);
					
					saveLanguageErrorPopup.open(view, true);
					
				} else 
				{
					var ro:RemoteObjectService = new RemoteObjectService(channel, "languageRemoteService", "updateLanguage", view.parameters.language, handleSave, handleSaveError);
				}
			} else {
				var saveLanguageErrorPopup:PopupNotification = new PopupNotification();
				saveLanguageErrorPopup.message = Translation.getTranslation('Please Complete all Fields.');
				
				saveLanguageErrorPopup.open(view, true);
			}
		}

		private function handleSave(event:ResultEvent):void
		{
			backHandler();	
		}
		
		private function handleSaveError(event:FaultEvent):void
		{
			var deleteLanguageErrorPopup:PopupNotification = new PopupNotification();
			deleteLanguageErrorPopup.message = Translation.getTranslation('Cannot Save Language.');
			
			deleteLanguageErrorPopup.open(view, true);
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