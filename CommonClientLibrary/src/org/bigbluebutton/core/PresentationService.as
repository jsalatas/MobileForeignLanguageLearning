package org.bigbluebutton.core {
	
	import org.bigbluebutton.model.ConferenceParameters;
	import org.bigbluebutton.model.IMessageListener;
	import org.bigbluebutton.model.UserSession;
	
	public class PresentationService {
		
		[Inject]
		public var conferenceParameters:ConferenceParameters;
		
		[Inject]
		public var userSession:UserSession;
		
		public var presentMessageSender:PresentMessageSender;
		
		public var presentMessageReceiver:PresentMessageReceiver;
		
		public function PresentationService() {
			presentMessageSender = new PresentMessageSender;
			presentMessageReceiver = new PresentMessageReceiver;
		}
		
		public function setupMessageSenderReceiver():void {
			presentMessageSender.userSession = userSession;
			presentMessageReceiver.userSession = userSession;
			userSession.mainConnection.addMessageListener(presentMessageReceiver as IMessageListener);
		}
		
		public function getPresentationInfo():void {
			presentMessageSender.getPresentationInfo();
		}
		
		public function gotoSlide(id:String):void {
			presentMessageSender.gotoSlide(id);
		}
		
		public function move(xOffset:Number, yOffset:Number, widthRatio:Number, heightRatio:Number):void {
			presentMessageSender.move(xOffset, yOffset, widthRatio, heightRatio);
		}
		
		public function removePresentation(name:String):void {
			presentMessageSender.removePresentation(name);
		}
		
		public function sendCursorUpdate(xPercent:Number, yPercent:Number):void {
			presentMessageSender.sendCursorUpdate(xPercent, yPercent);
		}
		
		public function sharePresentation(share:Boolean, presentationName:String):void {
			presentMessageSender.sharePresentation(share, presentationName);
		}
	}
}
