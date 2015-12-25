package gr.ictpro.mall.client.components
{
	import flash.events.Event;
	
	import mx.collections.IList;
	import mx.core.ClassFactory;
	import mx.states.OverrideBase;
	
	import gr.ictpro.mall.client.components.renderers.IconItemRenderer;
	import gr.ictpro.mall.client.runtime.Device;

	[Event(name="addClicked", type="flash.events.MouseEvent")]
	[Event(name="showDetailClicked", type="flash.events.MouseEvent")]
	
	public class TopBarListView extends TopBarView
	{
		private var _list:List = new List();
		
		public function TopBarListView()
		{
			super();
			addButton = true;
			deleteButton = false;
			okButton = false;
			cancelButton = false;
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			_list.left = 10;
			_list.top = 10;
			_list.bottom = 10;
			_list.right = 10;
			_list.percentWidth = 100;
			_list.percentHeight = 100;
			_list.setStyle("borderAlpha", 0);
			_list.setStyle("contentBackgroundColor", "#ffffff");
			
			var itemRenderer:ClassFactory = new ClassFactory(IconItemRenderer);
			itemRenderer.properties= {height: 25, bottomSeparatorColor: Device.getDefaultColor(0.5), styles:{verticalAlign: "middle", paddingLeft: 2, paddingRight: 2}};
	
			_list.itemRenderer =itemRenderer;
			
			mxmlContentGroup.percentHeight = 100;
			mxmlContentGroup.percentWidth = 100;
			mxmlContentGroup.mxmlContent = [_list];
			addElement(mxmlContentGroup);
			_list.addEventListener(Event.CHANGE, changeHandler);
		}
		

		
		private function changeHandler(event:Event):void 
		{
			var e:Event = new Event("showDetailClicked", event.bubbles, event.cancelable);
			dispatchEvent(e);

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