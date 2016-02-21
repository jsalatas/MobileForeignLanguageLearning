package gr.ictpro.mall.client.controller
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
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
	import gr.ictpro.mall.client.service.LocalDBStorage;
	import gr.ictpro.mall.client.signal.ListSignal;
	import gr.ictpro.mall.client.signal.SaveErrorSignal;
	import gr.ictpro.mall.client.signal.SaveSuccessSignal;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class SaveCommand extends SignalCommand
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
		public var saveSuccess:SaveSuccessSignal;
		
		[Inject]
		public var saveError:SaveErrorSignal;

		[Inject]
		public var listSignal:ListSignal;

		override public function execute():void
		{
			var model:AbstractModel = mapper.getModelforVO(Class(getDefinitionByName(getQualifiedClassName(vo))));
			if(model is IServerPersistent) {
				saveServerObject(model as IServerPersistent);
			} else if (model is IClientPersistent) {
				saveClientObject(model as IClientPersistent);
			}
		}
		
		protected function saveServerObject(model:IServerPersistent):void
		{
			var ro:RemoteObject = new RemoteObject();
			ro.showBusyCursor= true;
			ro.channelSet = channel.getChannelSet();
			ro.destination = model.destination;
			ro[model.saveMethod].addEventListener(ResultEvent.RESULT, success);
			ro[model.saveMethod].addEventListener(FaultEvent.FAULT, error);
			ro[model.saveMethod].send(vo);
			
			
			
		}
		
		protected function saveClientObject(model:IClientPersistent):void
		{
			try {
				localDBStorage.saveObject(model, vo);
			} catch (e:Error) {
				saveError.dispatch(Class(getDefinitionByName(getQualifiedClassName(vo))), model.saveErrorMessage);
				return; 
			}
			saveSuccess.dispatch(AbstractModel(model).getVOClass());
		}
		
		protected function success(event:ResultEvent):void
		{
			var model:IPersistent = IPersistent(mapper.getModelforVO(Class(getDefinitionByName(getQualifiedClassName(vo)))));
			listSignal.dispatch(AbstractModel(model).getVOClass());
			saveSuccess.dispatch(Class(getDefinitionByName(getQualifiedClassName(vo))));
		}
		
		protected function error(event:FaultEvent):void
		{
			var model:IPersistent = IPersistent(mapper.getModelforVO(Class(getDefinitionByName(getQualifiedClassName(vo)))));
			if(model is IClientPersistent) {
				model.list.removeAll();
			}
			saveError.dispatch(Class(getDefinitionByName(getQualifiedClassName(vo))), model.saveErrorMessage);
		}
	}
}