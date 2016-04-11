package gr.ictpro.mall.client.view
{
	import flash.events.MouseEvent;
	
	import gr.ictpro.mall.client.components.Group;
	import gr.ictpro.mall.client.view.components.bbb.ParticipantsView;
	import gr.ictpro.mall.client.view.components.bbb.WhiteboardView;
	
	import org.bigbluebutton.command.JoinMeetingSignal;

	public class BBBMeetingViewMediator extends TopBarCollaborationViewMediator
	{
		[Inject]
		public var joinMeetingSignal:JoinMeetingSignal;
		
		private var currentModule:Group;
		
		
		override public function onRegister():void
		{
			super.onRegister();
			
			trace("joining meeting: " + view.parameters.vo.id);
			showView(new WhiteboardView());
			test();
		}
		
		private function test():void {
			var url:String = "http://192.168.0.20/bigbluebutton/api/join?meetingID=Demo+Meeting&fullName=test&password=mp&checksum=1f3a9cc3530a12f9e9cc83f9dde5e56a6dcb79e2";
			joinMeetingSignal.dispatch(url);
		}
		
		private function showView(currentModule:Group):void
		{
			BBBMeetingView(view).container.removeAllElements();
//			currentModule.percentWidth=100;
//			currentModule.percentHeight=100;
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
		
	}
}