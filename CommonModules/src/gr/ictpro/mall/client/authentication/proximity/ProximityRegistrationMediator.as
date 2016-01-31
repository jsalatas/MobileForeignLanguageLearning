package gr.ictpro.mall.client.authentication.proximity
{
	import gr.ictpro.mall.client.signal.AddViewSignal;
	import gr.ictpro.mall.client.signal.ListSignal;
	import gr.ictpro.mall.client.signal.RegisterFailedSignal;
	import gr.ictpro.mall.client.signal.RegisterSignal;
	import gr.ictpro.mall.client.signal.RegisterSuccessSignal;
	
	import org.robotlegs.mvcs.SignalMediator;
	
	public class ProximityRegistrationMediator extends SignalMediator
	{
		[Inject]
		public var view:ProximityRegistration;
		
		[Inject]
		public var registrationFailed:RegisterFailedSignal;
		
		[Inject]
		public var registrationSuccess:RegisterSuccessSignal;
		
		[Inject]
		public var register:RegisterSignal;
		
		[Inject]
		public var listSignal:ListSignal;
		
		[Inject]
		public var addView:AddViewSignal;
		
		override public function onRegister():void
		{
			super.onRegister();

		}
	}
}