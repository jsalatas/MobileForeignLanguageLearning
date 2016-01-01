package gr.ictpro.mall.client.model
{
	import gr.ictpro.mall.client.model.vo.Language;
	import gr.ictpro.mall.client.runtime.Translation;

	public class LanguageModel extends AbstractModel implements IServerPersistent
	{
		public function LanguageModel()
		{
			super(Language);
		}
		
		public function get saveErrorMessage():String
		{
			return Translation.getTranslation("Cannot Save Language");
		}
		
		public function get deleteErrorMessage():String
		{
			return Translation.getTranslation("Cannot Delete Language");
		}
		
		public function get listErrorMessage():String
		{
			return Translation.getTranslation("Cannot Get Languages");
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