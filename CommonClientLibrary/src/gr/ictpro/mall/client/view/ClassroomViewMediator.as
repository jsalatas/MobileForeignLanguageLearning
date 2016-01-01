package gr.ictpro.mall.client.view
{
	import mx.collections.ArrayCollection;
	
	import spark.collections.SortField;
	
	import gr.ictpro.mall.client.model.AbstractModel;
	import gr.ictpro.mall.client.model.ClassroomModel;
	import gr.ictpro.mall.client.model.LanguageModel;
	import gr.ictpro.mall.client.model.UserModel;
	import gr.ictpro.mall.client.model.vo.Classroom;
	import gr.ictpro.mall.client.model.vo.Language;
	import gr.ictpro.mall.client.model.vo.User;
	import gr.ictpro.mall.client.runtime.RuntimeSettings;
	import gr.ictpro.mall.client.runtime.Translation;
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
			
			ClassroomView(view).userModel = userModel;
			
			addToSignal(listSuccessSignal, listSuccess);

			if(settings.user != null && !userModel.isAdmin(settings.user)) {
				ClassroomView(view).teacher.visible = false;
			} else {
				var args:Object = new Object();
				listSignal.dispatch(User);
			}
			listSignal.dispatch(Language);
		}

		private function listSuccess(classType:Class):void {
			if(classType == Language) {
				ClassroomView(view).languages = languageModel.getSortedListByFields([new SortField("englishName")]);
			} else if (classType == User) {
				ClassroomView(view).teachers = userModel.getFilteredList(filterTeachers);
			}
		}
		
		private function filterTeachers(item:Object):Boolean {
			var user:User = User(item);
			return userModel.isTeacher(user);
		}
		
		override protected function beforeSaveHandler():void
		{
			Classroom(view.parameters.vo).language =  Language(ClassroomView(view).languagePopup.selected);
			
			var newTeacher:User;
			if(userModel.isAdmin(settings.user)) {
				newTeacher = User(ClassroomView(view).teacherPopup.selected); 
			} else {
				newTeacher = settings.user;
			}
			
			if(Classroom(view.parameters.vo).users == null) {
				Classroom(view.parameters.vo).users = new ArrayCollection();
			}
			
			// Get old Teacher (if exists)
			var oldTeacher:User = null;
			for each(var user:User in Classroom(view.parameters.vo).users) {
				if(userModel.isTeacher(user)) {
					oldTeacher = user;
					break;
				}
			}
			
			if(oldTeacher != null) {
				Classroom(view.parameters.vo).users.removeItemAt(Classroom(view.parameters.vo).users.getItemIndex(oldTeacher));
			}
			
			Classroom(view.parameters.vo).users.addItem(newTeacher);
		}
		
		override protected function validateSave():Boolean
		{
			if(Classroom(view.parameters.vo).name == null || Classroom(view.parameters.vo).name == '') {
				UI.showError(view, Translation.getTranslation("Please Enter Classroom's Name"));
				return false;
			}
			
			if(ClassroomView(view).languagePopup.selected == null) {
				UI.showError(view, Translation.getTranslation("Please Assign a Language to the Classroom"));
				return false;
			}
			
			var teacher:User = null;
			for each(var user:User in Classroom(view.parameters.vo).users) {
				if(userModel.isTeacher(user)) {
					teacher = user;
					break;
				}
			}

			if(teacher == null) {
				UI.showError(view, Translation.getTranslation("Please Assign a Teacher to the Classroom"));
				return false;
			}
			return true;
		}
	}
}