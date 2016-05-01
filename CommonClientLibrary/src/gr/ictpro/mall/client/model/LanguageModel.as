package gr.ictpro.mall.client.model
{
	import gr.ictpro.mall.client.model.vo.Classroom;
	import gr.ictpro.mall.client.model.vo.Language;
	import gr.ictpro.mall.client.model.vomapper.DetailMapper;
	import gr.ictpro.mall.client.runtime.Device;
	import gr.ictpro.mall.client.utils.boolean.Answer;
	import gr.ictpro.mall.client.view.LanguageView;
	import gr.ictpro.mall.client.view.components.LanguageComponent;
	import gr.ictpro.mall.client.view.components.TranslationManagerComponent;

	public class LanguageModel extends AbstractModel implements IServerPersistent
	{
		public function LanguageModel()
		{
			super(Language, LanguageView, LanguageComponent);
			addDetail(new DetailMapper("Translations", null, null, TranslationManagerComponent, null, null, answerFalse, null, null, null));
			addDetail(new DetailMapper("Classrooms", "classrooms", Classroom, null, null, null, answerTrue, null, null, null));
		}

		public function answerFalse(o:Object):Boolean
		{
			return false;
		}

		public function answerTrue(o:Object):Boolean
		{
			return true;
		}

		public function get saveErrorMessage():String
		{
			return Device.translations.getTranslation("Cannot Save Language.");
		}
		
		public function get deleteErrorMessage():String
		{
			return Device.translations.getTranslation("Cannot Delete Language.");
		}
		
		public function get listErrorMessage():String
		{
			return Device.translations.getTranslation("Cannot Get Languages.");
		}
		
		public function get idField():String
		{
			return "code";
		}
		
		public function idIsNull(vo:Object):Boolean
		{
			return vo[idField] == null;
		}
		
		public function get destination():String
		{
			return "languageRemoteService";
		}
		
		public function get saveMethod():String
		{
			return "updateLanguage";
		}
		
		public function get deleteMethod():String
		{
			return "deleteLanguage";
		}
		
		public function get listMethod():String
		{
			return "getLanguages";
		}
	}
}