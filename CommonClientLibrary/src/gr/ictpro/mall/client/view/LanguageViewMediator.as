package gr.ictpro.mall.client.view
{
	
	import gr.ictpro.mall.client.components.TopBarDetailView;
	import gr.ictpro.mall.client.model.AbstractModel;
	import gr.ictpro.mall.client.model.LanguageModel;
	import gr.ictpro.mall.client.model.vo.Classroom;
	import gr.ictpro.mall.client.model.vo.Language;
	import gr.ictpro.mall.client.runtime.Translation;
	import gr.ictpro.mall.client.utils.ui.UI;
	
	public class LanguageViewMediator extends TopBarDetailViewMediator
	{
		[Inject]
		public function set languageModel(model:LanguageModel):void
		{
			super.model = model as AbstractModel;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			if(Language(view.parameters.vo).code == 'en') {
				view.disableDelete();
			}
		}
		
		override protected function beforeSaveHandler():void
		{
//			Language(view.parameters.vo).code = TopBarDetailView(view).editor["txtCode"].text;
//			Language(view.parameters.vo).englishName = TopBarDetailView(view).editor["txtEnglishName"].text;
//			Language(view.parameters.vo).localName = TopBarDetailView(view).editor["txtLocalName"].text;
		}
		
		
		
		override protected function validateSave():Boolean
		{
			var language:Language = Language(view.parameters.vo);
			if(language.code == null || language.code == '') {
				UI.showError(Translation.getTranslation("Language Code Cannot be Empty"));
				return false;
			}
			if(language.englishName == null || language.englishName == '') {
				UI.showError(Translation.getTranslation("English Name Cannot be Empty"));
				return false;
			}
			if(language.localName == null || language.localName == '') {
				UI.showError(Translation.getTranslation("Local Name Cannot be Empty"));
				return false;
			}
			return true;
		}
	}
}