package org.bigbluebutton.command {
	
	import org.bigbluebutton.core.LoginService;
	import org.bigbluebutton.model.ConferenceParameters;
	import org.bigbluebutton.model.Config;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.model.VideoProfileManager;
	import org.robotlegs.mvcs.SignalCommand;
	
	public class JoinMeetingCommand extends SignalCommand {
		private const LOG:String = "JoinMeetingCommand::";
		
		[Inject]
		public var loginService:LoginService;
		
		[Inject]
		public var userSession:UserSession;
		
		[Inject]
		public var url:String;
		
		[Inject]
		public var conferenceParameters:ConferenceParameters;
		
		[Inject]
		public var connectSignal:ConnectSignal;
		
		override public function execute():void {
			loginService.successJoinedSignal.add(successJoined);
			loginService.successGetConfigSignal.add(successConfig);
			loginService.successGetProfilesSignal.add(sucessProfiles);
			loginService.unsuccessJoinedSignal.add(unsuccessJoined);
			//remove users from list in case we reconnect to have a clean user list 
			userSession.guestList.removeAllUsers();
			userSession.userList.removeAllUsers();
			loginService.load(url);
		}
		
		protected function successJoined(userObject:Object):void {
			conferenceParameters.load(userObject);
			connectSignal.dispatch(new String(userSession.config.application.uri));
		}
		
		protected function successConfig(config:Config):void {
			userSession.config = config;
		}
		
		protected function sucessProfiles(profiles:VideoProfileManager):void {
			userSession.videoProfileManager = profiles;
		}
		
		protected function unsuccessJoined(reason:String):void {
			trace(LOG + "unsuccessJoined()");
		}
	}
}
