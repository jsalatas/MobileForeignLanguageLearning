package org.bigbluebutton.command {
	
	import org.bigbluebutton.core.UsersService;
	import org.bigbluebutton.model.UserSession;
	import org.robotlegs.mvcs.SignalCommand;
	
	public class ChangeRoleCommand extends SignalCommand {
		
		[Inject]
		public var userSession:UserSession;
		
		[Inject]
		public var userService:UsersService;
		
		[Inject]
		public var roleOptions:Object;
		
		private var _userID:String;
		
		private var _role:String;
		
		override public function execute():void {
			getRoleOptions(roleOptions);
			trace("ChangeRoleCommand.execute() - change mood");
			userService.changeRole(_userID, _role);
		}
		
		private function getRoleOptions(options:Object):void {
			if (options != null && options.hasOwnProperty("userID") && options.hasOwnProperty("role")) {
				_userID = options.userID;
				_role = options.role;
			}
		}
	}
}
