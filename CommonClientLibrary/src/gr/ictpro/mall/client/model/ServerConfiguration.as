package gr.ictpro.mall.client.model
{
	import gr.ictpro.mall.client.service.RemoteObjectService;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	public class ServerConfiguration implements IServerPersistentObject
	{
		private var _persistentData:PersistentData = null;
		
		
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
		
		public function get persistentData():PersistentData
		{
			return this._persistentData;
			
		}
		
		public function resultHandler(event:ResultEvent):void
		{
			_persistentData = new PersistentData();
			var res:ArrayCollection = event.result as ArrayCollection;
			for each (var config:Object in res) {
				_persistentData.addValue(config.name, config.value);		
			}
			
		}
		
		public function errorHandler(event:FaultEvent):void
		{
		}

	}
}