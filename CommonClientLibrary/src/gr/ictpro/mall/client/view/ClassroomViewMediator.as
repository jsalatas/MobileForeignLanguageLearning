package gr.ictpro.mall.client.view
{
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.collections.Sort;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectProxy;
	
	import spark.collections.SortField;
	
	import gr.ictpro.mall.client.model.SaveLocation;
	import gr.ictpro.mall.client.model.Settings;
	import gr.ictpro.mall.client.model.Translation;
	import gr.ictpro.mall.client.service.RemoteObjectService;
	import gr.ictpro.mall.client.utils.ui.UI;
	
	public class ClassroomViewMediator extends TopBarDetailViewMediator
	{
		[Inject]
		public var settings:Settings;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			setSaveHandler(handleSave);
			setSaveErrorHandler(handleSaveError);
			setDeleteHandler(handleDelete);
			setDeleteErrorMessage(Translation.getTranslation('Cannot Delete Classroom.'));

			var ro:RemoteObjectService;
			if(view.parameters.classroom.name=="") {
				view.currentState = "new";
				view.disableDelete();
			} else {
				view.currentState = "edit";
			}
			if(settings.user != null && !settings.user.isAdmin) {
				ClassroomView(view).teacher.visible = false;
			} else {
				var args:Object = new Object();
				args.role="Teacher";
				ro = new RemoteObjectService(channel, "userRemoteService", "getUsers", args, handleGetTeachers, handleGetTeachersError);
			}
			ro = new RemoteObjectService(channel, "languageRemoteService", "getLanguages", null, handleGetLanguages, getLanguagesError);
		}

		private function handleGetLanguages(event:ResultEvent):void
		{
			var languages:ArrayCollection = new ArrayCollection();
			var items:ArrayCollection = ArrayCollection(event.result);
			for(var i:int=0; i<items.length; i++) {
				var o:Object = new ObjectProxy(items.getItemAt(i));
				o.text = o.englishName + " - " + o.localName;
				languages.addItem(o);
			}
			var sort:Sort = new Sort();
			sort.fields = [new SortField("text")];
			languages.sort = sort;
			languages.refresh();
			
			ClassroomView(view).languages = new ArrayList(languages.toArray());
		}
		
		private function getLanguagesError(event:FaultEvent):void
		{
			UI.showError(view, Translation.getTranslation("Cannot Get Languages."));
		}

		private function handleGetTeachers(event:ResultEvent):void
		{
			var items:ArrayCollection = ArrayCollection(event.result);
			var teachers:ArrayCollection = new ArrayCollection();
			for each (var o:Object in items) {
				var teacher:ObjectProxy = new ObjectProxy();
				teacher.id = o.id; 	
				teacher.text = o.hasOwnProperty("profile")?o.profile.name + " <" + o.username + ">" : "<" +o.username + ">";
				teachers.addItem(teacher);
			}
			var sort:Sort = new Sort();
			sort.fields = [new SortField("text")];
			teachers.sort = sort;
			teachers.refresh();
				
			ClassroomView(view).teachers = new ArrayList(teachers.toArray());
	
		}
		
		private function handleGetTeachersError(event:FaultEvent):void
		{
			UI.showError(view,Translation.getTranslation('Cannot Get Teachers.'));
		}
		
		private function handleSave():void
		{
			var teacherId:int;
			var classroom:Object = new Object();
			if(view.parameters.classroom.name == null || view.parameters.classroom.name == '') {
				UI.showError(view, Translation.getTranslation("Please Enter Classroom's Name"));
				return;
			}
			
			if(settings.user.isAdmin) {
				if(ClassroomView(view).teacherPopup.selected == null) {
					UI.showError(view, Translation.getTranslation("Please Assign a Teacher to the Classroom"));
					return;
				}
				teacherId = ClassroomView(view).teacherPopup.selected.id; 
			} else {
				teacherId =settings.user.id;
			}
			
			if(ClassroomView(view).languagePopup.selected == null) {
				UI.showError(view, Translation.getTranslation("Please Assign a Language to the Classroom"));
				return;
			}
			if(view.parameters.classroom.hasOwnProperty("id")) {
				classroom.id = view.parameters.classroom.id; 
			}
			classroom.language_code = ClassroomView(view).languagePopup.selected.code;
			classroom.teacher_id = teacherId; 
			classroom.name = view.parameters.classroom.name;
			classroom.notes = view.parameters.classroom.notes;
			
			saveData(SaveLocation.SERVER, classroom, "classroomRemoteService", "updateClassroom");
		}

		private function handleSaveError(event:FaultEvent):void
		{
			if(event.fault.faultString.indexOf("org.hibernate.exception.ConstraintViolationException") > -1) {
				UI.showError(view,Translation.getTranslation("Classroom's Name and Language Combinations Already Exist. Please Choose Another name."));
			} else {
				UI.showError(view,Translation.getTranslation('Cannot Save Classroom.'));
			}
		}

		private function handleDelete():void 
		{
			var classroom:Object = new Object();
			classroom.classroom_id = view.parameters.classroom.id; 
			deleteData(SaveLocation.SERVER, classroom, "classroomRemoteService", "deleteClassroom");
		}

	}
}