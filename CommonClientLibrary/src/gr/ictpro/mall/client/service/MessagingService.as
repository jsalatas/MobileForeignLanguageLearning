package gr.ictpro.mall.client.service
{
	import mx.collections.ArrayList;
	import mx.messaging.Consumer;
	import mx.messaging.events.MessageEvent;
	
	import gr.ictpro.mall.client.runtime.RuntimeSettings;
	import gr.ictpro.mall.client.signal.GetServerNotificationsSignal;

	public class MessagingService
	{
		[Inject]
		public var channel:Channel;

		[Inject]
		public var settings:RuntimeSettings;
		
		[Inject]
		public var updateServerNotifications:GetServerNotificationsSignal;
		
		private var consumer:Consumer = new Consumer();
		
		public function MessagingService()
		{
		}
		
		public function init(): void
		{
			consumer.destination = "messages";
			consumer.channelSet = channel.getMessagingChannelSet();
			consumer.subscribe();
			consumer.addEventListener(MessageEvent.MESSAGE, receiveMessage);
			
		}

		private function receiveMessage(event:MessageEvent): void 
		{
			var subject:String = event.message.headers.Subject;
			switch(subject)
			{
				case "New Notifications":
				{
					var params:Object = event.message.headers.Parameters;
					var update:Boolean = false;
					if(params.hasOwnProperty("users")) {
						var userid:int = settings.user.id;
						for each (var id:int in params.users) {
							if(id == userid) {
								update = true;
								break;
							}
						}
					}
					if(!update && params.hasOwnProperty("roles")) {
						var userRoles:ArrayList = settings.user.roles;
						for each (var role:String in params.roles) {
							if(userRoles.getItemIndex(role) != -1) {
								update = true;
								break;
							}
						}
					}
					
					if(update) {
						updateServerNotifications.dispatch();
					}
					break;
				}
					
				default:
				{
					trace(subject);
				}
			}
			trace(event.message.body);
		}
	}
}