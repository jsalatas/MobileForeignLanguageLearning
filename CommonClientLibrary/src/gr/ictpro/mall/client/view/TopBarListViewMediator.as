package gr.ictpro.mall.client.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.utils.ObjectProxy;
	
	import gr.ictpro.mall.client.components.TopBarDetailView;

	public class TopBarListViewMediator extends TopBarViewMediator
	{
		private var _detailViewClass:Class;
		private var _buildParametersHandler:Function;
		private var _getNewHandler:Function;

		override public function onRegister():void
		{
			super.onRegister();
			
			view.addEventListener("addClicked", addClicked);
			view.addEventListener("showDetailClicked", showDetailClicked);
		}

		protected function setDetailViewClass(detailViewClass:Class):void
		{
			this._detailViewClass = detailViewClass;
		}
		
		protected function setBuildParametersHandler(buildParametersHandler:Function):void
		{
			this._buildParametersHandler = buildParametersHandler;
		}
		
		protected function setGetNewHandler(getNewHandler:Function):void
		{
			this._getNewHandler = getNewHandler;
		}
		
		protected function addClicked(event:MouseEvent):void
		{
			var parameters:ObjectProxy = _buildParametersHandler(_getNewHandler());
			showDetail(parameters);
		}

		protected function showDetailClicked(event:Event):void
		{
			var parameters:ObjectProxy = _buildParametersHandler(event.target.selectedItem);
			showDetail(parameters);
		}
		
		protected function showDetail(parameters:ObjectProxy):void
		{
			var detailView:TopBarDetailView = new _detailViewClass() as TopBarDetailView;
			view.removeEventListener("addClicked", addClicked);
			view.removeEventListener("showDetailClicked", showDetailClicked);
			addView.dispatch(detailView, parameters, view);
			view.dispose();
		}

		override protected function back():void
		{
			view.removeEventListener("addClicked", addClicked);
			view.removeEventListener("showDetailClicked", showDetailClicked);
			super.back();
		}

	}
}