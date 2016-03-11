package gr.ictpro.mall.client.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.utils.ObjectUtil;
	
	import gr.ictpro.mall.client.components.LongPressEvent;
	import gr.ictpro.mall.client.components.TopBarCommunicationView;
	import gr.ictpro.mall.client.components.TopBarDetailView;
	import gr.ictpro.mall.client.components.VOEditor;
	import gr.ictpro.mall.client.components.VOViewerPopup;
	import gr.ictpro.mall.client.model.UserModel;
	import gr.ictpro.mall.client.model.ViewParameters;
	import gr.ictpro.mall.client.model.vo.GenericServiceArguments;
	import gr.ictpro.mall.client.runtime.Device;
	import gr.ictpro.mall.client.signal.GenericCallErrorSignal;
	import gr.ictpro.mall.client.signal.GenericCallSignal;
	import gr.ictpro.mall.client.signal.GenericCallSuccessSignal;
	import gr.ictpro.mall.client.utils.ui.UI;
	import gr.ictpro.mall.client.view.components.UserComponent;

	public class TopBarCommunicationViewMediator extends TopBarViewMediator
	{
		[Inject]
		public var model:UserModel;
		
		[Inject]
		public var genericCallSignal:GenericCallSignal;
		
		[Inject]
		public var genericCallErrorSignal:GenericCallErrorSignal;
		
		[Inject]
		public var genericCallSuccessSignal:GenericCallSuccessSignal;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			eventMap.mapListener(view, "addClicked", addClicked);
			eventMap.mapListener(view, "longpress", showDetailClicked);
			
			var args:GenericServiceArguments = new GenericServiceArguments;
			args.type = "getOnlineUsers";
			args.destination = "userRemoteService";
			args.method = "getUsers"
			args.arguments = null;

			
			addToSignal(genericCallSuccessSignal, listSuccess);
			addToSignal(genericCallErrorSignal, listError);
			genericCallSignal.dispatch(args);
		}

		protected function listSuccess(type:String, result:Object):void
		{
			if(type == "getOnlineUsers") {
				TopBarCommunicationView(view).data = ArrayCollection(result);
			}
		}

		private function listError(type:String, event:FaultEvent):void
		{
			if(type == "getOnlineUsers") {
				UI.showError("Cannot get Online Users.");
			}
		}

		private function addClicked(event:MouseEvent):void
		{
			//TODO:
			//var parameters:Object = buildParameters(model.create());
			//showDetail(parameters);
		}

//TODO:		
//		protected function buildParameters(vo:Object):ViewParameters
//		{
//			var parameters:ViewParameters = new ViewParameters();
//			parameters.vo = vo;
//
//			if(view.parameters != null && view.parameters.notification != null) {
//				parameters.notification = view.parameters.notification; 
//			}
//			
//
//			return parameters;
//		}		
		
		private function showDetailClicked(event:LongPressEvent):void
		{
			var viewerPopup:VOViewerPopup = new VOViewerPopup();
			
			var component:VOEditor = new UserComponent();
			component.vo = event.item;
			component.currentState = "view";
			viewerPopup.view = component;
			viewerPopup.open(Device.shellView, true);

		}
		
	}
}