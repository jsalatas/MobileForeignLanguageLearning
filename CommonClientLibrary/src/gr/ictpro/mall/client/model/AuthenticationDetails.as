package gr.ictpro.mall.client.model
{
	public class AuthenticationDetails
	{
		private var _authenticationMethod:String;
		private var _username:String;
		private var _credentials:Object;
		private var _autoLogin:Boolean;
		
		public function AuthenticationDetails(authenticationMethod: String, username:String, credentials:Object, autoLogin:Boolean)
		{
			this._authenticationMethod = authenticationMethod;
			this._username = username;
			this._credentials = credentials;
			this._autoLogin = autoLogin;
		}
		
		public function get username():String
		{
			return this._username;
		}
		public function get credentials():Object
		{
			return this._credentials;
		}
		public function get authenticationMethod():String
		{
			return this._authenticationMethod;
		}
		
		public function get autoLogin():Boolean
		{
			return this._autoLogin;
		}
	}
}