package org.bigbluebutton.command {
	
	import org.bigbluebutton.core.UsersService;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.model.User;
	import org.robotlegs.mvcs.SignalCommand;
	
	public class MicrophoneMuteCommand extends SignalCommand {
		
		[Inject]
		public var user:User;
		
		[Inject]
		public var userSession:UserSession;
		
		[Inject]
		public var userService:UsersService;
		
		override public function execute():void {
			trace("MicrophoneMuteCommand.execute() - user.muted = " + user.muted);
			if (user != null) {
				if (user.muted) {
					userService.unmute(user);
				} else {
					userService.mute(user);
				}
			}
		}
	}
}
