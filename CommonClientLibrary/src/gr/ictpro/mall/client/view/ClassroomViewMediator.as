package gr.ictpro.mall.client.view
{
	import spark.collections.SortField;
	
	import gr.ictpro.mall.client.components.TopBarDetailView;
	import gr.ictpro.mall.client.model.AbstractModel;
	import gr.ictpro.mall.client.model.ClassroomModel;
	import gr.ictpro.mall.client.model.LanguageModel;
	import gr.ictpro.mall.client.model.UserModel;
	import gr.ictpro.mall.client.model.vo.Classroom;
	import gr.ictpro.mall.client.model.vo.Language;
	import gr.ictpro.mall.client.model.vo.User;
	import gr.ictpro.mall.client.runtime.Device;
	import gr.ictpro.mall.client.runtime.RuntimeSettings;
	import gr.ictpro.mall.client.signal.ListSignal;
	import gr.ictpro.mall.client.signal.ListSuccessSignal;
	import gr.ictpro.mall.client.utils.ui.UI;
	
	public class ClassroomViewMediator extends TopBarDetailViewMediator
	{
		[Inject]
		public var settings:RuntimeSettings;
		
		[Inject]
		public var userModel:UserModel;
		
		[Inject]
		public var languageModel:LanguageModel;
		
		[Inject]
		public var listSignal:ListSignal;

		[Inject]
		public var listSuccessSignal:ListSuccessSignal;

		[Inject]
		public function set classroomModel(model:ClassroomModel):void
		{
			super.model = model as AbstractModel;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			addToSignal(listSuccessSignal, listSuccess);

			if(settings.user != null && ! UserModel.isAdmin(settings.user)) {
				TopBarDetailView(view).editor["teacher"].visible = false;
			} else {
				var args:Object = new Object();
				listSignal.dispatch(User);
			}
			listSignal.dispatch(Language);
		}

		private function listSuccess(classType:Class):void {
			if(classType == Language) {
				TopBarDetailView(view).editor["languages"] = languageModel.getSortedListByFields([new SortField("englishName")]);
			} else if (classType == User) {
				TopBarDetailView(view).editor["teachers"] = userModel.getFilteredList(filterTeachers);
			}
		}
		
		private function filterTeachers(item:Object):Boolean {
			var user:User = User(item);
			return UserModel.isTeacher(user);
		}
		
		override protected function beforeSaveHandler():void
		{
//			Classroom(view.parameters.vo).name = TopBarDetailView(view).editor["txtName"].text;
//			Classroom(view.parameters.vo).notes = TopBarDetailView(view).editor["txtNotes"].text;
			Classroom(view.parameters.vo).language =  Language(TopBarDetailView(view).editor["languagePopup"].selected);
			
			var newTeacher:User;
			if(UserModel.isAdmin(settings.user)) {
				newTeacher = User(TopBarDetailView(view).editor["teacherPopup"].selected); 
			} else {
				newTeacher = settings.user;
			}
			
			Classroom(view.parameters.vo).teacher = newTeacher;
		}
		
		override protected function validateSave():Boolean
		{
			if(Classroom(view.parameters.vo).name == null || Classroom(view.parameters.vo).name == '') {
				UI.showError(Device.tranlations.getTranslation("Please Enter Classroom's Name"));
				return false;
			}
			
			if(TopBarDetailView(view).editor["languagePopup"].selected == null) {
				UI.showError(Device.tranlations.getTranslation("Please Assign a Language to the Classroom"));
				return false;
			}
			
			if(Classroom(view.parameters.vo).teacher  == null) {
				UI.showError(Device.tranlations.getTranslation("Please Assign a Teacher to the Classroom"));
				return false;
			}
			return true;
		}
	}
}