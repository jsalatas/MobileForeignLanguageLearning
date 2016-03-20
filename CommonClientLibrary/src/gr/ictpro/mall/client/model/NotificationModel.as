package gr.ictpro.mall.client.model
{
	import flash.errors.IllegalOperationError;
	
	import gr.ictpro.mall.client.model.vo.Notification;
	import gr.ictpro.mall.client.runtime.Device;
	
	public class NotificationModel extends AbstractModel implements IServerPersistent
	{
		public function NotificationModel()
		{
			super(Notification, null, null);
		}
		
		public function get deleteErrorMessage():String
		{
			//Not implemented
			throw new IllegalOperationError("Deleting Notifications is not permitted");
		}
		
		public function get listErrorMessage():String
		{
			return Device.translations.getTranslation("Cannot Get Notifications.");
		}
		
		public function get saveErrorMessage():String
		{
			return Device.translations.getTranslation("Cannot Save Notification.");
		}
		
		public function get destination():String
		{
			return "notificationRemoteService";
		}
		
		public function get saveMethod():String
		{
			return "updateNotification";
		}
		public function get deleteMethod():String
		{
			// Not implemented
			throw new IllegalOperationError("Deleting Notifications is not permitted");
		}
		
		public function get listMethod():String
		{
			return "getNotifications";
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