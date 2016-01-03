package gr.ictpro.mall.client.controller
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	
	import gr.ictpro.mall.client.model.AbstractModel;
	import gr.ictpro.mall.client.model.IClientPersistent;
	import gr.ictpro.mall.client.model.IPersistent;
	import gr.ictpro.mall.client.model.IServerPersistent;
	import gr.ictpro.mall.client.model.vomapper.VOMapper;
	import gr.ictpro.mall.client.service.Channel;
	import gr.ictpro.mall.client.service.LocalDBStorage;
	import gr.ictpro.mall.client.signal.DeleteErrorSignal;
	import gr.ictpro.mall.client.signal.DeleteSuccessSignal;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class DeleteCommand extends SignalCommand
	{
		[Inject]
		public var channel:Channel;
		[Inject]
		public var localDBStorage:LocalDBStorage;
		
		[Inject]
		public var vo:Object;
		
		[Inject]
		public var mapper:VOMapper;
		
		[Inject]
		public var model:VOMapper;
		
		[Inject]
		public var deleteSuccess:DeleteSuccessSignal;
		
		[Inject]
		public var deleteError:DeleteErrorSignal;
		
		override public function execute():void
		{
			var model:AbstractModel = mapper.getModelforVO(Class(getDefinitionByName(getQualifiedClassName(vo))));
			if(model is IServerPersistent) {
				deleteServerObject(model as IServerPersistent);
			} else if (model is IClientPersistent) {
				deleteClientObject(model as IClientPersistent);
			}
		}

		protected function deleteServerObject(model:IServerPersistent):void
		{
			var ro:RemoteObject = new RemoteObject();
			ro.showBusyCursor= true;
			ro.channelSet = channel.getChannelSet();
			ro.destination = model.destination;
			ro[model.deleteMethod].addEventListener(ResultEvent.RESULT, success);
			ro[model.deleteMethod].addEventListener(FaultEvent.FAULT, error);
			ro[model.deleteMethod].send(vo);
		}
		
		protected function deleteClientObject(model:IClientPersistent):void
		{
			try {
				localDBStorage.deleteObject(model, vo);
			} catch (e:Error) {
				deleteError.dispatch(Class(getDefinitionByName(getQualifiedClassName(vo))), model.saveErrorMessage);
				return; 
			}
			deleteSuccess.dispatch(Class(getDefinitionByName(getQualifiedClassName(vo))));
		}
		
		protected function success(event:ResultEvent):void
		{
			var model:IPersistent = IPersistent(mapper.getModelforVO(Class(getDefinitionByName(getQualifiedClassName(vo)))));
			deleteSuccess.dispatch(Class(getDefinitionByName(getQualifiedClassName(vo))));
		}
		
		protected function error(event:FaultEvent):void
		{
			var model:IPersistent = IPersistent(mapper.getModelforVO(Class(getDefinitionByName(getQualifiedClassName(vo)))));
			deleteError.dispatch(Class(getDefinitionByName(getQualifiedClassName(vo))), model.saveErrorMessage);
		}

	}
}