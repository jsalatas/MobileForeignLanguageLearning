package gr.ictpro.mall.client.model
{
	import flash.errors.IllegalOperationError;
	
	import gr.ictpro.mall.client.model.vo.Schedule;
	import gr.ictpro.mall.client.runtime.Device;

	public class ScheduleModel extends AbstractModel implements IServerPersistent
	{
		public function ScheduleModel()
		{
			super(Schedule, null, null);
		}
		
		public function get destination():String
		{
			return "calendarRemoteService";
		}
		
		public function get saveMethod():String
		{
			return "updateSchedule";
		}
		
		public function get deleteMethod():String
		{
			return "deleteSchedule";
		}
		
		public function get listMethod():String
		{
			throw new IllegalOperationError("List method not available in Schedule");
		}
		
		public function get saveErrorMessage():String
		{
			return Device.tranlations.getTranslation("Cannot Save Schedule.");
		}
		
		public function get deleteErrorMessage():String
		{
			return Device.tranlations.getTranslation("Cannot Delete Schedule.");
		}
		
		public function get listErrorMessage():String
		{
			throw new IllegalOperationError("List method not available in Schedule");
		}
		
		public function get idField():String
		{
			return "id";
		}
		
		public function idIsNull(vo:Object):Boolean
		{
			return isNaN(vo[idField]);
		}
	}
}