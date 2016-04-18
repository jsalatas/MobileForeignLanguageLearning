package gr.ictpro.mall.client.service
{
	import mx.messaging.ChannelSet;
	import mx.messaging.channels.AMFChannel;
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
			var endPoint:String;
			var channel;
			var pollingEndPoint:String;
			var pollingChannel;
			if(serverURL.indexOf("https://")>-1) {
				endPoint = serverURL + applicationPath+"/messagebroker/amfsecure";
				channel = new SecureAMFChannel("my-secure-amf", endPoint);
				_channelSet.addChannel(channel);
				
				pollingEndPoint = serverURL + applicationPath+"/messagebroker/amfsecurepolling";
				pollingChannel = new SecureAMFChannel("my-secure-polling-amf", pollingEndPoint);
				pollingChannel.pollingEnabled = true;
				pollingChannel.pollingInterval = 1000;
			
//				var streamingEndPoint:String = serverURL + applicationPath+"/messagebroker/amfsecurestreaming";
//				var streamingChannel:SecureStreamingAMFChannel = new SecureStreamingAMFChannel("my-secure-streaming-amf", streamingEndPoint);

//				_messagingChannelSet.addChannel(streamingChannel);
				_messagingChannelSet.addChannel(pollingChannel);
				_messagingChannelSet.heartbeatInterval = 5000;
			} else {
				endPoint = serverURL + applicationPath+"/messagebroker/amf";
				channel = new AMFChannel("my-amf", endPoint);
				_channelSet.addChannel(channel);
					
				pollingEndPoint = serverURL + applicationPath+"/messagebroker/amfsecurepolling";
				pollingChannel = new AMFChannel("my-secure-polling-amf", pollingEndPoint);
				pollingChannel.pollingEnabled = true;
				pollingChannel.pollingInterval = 1000;
					
//				var streamingEndPoint:String = serverURL + applicationPath+"/messagebroker/amfsecurestreaming";
//				var streamingChannel:SecureStreamingAMFChannel = new SecureStreamingAMFChannel("my-secure-streaming-amf", streamingEndPoint);
				
//				_messagingChannelSet.addChannel(streamingChannel);
				_messagingChannelSet.addChannel(pollingChannel);
				_messagingChannelSet.heartbeatInterval = 5000;
			}
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