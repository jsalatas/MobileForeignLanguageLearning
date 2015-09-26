package gr.ictpro.mall.client.model
{
	public class ServerNotificationSelected
	{
		private var _notification:ServerNotification;
		
		public function ServerNotificationSelected(notification:ServerNotification)
		{
			this._notification = notification;
		}
		
		public function get notification():ServerNotification
		{
			return _notification;
		}
	}
}