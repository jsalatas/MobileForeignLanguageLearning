package gr.ictpro.mall.client.model
{
	public class PersistentObjectWrapper
	{
		private var _persistentObject:IPersistentObject;
		private var _successHandler:Function = null;
		private var _errorHandler:Function = null;
		
		public function PersistentObjectWrapper(persistentObject:IPersistentObject, successHandler:Function, errorHandler:Function)
		{
			this._persistentObject = persistentObject;
			this._successHandler = successHandler;
			this._errorHandler = errorHandler;
		}
		
		public function get persistentObject():IPersistentObject
		{
			return _persistentObject;
		}
		
		public function get successHandler():Function
		{
			return _successHandler;
		}

		public function get errorHandler():Function
		{
			return _errorHandler;
		}

	}
}