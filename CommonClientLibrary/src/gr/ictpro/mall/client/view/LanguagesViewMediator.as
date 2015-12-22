package gr.ictpro.mall.client.view
{
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.collections.Sort;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectProxy;
	
	import spark.collections.SortField;
	
	import gr.ictpro.mall.client.components.TopBarListView;
	import gr.ictpro.mall.client.model.Translation;
	import gr.ictpro.mall.client.service.RemoteObjectService;
	import gr.ictpro.mall.client.utils.ui.UI;
	
	public class LanguagesViewMediator extends TopBarListViewMediator
	{

		override public function onRegister():void
		{
			super.onRegister();
			
			view.title = Translation.getTranslation("Languages");
			setBuildParametersHandler(buildDetailParameters);
			setDetailViewClass(LanguageView);
			setGetNewHandler(getNew);

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
			
			TopBarListView(view).data = languages;
		}
		
		private function getLanguagesError(event:FaultEvent):void
		{
			UI.showError(view, Translation.getTranslation("Cannot Get Languages."));
		}

		private function buildDetailParameters(language:Object): ObjectProxy
		{
			var parameters:ObjectProxy = new ObjectProxy();
			parameters.language = language;
			var languageCodes:ArrayList = new ArrayList();
			for (var i:int = 0; i< TopBarListView(view).data.length; i++) {
				languageCodes.addItem(TopBarListView(view).data.getItemAt(i).code);
			}
			parameters.languageCodes = languageCodes; 

			return parameters;
		}

		private function getNew():ObjectProxy
		{
			var language:ObjectProxy = new ObjectProxy();
			language.code = "";
			language.englishName = "";
			language.localName = "";
			
			return language;
		}	

	}
}