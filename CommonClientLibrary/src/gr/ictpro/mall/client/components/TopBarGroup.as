package gr.ictpro.mall.client.components
{
	import flash.events.MouseEvent;
	import flash.text.ReturnKeyLabel;
	
	import mx.core.mx_internal;
	
	import spark.layouts.supportClasses.LayoutBase;
	
	import assets.fxg.add;
	import assets.fxg.back;
	import assets.fxg.cancel;
	import assets.fxg.ok;
	
	import flashx.textLayout.tlf_internal;
	import flashx.textLayout.formats.VerticalAlign;
	
	import gr.ictpro.mall.client.model.Device;

use namespace mx_internal;	
	
	[Event(name="backClicked", type="flash.events.MouseEvent")]
	[Event(name="okClicked", type="flash.events.MouseEvent")]
	[Event(name="cancelClicked", type="flash.events.MouseEvent")]
	[Event(name="addClicked", type="flash.events.MouseEvent")]
	
	public class TopBarGroup extends Group
	{
		public var addButton:Boolean = false;
		public var okButton:Boolean = true;
		public var cancelButton:Boolean = true;
		private var mxmlContentGroup:Group = new Group(); 
		protected var _title:String;
		private var _titleLabel:Label; 
		
		public function TopBarGroup()
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
			_titleLabel.setStyle("fontSize", 16);
			
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
				fxgAdd.right=10;
				var groupOK:Group = new Group();
				groupOK.addElement(fxgAdd);
				groupOK.addEventListener(MouseEvent.CLICK, addClickedHandler);
				
				ocgroup.addElement(groupOK);
				
			}

			if(okButton) {
				var fxgOk:ok = new ok();
				fxgOk.width = Device.getScaledSize(21);
				fxgOk.height = Device.getScaledSize(15);
				var groupOK:Group = new Group();
				groupOK.addElement(fxgOk);
				groupOK.addEventListener(MouseEvent.CLICK, okClickedHandler);
				
				ocgroup.addElement(groupOK);

			}
			
			if(cancelButton) {
				var fxgCancel:cancel = new cancel();
				fxgCancel.width = Device.getScaledSize(15);
				fxgCancel.height = Device.getScaledSize(15);
				var groupCancel:Group = new Group();
				groupCancel.addElement(fxgCancel);
				groupCancel.addEventListener(MouseEvent.CLICK, cancelClickedHandler);
				ocgroup.addElement(groupCancel);
			}

			topBarGroup.addElement(ocgroup);
			var scroller:Scroller = new Scroller();
			scroller.percentWidth = 100;
			scroller.percentHeight = 100;
			scroller.minViewportInset = 1;
			scroller.hasFocusableChildren = true;
			scroller.ensureElementIsVisibleForSoftKeyboard = false;
			scroller.viewport = mxmlContentGroup;
			addElement(scroller);
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
	}
}