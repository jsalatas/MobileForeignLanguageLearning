package gr.ictpro.mall.client.view
{
	import flash.events.MouseEvent;
	
	import gr.ictpro.mall.client.components.Group;
	import gr.ictpro.mall.client.view.components.bbb.ChatView;
	import gr.ictpro.mall.client.view.components.bbb.MeetingSettingsView;
	import gr.ictpro.mall.client.view.components.bbb.ParticipantsView;
	import gr.ictpro.mall.client.view.components.bbb.ShowVideoEvent;
	import gr.ictpro.mall.client.view.components.bbb.VideoView;
	import gr.ictpro.mall.client.view.components.bbb.WhiteboardView;
	
	import org.bigbluebutton.command.JoinMeetingSignal;
	import org.bigbluebutton.core.UsersService;

	public class BBBMeetingViewMediator extends TopBarCollaborationViewMediator
	{
		[Inject]
		public var joinMeetingSignal:JoinMeetingSignal;
		
		[Inject]
		public var usersService:UsersService;
		
		protected var currentModule:Group;
		
		
		override public function onRegister():void
		{
			super.onRegister();
			
			showView(new (MeetingSettingsView));

			joinMeetingSignal.dispatch(view.parameters.vo.url);
		}
		
		private function showView(currentModule:Group):void
		{
			BBBMeetingView(view).container.removeAllElements();
			BBBMeetingView(view).container.addElement(currentModule);
			this.currentModule = currentModule;
			
		}
		
		override protected function whiteboardClicked(event:MouseEvent):void
		{
			if(currentModule == null || !(currentModule is WhiteboardView)) {
				showView(new WhiteboardView());
			} else {
				trace("already showing whiteboard");
			}
		}
		
		override protected function participantsClicked(event:MouseEvent):void
		{
			if(currentModule == null || !(currentModule is ParticipantsView)) {
				showView(new ParticipantsView());
			} else {
				trace("already showing participants");
			}
		}

		override protected function chatClicked(event:MouseEvent):void
		{
			if(currentModule == null || !(currentModule is ChatView)) {
				showView(new ChatView());
			} else {
				trace("already showing chat");
			}
		}

		override protected function videoClicked(event:ShowVideoEvent):void
		{
			if(currentModule == null || !(currentModule is VideoView)) {
				var v:VideoView = new VideoView();
				v.currentUser = event.user;
				showView(v);
			} else {
				trace("already showing video");
			}
		}

		override protected function settingsClicked(event:MouseEvent):void
		{
			if(currentModule == null || !(currentModule is MeetingSettingsView)) {
				var v:MeetingSettingsView = new MeetingSettingsView();
				showView(v);
			} else {
				trace("already showing settings");
			}
		}


	}
}