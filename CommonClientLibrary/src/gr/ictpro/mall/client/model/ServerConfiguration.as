package gr.ictpro.mall.client.model
{
	import flash.sampler.NewObjectSample;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import gr.ictpro.mall.client.service.RemoteObjectService;

	public class ServerConfiguration 
	{
		private var _persistentData:Object;
		
		
		public function ServerConfiguration(channel:Channel)
		{
			new RemoteObjectService(channel, destination, "getConfig", null, resultHandler, errorHandler);
		}
		
		public function get destination():String 
		{
			return "configRemoteService";	
		}
		
		public function get methodName():String
		{
			return "saveConfig";
		}
		
		public function get persistentData():Object
		{
			return this._persistentData;
			
		}
		
		public function resultHandler(event:ResultEvent):void
		{
			_persistentData = new Object();
			var res:ArrayCollection = event.result as ArrayCollection;
			for each (var config:Object in res) {
				_persistentData[config.name] =  config.value;		
			}
			
		}
		
		public function errorHandler(event:FaultEvent):void
		{
		}

	}
}