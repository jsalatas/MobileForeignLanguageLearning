package gr.ictpro.mall.client.view
{
	import flash.events.MouseEvent;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import gr.ictpro.mall.client.model.SaveLocation;
	import gr.ictpro.mall.client.service.RemoteObjectService;
	import gr.ictpro.mall.client.utils.ui.UI;

	public class TopBarDetailViewMediator extends TopBarViewMediator
	{
		private var _saveHandler:Function;
		private var _cancelHandler:Function;
		private var _deleteHandler:Function;
		private var _saveSuccessHandler:Function;
		private var _saveErrorHandler:Function;
		private var _saveErrorMessage:String;
		private var _deleteSuccessHandler:Function;
		private var _deleteErrorHandler:Function;
		private var _deleteErrorMessage:String;

		override public function onRegister():void
		{
			super.onRegister();
			view.addEventListener("okClicked", okClicked);
			view.addEventListener("cancelClicked", cancelClicked);
			view.addEventListener("deleteClicked", deleteClicked);
		}
		
		protected function setSaveHandler(saveHandler:Function):void
		{
			this._saveHandler = saveHandler;
		}
		
		protected function setCancelHandler(cancelHandler:Function):void
		{
			this._cancelHandler = cancelHandler;
		}

		protected function setDeleteHandler(deleteHandler:Function):void
		{
			this._deleteHandler = deleteHandler;
		}
		
		protected function setSaveSuccessHandler(saveSuccessHandler:Function):void
		{
			this._saveSuccessHandler = saveSuccessHandler;
		}
		
		protected function setSaveErrorHandler(saveErrorHandler:Function):void
		{
			this._saveErrorHandler = saveErrorHandler;
		}
		
		protected function setSaveErrorMessage(saveErrorMessage:String):void
		{
			this._saveErrorMessage = saveErrorMessage;
		}

		protected function setDeleteSuccessHandler(deleteSuccessHandler:Function):void
		{
			this._deleteSuccessHandler = deleteSuccessHandler;
		}
		
		protected function setDeleteErrorHandler(deleteErrorHandler:Function):void
		{
			this._deleteErrorHandler = deleteErrorHandler;
		}
		
		protected function setDeleteErrorMessage(deleteErrorMessage:String):void
		{
			this._deleteErrorMessage = deleteErrorMessage;
		}

		protected function okClicked(event:MouseEvent):void
		{
			if(_saveHandler != null)
				_saveHandler();
		}
		
		protected function cancelClicked(event:MouseEvent):void
		{
			if(_cancelHandler != null)
				_cancelHandler();
			
			backClicked(event);
		}
		
		protected function deleteClicked(event:MouseEvent):void
		{
			if(_deleteHandler != null)
				_deleteHandler();
		}

		protected function saveData(location:String, persistentObject:Object, service:String, method:String):void 
		{
			if(location == SaveLocation.SERVER) {
				var ro:RemoteObjectService = new RemoteObjectService(channel, service, method, persistentObject, handleSaveSuccess, handleSaveError);
			} else if(location == SaveLocation.CLIENT) {
				//TODO: Save data on device
			}
		}
		
		private function handleSaveSuccess(event:ResultEvent):void
		{
			if(_saveSuccessHandler != null) 
				_saveSuccessHandler(event);
			
			if(view.parameters.hasOwnProperty('notification')) {
				serverNotificationHandle.dispatch(view.parameters.notification);
			}
			
			super.back();
		}
		
		private function handleSaveError(event:FaultEvent):void
		{
			if(_saveErrorMessage != null)
				UI.showError(view, _saveErrorMessage);
			
			if(_saveErrorHandler != null) 
				_saveErrorHandler(event);
		}
		
		protected function deleteData(location:String, persistentObject:Object, service:String, method:String):void 
		{
			if(location == SaveLocation.SERVER) {
				var ro:RemoteObjectService = new RemoteObjectService(channel, service, method, persistentObject, handleDeleteSuccess, handleDeleteError);
			} else if(location == SaveLocation.CLIENT) {
				//TODO: Save data on device
			}
		}
		
		private function handleDeleteSuccess(event:ResultEvent):void
		{
			if(_deleteSuccessHandler != null) 
				_deleteSuccessHandler(event);
			
			super.back();
		}
		
		private function handleDeleteError(event:FaultEvent):void
		{
			if(_deleteErrorMessage != null)
				UI.showError(view, _deleteErrorMessage);
			
			if(_deleteErrorHandler != null) 
				_deleteErrorHandler(event);
			
			if(_deleteErrorHandler == null && _deleteErrorMessage != null) {
				throw new Error("Unhandled Server Error");
			}
		}

		override protected function back():void
		{
			view.removeEventListener("okClicked", okClicked);
			view.removeEventListener("cancelClicked", cancelClicked);
			view.removeEventListener("deleteClicked", deleteClicked);
			super.back();
		}
	}
}