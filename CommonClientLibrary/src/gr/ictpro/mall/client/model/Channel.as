package gr.ictpro.mall.client.model
{
	import mx.messaging.ChannelSet;
	import mx.messaging.channels.AMFChannel;
	import mx.messaging.channels.SecureAMFChannel;

	public class Channel
	{
		private var _channelSet:ChannelSet = new ChannelSet();
		private var _messagingChannelSet:ChannelSet = new ChannelSet();
		
		
		public function Channel()
		{
		}
		
		public function setupChannel(serverName:String, applicationPath:String):void
		{
			var endPoint:String = "https://" +serverName + ":8443/" + applicationPath+"/messagebroker/amfsecure";
			var channel:SecureAMFChannel = new SecureAMFChannel("my-secure-amf", endPoint);
			_channelSet.addChannel(channel);
			
			var messagingEndPoint:String = "https://" +serverName + ":8443/" + applicationPath+"/messagebroker/amfsecurepolling";
			var messagingChannel:SecureAMFChannel = new SecureAMFChannel("my-secure-polling-amf", messagingEndPoint);
			_messagingChannelSet.addChannel(messagingChannel);
		}
		
		public function getChannelSet():ChannelSet
		{
			return _channelSet;
		}

		public function getMessagingChannelSet():ChannelSet
		{
			return _messagingChannelSet;
		}
	}
}