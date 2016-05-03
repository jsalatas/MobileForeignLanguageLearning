package org.bigbluebutton.command {
	
	import org.bigbluebutton.model.UserSession;
	import org.robotlegs.mvcs.SignalCommand;
	
	
	public class DisconnectUserCommand extends SignalCommand {
		
		[Inject]
		public var disconnectionStatusCode:int;
		
		[Inject]
		public var userSession:UserSession;
		
		public function DisconnectUserCommand() {
			super();
		}
		
		override public function execute():void {
			if (userSession.mainConnection)
				userSession.mainConnection.disconnect(true);
			if (userSession.videoConnection)
				userSession.videoConnection.disconnect(true);
			if (userSession.voiceConnection)
				userSession.voiceConnection.disconnect(true);
			if (userSession.deskshareConnection)
				userSession.deskshareConnection.disconnect(true);
		}
	}
}
