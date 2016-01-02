package gr.ictpro.mall.client.view
{
	import gr.ictpro.mall.client.model.AbstractModel;
	import gr.ictpro.mall.client.model.ClassroomModel;
	import gr.ictpro.mall.client.runtime.Translation;
	
	
	public class ClassroomsViewMediator extends TopBarListViewMediator
	{
		[Inject]
		public function set classroomModel(model:ClassroomModel):void
		{
			super.model = model as AbstractModel;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			view.title = Translation.getTranslation("Classrooms");
		}
		

	}
}