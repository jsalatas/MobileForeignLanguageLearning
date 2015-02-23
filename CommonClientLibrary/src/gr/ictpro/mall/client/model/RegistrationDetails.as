package gr.ictpro.mall.client.model
{
	import gr.ictpro.mall.client.service.RemoteObjectService;
	import gr.ictpro.mall.client.signal.RegisterFailedSignal;
	import gr.ictpro.mall.client.signal.RegisterSuccessSignal;
	import gr.ictpro.mall.client.signal.ServerConnectErrorSignal;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	public class RegistrationDetails
	{

		private var _userName:String;
		private var _firstName:String;
		private var _lastName:String;
		private var _password:String;
		private var _email:String;
		private var _role:int;
		private var _registrationMethod:String;
		
		public function RegistrationDetails(registrationMethod:String, userName:String, firstName:String, lastName:String, password:String, email:String, role:int)
		{
			this._registrationMethod = registrationMethod;
			this._userName = userName;
			this._firstName = firstName;
			this._lastName = lastName;
			this._password = password;
			this._email = email;
			this._role = role;
		}
	
		public function get userName(): String
		{
			return this._userName;
		}
		public function get firstName(): String
		{
			return this._firstName;
		}
		public function get lastName(): String
		{
			return this._lastName;
		}
		public function get password(): String
		{
			return this._password;
		}
		public function get email(): String
		{
			return this._email;
		}
		public function get registrationMethod(): String
		{
			return this._registrationMethod;
		}
		public function get role():int
		{
			return this._role;
		}
		
	}
}