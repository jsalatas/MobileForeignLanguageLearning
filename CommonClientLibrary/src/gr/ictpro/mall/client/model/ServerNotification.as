package gr.ictpro.mall.client.model
{
	import flash.utils.ByteArray;

	public class ServerNotification
	{
		private var _id:int;
		private var _date:Date;
		private var _subject:String;
		private var _message:String;
		private var _module:String;
		private var _parameters:String;
		
		public function ServerNotification(id:int, date:Date, subject:String, message:String, module:String, parameters:ByteArray)
		{
			this._id = id;
			this._date = date;
			this._subject = subject;
			this._message = message;
			this._module = module;
			this._parameters = parameters.readUTF();
		}
		
		public function get id():int
		{
			return this._id;
		}

		public function get date():Date
		{
			return this._date;
		}

		public function get subject():String
		{
			return this._subject;
		}

		public function get message():String
		{
			return this._message;
		}
		
		public function get module():String
		{
			return this._module;
		}
		
		public function get parameters():String
		{
			return this._parameters;
		}
		
	}
}