package gr.ictpro.mall.client.authentication.proximity
{
	import gr.ictpro.mall.client.authentication.standard.StandardRegistration;
	import gr.ictpro.mall.client.model.RoleModel;
	import gr.ictpro.mall.client.service.Channel;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	import gr.ictpro.mall.client.signal.ListErrorSignal;
	import gr.ictpro.mall.client.signal.ListSignal;
	import gr.ictpro.mall.client.signal.ListSuccessSignal;
	import gr.ictpro.mall.client.signal.RegisterFailedSignal;
	import gr.ictpro.mall.client.signal.RegisterSignal;
	import gr.ictpro.mall.client.signal.RegisterSuccessSignal;
	
	import org.robotlegs.mvcs.SignalMediator;
	
	public class ProximityRegistrationMediator extends SignalMediator
	{
		[Inject]
		public var view:StandardRegistration;
		
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