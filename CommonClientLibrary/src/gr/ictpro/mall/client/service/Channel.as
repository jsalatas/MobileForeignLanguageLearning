package gr.ictpro.mall.client.service
{
	import mx.messaging.ChannelSet;
	import mx.messaging.channels.AMFChannel;
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
			var channel:AMFChannel;
			var pollingEndPoint:String;
			var pollingChannel:AMFChannel;
			if(serverURL.charAt(serverURL.length-1) != "/") {
				serverURL = serverURL + "/";
			}
			endPoint = serverURL + applicationPath+"/messagebroker/amf";
			channel = new AMFChannel("my-amf", endPoint);
			_channelSet.addChannel(channel);
					
			pollingEndPoint = serverURL + applicationPath+"/messagebroker/amfpolling";
			pollingChannel = new AMFChannel("my-polling-amf", pollingEndPoint);
			pollingChannel.pollingEnabled = true;
			pollingChannel.pollingInterval = 1000;
					
//			var streamingEndPoint:String = serverURL + applicationPath+"/messagebroker/amfstreaming";
//			var streamingChannel:StreamingAMFChannel = new StreamingAMFChannel("my-streaming-amf", streamingEndPoint);
				
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