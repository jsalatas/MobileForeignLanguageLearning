package gr.ictpro.mall.client.model.vomapper
{
	import flash.errors.IllegalOperationError;
	
	import mx.collections.ArrayCollection;
	
	
	public class DetailMapper
	{
		public var label:String;
		public var propertyName:String;
		public var propertyClass:Class;
		public var viewComponent:Class;
		public var filter:Function;
		public var addFilter:Function;
		private var _list:ArrayCollection;
		public var readOnly:Boolean;
		public var beforeDelete:Function;
		public var afterAdd:Function;
		public var showCondition:Function;

		public var initialized:Boolean = false;
		
		public function DetailMapper(label:String, propertyName:String, propertyClass:Class, viewComponent:Class, filter:Function, addFilter:Function, readOnly:Boolean, beforeDelete:Function, afterAdd:Function, showCondition:Function)
		{
			if(propertyClass != null && viewComponent != null) {
				throw new IllegalOperationError("You cannot supply both voClass and viewComponent");
			}
			
			if(viewComponent != null && (filter != null || addFilter != null || propertyName != null)) {
				throw new IllegalOperationError("filter and/or addFilter provided with a viewComponent class");
			}
			
			if((propertyClass != null && propertyName == null) || (propertyClass == null && propertyName != null)) {
				throw new IllegalOperationError("You need to supply both propertyClass and propertyName");
			}
			this.label = label;
			this.propertyName = propertyName;
			this.propertyClass = propertyClass;
			this.viewComponent = viewComponent;
			this.filter = filter;
			this.addFilter = addFilter;
			this.readOnly = readOnly;
			this.beforeDelete = beforeDelete;
			this.afterAdd = afterAdd;
			this.showCondition = showCondition; 
		}
		
		[Bindable]
		public function get list():ArrayCollection
		{
			return _list;
		}
		
		public function set list(value:ArrayCollection):void
		{
			_list = value;
			initialized = true;
		}
		

	}
}