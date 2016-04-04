package org.bigbluebutton.command {
	
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.model.UserUISession;
	import org.robotlegs.mvcs.SignalCommand;
	
	public class AuthenticationCommand extends SignalCommand {
		
		[Inject]
		public var command:String;
		
		[Inject]
		public var userUISession:UserUISession;
		
		[Inject]
		public var userSession:UserSession;
		
		public function AuthenticationCommand() {
			super();
		}
		
		override public function execute():void {
			userUISession.loading = false;
			switch (command) {
				case "timeOut":
					userUISession.unsuccessJoined.dispatch("authTokenTimedOut");
					break;
				case "invalid":
					userUISession.unsuccessJoined.dispatch("authTokenInvalid");
					break;
			}
		}
	}
}
