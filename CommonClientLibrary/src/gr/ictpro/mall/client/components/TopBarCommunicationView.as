package gr.ictpro.mall.client.components
{
	import mx.collections.IList;
	import mx.core.ClassFactory;
	
	
	import gr.ictpro.mall.client.components.renderers.LongPressIconItemRenderer;
	import gr.ictpro.mall.client.runtime.Device;

	[Event(name="addClicked", type="flash.events.MouseEvent")]
	
	public class TopBarCommunicationView extends TopBarView
	{
		private var _list:MultipleSelectionsList = new MultipleSelectionsList();
		
		public function TopBarCommunicationView()
		{
			super();
			addButton = true;
			deleteButton = false;
			okButton = false;
			cancelButton = false;
		}
		
		private var _listItemHeight:int = 25;
		
		public function set listItemHeight(height:int):void
		{
			_listItemHeight = height;
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			_list.percentWidth = 100;
			_list.percentHeight = 100;
			_list.left = 10;
			_list.top = 10;
			_list.bottom = 10;
			_list.right = 10;
			_list.setStyle("borderAlpha", 0);
			_list.setStyle("contentBackgroundColor", "#ffffff");
			
			var itemRenderer:ClassFactory = new ClassFactory(LongPressIconItemRenderer);
			itemRenderer.properties= {height: _listItemHeight, bottomSeparatorColor: Device.getDefaultColor(0.5), styles:{verticalAlign: "middle", paddingLeft: 2, paddingRight: 2}};
	
			_list.itemRenderer =itemRenderer;

			var listGroup:Group = new Group();
			listGroup.percentHeight=100;
			listGroup.percentWidth=100;
			listGroup.addElement(_list);
			addElement(listGroup);
		}
		
		
		override public function set mxmlContent(value:Array):void
		{
			invalidateDisplayList();
		}

		public function get keyField():String
		{
			return this.keyField;	
		}

		public function set selectedItem(item:Object):void
		{
			this._list.selectedItem = item;	
		}
		
		public function get selectedItem():Object
		{
			return this._list.selectedItem;	
		}

		public function set data(data:IList):void
		{
			_list.dataProvider = data;
		}
		
		public function get data():IList
		{
			return this._list.dataProvider;
		}

		public function set labelFunction(labelFunction:Function):void
		{
			_list.labelFunction = labelFunction;
		}
		
		public function get labelFunction():Function
		{
			return this._list.labelFunction;
		}

		public function set labelField(labelField:String):void
		{
			_list.labelField = labelField;
		}
		
		public function get labelField():String
		{
			return this._list.labelField;
		}
	}
}