package gr.ictpro.mall.client.view
{
	import gr.ictpro.mall.client.model.AbstractModel;
	import gr.ictpro.mall.client.model.CourseTemplateModel;
	import gr.ictpro.mall.client.runtime.Device;

	public class CourseTemplatesViewMediator extends TopBarListViewMediator
	{
		[Inject]
		public function set courseTemplateModel(model:CourseTemplateModel):void
		{
			super.model = model as AbstractModel;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			view.title = Device.translations.getTranslation("Course Templates");
		}
	}
}