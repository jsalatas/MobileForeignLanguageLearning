package gr.ictpro.mall.client.view.components.bbb
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.drm.AddToDeviceGroupSetting;
	
	import mx.core.FlexGlobals;
	import mx.events.ResizeEvent;
	
	import gr.ictpro.mall.client.runtime.Device;
	
	import org.bigbluebutton.command.LoadSlideSignal;
	import org.bigbluebutton.core.PresentationService;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.UserList;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.model.presentation.Presentation;
	import org.bigbluebutton.model.presentation.Slide;
	import org.bigbluebutton.util.CursorIndicator;
	import org.robotlegs.mvcs.SignalMediator;
	
	public class WhiteboardViewMediator extends SignalMediator
	{
		[Inject]
		public var view:WhiteboardView;

		[Inject]
		public var userSession:UserSession;
		
		[Inject]
		public var loadSlideSignal:LoadSlideSignal;
		
		[Inject]
		public var presentationService:PresentationService;
		
		private var _currentPresentation:Presentation;
		
		private var _currentSlideNum:int = -1;
		
		private var _currentSlide:Slide;
		
		private var _cursor:CursorIndicator = new CursorIndicator();
		
		private var _lastMouseXPosition:Number = 0;
		private var _lastMouseYPosition:Number = 0;
		
		private var wasPresenter:Boolean = false;
		
		
		override public function onRegister():void
		{
			view.currentState = userSession.userList.me.presenter?"presenter":"viewer";
			userSession.presentationList.presentationChangeSignal.add(presentationChangeHandler);
			userSession.presentationList.viewedRegionChangeSignal.add(viewedRegionChangeHandler);
			userSession.presentationList.cursorUpdateSignal.add(cursorUpdateHandler);
			FlexGlobals.topLevelApplication.stage.addEventListener(Event.RESIZE, stageOrientationChangingHandler);
			view.presenterContainer.addEventListener(Event.RESIZE, stageOrientationChangingHandler);
			
			view.slide.addEventListener(Event.COMPLETE, handleLoadingComplete);
			view.slideModel.parentChange(view.content.width, view.content.height);
			setPresentation(userSession.presentationList.currentPresentation);
			//setCurrentSlideNum(userSession.presentationList.currentSlideNum);
			//FlexGlobals.topLevelApplication.backBtn.visible = false;
			//FlexGlobals.topLevelApplication.profileBtn.visible = true;
			if(userSession.userList.me.presenter) {
				wasPresenter = true;
				view.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			}
			userSession.userList.userChangeSignal.add(userChangeHandler);
			stageOrientationChangingHandler(null);
			
		}
		
		private function userChangeHandler(u:User, status:int):void {
			if(status == UserList.PRESENTER) {
				if(u == userSession.userList.me) {
					view.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
					wasPresenter = true;
					view.currentState = "presenter";
					view.presenterContainer.addEventListener(Event.RESIZE, stageOrientationChangingHandler);
					stageOrientationChangingHandler(null);
				} else if(wasPresenter) {
					view.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
					view.presenterContainer.removeEventListener(Event.RESIZE, stageOrientationChangingHandler);
					wasPresenter = false;
					view.currentState = "viewer";
					stageOrientationChangingHandler(null);
				}
			}
		}
		private function mouseMoveHandler(e:MouseEvent):void {
			if(view.whiteboardCanvas.isDrawing) {
				return;
			}
			var cursorXPosition:Number = view.viewport.mouseX;
			var cursorYPosition:Number = view.viewport.mouseY;
			if ( (Math.abs(cursorXPosition - _lastMouseXPosition) < 0.1) 
				&& (Math.abs(cursorYPosition - _lastMouseYPosition) < 0.1) ) {
				return;
			}
			
			if (cursorXPosition > view.viewport.width || cursorXPosition < 1 
				|| cursorYPosition > view.viewport.height || cursorYPosition < 1) {
				//          LogUtil.debug("Cursor outside the window...not sending [" + cursorXPosition + "," + cursorYPosition + "]");
				return;
			}
			
			_lastMouseXPosition = cursorXPosition;
			_lastMouseYPosition = cursorYPosition;
			
			var xPercent:Number = cursorXPosition / view.viewport.width;
			var yPercent:Number = cursorYPosition / view.viewport.height;
			
			presentationService.sendCursorUpdate(xPercent, yPercent);
		}
		
		private function displaySlide():void {
			if (_currentSlide != null) {
				_currentSlide.slideLoadedSignal.remove(slideLoadedHandler);
			}
			if (_currentPresentation != null && _currentSlideNum >= 0) {
				_currentSlide = _currentPresentation.getSlideAt(_currentSlideNum);
				if (_currentSlide != null) {
					if (_currentSlide.loaded && view != null) {
						view.setSlide(_currentSlide);
					} else {
						_currentSlide.slideLoadedSignal.add(slideLoadedHandler);
						loadSlideSignal.dispatch(_currentSlide, _currentPresentation.id);
					}
				}
			} else if (view != null) {
				view.setSlide(null);
			}
		}
		
		private function viewedRegionChangeHandler(x:Number, y:Number, widthPercent:Number, heightPercent:Number):void {
			resetSize(x, y, widthPercent, heightPercent);
		}
		
		private function resizePresentation():void {
			if (view.slideModel && view && view.slide) {
				view.slideModel.resetForNewSlide(view.slide.contentWidth, view.slide.contentHeight);
				if(userSession.presentationList.currentPresentation != null) {
				var currentSlide:Slide = userSession.presentationList.currentPresentation.getSlideAt(_currentSlideNum);
				if (currentSlide) {
					resetSize(currentSlide.x, currentSlide.y, currentSlide.widthPercent, currentSlide.heightPercent);
					_cursor.draw(view.viewport, userSession.presentationList.cursorXPercent, userSession.presentationList.cursorYPercent);
					//resetSize(_currentSlide.x, _currentSlide.y, _currentSlide.widthPercent, _currentSlide.heightPercent);
				}
				}
			}
		}
		
		private function stageOrientationChangingHandler(e:Event):void {
//			if (userUISession.currentPage == PagesENUM.PRESENTATION) { //apply rotation only if user didn´t change view at the same time
				var newWidth:Number = Device.getUnScaledSize(FlexGlobals.topLevelApplication.stage.stageWidth);
				var presenterControlsH:Number = Device.getUnScaledSize(view.presenterContainer != null && userSession.userList.me.presenter? view.presenterContainer.height:0);
				var newHeight:Number = Device.getUnScaledSize(FlexGlobals.topLevelApplication.stage.stageHeight) - 30 - presenterControlsH;
				view.slideModel.parentChange(newWidth, newHeight);
				view.slideModel.adjustSlideAfterParentResized();
				resizePresentation();
//			}
		}
		
		private function handleLoadingComplete(e:Event):void {
			resizePresentation();
			//view.rotationHandler(FlexGlobals.topLevelApplication.currentOrientation);
		}
		
		private function resetSize(x:Number, y:Number, widthPercent:Number, heightPercent:Number):void {
			view.slideModel.calculateViewportNeededForRegion(widthPercent, heightPercent);
			view.slideModel.displayViewerRegion(x, y, widthPercent, heightPercent);
			view.slideModel.calculateViewportXY();
			view.slideModel.displayPresenterView();
			setViewportSize();
			fitLoaderToSize();
			//fitSlideToLoader();
			zoomCanvas(Device.getUnScaledSize(view.slide.x), Device.getUnScaledSize(view.slide.y), Device.getUnScaledSize(view.slide.width), Device.getUnScaledSize(view.slide.height), 1 / Math.max(widthPercent / 100, heightPercent / 100));
		}
		
		private function setViewportSize():void {
			view.viewport.x = view.slideModel.viewportX;
			view.viewport.y = view.slideModel.viewportY;
			view.viewport.height = view.slideModel.viewportH;
			view.viewport.width = view.slideModel.viewportW;
		}
		
		private function fitLoaderToSize():void {
			view.slide.x = Device.getScaledSize(view.slideModel.loaderX);
			view.slide.y = Device.getScaledSize(view.slideModel.loaderY);
			view.slide.width = Device.getScaledSize(view.slideModel.loaderW);
			view.slide.height = Device.getScaledSize(view.slideModel.loaderH);
		}
		
		public function zoomCanvas(x:Number, y:Number, width:Number, height:Number, zoom:Number):void {
			view.whiteboardCanvas.moveCanvas(x, y, width, height, zoom);
		}
		
		private function resizeWhiteboard():void {
			view.whiteboardCanvas.height = Device.getUnScaledSize(view.slide.height);
			view.whiteboardCanvas.width = Device.getUnScaledSize(view.slide.width);
			view.whiteboardCanvas.x = view.slide.x;
			view.whiteboardCanvas.y = view.slide.y;
		}
		
		private function cursorUpdateHandler(xPercent:Number, yPercent:Number):void {
			_cursor.draw(view.viewport, xPercent, yPercent);
		}
		
		private function presentationChangeHandler():void {
			setPresentation(userSession.presentationList.currentPresentation);
		}
		
		private function slideChangeHandler():void {
			setCurrentSlideNum(userSession.presentationList.currentPresentation.currentSlideNum);
			_cursor.remove(view.viewport);
		}
		
		private function setPresentation(p:Presentation):void {
			_currentPresentation = p;
			if (_currentPresentation != null) {
				_currentPresentation.slideChangeSignal.remove(slideChangeHandler);
				view.setPresentationName(_currentPresentation.fileName);
				_currentPresentation.slideChangeSignal.add(slideChangeHandler);
				setCurrentSlideNum(p.currentSlideNum);
			} else {
				view.setPresentationName("");
			}
		}
		
		private function setCurrentSlideNum(n:int):void {
			_currentSlideNum = n;
			displaySlide();
		}
		
		private function slideLoadedHandler():void {
			displaySlide();
		}
		
		override public function onRemove():void {
			view.slide.removeEventListener(Event.COMPLETE, handleLoadingComplete);
			FlexGlobals.topLevelApplication.stage.removeEventListener(Event.RESIZE, stageOrientationChangingHandler);
			view.presenterContainer.removeEventListener(Event.RESIZE, stageOrientationChangingHandler);

			userSession.presentationList.presentationChangeSignal.remove(presentationChangeHandler);
			userSession.presentationList.viewedRegionChangeSignal.remove(viewedRegionChangeHandler);
			userSession.presentationList.cursorUpdateSignal.remove(cursorUpdateHandler);
			userSession.userList.userChangeSignal.remove(userChangeHandler);
			
			if (_currentPresentation != null) {
				_currentPresentation.slideChangeSignal.remove(slideChangeHandler);
			}
			if(wasPresenter) {
				view.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			}
			
			super.onRemove();
			//view.dispose();
			view = null;
		}
		
	}
}