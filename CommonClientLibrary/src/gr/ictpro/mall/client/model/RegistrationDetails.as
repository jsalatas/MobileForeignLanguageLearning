package gr.ictpro.mall.client.model
{
	public class RegistrationDetails
	{

		private var _userName:String;
		private var _name:String;
		private var _password:String;
		private var _email:String;
		private var _role:int;
		private var _registrationMethod:String;
		private var _teacherName:String;
		
		public function RegistrationDetails(registrationMethod:String, userName:String, name:String, password:String, email:String, role:int, teacherName:String)
		{
			this._registrationMethod = registrationMethod;
			this._userName = userName;
			this._name = name;
			this._password = password;
			this._email = email;
			this._role = role;
			this._teacherName = teacherName;
		}
	
		public function get userName(): String
		{
			return this._userName;
		}
		public function get name(): String
		{
			return this._name;
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
		public function get teacherName():String
		{
			return this._teacherName;
		}
		
	}
}