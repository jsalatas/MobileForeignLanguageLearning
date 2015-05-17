package gr.ictpro.mall.client.controller
{
	import gr.ictpro.mall.client.model.Channel;
	import gr.ictpro.mall.client.model.IClientPersistentObject;
	import gr.ictpro.mall.client.model.IPersistentObject;
	import gr.ictpro.mall.client.model.IServerPersistentObject;
	import gr.ictpro.mall.client.model.PersistentData;
	import gr.ictpro.mall.client.model.PersistentObjectWrapper;
	import gr.ictpro.mall.client.service.RemoteObjectService;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class PersistCommand extends SignalCommand
	{
		[Inject]
		public var persistentObjectWrapper:PersistentObjectWrapper;

		[Inject]
		public var channel:Channel;

		override public function execute():void
		{
			var persistentObject:IPersistentObject = persistentObjectWrapper.persistentObject;
			if(persistentObject is IServerPersistentObject) {
				trace ("server side");
				var destination:String = (persistentObject as IServerPersistentObject).destination;
				var methodName:String = (persistentObject as IServerPersistentObject).methodName;
				new RemoteObjectService(channel, destination, methodName, persistentObject.persistentData, handleSuccess, handleError);  
			} else if(persistentObject is IClientPersistentObject) {
				trace ("client side");
			}
		}
		
		private function handleSuccess(event:ResultEvent):void
		{
			persistentObjectWrapper.successHandler(event);
		}
		
		private function handleError(event:FaultEvent):void
		{
			persistentObjectWrapper.errorHandler(event);
		}

	}
}