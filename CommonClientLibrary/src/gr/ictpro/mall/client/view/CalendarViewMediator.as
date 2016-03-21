package gr.ictpro.mall.client.view
{
	import mx.rpc.events.FaultEvent;
	
	import gr.ictpro.mall.client.components.TopBarDetailView;
	import gr.ictpro.mall.client.model.AbstractModel;
	import gr.ictpro.mall.client.model.CalendarModel;
	import gr.ictpro.mall.client.model.ClassroomModel;
	import gr.ictpro.mall.client.model.UserModel;
	import gr.ictpro.mall.client.model.vo.Classroom;
	import gr.ictpro.mall.client.model.vo.GenericServiceArguments;
	import gr.ictpro.mall.client.model.vo.Schedule;
	import gr.ictpro.mall.client.runtime.Device;
	import gr.ictpro.mall.client.runtime.RuntimeSettings;
	import gr.ictpro.mall.client.signal.GenericCallErrorSignal;
	import gr.ictpro.mall.client.signal.GenericCallSignal;
	import gr.ictpro.mall.client.signal.GenericCallSuccessSignal;
	import gr.ictpro.mall.client.signal.ListErrorSignal;
	import gr.ictpro.mall.client.signal.ListSignal;
	import gr.ictpro.mall.client.signal.ListSuccessSignal;
	import gr.ictpro.mall.client.utils.ui.UI;
	import gr.ictpro.mall.client.view.components.CalendarComponent;
	import gr.ictpro.mall.client.view.components.MeetingComponent;

	public class CalendarViewMediator extends TopBarDetailViewMediator
	{
		[Inject]
		public var clasroomModel:ClassroomModel;

		[Inject]
		public var settings:RuntimeSettings;

		[Inject]
		public var listSignal:ListSignal;
		
		[Inject]
		public var listSuccessSignal:ListSuccessSignal;
		
		[Inject]
		public var listErrorSignal:ListErrorSignal;
		
		[Inject]
		public var genericCall:GenericCallSignal;
		
		[Inject]
		public var genericCallSuccess:GenericCallSuccessSignal;
		
		[Inject]
		public var genericCallError:GenericCallErrorSignal;

		[Inject]
		public var runtimeSettings:RuntimeSettings;

		[Inject]
		public function set calendarModel(model:CalendarModel):void
		{
			super.model = model as AbstractModel;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			if(view.parameters != null && view.parameters.initParams != null && view.parameters.initParams.calendar_id != null) {
				getCalendar(view.parameters.initParams.calendar_id);
			} else {
				init();
			}
		}

		private function init():void {
			var calendarComponent:CalendarComponent = CalendarComponent(TopBarDetailView(view).editor);
			if(calendarComponent.vo.classroom != null && (UserModel.isTeacher(runtimeSettings.user) || UserModel.isAdmin(runtimeSettings.user))) {  
				listSignal.dispatch(Classroom);
			}
			if(calendarComponent.vo.classroom != null && (UserModel.isStudent(runtimeSettings.user) || UserModel.isParent(runtimeSettings.user))) {
				calendarComponent.enabled = false;
				view.disableDelete();
				view.disableOK();
			}
			addToSignal(listSuccessSignal, success);
			addToSignal(listErrorSignal, error);
			addToSignal(saveSuccessSignal, saveSuccess);
			addToSignal(saveErrorSignal, saveError);
			addToSignal(deleteSuccessSignal, deleteSuccess);
			addToSignal(deleteErrorSignal, deleteError);
		}
		
		private function getCalendar(id:int):void
		{
			var args:GenericServiceArguments = new GenericServiceArguments();
			args.arguments = new Object();
			args.arguments.id = id;
			args.destination = "calendarRemoteService";
			args.method = "getCalendar";
			args.type = "get_calendar";
			genericCallSuccess.add(genericSuccess);
			genericCallError.add(genericError);
			genericCall.dispatch(args);
		}
		
		private function genericSuccess(type:String, result:Object):void
		{
			if(type == "get_calendar") {
				removeSignals();
				if(result != null) {
					view.parameters.vo = result;
					view.invalidateChildren();
					init();
					CalendarView(view).init();
				} else {
					UI.showError("Cannot get Calendar.");
					back();
				}
			}
		}
		
		private function genericError(type:String, event:FaultEvent):void
		{
			if(type == "get_calendar") {
				removeSignals();
				UI.showError("Cannot get Calendar.");
				back();
			}
		}
		
		private function removeSignals():void
		{
			genericCallSuccess.remove(success);
			genericCallError.remove(error);
		}

		private function success(classType:Class):void
		{
			if(classType == Classroom) {
				TopBarDetailView(view).editor["classrooms"] = clasroomModel.list;
				if(clasroomModel.list.length == 0) {
					TopBarDetailView(view).editor["classrooms"].visible= false;
				}
			}
		}

		private function error(classType:Class, errorMesage:String):void
		{
			if(classType == Classroom) {
				UI.showError(errorMesage);
			}
		}

		override protected function beforeSaveHandler():void {
			var calendarComponent:CalendarComponent = CalendarComponent(TopBarDetailView(view).editor);
			
			if(calendarComponent.selectedCalendarType == 0) {
				// one time
				if(calendarComponent.classroom.selected == null) {
					calendarComponent.vo.user = settings.user; 
				} else {
					calendarComponent.vo.classroom = calendarComponent.classroom.selected; 
				}
				
				calendarComponent.vo.description = calendarComponent.description.text;
				calendarComponent.vo.startTime = calendarComponent.startDate.date;
				calendarComponent.vo.endTime = calendarComponent.endDate.date;
				calendarComponent.vo.schedule = null;
			} else {
				// repeating
				if(calendarComponent.classroom.selected == null) {
					calendarComponent.vo.schedule.user = settings.user; 
				} else {
					calendarComponent.vo.schedule.classroom = calendarComponent.classroom.selected; 
				}
				
				calendarComponent.vo.schedule.description = calendarComponent.description.text;
				calendarComponent.vo.schedule.startTime = calendarComponent.startDate.date;
				calendarComponent.vo.schedule.endTime = calendarComponent.endDate.date;
				calendarComponent.vo.schedule.day = calendarComponent.day.dataList.getItemIndex(calendarComponent.day.selected);
				calendarComponent.vo.schedule.repeatInterval = parseInt(calendarComponent.repeatInterval.text, 10);
				calendarComponent.vo.schedule.repeatUntil = calendarComponent.repeatUntil.selectedDate;
			}
		}
		
		override protected function validateSave():Boolean {
			var calendarComponent:CalendarComponent = CalendarComponent(TopBarDetailView(view).editor);
			if(calendarComponent.selectedCalendarType == 0) {
				// one time
				if(calendarComponent.vo.description == null || calendarComponent.vo.description == '') {
					UI.showError("Please Enter a Description.");
					return false; 
				}
			} else {
				// repeating
				if(calendarComponent.vo.schedule.description == null || calendarComponent.vo.schedule.description == '') {
					UI.showError("Please Enter a Description.");
					return false; 
				}
			}
			return true;
		}		
		

		override protected function deleteHandler():void
		{
			var calendarComponent:CalendarComponent = CalendarComponent(TopBarDetailView(view).editor);
			var o:Object = view.parameters.vo;
			if(calendarComponent.selectedCalendarType == 1) {
				o = view.parameters.vo.schedule;
			}
			deleteSignal.dispatch(o);
		}
		
		override protected function saveHandler():void
		{
			var calendarComponent:CalendarComponent = CalendarComponent(TopBarDetailView(view).editor);
			var o:Object = view.parameters.vo;
			if(calendarComponent.selectedCalendarType == 1) {
				o = view.parameters.vo.schedule;
			}
			saveSignal.dispatch(o);
		}
		
		private function saveSuccess(classType:Class):void
		{
			// We need only to catch Schedule her. Calendar is catched by the super class
			if(classType == Schedule) {
				if(view.parameters != null && view.parameters.notification != null) {
					saveSignal.dispatch(view.parameters.notification);
				}
				back();
			}
		}
		
		private function saveError(classType:Class, errorMessage:String):void
		{
			// We need only to catch Schedule her. Calendar is catched by the super class
			if(classType == Schedule) {
				if(errorMessage != null)
					UI.showError(errorMessage);
			}
		}
		
		private function deleteSuccess(classType:Class):void
		{
			// We need only to catch Schedule her. Calendar is catched by the super class
			if(classType == Schedule) {
				back();
			}
		}
		
		private function deleteError(classType:Class, errorMessage:String):void
		{
			// We need only to catch Schedule her. Calendar is catched by the super class
			if(classType == Schedule) {
				if(errorMessage != null)
					UI.showError(errorMessage);
			}
		}
		
	}
}