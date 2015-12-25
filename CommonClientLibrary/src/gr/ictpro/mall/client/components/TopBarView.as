package gr.ictpro.mall.client.components
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.core.mx_internal;
	import mx.utils.ObjectProxy;
	
	import spark.layouts.supportClasses.LayoutBase;
	
	import assets.fxg.add;
	import assets.fxg.back;
	import assets.fxg.cancel;
	import assets.fxg.ok;
	import assets.fxg.trashcan;
	
	import flashx.textLayout.formats.VerticalAlign;
	
	import gr.ictpro.mall.client.runtime.Device;


	use namespace mx_internal;	

	[Event(name="backClicked", type="flash.events.MouseEvent")]

	public class TopBarView extends Group implements IDetailView, IParameterizedView
	{
		public var addButton:Boolean = false;
		public  var deleteButton:Boolean = false;
		public var okButton:Boolean = false;
		public var cancelButton:Boolean = false;
		protected var _title:String;
		private var _titleLabel:Label; 
		protected var mxmlContentGroup:Group = new Group(); 
		private var _masterView:IVisualElement;
		private var _parameters:ObjectProxy;
		private var _groupDelete:Group;
		private var _groupOK:Group;
		private var _groupCancel:Group;
		private var _disableDelete:Boolean = false; 
		private var _disableOK:Boolean = false; 
		private var _disableCancel:Boolean = false; 

		public function TopBarView()
		{
			super();
		}
		
		[Bindable]
		public function set title(title:String):void
		{
			this._title = title;
			if(this._titleLabel != null) {
				this._titleLabel.text = _title;
			}
		}
		
		public function get title():String
		{
			return this._title;
		}
		
		public function dispose():void
		{
			if(parent && parent.contains(this)) {
				IVisualElementContainer(parent).removeElement(this);
			}
		}
		public function set masterView(masterView:IVisualElement):void 
		{
			this._masterView = masterView;
		}
		
		public function get masterView():IVisualElement
		{
			return this._masterView;
		}
		
		[Bindable]
		public function set parameters(parameters:ObjectProxy):void
		{
			this._parameters = parameters;
		}
		
		public function get parameters():ObjectProxy
		{
			return this._parameters;
		}
		
		
		
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			var v:VerticalLayout = new VerticalLayout();
			v.gap = 0;
			super.layout = v;
			// Top Bar background
			var topBarGroup:Group = new Group();
			topBarGroup.top=0;
			topBarGroup.percentWidth=100;
			topBarGroup.height=30; //Device.getScaledSize(40);
			
			var bg:Rect = new Rect();
			bg.fill = new SolidColor(Device.getDefaultColor(0.67));
			bg.left = 0;
			bg.bottom = 0;
			bg.top = 0;
			bg.right = 0;
			topBarGroup.addElement(bg);
			
			addElement(topBarGroup);
			
			// Back button and title
			var bgroup:Group = new Group();
			var l1:HorizontalLayout = new HorizontalLayout();
			l1.paddingLeft = 10;
			l1.paddingRight = 10;
			l1.gap = 10;
			l1.verticalAlign = VerticalAlign.MIDDLE;
			bgroup.layout = l1;
			bgroup.left = 0;
			bgroup.top = 0;
			bgroup.height = 30; //Device.getScaledSize(40);
			
			var fxgBack:back = new back();
			fxgBack.width = Device.getScaledSize(16);
			fxgBack.height = Device.getScaledSize(15);
			
			var groupBack:Group = new Group();
			groupBack.addElement(fxgBack);
			groupBack.addEventListener(MouseEvent.CLICK, backClickedHandler);
			bgroup.addElement(groupBack);
			
			_titleLabel = new Label();
			_titleLabel.text = _title;
			_titleLabel.left = 0;
			_titleLabel.top = 0;
			_titleLabel.bottom = 0;
			_titleLabel.right = 0;
			_titleLabel.setStyle("color", 0xffffff);
			_titleLabel.setStyle("fontSize", Device.isAndroid?14:16);
			
			bgroup.addElement(_titleLabel);
			
			topBarGroup.addElement(bgroup);
			
			
			// OK/Cancel buttons
			var ocgroup:Group = new Group();
			var l2:HorizontalLayout = new HorizontalLayout();
			l2.paddingLeft = 10;
			l2.paddingRight = 10;
			l2.gap = 10;
			l2.verticalAlign = VerticalAlign.MIDDLE;
			ocgroup.layout = l2;
			ocgroup.right = 0;
			ocgroup.top = 0;
			ocgroup.height = 30; //Device.getScaledSize(40);
			
			if(addButton) {
				var fxgAdd:add = new add();
				fxgAdd.width = Device.getScaledSize(15);
				fxgAdd.height = Device.getScaledSize(15);
				var groupAdd:Group = new Group();
				groupAdd.addElement(fxgAdd);
				groupAdd.addEventListener(MouseEvent.CLICK, addClickedHandler);
				
				ocgroup.addElement(groupAdd);
			}
			
			if(deleteButton) {
				var fxgDelete:trashcan = new trashcan();
				fxgDelete.width = Device.getScaledSize(11);
				fxgDelete.height = Device.getScaledSize(15);
				_groupDelete = new Group();
				_groupDelete.addElement(fxgDelete);
				_groupDelete.addEventListener(MouseEvent.CLICK, deleteClickedHandler);
				
				ocgroup.addElement(_groupDelete);
			}
			
			if(okButton) {
				var fxgOk:ok = new ok();
				fxgOk.width = Device.getScaledSize(21);
				fxgOk.height = Device.getScaledSize(15);
				fxgOk.left = 10;
				_groupOK = new Group();
				_groupOK.addElement(fxgOk);
				_groupOK.addEventListener(MouseEvent.CLICK, okClickedHandler);
				
				ocgroup.addElement(_groupOK);
				addElement(mxmlContentGroup);
				
			}
			
			if(cancelButton) {
				var fxgCancel:cancel = new cancel();
				fxgCancel.width = Device.getScaledSize(15);
				fxgCancel.height = Device.getScaledSize(15);
				fxgCancel.left = okButton?0:10;
				_groupCancel = new Group();
				_groupCancel.addElement(fxgCancel);
				_groupCancel.addEventListener(MouseEvent.CLICK, cancelClickedHandler);
				ocgroup.addElement(_groupCancel);
			}
			
			topBarGroup.addElement(ocgroup);
			mxmlContentGroup.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);

		}

		private function removedFromStageHandler(event:Event):void 
		{
			mxmlContentGroup.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		override public function set layout(value:LayoutBase):void
		{
			mxmlContentGroup.layout = layout;
		}
		
		private function backClickedHandler(event:MouseEvent):void
		{
			var e:MouseEvent = new MouseEvent("backClicked", event.bubbles, event.cancelable, event.localX, event.localY, event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown, event.delta, event.commandKey, event.controlKey, event.clickCount);
			dispatchEvent(e);
		}
		
		private function okClickedHandler(event:MouseEvent):void
		{
			var e:MouseEvent = new MouseEvent("okClicked", event.bubbles, event.cancelable, event.localX, event.localY, event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown, event.delta, event.commandKey, event.controlKey, event.clickCount);
			dispatchEvent(e);
		}
		
		private function addClickedHandler(event:MouseEvent):void
		{
			var e:MouseEvent = new MouseEvent("addClicked", event.bubbles, event.cancelable, event.localX, event.localY, event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown, event.delta, event.commandKey, event.controlKey, event.clickCount);
			dispatchEvent(e);
		}
		
		private function deleteClickedHandler(event:MouseEvent):void
		{
			var e:MouseEvent = new MouseEvent("deleteClicked", event.bubbles, event.cancelable, event.localX, event.localY, event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown, event.delta, event.commandKey, event.controlKey, event.clickCount);
			dispatchEvent(e);
		}
		
		private function cancelClickedHandler(event:MouseEvent):void
		{
			var e:MouseEvent = new MouseEvent("cancelClicked", event.bubbles, event.cancelable, event.localX, event.localY, event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown, event.delta, event.commandKey, event.controlKey, event.clickCount);
			dispatchEvent(e);
		}
		
		override public function set mxmlContent(value:Array):void
		{
			mxmlContentGroup.mxmlContent = value;
			invalidateDisplayList();
		}

		public function disableDelete():void {
			_disableDelete = true;
			if(_groupDelete != null) {
				_groupDelete.getChildAt(0).alpha = 0;
				_groupDelete.removeEventListener(MouseEvent.CLICK, deleteClickedHandler);
			}
		}
		
		public function enableDelete():void {
			_disableDelete = false;
			if(_groupDelete != null) {
				_groupDelete.getChildAt(0).alpha = 1.0;
				_groupDelete.addEventListener(MouseEvent.CLICK, deleteClickedHandler);
			}
		}
		
		public function disableCancel():void {
			_disableCancel = true;
			if(_groupCancel != null) {
				_groupCancel.getChildAt(0).alpha = 0;
				_groupCancel.removeEventListener(MouseEvent.CLICK, cancelClickedHandler);
			}
		}
		
		public function enableCancel():void {
			_disableCancel = false;
			if(_groupCancel != null) {
				_groupCancel.getChildAt(0).alpha = 1.0;
				_groupCancel.addEventListener(MouseEvent.CLICK, cancelClickedHandler);
			}
		}

		
		public function disableOK():void {
			_disableOK = true;
			if(_groupOK != null) {
				_groupOK.getChildAt(0).alpha = 0;
				_groupOK.removeEventListener(MouseEvent.CLICK, okClickedHandler);
			}
		}
		
		public function enableOK():void {
			_disableOK = false;
			if(_groupOK != null) {
				_groupOK.getChildAt(0).alpha = 1.0;
				_groupOK.addEventListener(MouseEvent.CLICK, okClickedHandler);
			}
		}

	}
}