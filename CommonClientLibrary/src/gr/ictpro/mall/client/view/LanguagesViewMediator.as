package gr.ictpro.mall.client.view
{
	import gr.ictpro.mall.client.model.AbstractModel;
	import gr.ictpro.mall.client.model.LanguageModel;
	
	public class LanguagesViewMediator extends TopBarListViewMediator
	{

		[Inject]
		public function set languageModel(model:LanguageModel):void
		{
			super.model = model as AbstractModel;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
		}
	}
}