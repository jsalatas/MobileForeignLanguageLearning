package gr.ictpro.mall.client.view
{
	import gr.ictpro.mall.client.model.SaveLocation;
	import gr.ictpro.mall.client.runtime.Translation;
	import gr.ictpro.mall.client.utils.ui.UI;

	public class ClassroomgroupViewMediator extends TopBarDetailViewMediator
	{
		override public function onRegister():void
		{
			super.onRegister();
			
			setSaveHandler(handleSave);
			setSaveErrorMessage(Translation.getTranslation('Cannot Save Classrooms Group.'));
			setDeleteHandler(handleDelete);
			setDeleteErrorMessage(Translation.getTranslation('Cannot Delete Classrooms Group.'));
			if(!view.parameters.classroomgroup.hasOwnProperty("id") || view.parameters.classroomgroup.id == null) {
				view.currentState = "new";
				view.disableDelete();
			} else {
				view.currentState = "edit";
			}

		}
		
		private function handleSave():void
		{
			var classroomgroup:Object = new Object();
			if(view.parameters.classroomgroup.name == null || view.parameters.classroomgroup.name == '') {
				UI.showError(view, Translation.getTranslation("Please Enter Classroom Group's Name"));
				return;
			}
			
			if(view.parameters.classroomgroup.hasOwnProperty("id")) {
				classroomgroup.id = view.parameters.classroomgroup.id; 
			}
			classroomgroup.name = view.parameters.classroomgroup.name;
			classroomgroup.notes = view.parameters.classroomgroup.notes;
			
			saveData(SaveLocation.SERVER, classroomgroup, "classroomRemoteService", "updateClassroomgroup");
		}

		private function handleDelete():void 
		{
			var classroomgroup:Object = new Object();
			classroomgroup.classroomgroup_id = view.parameters.classroomgroup.id; 
			deleteData(SaveLocation.SERVER, classroomgroup, "classroomRemoteService", "deleteClassroomgroup");
		}

	}
}