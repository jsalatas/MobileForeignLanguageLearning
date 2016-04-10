package gr.ictpro.mall.client.view
{
	import flash.events.MouseEvent;
	
	import org.bigbluebutton.command.JoinMeetingSignal;

	public class BBBMeetingViewMediator extends TopBarCollaborationViewMediator
	{
		[Inject]
		public var joinMeetingSignal:JoinMeetingSignal;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			trace("joining meeting: " + view.parameters.vo.id);
			test();
		}
		
		private function test():void {
			var url:String = "http://192.168.0.20/bigbluebutton/api/join?meetingID=Demo+Meeting&fullName=test&password=mp&checksum=1f3a9cc3530a12f9e9cc83f9dde5e56a6dcb79e2";
			joinMeetingSignal.dispatch(url);
		}
		
		override protected function whiteboardClicked(event:MouseEvent):void
		{
			//BBBMeetingView(view).container.removeAllElements();
			//BBBMeetingView(view).container.addElement(new Whi
		}
		
		
	}
}