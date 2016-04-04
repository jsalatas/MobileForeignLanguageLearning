package org.bigbluebutton.command {
	
	import org.bigbluebutton.core.UsersService;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.model.User;
	import org.robotlegs.mvcs.SignalCommand;
	
	public class PresenterCommand extends SignalCommand {
		
		[Inject]
		public var userSession:UserSession;
		
		[Inject]
		public var userService:UsersService;
		
		[Inject]
		public var user:User;
		
		[Inject]
		public var userMeID:String;
		
		override public function execute():void {
			trace("PresenterCommand.execute() -assign presenter");
			userService.assignPresenter(user.userID, user.name, userMeID);
		}
	}
}
