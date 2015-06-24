package gr.ictpro.mall.client.components.renderers
{
	import gr.ictpro.mall.client.components.SolidColor;
	import gr.ictpro.mall.client.model.Device;
	
	import mx.core.IDataRenderer;
	import mx.core.IFlexDisplayObject;
	import mx.core.ILayoutElement;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	import mx.managers.SystemManagerGlobals;
	import mx.styles.StyleManager;
	
	import spark.components.Group;
	import spark.components.IItemRenderer;
	import spark.primitives.Rect;
	
	use namespace mx_internal;

	public class ColorItemRenderer extends UIComponent implements IDataRenderer, IItemRenderer
	{
		private var _itemIndex:int;
		private var _dragging:Boolean = false;
		private var _selected:Boolean = false;
		private var _showsCaret:Boolean = false;
		private var _label:String;
		protected var rectDisplay:Group;
		private var _data:Object;
		
		public function ColorItemRenderer()
		{
			super();
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			_data = value;
			
			if (hasEventListener(FlexEvent.DATA_CHANGE))
				dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
			
			(rectDisplay.getElementAt(0) as Rect).fill = new SolidColor(StyleManager.getStyleManager(SystemManagerGlobals.topLevelSystemManagers[0]).getColorName(data)); 

			trace(_data);
			invalidateProperties();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number,
													  unscaledHeight:Number):void
		{
			// clear the graphics before calling super.updateDisplayList()
			graphics.clear();
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			layoutContents(unscaledWidth, unscaledHeight);
		}

		
		public function get itemIndex():int
		{
			return _itemIndex;
		}
		
		public function set itemIndex(value:int):void
		{
			if (value == _itemIndex)
				return;
			
			_itemIndex = value;
		}

		public function get dragging():Boolean
		{
			return _dragging;
		}
		
		/**
		 *  @private  
		 */
		public function set dragging(value:Boolean):void
		{
			_dragging = value;
		}

		public function get label():String
		{
			return _label;	
		}
		
		public function set label(value:String):void
		{
			_label=value;
		}

		public function get selected():Boolean {
			return _selected;
		}
		
		public function set selected(value:Boolean):void 
		{
			_selected = value;
		}

		public function get showsCaret():Boolean
		{
			return _showsCaret;
		}
		
		public function set showsCaret(value:Boolean):void
		{
			_showsCaret = value;
		}

		override protected function createChildren():void
		{
			super.createChildren();

			if (!rectDisplay)
			{
				createRectDisplay();
			}

		}
		
		protected function createRectDisplay():void
		{
			var r:Rect = new Rect();
			r.percentWidth=100;
			r.percentHeight=100;
			rectDisplay = new Group();
			rectDisplay.addElement(r);
			rectDisplay.width = 60;
			rectDisplay.height = Device.getScaledSize(20);
			addChild(rectDisplay);
		}
		
		protected function layoutContents(unscaledWidth:Number, 
										  unscaledHeight:Number):void
		{
			if(!rectDisplay)
				return;
			
			var paddingLeft:Number   = getStyle("paddingLeft"); 
			var paddingRight:Number  = getStyle("paddingRight");
			var paddingTop:Number    = getStyle("paddingTop");
			var paddingBottom:Number = getStyle("paddingBottom");

			var viewWidth:Number  = unscaledWidth  - paddingLeft - paddingRight;
			var viewHeight:Number = unscaledHeight - paddingTop  - paddingBottom;
			
			var rectWidth:Number = viewWidth; 
			var rectHeight:Number = viewHeight;
			
			setElementSize(rectDisplay, rectWidth, rectHeight);
			setElementPosition(rectDisplay, paddingLeft, paddingTop);

		}
		
		protected function setElementSize(element:Object, width:Number, height:Number):void
		{
			if (element is ILayoutElement)
			{
				ILayoutElement(element).setLayoutBoundsSize(width, height, false);
			}
			else if (element is IFlexDisplayObject)
			{
				IFlexDisplayObject(element).setActualSize(width, height);
			}
			else
			{
				element.width = width;
				element.height = height;
			}
		}

		protected function setElementPosition(element:Object, x:Number, y:Number):void
		{
			if (element is ILayoutElement)
			{
				ILayoutElement(element).setLayoutBoundsPosition(x, y, false);
			}
			else if (element is IFlexDisplayObject)
			{
				IFlexDisplayObject(element).move(x, y);   
			}
			else
			{
				element.x = x;
				element.y = y;
			}
		}

		override protected function measure():void
		{
			super.measure();
			
			if (rectDisplay)
			{
				// reset text if it was truncated before.
				var horizontalPadding:Number = getStyle("paddingLeft") + getStyle("paddingRight");
				var verticalPadding:Number = getStyle("paddingTop") + getStyle("paddingBottom");
				
				// Text respects padding right, left, top, and bottom
				measuredWidth = getElementPreferredWidth(rectDisplay) + horizontalPadding;
				// We only care about the "real" ascent
				measuredHeight = getElementPreferredHeight(rectDisplay) + verticalPadding; 
			}
			
		}

		protected function getElementPreferredWidth(element:Object):Number
		{
			var result:Number;
			
			if (element is ILayoutElement)
			{
				result = ILayoutElement(element).getPreferredBoundsWidth();
			}
			else if (element is IFlexDisplayObject)
			{
				result = IFlexDisplayObject(element).measuredWidth;
			}
			else
			{
				result = element.width;
			}
			
			return Math.round(result);
		}

		protected function getElementPreferredHeight(element:Object):Number
		{
			var result:Number;
			
			if (element is ILayoutElement)
			{
				result = ILayoutElement(element).getPreferredBoundsHeight();
			}
			else if (element is IFlexDisplayObject)
			{
				result =  IFlexDisplayObject(element).measuredHeight;
			}
			else
			{
				result =  element.height;
			}
			
			return Math.ceil(result);
		}

	}
}