package gr.ictpro.mall.client.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.utils.ObjectUtil;
	
	import gr.ictpro.mall.client.components.TopBarCommunicationView;
	import gr.ictpro.mall.client.components.TopBarDetailView;
	import gr.ictpro.mall.client.model.UserModel;
	import gr.ictpro.mall.client.model.vo.GenericServiceArguments;
	import gr.ictpro.mall.client.signal.GenericCallErrorSignal;
	import gr.ictpro.mall.client.signal.GenericCallSignal;
	import gr.ictpro.mall.client.signal.GenericCallSuccessSignal;
	import gr.ictpro.mall.client.utils.ui.UI;

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
			eventMap.mapListener(view, "showDetailClicked", showDetailClicked);
			
			var args:GenericServiceArguments = new GenericServiceArguments;
			args.type = "getOnlineUsers";
			args.destination = "userRemoteService";
			args.method = "getOnlineUsers"
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
		
		private function showDetailClicked(event:Event):void
		{
			// Use a copy of the object and not the one in the list
			// TODO:
			//showDetail(buildParameters(ObjectUtil.copy(event.target.selectedItem)));
		}
		
		private function showDetail(parameters:Object):void
		{
			var detailViewClass:Class = model.getViewClass();
			var detailView:TopBarDetailView = new detailViewClass() as TopBarDetailView;
//			detailView.model = model;
			addView.dispatch(detailView, parameters, view);
			view.dispose();
		}
	}
}