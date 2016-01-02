package gr.ictpro.mall.client.model
{
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	
	import gr.ictpro.mall.client.model.vomapper.VOMapper;
	
	public class AbstractModel implements IModel
	{
		[Inject]
		public var mapper:VOMapper;
		
		private var _voClass:Class;
		private var _viewClass:Class;
		
		private var _list:ArrayCollection = new ArrayCollection();
		
		public function AbstractModel(voClass:Class, viewClass:Class) 
		{
			this._voClass = voClass;
			this._viewClass = viewClass;
		}
		
		public function getVOClass():Class
		{
			return this._voClass;
		}
		
		public function getViewClass():Class
		{
			return this._viewClass;
		}

		[PostConstruct]
		public function init():void
		{
			mapper.mapClass(this, _voClass, _viewClass);
		}
		
		public function set list(list:ArrayCollection):void
		{
			this._list = list;
		}
		
		public function get list():ArrayCollection
		{
			return this._list;
		}
		
		public function remove(item:*):void
		{
			var itemIndex:int = _list.getItemIndex(item);
			if(itemIndex > -1) {
				_list.removeItemAt(itemIndex);
			}
		}
		
		public function getIndexByField(field:String, value:Object):int
		{
			var res:int = -1;
			for (var i:int = 0; i<_list.length; i++) 
			{
				if(_list.getItemAt(i)[field] == value) {
					res = i;
					break;
				}
			}
			
			return res;
		}
		
		public function getIndexById(value:Object):int
		{
			return getIndexByField(IPersistent(this).idField, value);
		}

		public function getItemByField(field:String, value:Object):Object
		{
			var res:Object = null;
			for (var i:int = 0; i<_list.length; i++) 
			{
				if(_list.getItemAt(i)[field] == value) {
					res = _list.getItemAt(i);
					break;
				}
			}
			
			return res;
		}
		
		public function getItemById(value:Object):Object
		{
			return getItemByField(IPersistent(this).idField, value);
		}

		public function create():Object
		{
			return new _voClass();
		}
		
		public function getFilteredList(filterFunction:Function):ArrayCollection
		{
			var filteredList:ArrayCollection = new ArrayCollection(this._list.source);
			filteredList.filterFunction = filterFunction;
			filteredList.refresh();
			
			return filteredList;
		}
		

		public function getSortedListByFunction(compareFunction:Function):ArrayCollection 
		{
			var sortedList:ArrayCollection = new ArrayCollection(this._list.source);
			var sort:Sort = new Sort();
			sort.compareFunction = compareFunction;
			sortedList.sort = sort;
			sortedList.refresh();
			
			return sortedList;
		}
		
		public function getSortedListByFields(fields:Array):ArrayCollection
		{
			var sortedList:ArrayCollection = new ArrayCollection(this._list.source);
			var sort:Sort = new Sort();
			sort.fields = fields;
			
			sortedList.sort = sort;
			sortedList.refresh();
			
			return sortedList;
		}
		
		
	}
}