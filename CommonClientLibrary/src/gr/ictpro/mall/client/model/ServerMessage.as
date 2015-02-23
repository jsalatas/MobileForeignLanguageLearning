package gr.ictpro.mall.client.model
{
	public class ServerMessage
	{
		private var _message:String;
		
		public function ServerMessage(message:String)
		{
			this._message = message;
		}
		
		public function get message():String
		{
			return this._message;
		}
	}
}