package gr.ictpro.mall.client.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.utils.ObjectProxy;
	
	import gr.ictpro.mall.client.components.TopBarDetailView;
	import gr.ictpro.mall.client.components.TopBarListView;
	import gr.ictpro.mall.client.model.AbstractModel;
	import gr.ictpro.mall.client.model.IPersistent;
	import gr.ictpro.mall.client.model.ViewParameters;
	import gr.ictpro.mall.client.signal.ListErrorSignal;
	import gr.ictpro.mall.client.signal.ListSignal;
	import gr.ictpro.mall.client.signal.ListSuccessSignal;
	import gr.ictpro.mall.client.utils.ui.UI;

	public class TopBarListViewMediator extends TopBarViewMediator
	{
		private var _detailViewClass:Class;

		protected var model:AbstractModel;
		
		[Inject]
		public var listSignal:ListSignal;
		
		[Inject]
		public var listErrorSignal:ListErrorSignal;
		
		[Inject]
		public var listSuccessSignal:ListSuccessSignal;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			eventMap.mapListener(view, "addClicked", addClicked);
			eventMap.mapListener(view, "showDetailClicked", showDetailClicked);
			addToSignal(listSuccessSignal, listSuccess);
			addToSignal(listErrorSignal, listError);
			listSignal.dispatch(model.getVOClass());
		}

		private function listSuccess(classType:Class):void
		{
			if(classType == model.getVOClass()) {
				TopBarListView(view).data = model.list;
			}
		}

		private function listError(classType:Class, errorMessage:String):void
		{
			if(classType == model.getVOClass()) {
				UI.showError(view, errorMessage);
			}
		}

		protected function setDetailViewClass(detailViewClass:Class):void
		{
			this._detailViewClass = detailViewClass;
		}
		
		private function addClicked(event:MouseEvent):void
		{
			var parameters:Object = buildParameters(model.create());
			showDetail(parameters);
		}
		
		private function buildParameters(vo:Object):ViewParameters
		{
			var parameters:ViewParameters = new ViewParameters();
			parameters.vo = vo;

			if(view.parameters != null && view.parameters.notification != null) {
				parameters.notification = view.parameters.notification; 
			}
			

			return parameters;
		}		
		
		private function showDetailClicked(event:Event):void
		{
			showDetail(buildParameters(event.target.selectedItem));
		}
		
		private function showDetail(parameters:Object):void
		{
			var detailView:TopBarDetailView = new _detailViewClass() as TopBarDetailView;
			addView.dispatch(detailView, parameters, view);
			view.dispose();
		}
	}
}