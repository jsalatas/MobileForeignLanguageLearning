package org.bigbluebutton.command {
	
	import org.bigbluebutton.core.UsersService;
	import org.bigbluebutton.model.UserSession;
	import org.robotlegs.mvcs.SignalCommand;
	
	public class LockUserCommand extends SignalCommand {
		
		[Inject]
		public var userSession:UserSession;
		
		[Inject]
		public var userService:UsersService;
		
		[Inject]
		public var userID:String;
		
		[Inject]
		public var lock:Boolean;
		
		override public function execute():void {
			userService.setUserLock(userID, lock);
		}
	}
}
