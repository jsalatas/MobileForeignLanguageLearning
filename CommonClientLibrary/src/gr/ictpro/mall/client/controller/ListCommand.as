package gr.ictpro.mall.client.controller
{
	import flash.utils.ByteArray;
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
	import gr.ictpro.mall.client.model.UserModel;
	import gr.ictpro.mall.client.model.vo.Classroom;
	import gr.ictpro.mall.client.model.vo.User;
	import gr.ictpro.mall.client.model.vomapper.VOMapper;
	import gr.ictpro.mall.client.runtime.RuntimeSettings;
	import gr.ictpro.mall.client.service.Channel;
	import gr.ictpro.mall.client.service.LocalDBStorage;
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
		
		[Inject]
		public var localDBStorage:LocalDBStorage;

		[Inject]
		public var runtimeSettings:RuntimeSettings;
		

		override public function execute():void
		{
			var model:AbstractModel = mapper.getModelforVO(classType);
			if(model is IServerPersistent) {
				if(model.list.length == 0 || model.forceRefresh) {
					listServerObjects(model as IServerPersistent);
				} else {
					// We already have data
					listSuccess.dispatch(classType);
				}
			} else if (model is IClientPersistent) {
				listClientObjects(model as IClientPersistent);
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
			try {
				localDBStorage.loadObjects(model);
			} catch (e:Error) {
				listError.dispatch(AbstractModel(model), model.saveErrorMessage);
				return; 
			}
			listSuccess.dispatch(AbstractModel(model).getVOClass());
		}

		protected function success(event:ResultEvent):void
		{
			var model:IPersistent = IPersistent(mapper.getModelforVO(classType));
			model.list = ArrayCollection(event.result);
			AbstractModel(model).forceRefresh = false;
			if(classType == Classroom && UserModel.isTeacher(runtimeSettings.user)) {
				runtimeSettings.user.teacherClassrooms = model.list; 
			}
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