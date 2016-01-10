package gr.ictpro.mall.client.components
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.core.mx_internal;
	import mx.events.ResizeEvent;
	import mx.utils.ObjectProxy;
	
	import spark.layouts.supportClasses.LayoutBase;
	
	import assets.fxg.add;
	import assets.fxg.back;
	import assets.fxg.cancel;
	import assets.fxg.ok;
	import assets.fxg.trashcan;
	
	import flashx.textLayout.formats.VerticalAlign;
	
	import gr.ictpro.mall.client.model.ViewParameters;
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
//		protected var mxmlContentGroup:Group; 
		private var _masterView:IVisualElement;
		private var _parameters:ViewParameters;
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
		public function set parameters(parameters:ViewParameters):void
		{
			this._parameters = parameters;
		}
		
		public function get parameters():ViewParameters
		{
			return this._parameters;
		}
		
		public function invalidateChildren():void {
			removeAllElements();
			createChildren();
			if(_disableCancel) {
				disableCancel();
			}
			if(_disableDelete) {
				disableDelete();
			}
			if(_disableOK) {
				disableOK();
			}
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
			
			l1.paddingLeft = 3;
			l1.paddingRight = 2;
			l1.gap = 0;
			l1.verticalAlign = VerticalAlign.MIDDLE;
			bgroup.layout = l1;
			bgroup.left = 0;
			bgroup.top = 0;
			bgroup.height = 30; //Device.getScaledSize(40);
			
			var fxgBack:back = new back();
			fxgBack.width = Device.getScaledSize(16);
			fxgBack.height = Device.getScaledSize(15);
			
			var groupBack:Group = new Group();

			groupBack.width = 31;
			groupBack.height = 30;
			var layout1:HorizontalLayout =  new HorizontalLayout();
			layout1.paddingTop = 7;
			layout1.paddingLeft = 7; 
			layout1.paddingBottom = 8;
			layout1.paddingRight = 8; 
			groupBack.layout = layout1;
			
			
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
			l2.paddingRight = 2;
			l2.gap = 0;
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
				
				groupAdd.width = 30;
				groupAdd.height = 30;
				var layout2:HorizontalLayout =  new HorizontalLayout();
				layout2.paddingTop = 7;
				layout2.paddingLeft = 7; 
				layout2.paddingBottom = 8;
				layout2.paddingRight = 8; 
				groupAdd.layout = layout2;

				
				groupAdd.addElement(fxgAdd);
				groupAdd.addEventListener(MouseEvent.CLICK, addClickedHandler);
				
				ocgroup.addElement(groupAdd);
			}
			
			if(deleteButton) {
				var fxgDelete:trashcan = new trashcan();
				fxgDelete.width = Device.getScaledSize(11);
				fxgDelete.height = Device.getScaledSize(15);
				_groupDelete = new Group();
				
				_groupDelete.width = 21;
				_groupDelete.height = 30;
				var layout3:HorizontalLayout =  new HorizontalLayout();
				layout3.paddingTop = 7;
				layout3.paddingLeft = 7; 
				layout3.paddingBottom = 8;
				layout3.paddingRight = 3; 
				_groupDelete.layout = layout3;

				
				
				_groupDelete.addElement(fxgDelete);
				_groupDelete.addEventListener(MouseEvent.CLICK, deleteClickedHandler);
				
				ocgroup.addElement(_groupDelete);
			}
			
			if(okButton) {
				var fxgOk:ok = new ok();
				fxgOk.width = Device.getScaledSize(21);
				fxgOk.height = Device.getScaledSize(15);
				//fxgOk.left = 10;
				_groupOK = new Group();
				
				_groupOK.width = 31;
				_groupOK.height = 30;
				var layout4:HorizontalLayout =  new HorizontalLayout();
				layout4.paddingTop = 7;
				layout4.paddingLeft = 7; 
				layout4.paddingBottom = 8;
				layout4.paddingRight = 3; 
				_groupOK.layout = layout4;

				_groupOK.addElement(fxgOk);
				
				_groupOK.addEventListener(MouseEvent.CLICK, okClickedHandler);
				
				ocgroup.addElement(_groupOK);
			}
			
			if(cancelButton) {
				var fxgCancel:cancel = new cancel();
				fxgCancel.width = Device.getScaledSize(15);
				fxgCancel.height = Device.getScaledSize(15);
				//fxgCancel.left = okButton?0:10;
				_groupCancel = new Group();
				
				_groupCancel.width = 30;
				_groupCancel.height = 30;
				var layout5:HorizontalLayout =  new HorizontalLayout();
				layout5.paddingTop = 7;
				layout5.paddingLeft = 7; 
				layout5.paddingBottom = 8;
				layout5.paddingRight = 8; 
				_groupCancel.layout = layout5;
				

				
				_groupCancel.addElement(fxgCancel);
				_groupCancel.addEventListener(MouseEvent.CLICK, cancelClickedHandler);
				ocgroup.addElement(_groupCancel);
			}
			
			topBarGroup.addElement(ocgroup);
			//addElement(mxmlContentGroup);

		}

		private function backClickedHandler(event:Event):void
		{
			var e:MouseEvent = new MouseEvent("backClicked");
			dispatchEvent(e);
		}
		
		private function okClickedHandler(event:Event):void
		{
			var e:MouseEvent = new MouseEvent("okClicked");
			dispatchEvent(e);
		}
		
		private function addClickedHandler(event:Event):void
		{
			var e:MouseEvent = new MouseEvent("addClicked");
			dispatchEvent(e);
		}
		
		private function deleteClickedHandler(event:Event):void
		{
			var e:MouseEvent = new MouseEvent("deleteClicked");
			dispatchEvent(e);
		}
		
		private function cancelClickedHandler(event:Event):void
		{
			var e:MouseEvent = new MouseEvent("cancelClicked");
			dispatchEvent(e);
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