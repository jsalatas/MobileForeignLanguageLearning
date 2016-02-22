package gr.ictpro.mall.client.model.vo
{
	[Bindable]
	[RemoteClass(alias="gr.ictpro.mall.model.UITranslation")]
	public class UITranslation
	{
		public var originalText:String;
		public var translatedText:String;

		public function UITranslation()
		{
		}
	}
}