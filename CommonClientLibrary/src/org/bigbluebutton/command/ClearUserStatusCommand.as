package org.bigbluebutton.command {
	
	import org.bigbluebutton.core.UsersService;
	import org.bigbluebutton.model.ConferenceParameters;
	import org.bigbluebutton.model.UserSession;
	import org.robotlegs.mvcs.SignalCommand;
	
	public class ClearUserStatusCommand extends SignalCommand {
		
		[Inject]
		public var conferenceParameters:ConferenceParameters;
		
		[Inject]
		public var userSession:UserSession;
		
		[Inject]
		public var userService:UsersService;
		
		[Inject]
		public var userID:String;
		
		override public function execute():void {
			trace("ClearUserStatusCommand.execute() - clear status");
			if (conferenceParameters.serverIsMconf) {
				userService.clearUserStatus(userID);
			} else {
				userService.lowerHand(userID, userSession.userList.me.userID);
			}
		}
	}
}
