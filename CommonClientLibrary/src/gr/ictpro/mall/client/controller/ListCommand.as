package gr.ictpro.mall.client.controller
{
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	
	import gr.ictpro.mall.client.model.AbstractModel;
	import gr.ictpro.mall.client.model.IClientPersistent;
	import gr.ictpro.mall.client.model.IPersistent;
	import gr.ictpro.mall.client.model.IServerPersistent;
	import gr.ictpro.mall.client.model.vomapper.VOMapper;
	import gr.ictpro.mall.client.service.Channel;
	import gr.ictpro.mall.client.signal.ListErrorSignal;
	import gr.ictpro.mall.client.signal.ListSuccessSignal;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class ListCommand extends SignalCommand
	{
		[Inject]
		public var channel:Channel;
		
		[Inject]
		public var classType:Class;
		
		[Inject]
		public var mapper:VOMapper;
		
		[Inject]
		public var listSuccess:ListSuccessSignal;
		
		[Inject]
		public var listError:ListErrorSignal;
		
		override public function execute():void
		{
			var model:AbstractModel = mapper.getModelforVO(classType);
			if(model.list.length == 0) {
				if(model is IServerPersistent) {
					listServerObjects(model as IServerPersistent);
				} else if (model is IClientPersistent) {
					listClientObjects(model as IClientPersistent);
				}
			} else {
				// We already have data
				listSuccess.dispatch(classType);
			}
		}
		
		protected function listServerObjects(model:IServerPersistent):void
		{
			var ro:RemoteObject = new RemoteObject();
			ro.showBusyCursor= true;
			ro.channelSet = channel.getChannelSet();
			ro.destination = model.destination;
			ro[model.listMethod].addEventListener(ResultEvent.RESULT, success);
			ro[model.listMethod].addEventListener(FaultEvent.FAULT, error);
			ro[model.listMethod].send();
			


		}

		protected function listClientObjects(model:IClientPersistent):void
		{
			//TODO:
		}

		protected function success(event:ResultEvent):void
		{
			var model:IPersistent = IPersistent(mapper.getModelforVO(classType));
			model.list = ArrayCollection(event.result);
			listSuccess.dispatch(classType);
		}
		
		protected function error(event:FaultEvent):void
		{
			var model:IPersistent = IPersistent(mapper.getModelforVO(classType));
			model.list = new ArrayCollection();
			listError.dispatch(classType, model.listErrorMessage);
		}

	}
}