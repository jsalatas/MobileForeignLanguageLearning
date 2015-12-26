package gr.ictpro.mall.client.service
{
	import mx.messaging.ChannelSet;
	import mx.messaging.channels.SecureAMFChannel;
	import mx.messaging.channels.StreamingAMFChannel;

	public class Channel
	{
		private var _channelSet:ChannelSet = new ChannelSet();
		private var _messagingChannelSet:ChannelSet = new ChannelSet();
		
		
		public function Channel()
		{
		}
		
		public function setupChannel(serverURL:String, applicationPath:String):void
		{
			var endPoint:String = serverURL + applicationPath+"/messagebroker/amfsecure";
			var channel:SecureAMFChannel = new SecureAMFChannel("my-secure-amf", endPoint);
			_channelSet.addChannel(channel);
			
			var messagingEndPoint:String = serverURL + applicationPath+"/messagebroker/amfsecurestreaming";
			var messagingChannel:StreamingAMFChannel = new StreamingAMFChannel("my-secure-streaming-amf", messagingEndPoint);
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