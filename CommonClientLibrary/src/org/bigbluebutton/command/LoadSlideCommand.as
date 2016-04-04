package org.bigbluebutton.command {
	
	import org.bigbluebutton.core.WhiteboardService;
	import org.bigbluebutton.core.LoadSlideService;
	import org.bigbluebutton.model.presentation.Slide;
	import org.robotlegs.mvcs.SignalCommand;
	
	public class LoadSlideCommand extends SignalCommand {
		
		[Inject]
		public var slide:Slide;
		
		[Inject]
		public var presentationID:String;
		
		[Inject]
		public var whiteboardService:WhiteboardService;
		
		private var _loadSlideService:LoadSlideService;
		
		public function LoadSlideCommand() {
			super();
		}
		
		override public function execute():void {
			if (slide != null) {
				_loadSlideService = new LoadSlideService(slide);
				whiteboardService.getAnnotationHistory(presentationID, slide.slideNumber);
			} else {
				trace("LoadSlideCommand: requested slide is null and cannot be loaded");
			}
		}
	}
}
