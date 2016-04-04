package org.bigbluebutton.view.ui {
	
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	
	import org.bigbluebutton.command.NavigateToSignal;
	import org.bigbluebutton.model.UserUISession;
	import org.bigbluebutton.view.navigation.pages.PagesENUM;
	import org.bigbluebutton.view.navigation.pages.TransitionAnimationENUM;
	import org.robotlegs.mvcs.SignalMediator;
	
	public class NavigationButtonMediator extends SignalMediator {
		
		[Inject]
		public var userSession:UserUISession;
		
		[Inject]
		public var navigateToPageSignal:NavigateToSignal;
		
		[Inject]
		public var view:NavigationButton;
		
		override public function onRegister():void {
			view.navigationSignal.add(navigate);
		}
		
		override public function onRemove():void {
			super.onRemove();
			view.dispose();
			view.navigationSignal.remove(navigate);
			view = null;
		}
		
		/**
		 * Navigate to the page specified on parameter
		 */
		private function navigate():void {
			navigateToPageSignal.dispatch(view.navigateTo[0], view.pageDetails, view.transitionAnimation);
		}
	}
}
