package gr.ictpro.mall.client.model
{
	import flash.text.ReturnKeyLabel;

	public class GenericServerPersistentObject implements IPersistentObject, IServerPersistentObject
	{
		private var _persistentData:PersistentData = new PersistentData();
		private var _destination:String;
		private var _methodName:String;
		
		public function GenericServerPersistentObject(destination:String, methodName:String)
		{
			this._destination = destination;
			this._methodName = methodName;
		}
		
		public function get destination():String {
			return this._destination;
		}
		
		public function get methodName():String {
			return this._methodName;	
		}

		public function set persistentData(persistentData:PersistentData):void
		{
			this._persistentData = persistentData;
		}
		
		public function get persistentData():PersistentData
		{
			return this._persistentData;
		}
	}
}