package gr.ictpro.mall.client.view
{
	import gr.ictpro.mall.client.model.AbstractModel;
	import gr.ictpro.mall.client.model.CourseTemplateModel;

	public class CourseTemplateViewMediator extends TopBarDetailViewMediator
	{
		[Inject]
		public function set courseTemplateModel(model:CourseTemplateModel):void
		{
			super.model = model as AbstractModel;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
		}			
	}
}