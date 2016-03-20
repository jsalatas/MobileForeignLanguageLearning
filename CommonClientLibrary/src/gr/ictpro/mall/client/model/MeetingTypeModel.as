package gr.ictpro.mall.client.model
{
	import gr.ictpro.mall.client.model.vo.MeetingType;
	import gr.ictpro.mall.client.runtime.Device;

	public class MeetingTypeModel extends AbstractModel implements IServerPersistent
	{
		public function MeetingTypeModel()
		{
			super(MeetingType, null, null);
		}
		
		public function get saveErrorMessage():String
		{
			throw new Error("Save operation not permitted in MeetingType objects");
		}
		
		public function get deleteErrorMessage():String
		{
			throw new Error("Delete operation not permitted in MeetingType objects");
		}
		
		public function get listErrorMessage():String
		{
			return Device.translations.getTranslation("Cannot Get Meeting Types.");
		}
		
		public function get idField():String
		{
			return "id";
		}
		
		public function idIsNull(vo:Object):Boolean
		{
			return isNaN(vo[idField]);
		}
		
		public function get destination():String
		{
			return "meetingRemoteService";
		}
		
		public function get saveMethod():String
		{
			throw new Error("Save operation not permitted in MeetingType objects");
		}
		
		public function get deleteMethod():String
		{
			throw new Error("Delete operation not permitted in MeetingType objects");
		}
		
		public function get listMethod():String
		{
			return "getMeetingTypes";
		}
	}
}