package gr.ictpro.mall.client.components
{
	import assets.fxg.back;
	import assets.fxg.cancel;
	import assets.fxg.ok;
	
	import flash.events.MouseEvent;
	
	import flashx.textLayout.formats.VerticalAlign;
	
	import mx.graphics.SolidColor;
	
	import spark.components.Group;
	import spark.layouts.HorizontalLayout;
	import spark.layouts.VerticalLayout;
	import spark.layouts.supportClasses.LayoutBase;
	import spark.primitives.Rect;

	
	
	[Event(name="backClicked", type="flash.events.MouseEvent")]
	[Event(name="okClicked", type="flash.events.MouseEvent")]
	[Event(name="cancelClicked", type="flash.events.MouseEvent")]
	
	public class TopBarGroup extends Group
	{
		public var okButton:Boolean = true;
		public var cancelButton:Boolean = true;
		private var mxmlContentGroup:Group = new Group(); 
		
		public function TopBarGroup()
		{
			super();
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
			topBarGroup.height=40;
			
			var bg:Rect = new Rect();
			bg.fill = new SolidColor(0xAAAAAA);
			bg.left = 0;
			bg.bottom = 0;
			bg.top = 0;
			bg.right = 0;
			topBarGroup.addElement(bg);
			
			addElement(topBarGroup);
			
			// Back button
			var bgroup:Group = new Group();
			var l1:HorizontalLayout = new HorizontalLayout();
			l1.paddingLeft = 10;
			l1.paddingRight = 10;
			l1.gap = 20;
			l1.verticalAlign = VerticalAlign.MIDDLE;
			bgroup.layout = l1;
			bgroup.left = 0;
			bgroup.top = 0;
			bgroup.height = 40;
			
			var fxgBack:back = new back();
			fxgBack.width = 23;
			fxgBack.height = 22;

			var groupBack:Group = new Group();
			groupBack.addElement(fxgBack);
			groupBack.addEventListener(MouseEvent.CLICK, backClickedHandler);
			bgroup.addElement(groupBack);
			
			topBarGroup.addElement(bgroup);
			
			
			// OK/Cancel buttons
			var ocgroup:Group = new Group();
			var l2:HorizontalLayout = new HorizontalLayout();
			l2.paddingLeft = 10;
			l2.paddingRight = 10;
			l2.gap = 20;
			l2.verticalAlign = VerticalAlign.MIDDLE;
			ocgroup.layout = l2;
			ocgroup.right = 0;
			ocgroup.top = 0;
			ocgroup.height = 40;

			if(okButton) {
				var fxgOk:ok = new ok();
				fxgOk.width = 31;
				fxgOk.height = 22;
				var groupOK:Group = new Group();
				groupOK.addElement(fxgOk);
				groupOK.addEventListener(MouseEvent.CLICK, okClickedHandler);
				
				ocgroup.addElement(groupOK);

			}
			
			if(cancelButton) {
				var fxgCancel:cancel = new cancel();
				fxgCancel.width = 22;
				fxgCancel.height = 22;
				var groupCancel:Group = new Group();
				groupCancel.addElement(fxgCancel);
				groupCancel.addEventListener(MouseEvent.CLICK, cancelClickedHandler);
				ocgroup.addElement(groupCancel);
			}

			topBarGroup.addElement(ocgroup);
			addElement(mxmlContentGroup);
			mxmlContentGroup.percentWidth = 100;
			mxmlContentGroup.percentHeight = 100;
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