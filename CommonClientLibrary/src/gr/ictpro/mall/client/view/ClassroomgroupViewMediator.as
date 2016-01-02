package gr.ictpro.mall.client.view
{
	import gr.ictpro.mall.client.model.AbstractModel;
	import gr.ictpro.mall.client.model.ClassroomgroupModel;
	import gr.ictpro.mall.client.model.vo.Classroom;
	import gr.ictpro.mall.client.model.vo.Classroomgroup;
	import gr.ictpro.mall.client.runtime.Translation;
	import gr.ictpro.mall.client.utils.ui.UI;

	public class ClassroomgroupViewMediator extends TopBarDetailViewMediator
	{
		[Inject]
		public function set classroomgroupModel(model:ClassroomgroupModel):void
		{
			super.model = model as AbstractModel;
		}

		override public function onRegister():void
		{
			super.onRegister();
		}
		
		override protected function beforeSaveHandler():void
		{
			Classroomgroup(view.parameters.vo).name = ClassroomgroupView(view).txtName.text;
			Classroomgroup(view.parameters.vo).notes = ClassroomgroupView(view).txtNotes.text;

		}
		
		
		
		override protected function validateDelete():Boolean
		{
			var classroomgroup:Classroomgroup = Classroomgroup(view.parameters.vo); 
			if(classroomgroup.name == null || classroomgroup.name == '') {
				UI.showError(Translation.getTranslation("Please Enter Classroom Group's Name"));
				return false;
			}
			
			return true;
		}


	}
}