package org.bigbluebutton.view.navigation.pages.presentation
{
	import flash.events.Event;
	import flash.filesystem.File;
	
	import org.bigbluebutton.core.FileUploadService;
	import org.bigbluebutton.core.PresentationService;
	import org.bigbluebutton.core.WhiteboardService;
	import org.bigbluebutton.model.ConferenceParameters;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.model.presentation.Presentation;
	import org.robotlegs.mvcs.SignalMediator;
	
	public class PresenterControlsMediator extends SignalMediator
	{
		[Inject]
		public var presentationService:PresentationService;

		[Inject]
		public var whiteboardService:WhiteboardService;
		
		[Inject]
		public var view:PresenterControls;
		
		[Inject]
		public var userSession:UserSession;
		
		[Inject]
		public var conferenceParameters:ConferenceParameters;

		private var whiteboardID:String; 
		private var slideNum:int;

		override public function onRegister():void {
			addToSignal(userSession.presentationList.presentationChangeSignal, presentationChangeHandler);
			addToSignal(userSession.presentationList.currentPresentation.slideChangeSignal, presentationChangeHandler);
			
			addToSignal(view.uploadPresSignal, uploadPresHandler);
			addToSignal(view.backSignal, backHandler);
			addToSignal(view.forwardSignal, forwardHandler);
			addToSignal(view.zoomSignal, zoomHandler);
			addToSignal(view.fitPageSignal, fitPageHandler);
			addToSignal(view.undoSignal, undoHandler);	
			addToSignal(view.clearSignal, clearHandler);

			presentationChangeHandler();
		}
		
		private function presentationChangeHandler():void {
			whiteboardID= userSession.presentationList.currentPresentation.id;
			slideNum = userSession.presentationList.currentPresentation.currentSlideNum+1;

			setPresentation(userSession.presentationList.currentPresentation);
		}
		
		private function setPresentation(p:Presentation):void {
			if (userSession.presentationList.currentPresentation != null) {
				userSession.presentationList.currentPresentation.slideChangeSignal.remove(slideChangeHandler);
				userSession.presentationList.currentPresentation.slideChangeSignal.add(slideChangeHandler);
				slideChangeHandler();
			} else {
				view.backButton.enabled = false;
				view.forwardButton.enabled = false;
			}
		}
		
		private function slideChangeHandler():void {
			if(userSession.presentationList.currentPresentation.currentSlideNum == 0) {
				view.backButton.enabled = false;
			} else {
				view.backButton.enabled = true;
			}
			if(userSession.presentationList.currentPresentation.currentSlideNum < userSession.presentationList.currentPresentation.slides.length -1) {
				view.forwardButton.enabled = true;
			} else {
				view.forwardButton.enabled = false;
			}
		}

		private function uploadPresHandler():void
		{
			var presentationFile:File = new File();
			presentationFile.browseForOpen("Upload Presentation");
			presentationFile.addEventListener(Event.SELECT, openPresentationFile);
		}
		
		private function openPresentationFile(event:Event):void {
			var file:File = File(event.target);
			var fileName:String = file.name;
			
			var uploadService:FileUploadService = new FileUploadService(conferenceParameters.host + "/bigbluebutton/presentation/upload", conferenceParameters.conference, conferenceParameters.room, presentationService);
			uploadService.upload(fileName, file);
		}

		private function backHandler():void
		{
			presentationService.gotoSlide(userSession.presentationList.currentPresentation.id + "/" + (userSession.presentationList.currentPresentation.currentSlideNum));
		}

		private function forwardHandler():void
		{
			presentationService.gotoSlide(userSession.presentationList.currentPresentation.id + "/" + (userSession.presentationList.currentPresentation.currentSlideNum+2));
		}
		
		private function zoomHandler(zoom:Number):void
		{
			var newWidth:Number = view.slideLoader.width / view.whiteBoard.zoom * zoom /100;
			var newHeight:Number = view.slideLoader.height / view.whiteBoard.zoom * zoom /100;
			
			var xoffset:Number = zoom==100?0:-25*(newWidth - view.viewport.width)/newWidth;
			var yoffset:Number = zoom==100?0:-25*(newHeight - view.viewport.height)/newHeight;
			var newX:Number =xoffset* newWidth*2/100;
			var newY:Number =yoffset* newHeight*2/100;

			presentationService.move(xoffset, yoffset, 10000/zoom, 10000/zoom);

		}
		
		private function fitPageHandler():void
		{
			presentationService.move(0, 0, 100, 100);
		}

		private function undoHandler():void
		{
			whiteboardService.undoGraphic(whiteboardID, slideNum);
		}
		
		private function clearHandler():void
		{
			whiteboardService.clearBoard(whiteboardID, slideNum);
		}

		


	}
}