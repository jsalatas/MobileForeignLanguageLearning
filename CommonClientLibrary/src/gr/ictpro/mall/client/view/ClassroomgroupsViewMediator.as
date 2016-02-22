package gr.ictpro.mall.client.view
{
	import gr.ictpro.mall.client.model.AbstractModel;
	import gr.ictpro.mall.client.model.ClassroomgroupModel;
	import gr.ictpro.mall.client.runtime.Device;

	public class ClassroomgroupsViewMediator extends TopBarListViewMediator
	{
		[Inject]
		public function set classroomgroupModel(model:ClassroomgroupModel):void
		{
			super.model = model as AbstractModel;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			view.title = Device.tranlations.getTranslation("Classroom Groups");
		}
	}
}