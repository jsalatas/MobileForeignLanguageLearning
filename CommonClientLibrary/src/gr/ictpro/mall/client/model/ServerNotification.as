package gr.ictpro.mall.client.model
{
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;

	public class ServerNotification extends EventDispatcher 
	{
		private var _id:int;
		private var _date:Date;
		private var _subject:String;
		private var _message:String;
		private var _module:String;
		private var _parameters:String;
		private var _internalModule:Boolean;
		
		public function ServerNotification(id:int, date:Date, subject:String, message:String, module:String, parameters:ByteArray, internalModule:Boolean)
		{
			this._id = id;
			this._date = date;
			this._subject = subject;
			this._message = message;
			this._module = module;
			this._internalModule = internalModule;
			if(parameters != null) {
				this._parameters = parameters.readUTF();
			}
		}
		
		[Bindable(event="notificationIdChanged")]
		public function get id():int
		{
			return this._id;
		}

		[Bindable(event="notificationDateChanged")]
		public function get date():Date
		{
			return this._date;
		}

		[Bindable(event="notificationSubjectChanged")]
		public function get subject():String
		{
			return this._subject;
		}

		[Bindable(event="notificationMessageChanged")]
		public function get message():String
		{
			return this._message;
		}
		
		[Bindable(event="notificationModuleChanged")]
		public function get module():String
		{
			return this._module;
		}
		
		[Bindable(event="notificationParametersChanged")]
		public function get parameters():String
		{
			return this._parameters;
		}

		public function get isInternalModule():Boolean
		{
			return this._internalModule;
		}

	}
}