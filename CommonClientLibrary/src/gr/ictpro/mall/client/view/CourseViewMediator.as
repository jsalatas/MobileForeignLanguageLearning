package gr.ictpro.mall.client.view
{
	import spark.collections.SortField;
	
	import gr.ictpro.mall.client.components.TopBarDetailView;
	import gr.ictpro.mall.client.model.AbstractModel;
	import gr.ictpro.mall.client.model.ClassroomModel;
	import gr.ictpro.mall.client.model.ClassroomgroupModel;
	import gr.ictpro.mall.client.model.CourseModel;
	import gr.ictpro.mall.client.model.CourseTemplateModel;
	import gr.ictpro.mall.client.model.LanguageModel;
	import gr.ictpro.mall.client.model.ProjectModel;
	import gr.ictpro.mall.client.model.UserModel;
	import gr.ictpro.mall.client.model.vo.Classroom;
	import gr.ictpro.mall.client.model.vo.Classroomgroup;
	import gr.ictpro.mall.client.model.vo.Course;
	import gr.ictpro.mall.client.model.vo.CourseTemplate;
	import gr.ictpro.mall.client.model.vo.Language;
	import gr.ictpro.mall.client.model.vo.Project;
	import gr.ictpro.mall.client.model.vo.User;
	import gr.ictpro.mall.client.runtime.RuntimeSettings;
	import gr.ictpro.mall.client.signal.ListSignal;
	import gr.ictpro.mall.client.signal.ListSuccessSignal;
	import gr.ictpro.mall.client.utils.ui.UI;

	public class CourseViewMediator extends TopBarDetailViewMediator
	{
		[Inject]
		public var courseTemplateModel:CourseTemplateModel;

		[Inject]
		public var classroomModel:ClassroomModel;

		[Inject]
		public var classroomgroupModel:ClassroomgroupModel;

		[Inject]
		public var projectModel:ProjectModel;
		
		[Inject]
		public var listSignal:ListSignal;
		
		[Inject]
		public var listSuccessSignal:ListSuccessSignal;
		
		[Inject]
		public var runtimeSettings:RuntimeSettings;

		[Inject]
		public function set courseModel(model:CourseModel):void
		{
			super.model = model as AbstractModel;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			if(UserModel.isStudent(runtimeSettings.user) || UserModel.isParent(runtimeSettings.user)) {
				view.disableDelete();
				view.disableOK();
			}
			
			addToSignal(listSuccessSignal, listSuccess);
			listSignal.dispatch(CourseTemplate);
			listSignal.dispatch(Classroom);
			listSignal.dispatch(Classroomgroup);
			listSignal.dispatch(Project);

		}
		
		private function listSuccess(classType:Class):void {
			if(classType == CourseTemplate) {
				TopBarDetailView(view).editor["courseTemplates"] = courseTemplateModel.getSortedListByFields([new SortField("name")]);
			} else if(classType == Classroom) {
				TopBarDetailView(view).editor["classrooms"] = classroomModel.getSortedListByFields([new SortField("name")]);
			} else if (classType == Classroomgroup) {
				TopBarDetailView(view).editor["classroomgroups"] = classroomgroupModel.getSortedListByFields([new SortField("name")]);
			} else if (classType == Project) {
				TopBarDetailView(view).editor["projects"] = projectModel.getSortedListByFields([new SortField("name")]);
			}
		}
		
		override protected function beforeSaveHandler():void
		{
			Course(view.parameters.vo).courseTemplate = CourseTemplate(TopBarDetailView(view).editor["courseTemplatePopup"].selected);
			Course(view.parameters.vo).classroom = Classroom(TopBarDetailView(view).editor["classroomPopup"].selected);
			Course(view.parameters.vo).classroomgroup = Classroomgroup(TopBarDetailView(view).editor["classroomgroupPopup"].selected);
			Course(view.parameters.vo).project = Project(TopBarDetailView(view).editor["projectPopup"].selected);
		}

		override protected function validateSave():Boolean
		{
			if(Course(view.parameters.vo).name == null || Course(view.parameters.vo).name == '') {
				UI.showError("Please Enter Course's Name.");
				return false;
			}
			
			if(TopBarDetailView(view).editor["courseTemplatePopup"].selected == null) {
				UI.showError("Please Select a Course Template.");
				return false;
			}
			
			if(TopBarDetailView(view).editor["classroomPopup"].selected == null && TopBarDetailView(view).editor["classroomgroupPopup"].selected == null && TopBarDetailView(view).editor["projectPopup"].selected == null) {
				UI.showError("Please Assign the Course to a Classroom, Classroom Group, or Project.");
				return false;
			}
			
			return true;
		}
	}
}