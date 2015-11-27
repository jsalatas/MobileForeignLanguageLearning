package gr.ictpro.mall.client.view
{
	import gr.ictpro.mall.client.model.Translation;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class LanguagesViewMediator extends Mediator
	{
		[Inject]
		public var view:LanguagesView;

		[Inject]
		public var addView:AddViewSignal;
		
		override public function onRegister():void
		{
			view.title = Translation.getTranslation("Languages");
			view.save.add(saveHandler);
			view.cancel.add(cancelHandler);
			view.back.add(backHandler);

		}
		
		private function saveHandler():void
		{
			//TODO: Save 
		}
		
		private function cancelHandler():void
		{
			backHandler();
		}
		
		private function backHandler():void
		{
			view.save.removeAll();
			view.cancel.removeAll();
			view.back.removeAll();
			view.dispose();
			if(view.masterView == null) {
				addView.dispatch(new MainView());	
			} else {
				addView.dispatch(view.masterView);
			}
}
	}
}