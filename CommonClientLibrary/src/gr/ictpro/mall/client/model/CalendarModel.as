package gr.ictpro.mall.client.model
{
	import gr.ictpro.mall.client.model.vo.Calendar;
	import gr.ictpro.mall.client.model.vo.Schedule;
	import gr.ictpro.mall.client.runtime.Device;
	import gr.ictpro.mall.client.view.CalendarView;
	import gr.ictpro.mall.client.view.components.CalendarComponent;

	public class CalendarModel extends AbstractModel implements IServerPersistent
	{
		public function CalendarModel()
		{
			super(Calendar, CalendarView, CalendarComponent);
		}
		
		public function get destination():String
		{
			return "calendarRemoteService";
		}
		
		public function get saveMethod():String
		{
			return "updateCalendar";
		}
		
		public function get deleteMethod():String
		{
			return "deleteCalendar";
		}
		
		public function get listMethod():String
		{
			return "getCalendars";
		}
		
		public function get saveErrorMessage():String
		{
			return Device.translations.getTranslation("Cannot Save Calendar.");
		}
		
		public function get deleteErrorMessage():String
		{
			return Device.translations.getTranslation("Cannot Delete Calendar.");
		}
		
		public function get listErrorMessage():String
		{
			return Device.translations.getTranslation("Cannot Get Calendar.");
		}
		
		public function get idField():String
		{
			return "id";
		}
		
		public function idIsNull(vo:Object):Boolean
		{
			return isNaN(vo[idField]);
		}

		
		override public function create():Object
		{
			var calendar:Calendar = Calendar(super.create());
			
			calendar.startTime = new Date();
			calendar.endTime = new Date();
			
			if(calendar.startTime.minutes%15 != 0) {
					calendar.startTime.minutes -= calendar.startTime.minutes%15;
			}

			if(calendar.endTime.minutes%15 != 0) {
				calendar.endTime.minutes -= calendar.endTime.minutes%15;
			}

			// default duration: 1 hour
			calendar.endTime.hours += 1;
			
			var schedule:Schedule = new Schedule();
			calendar.schedule = schedule;
			
			schedule.startTime = calendar.startTime;
			schedule.endTime = calendar.endTime;
			schedule.repeatUntil = new Date(calendar.endTime);
			schedule.repeatUntil.fullYear += 1; 
			schedule.repeatInterval = 1;
			
			
			return calendar;
		}
		

	}
}