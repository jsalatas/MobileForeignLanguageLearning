package gr.ictpro.mall.client.view
{
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.collections.Sort;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectProxy;
	
	import spark.collections.SortField;
	
	import gr.ictpro.mall.client.components.PopupNotification;
	import gr.ictpro.mall.client.model.Channel;
	import gr.ictpro.mall.client.model.Translation;
	import gr.ictpro.mall.client.service.RemoteObjectService;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	import gr.ictpro.mall.client.signal.PersistSignal;
	
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
			view.back.add(backHandler);
			view.showDetail.add(showDetailHandler);
			view.add.add(addLanguageHandler);
			var ro:RemoteObjectService = new RemoteObjectService(channel, "languageRemoteService", "getLanguages", null, handleGetLanguages, getLanguagesError); 

		}
		
		private function handleGetLanguages(event:ResultEvent):void
		{
			var languages:ArrayCollection = new ArrayCollection();
			var items:ArrayCollection = ArrayCollection(event.result);
			for(var i:int=0; i<items.length; i++) {
				var o:Object = new ObjectProxy(items.getItemAt(i));
				languages.addItem(o);
			}
			var sort:Sort = new Sort();
			sort.fields = [new SortField("name")];
			languages.sort = sort;
			languages.refresh();
			
			view.languages = languages;
		}
		
		private function getLanguagesError(event:FaultEvent):void
		{
			var languagesErrorPopup:PopupNotification = new PopupNotification();
			languagesErrorPopup.message = Translation.getTranslation("Cannot Get Languages.");
			
			languagesErrorPopup.open(view, true);
		}

		private function addLanguageHandler():void
		{
			var language:ObjectProxy = new ObjectProxy();
			language.code = "";
			language.englishName = "";
			language.localName = "";
			showDetailHandler(language);
		}	

		private function cancelHandler():void
		{
			backHandler();
		}
		
		private function buildDetailParameters(language:Object): ObjectProxy
		{
			var parameters:ObjectProxy = new ObjectProxy();
			parameters.language = language;
			var languageCodes:ArrayList = new ArrayList();
			for (var i:int = 0; i< view.languages.length; i++) {
				languageCodes.addItem(view.languages.getItemAt(i).code);
			}
			parameters.languageCodes = languageCodes; 

			return parameters;
		}
		
		private function showDetailHandler(language:Object):void
		{
			var parameters:Object = buildDetailParameters(language); 
			var detailView:LanguageView = new LanguageView();
			detailView.masterView = view;
			view.back.removeAll();
			view.showDetail.removeAll();
			view.add.removeAll();
			view.dispose();
			addView.dispatch(detailView, parameters, view);
		}
		
		private function backHandler():void
		{
			view.back.removeAll();
			view.showDetail.removeAll();
			view.add.removeAll();
			view.dispose();
			if(view.masterView == null) {
				addView.dispatch(new MainView());	
			} else {
				addView.dispatch(view.masterView);
			}
		}
	}
}