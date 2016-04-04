package org.bigbluebutton.command {
	
	import org.bigbluebutton.core.UsersService;
	import org.bigbluebutton.model.UserSession;
	import org.robotlegs.mvcs.SignalCommand;
	
	public class MoodCommand extends SignalCommand {
		
		[Inject]
		public var userSession:UserSession;
		
		[Inject]
		public var userService:UsersService;
		
		[Inject]
		public var mood:String;
		
		override public function execute():void {
			trace("MoodCommand.execute() - change mood");
			userService.changeMood(mood);
		}
	}
}
