package gr.ictpro.mall.client.view
{
	import flash.events.MouseEvent;
	
	import mx.states.State;
	
	import gr.ictpro.mall.client.model.AbstractModel;
	import gr.ictpro.mall.client.model.IPersistent;
	import gr.ictpro.mall.client.signal.DeleteErrorSignal;
	import gr.ictpro.mall.client.signal.DeleteSignal;
	import gr.ictpro.mall.client.signal.DeleteSuccessSignal;
	import gr.ictpro.mall.client.signal.SaveErrorSignal;
	import gr.ictpro.mall.client.signal.SaveSignal;
	import gr.ictpro.mall.client.signal.SaveSuccessSignal;
	import gr.ictpro.mall.client.utils.ui.UI;

	public class TopBarDetailViewMediator extends TopBarViewMediator
	{
		[Inject]
		public var saveSignal:SaveSignal;

		[Inject]
		public var saveSuccessSignal:SaveSuccessSignal;

		[Inject]
		public var saveErrorSignal:SaveErrorSignal;

		[Inject]
		public var deleteSignal:DeleteSignal;
		
		[Inject]
		public var deleteSuccessSignal:DeleteSuccessSignal;
		
		[Inject]
		public var deleteErrorSignal:DeleteErrorSignal;

		protected var model:AbstractModel;
		
		override public function onRegister():void
		{
			super.onRegister();
			eventMap.mapListener(view, "okClicked", okClicked);
			eventMap.mapListener(view, "cancelClicked", cancelClicked);
			eventMap.mapListener(view, "deleteClicked", deleteClicked);

			addToSignal(saveSuccessSignal, saveSuccess);
			addToSignal(saveErrorSignal, saveError);
			addToSignal(deleteSuccessSignal, deleteSuccess);
			addToSignal(deleteErrorSignal, deleteError);
			
			if(viewHasState("new") && viewHasState("edit") && view.parameters != null && view.parameters.vo != null) {
				if(IPersistent(model).idIsNull(view.parameters.vo)) {
					view.currentState = "new";
					view.disableDelete();
				} else {
					view.currentState = "edit";
				}
			}
		}
		
		private function viewHasState(stateName:String):Boolean {
			for(var i:int = 0; i < view.states.length; i++) {
				if(view.states[i].name == stateName) {
					return true;
				}
				
			}
			return false;
		}
		
		private function okClicked(event:MouseEvent):void
		{
			beforeSaveHandler();
			if(validateSave()) {
				saveHandler();
			}
		}
		
		protected function beforeSaveHandler():void {
		}		
		
		protected function validateSave():Boolean {
			return true;
		}		
		
		protected function saveHandler():void {
			saveSignal.dispatch(view.parameters.vo);
		}

		private function saveSuccess(classType:Class):void
		{
			if(classType == model.getVOClass()) {
				if(view.parameters.notification != null) {
					saveSignal.dispatch(view.parameters.notification);
				}
				back();
			}
		}
		
		private function saveError(classType:Class, errorMessage:String):void
		{
			if(classType == view.parameters.getVOClass()) {
				if(errorMessage != null)
					UI.showError(errorMessage);
			}
		}
		
		private function cancelClicked(event:MouseEvent):void
		{
			cancelHandler();
			back();
		}

		protected function cancelHandler():void {
		}
		
		
		private function deleteClicked(event:MouseEvent):void
		{
			beforeDeleteHandler();
			if(validateDelete()) {
				deleteHandler();
			}
		}
		
		protected function validateDelete():Boolean {
			return true;
		}

		protected function beforeDeleteHandler():void {
			
		}

		protected function deleteHandler():void {
			deleteSignal.dispatch(view.parameters.vo);
		}
		
		private function deleteSuccess(classType:Class):void
		{
			if(classType == model.getVOClass()) {
				back();
			}
		}
		
		private function deleteError(classType:Class, errorMessage:String):void
		{
			if(classType == model.getVOClass()) {
				if(errorMessage != null)
					UI.showError(errorMessage);
			}
		}

	}
}