package gr.ictpro.mall.client.view
{
	import mx.rpc.events.FaultEvent;
	
	import gr.ictpro.mall.client.model.Channel;
	import gr.ictpro.mall.client.model.Settings;
	import gr.ictpro.mall.client.model.Translation;
	import gr.ictpro.mall.client.service.RemoteObjectService;
	import gr.ictpro.mall.client.utils.ui.UI;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class ClassroomsViewMediator extends Mediator
	{
		[Inject]
		public var view:ClassroomsView;

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
			UI.showError(view,Translation.getTranslation("Cannot Get Classrooms."));
		}

	}
}