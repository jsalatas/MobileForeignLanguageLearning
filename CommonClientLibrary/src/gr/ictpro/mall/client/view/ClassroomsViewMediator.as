package gr.ictpro.mall.client.view
{
	import mx.rpc.events.FaultEvent;
	
	import gr.ictpro.mall.client.components.PopupNotification;
	import gr.ictpro.mall.client.model.Channel;
	import gr.ictpro.mall.client.model.Settings;
	import gr.ictpro.mall.client.model.Translation;
	import gr.ictpro.mall.client.service.RemoteObjectService;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class ClassroomsViewMediator extends Mediator
	{
		[Inject]
		public var view:ClassroonsView;

		[Inject]
		public var channel:Channel;
		
		[Inject]
		public var settings:Settings;

		override public function onRegister():void
		{
//			view.title = Translation.getTranslation("Classrooms");
//			view.save.add(saveHandler);
//			view.cancel.add(cancelHandler);
//			view.back.add(backHandler);
//			
//			var ro:RemoteObjectService = new RemoteObjectService(channel, "classroomRemoteService", "getClassrooms", , handleGetClassrooms, getClassroomsError); 
			
		}
		
		private function getClassroomsError(event:FaultEvent):void
		{
			var classroomsErrorPopup:PopupNotification = new PopupNotification();
			classroomsErrorPopup.message = Translation.getTranslation("Cannot Get Classrooms.");
			
			classroomsErrorPopup.open(view, true);
		}

	}
}