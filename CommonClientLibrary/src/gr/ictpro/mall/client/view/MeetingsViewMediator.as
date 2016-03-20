package gr.ictpro.mall.client.view
{
	import gr.ictpro.mall.client.model.AbstractModel;
	import gr.ictpro.mall.client.model.MeetingModel;

	public class MeetingsViewMediator extends TopBarListViewMediator
	{
		[Inject]
		public function set languageModel(model:MeetingModel):void
		{
			super.model = model as AbstractModel;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
		}
	}
}