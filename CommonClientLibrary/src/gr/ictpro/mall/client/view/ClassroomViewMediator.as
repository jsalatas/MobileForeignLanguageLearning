package gr.ictpro.mall.client.view
{
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.collections.Sort;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectProxy;
	
	import spark.collections.SortField;
	
	import gr.ictpro.mall.client.model.Channel;
	import gr.ictpro.mall.client.model.Settings;
	import gr.ictpro.mall.client.model.Translation;
	import gr.ictpro.mall.client.service.RemoteObjectService;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	import gr.ictpro.mall.client.signal.ServerNotificationHandledSignal;
	import gr.ictpro.mall.client.utils.ui.UI;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class ClassroomViewMediator extends Mediator
	{
		[Inject]
		public var view:ClassroomView;
		
		[Inject]
		public var addView:AddViewSignal;
		
		[Inject]
		public var settings:Settings;
		
		[Inject]
		public var channel:Channel;
		
		[Inject]
		public var serverNotificationHandle:ServerNotificationHandledSignal;
		
		override public function onRegister():void
		{
			view.cancel.add(cancelHandler);
			view.back.add(backHandler);
			view.ok.add(saveHandler);
			view.deleteClassroom.add(deleteClassroomHandler);
			var ro:RemoteObjectService;
			if(view.parameters.classroom.name=="") {
				view.currentState = "new";
				view.disableDelete();
			} else {
				view.currentState = "edit";
			}
			if(settings.user != null && !settings.user.isAdmin) {
				view.teacher.visible = false;
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
			
			view.languages = new ArrayList(languages.toArray());
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
				
			view.teachers = new ArrayList(teachers.toArray());
	
		}
		
		private function handleGetTeachersError(event:FaultEvent):void
		{
			UI.showError(view,Translation.getTranslation('Cannot Get Teachers.'));
		}
		
		private function cancelHandler():void
		{
			backHandler();
		}

		private function backHandler():void
		{
			view.cancel.removeAll();
			view.back.removeAll();
			view.ok.removeAll();
			view.deleteClassroom.removeAll();
			view.dispose();
			if(view.masterView == null) {
				addView.dispatch(new MainView());	
			} else {
				addView.dispatch(view.masterView);
			}
		}

		private function saveHandler():void
		{
			var teacherId:int;
			var classroom:Object = new Object();
			if(view.parameters.classroom.name == null || view.parameters.classroom.name == '') {
				UI.showError(view, Translation.getTranslation("Please Enter Classroom's Name"));
				return;
			}
			
			if(settings.user.isAdmin) {
				if(view.teacherPopup.selected == null) {
					UI.showError(view, Translation.getTranslation("Please Assign a Teacher to the Classroom"));
					return;
				}
				teacherId =view.teacherPopup.selected.id; 
			} else {
				teacherId =settings.user.id;
			}
			
			if(view.languagePopup.selected == null) {
				UI.showError(view, Translation.getTranslation("Please Assign a Language to the Classroom"));
				return;
			}
			if(view.parameters.classroom.hasOwnProperty("id")) {
				classroom.id = view.parameters.classroom.id; 
			}
			classroom.language_code = view.languagePopup.selected.code;
			classroom.teacher_id = teacherId; 
			classroom.name = view.parameters.classroom.name;
			classroom.notes = view.parameters.classroom.notes;
			
			var ro:RemoteObjectService = new RemoteObjectService(channel, "classroomRemoteService", "updateClassroom", classroom, handleSave, handleSaveError);
		}

		private function handleSave(event:ResultEvent):void
		{
			if(view.parameters.hasOwnProperty('notification')) {
				serverNotificationHandle.dispatch(view.parameters.notification);
			}
			if(view.parameters.hasOwnProperty('notification')) {
				serverNotificationHandle.dispatch(view.parameters.notification);
			}
			backHandler();	
		}
		
		private function handleSaveError(event:FaultEvent):void
		{
			if(event.fault.faultString.indexOf("org.hibernate.exception.ConstraintViolationException") > -1) {
				UI.showError(view,Translation.getTranslation("Classroom's Name and Language Combinations Already Exist. Please Choose Another name."));
			} else {
				UI.showError(view,Translation.getTranslation('Cannot Save Classroom.'));
			}
		}

		private function deleteClassroomHandler(language:Object):void 
		{
			var classroom:Object = new Object();
			classroom.classroom_id = view.parameters.classroom.id; 
			var ro:RemoteObjectService = new RemoteObjectService(channel, "classroomRemoteService", "deleteClassroom", classroom, handleDelete, handleDeleteError);
		}
		
		private function handleDelete(event:ResultEvent):void
		{
			backHandler();
		}
		
		private function handleDeleteError(event:FaultEvent):void
		{
			UI.showError(view,Translation.getTranslation('Cannot Delete Classroom.'));
		}
		

	}
}