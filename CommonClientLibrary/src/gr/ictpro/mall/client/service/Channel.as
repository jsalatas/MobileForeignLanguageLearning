package gr.ictpro.mall.client.service
{
	import mx.messaging.ChannelSet;
	import mx.messaging.channels.SecureAMFChannel;
	import mx.messaging.channels.SecureStreamingAMFChannel;
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
			
			var pollingEndPoint:String = serverURL + applicationPath+"/messagebroker/amfsecurepolling";
			var pollingChannel:SecureAMFChannel = new SecureAMFChannel("my-secure-polling-amf", pollingEndPoint);
			pollingChannel.pollingEnabled = true;
			pollingChannel.pollingInterval = 1000;
			
//			var streamingEndPoint:String = serverURL + applicationPath+"/messagebroker/amfsecurestreaming";
//			var streamingChannel:SecureStreamingAMFChannel = new SecureStreamingAMFChannel("my-secure-streaming-amf", streamingEndPoint);

//			_messagingChannelSet.addChannel(streamingChannel);
			_messagingChannelSet.addChannel(pollingChannel);
			_messagingChannelSet.heartbeatInterval = 5000;
			
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