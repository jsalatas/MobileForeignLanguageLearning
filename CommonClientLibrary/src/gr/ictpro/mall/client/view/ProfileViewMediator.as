package gr.ictpro.mall.client.view
{
	import flash.events.Event;
	
	import gr.ictpro.mall.client.model.IPersistentObject;
	import gr.ictpro.mall.client.model.PersistentData;
	import gr.ictpro.mall.client.model.PersistentObjectWrapper;
	import gr.ictpro.mall.client.model.Settings;
	import gr.ictpro.mall.client.model.User;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	import gr.ictpro.mall.client.signal.PersistSignal;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	import spark.events.PopUpEvent;
	
	public class ProfileViewMediator extends Mediator
	{
		[Inject]
		public var view:ProfileView;
		
		[Inject]
		public var addView:AddViewSignal;
		
		[Inject]
		public var settings:Settings;
		
		[Inject]
		public var persist:PersistSignal;
		
		override public function onRemove():void
		{
			trace("Removed");
		}
		override public function onRegister():void
		{
			//TODO: 
			view.user = settings.user;
			view.save.add(saveHandler);
			view.cancel.add(cancelHandler);
			view.back.add(backHandler);
		}
		
		private function saveHandler():void
		{
			settings.user.name = view.txtName.text;
			settings.user.photo = view.imgPhoto.source;
			settings.user.email = view.txtEmail.text;
			persist.dispatch(new PersistentObjectWrapper(settings.user, persistSuccessHandler, persistErrorHandler));
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
			addView.dispatch(new MainView());
		}
		
		private function persistSuccessHandler(event:Event):void
		{
			var o:Object = (event as ResultEvent).result;
			settings.user = User.createUser(o);
			view.user = settings.user;
			backHandler();
		}

		private function persistErrorHandler(event:FaultEvent):void
		{
			var saveErrorPopup:Notification = new Notification();
			saveErrorPopup.message = "Cannot Save Profile.";
			
			saveErrorPopup.open(view, true);
		}
	}
}