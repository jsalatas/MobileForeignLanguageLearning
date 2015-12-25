package gr.ictpro.mall.client.components.renderers
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.utils.flash_proxy;
	
	import gr.ictpro.mall.client.runtime.Device;
	import gr.ictpro.mall.client.utils.string.IntoToHexString;
	
	import mx.core.DPIClassification;
	import mx.core.FlexGlobals;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	import mx.graphics.BitmapFillMode;
	import mx.graphics.BitmapScaleMode;
	import mx.utils.DensityUtil;
	
	import spark.components.LabelItemRenderer;
	import spark.components.supportClasses.InteractionState;
	import spark.components.supportClasses.StyleableTextField;
	import spark.core.ContentCache;
	import spark.core.DisplayObjectSharingMode;
	import spark.core.IContentLoader;
	import spark.core.IGraphicElement;
	import spark.core.IGraphicElementContainer;
	import spark.core.ISharedDisplayObject;
	import spark.primitives.BitmapImage;
	import spark.utils.MultiDPIBitmapSource;
	
	use namespace mx_internal;
	
	//--------------------------------------
	//  Styles
	//--------------------------------------
	
	/**
	 *  Number of pixels between children in the horizontal direction.
	 *  The default value depends on the component class;
	 *  if not overridden for the class, the default value is 8.
	 *  
	 *  @langversion 3.0
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 4.5
	 */
	[Style(name="horizontalGap", type="Number", format="Length", inherit="no")]
	
	/**
	 *  Number of pixels between children in the vertical direction.
	 *  The default value depends on the component class;
	 *  if not overridden for the class, the default value is 6.
	 *  
	 *  @langversion 3.0
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 4.5
	 */
	[Style(name="verticalGap", type="Number", format="Length", inherit="no")]
	
	
	/**
	 *  The delay value before attempting to load the 
	 *  icon's source if it has not been cached already.
	 * 
	 *  <p>The reason a delay is useful is while scrolling around, you 
	 *  don't necessarily want the image to load up immediately.  Instead, 
	 *  you should wait a certain delay period to make sure the user actually 
	 *  wants to see this item renderer.</p>
	 * 
	 *  @default 500
	 *  
	 *  @langversion 3.0
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 4.5
	 */
	[Style(name="iconDelay", type="Number", format="Time", inherit="no")]
	
	/**
	 *  The IconItemRenderer class is a performant item 
	 *  renderer optimized for mobile devices.  
	 *  It displays four optional parts for each item in the 
	 *  list-based control: 
	 *
	 *  <ul>
	 *    <li>An icon on the left defined by the <code>iconField</code> or 
	 *      <code>iconFunction</code> property.</li>
	 *    <li>A single-line text label next to the icon defined by the 
	 *      <code>labelField</code> or <code>labelFunction</code> property.</li>
	 *    <li>A decorator icon on the right defined by the 
	 *      <code>decorator</code> property.</li>
	 *  </ul>
	 *
	 *  <p>To apply CSS styles to the single-line text label, such as font size and color, 
	 *  set the styles on the IconItemRenderer class. 
	 *  The following example sets the text styles for the text label:</p>
	 *
	 *  <pre>
	 *     &lt;fx:Style&gt;
	 *         .myFontStyle { 
	 *             fontSize: 15;
	 *             color: #9933FF;
	 *         }
	 *  
	 *     &lt;/fx:Style&gt;
	 *     
	 *     &lt;s:List id="myList"
	 *         width="100%" height="100%"
	 *         labelField="firstName"&gt;
	 *         &lt;s:itemRenderer&gt;
	 *             &lt;fx:Component&gt;
	 *                 &lt;s:IconItemRenderer messageStyleName="myFontStyle" fontSize="25"
	 *                     labelField="firstName"
	 *                     decorator="&#64;Embed(source='assets/logo_small.jpg')"/&gt;
	 *             &lt;/fx:Component&gt;
	 *         &lt;/s:itemRenderer&gt;
	 *         &lt;s:ArrayCollection&gt;
	 *             &lt;fx:Object firstName="Dave" lastName="Duncam" company="Adobe" phone="413-555-1212"/&gt;
	 *             &lt;fx:Object firstName="Sally" lastName="Smith" company="Acme" phone="617-555-1491"/&gt;
	 *             &lt;fx:Object firstName="Jim" lastName="Jackson" company="Beta" phone="413-555-2345"/&gt;
	 *             &lt;fx:Object firstName="Mary" lastName="Moore" company="Gamma" phone="617-555-1899"/&gt;
	 *         &lt;/s:ArrayCollection&gt;
	 *     &lt;/s:List&gt;
	 *  </pre>
	 *
	 *  @mxml
	 *  
	 *  <p>The <code>&lt;s:IconItemRenderer&gt;</code> tag inherits all of the tag 
	 *  attributes of its superclass and adds the following tag attributes:</p>
	 *  
	 *  <pre>
	 *  &lt;s:IconItemRenderer
	 *   <strong>Properties</strong>
	 *    decorator=""
	 *    iconContentLoader="<i>See property description</i>"
	 *    iconField="null"
	 *    iconFillMode=""scale
	 *    iconFunction="null"
	 *    iconHeight="NaN"
	 *    iconPlaceholder="null"
	 *    iconScaleMode="stretch"
	 *    iconWidth="NaN"
	 *    label=""
	 *    labelField="null"
	 *    labelFunction="null"
	 * 
	 *   <strong>Common Styles</strong>
	 *    horizontalGap="8"
	 *    iconDelay="500"
	 *    verticalGap="6"
	 *  &gt;
	 *  </pre>
	 *
	 *  @see spark.components.List
	 *  @see mx.core.IDataRenderer
	 *  @see spark.components.IItemRenderer
	 *  @see spark.components.supportClasses.ItemRenderer
	 *  @see spark.components.LabelItemRenderer
	 *  @includeExample examples/IconItemRendererExample.mxml -noswf
	 *  
	 *  @langversion 3.0
	 *  @productversion Flex 4.5
	 */
	public class IconItemRenderer extends spark.components.LabelItemRenderer
		implements IGraphicElementContainer, ISharedDisplayObject
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Static icon image cache.  This is the default for iconContentLoader.
		 */
		mx_internal static var _imageCache:ContentCache;
		
		
		private var _topSeparatorColor:uint = 0xFFFFFF;
		private var _topSeparatorAlpha:Number = .3;
		private var _bottomSeparatorColor:uint = 0x000000;
		private var _bottomSeparatorAlpha:Number = .3;
		protected var isGroup:Boolean = false;
		
		private var groupItemAdjusted:Boolean = false;

		private var _fontSize:Number = 0;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function IconItemRenderer()
		{
			super();
			
			if (_imageCache == null) {
				_imageCache = new ContentCache();
				_imageCache.enableCaching = true;
				_imageCache.maxCacheEntries = 100;
			}
			
			// set default labelDisplay width
			switch (applicationDPI)
			{
				case DPIClassification.DPI_320:
				{
					oldUnscaledWidth = 640;
					break;
				}
				case DPIClassification.DPI_240:
				{
					oldUnscaledWidth = 480;
					break;
				}
				default:
				{
					// default PPI160
					oldUnscaledWidth = 320;
					break;
				}
			}
			_fontSize = Device.getDefaultScaledFontSize();
			super.setStyle("fontSize", _fontSize);
			super.setStyle("downColor", Device.getDefaultColor(0.6));
			super.setStyle("selectionColor", Device.getDefaultColor(0.3));
			super.setStyle("rollOverColor", Device.getDefaultColor(0.05));
			
		}

		override public function setStyle(styleProp:String, newValue:*):void
		{
			if(styleProp == "fontSize") {
				newValue = Device.getScaledSize(newValue);
				_fontSize = newValue;
			}
			super.setStyle(styleProp, newValue);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Stores the text of the label component.  This is calculated in 
		 *  commitProperties() based on labelFunction, labelField, and label.
		 * 
		 *  <p>We can't just use labelDisplay.text because it may contain 
		 *  a truncated value.</p>
		 */
		mx_internal var labelText:String = "";
		
		/**
		 *  @private
		 *  Since iconDisplay is a GraphicElement, we have to call its lifecycle methods 
		 *  directly.
		 */
		private var iconNeedsValidateProperties:Boolean = false;
		
		/**
		 *  @private
		 *  Since iconDisplay is a GraphicElement, we have to call its lifecycle methods 
		 *  directly.
		 */
		private var iconNeedsValidateSize:Boolean = false;
		
		/**
		 *  @private
		 *  Since iconDisplay is a GraphicElement, we have to call help assign 
		 *  its display object
		 */
		private var iconNeedsDisplayObjectAssignment:Boolean = false;
		
		/**
		 *  @private
		 *  Timer, used to delay setting the source on the icon.
		 */
		private var iconSetterDelayTimer:Timer;
		
		/**
		 *  @private
		 *  The source to set iconDisplay to, after waiting an appropriate delay period
		 */
		private var iconSourceToLoad:Object;
		
		/**
		 *  @private
		 *  The width of the component on the previous layout manager 
		 *  pass.  This gets set in updateDisplayList() and used in measure() on 
		 *  the next layout pass.  This is so our "guessed width" in measure(). 
		 * 
		 *  In the constructor, this is actually set based on the DPI.
		 */
		mx_internal var oldUnscaledWidth:Number;
		
		//--------------------------------------------------------------------------
		//
		//  Public Properties: Overridden
		//
		//--------------------------------------------------------------------------
		
		private var heightAdjusted:Boolean = false;
		
		[Bindable(event="HeightScaled")]
		override public function set height(value:Number):void
		{
			if(!heightAdjusted) {
				super.height = Device.getScaledSize(value);
				heightAdjusted = true;
			}
		}
		
		[Bindable(event="HeightScaled")]
		public function get definedHeight():Number
		{
			return Device.getUnScaledSize(super.height);	
		}
		

		/**
		 *  @private
		 */
		override public function set data(value:Object):void
		{
			super.data = value;
			
			iconChanged = true;
			labelChanged = true;
			
			//labelDisplay.setStyle("color", (selected || down)?"0xffffff":IntoToHexString.convertToHex(Device.getDefaultColor()));
			if(value.hasOwnProperty("isGroup") && value.isGroup) {
				isGroup = true;
				labelDisplay.setStyle("fontSize", _fontSize + Device.getScaledSize(2));
				labelDisplay.setStyle("fontWeight", 'bold');
				if(height != 0 && !groupItemAdjusted) {
					height += Device.getScaledSize(15);
					groupItemAdjusted = true;
				}
			} else {
				isGroup = false;
				if(height != 0 && groupItemAdjusted) {
					height -= Device.getScaledSize(15);
					groupItemAdjusted = false;
				}
				labelDisplay.setStyle("fontSize", _fontSize);
				labelDisplay.setStyle("fontWeight", 'normal');
			}
			labelDisplay.commitStyles();
			
			if (hasEventListener(FlexEvent.DATA_CHANGE))
				dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
			
			invalidateProperties();
		}
		
		/**
		 *  <p>If <code>labelFunction</code> = <code>labelField</code> = null,
		 *  then use the <code>label</code> property that gets 
		 *  pushed in from the list control. 
		 *  However if <code>labelField</code> is explicitly set to 
		 *  <code>""</code> (the empty string), then no label appears.</p>
		 * 
		 *  @inheritDoc
		 * 
		 *  @see spark.components.IconItemRenderer#labelField
		 *  @see spark.components.IconItemRenderer#labelFunction
		 *  @see spark.components.IItemRenderer#label
		 * 
		 *  @langversion 3.0
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5   
		 */
		override public function set label(value:String):void
		{
			if (value == label)
				return;
			
			super.label = value;
			
			labelChanged = true;
			invalidateProperties();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  iconContentLoader
		//----------------------------------
		
		/**
		 *  @private 
		 */ 
		private var _iconContentLoader:IContentLoader = _imageCache;
		
		
		/**
		 *  Optional custom image loader, such as an image cache or queue, to
		 *  associate with content loader client.
		 * 
		 *  <p>The default value is a static content cache defined on IconItemRenderer
		 *  that allows up to 100 entries.</p>
		 * 
		 *  @langversion 3.0
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5   
		 */
		public function get iconContentLoader():IContentLoader
		{
			return _iconContentLoader;
		}
		
		/**
		 *  @private
		 */ 
		public function set iconContentLoader(value:IContentLoader):void
		{
			if (value == _iconContentLoader)
				return;
			
			_iconContentLoader = value;
			
			if (iconDisplay)
				iconDisplay.contentLoader = _iconContentLoader;
		}
		
		//----------------------------------
		//  labelField
		//----------------------------------
		
		/**
		 *  @private
		 */
		private var _labelField:String = null;
		
		/**
		 *  @private
		 */
		private var labelFieldOrFunctionChanged:Boolean;
		
		/**
		 *  @private
		 */
		private var labelChanged:Boolean; 
		
		/**
		 *  The name of the field in the data provider items to display 
		 *  as the label. 
		 *  The <code>labelFunction</code> property overrides this property.
		 * 
		 *  <p>If <code>labelFunction</code> = <code>labelField</code> = null,
		 *  then use the <code>label</code> property that gets 
		 *  pushed in from the list-based control.  
		 *  However if <code>labelField</code> is explicitly set to 
		 *  <code>""</code> (the empty string),
		 *  then no label appears.</p>
		 * 
		 *  @see spark.components.IconItemRenderer#labelFunction
		 *  @see spark.components.IItemRenderer#label
		 *
		 *  @default null
		 *  
		 *  @langversion 3.0
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get labelField():String
		{
			return _labelField;
		}
		
		/**
		 *  @private
		 */
		public function set labelField(value:String):void
		{
			if (value == _labelField)
				return;
			
			_labelField = value;
			labelFieldOrFunctionChanged = true;
			labelChanged = true;
			
			invalidateProperties();
		}
		
		//----------------------------------
		//  labelFunction
		//----------------------------------
		
		/**
		 *  @private
		 */
		private var _labelFunction:Function; 
		
		/**
		 *  A user-supplied function to run on each item to determine its label.  
		 *  The <code>labelFunction</code> property overrides 
		 *  the <code>labelField</code> property.
		 *
		 *  <p>You can supply a <code>labelFunction</code> that finds the 
		 *  appropriate fields and returns a displayable string. The 
		 *  <code>labelFunction</code> is also good for handling formatting and 
		 *  localization.</p>
		 *
		 *  <p>The label function takes a single argument which is the item in 
		 *  the data provider and returns a String.</p>
		 *  <pre>
		 *  myLabelFunction(item:Object):String</pre>
		 * 
		 *  <p>If <code>labelFunction</code> = <code>labelField</code> = null,
		 *  then use the <code>label</code> property that gets 
		 *  pushed in from the list-based control.  
		 *  However if <code>labelField</code> is explicitly set to 
		 *  <code>""</code> (the empty string),
		 *  then no label appears.</p>
		 * 
		 *  @see spark.components.IconItemRenderer#labelFunction
		 *  @see spark.components.IItemRenderer#label
		 *
		 *  @default null
		 *  
		 *  @langversion 3.0
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get labelFunction():Function
		{
			return _labelFunction;
		}
		
		/**
		 *  @private
		 */
		public function set labelFunction(value:Function):void
		{
			if (value == _labelFunction)
				return;
			
			_labelFunction = value;
			labelFieldOrFunctionChanged = true;
			labelChanged = true;
			
			invalidateProperties(); 
		}
		
		//----------------------------------
		//  iconField
		//----------------------------------
		
		/**
		 *  @private 
		 */ 
		private var _iconField:String;
		
		/**
		 *  @private 
		 */ 
		private var iconFieldOrFunctionChanged:Boolean;
		
		/**
		 *  @private 
		 */ 
		private var iconChanged:Boolean;
		
		/**
		 *  @private
		 *  The class to use when instantiating the icon for IconItemRenderer.
		 *  This class must extend spark.primitives.BitmapImage.
		 *  This property was added for Design View so they can set this to a special
		 *  subclass of BitmapImage that knows how to load and resolve resources in Design View.
		 */
		mx_internal var iconDisplayClass:Class = BitmapImage;
		
		/**
		 *  The bitmap image component used to 
		 *  display the icon data of the item renderer.
		 * 
		 *  @langversion 3.0
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		protected var iconDisplay:BitmapImage;
		
		/**
		 *  The name of the field in the data item to display as the icon. 
		 *  By default <code>iconField</code> is <code>null</code>, and the item renderer 
		 *  does not display an icon.
		 *
		 *  @default null
		 * 
		 *  @langversion 3.0
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get iconField():String
		{
			return _iconField;
		}
		
		/**
		 *  @private
		 */ 
		public function set iconField(value:String):void
		{
			if (value == _iconField)
				return;
			
			_iconField = value;
			iconFieldOrFunctionChanged = true;
			iconChanged = true;
			
			invalidateProperties();
		}
		
		//----------------------------------
		//  iconFillMode
		//----------------------------------
		
		/**
		 *  @private 
		 */ 
		private var _iconFillMode:String = BitmapFillMode.SCALE;
		
		[Inspectable(category="General", enumeration="clip,repeat,scale", defaultValue="scale")]
		
		/**
		 *  @copy spark.primitives.BitmapImage#fillMode
		 *
		 *  @default <code>mx.graphics.BitmapFillMode.SCALE</code>
		 *
		 *  @see mx.graphics.BitmapFillMode
		 * 
		 *  @langversion 3.0
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get iconFillMode():String
		{
			return _iconFillMode;
		}
		
		/**
		 *  @private
		 */ 
		public function set iconFillMode(value:String):void
		{
			if (value == _iconFillMode)
				return;
			
			_iconFillMode = value;
			
			if (iconDisplay)
				iconDisplay.fillMode = _iconFillMode;
		}
		
		//----------------------------------
		//  iconFunction
		//----------------------------------
		
		/**
		 *  @private 
		 */ 
		private var _iconFunction:Function;
		
		/**
		 *  A user-supplied function to run on each item to determine its icon.  
		 *  The <code>iconFunction</code> property overrides 
		 *  the <code>iconField</code> property.
		 *
		 *  <p>You can supply an <code>iconFunction</code> that finds the 
		 *  appropriate fields and returns a valid URL or object to be used as 
		 *  the icon.</p>
		 *
		 *  <p>The icon function takes a single argument which is the item in 
		 *  the data provider and returns an Object that gets passed to a 
		 *  <code>spark.primitives.BitmapImage</code> object as the <code>source</code>
		 *  property.  Icon function can return a valid URL pointing to an image 
		 *  or a Class file that represents an image.  To see what other types 
		 *  of objects can be returned from the icon 
		 *  function, see the <code>BitmapImage</code>'s documentation</p>
		 *  <pre>
		 *  myIconFunction(item:Object):Object</pre>
		 *
		 *  @default null
		 * 
		 *  @see spark.primitives.BitmapImage#source
		 *  
		 *  @langversion 3.0
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get iconFunction():Function
		{
			return _iconFunction;
		}
		
		/**
		 *  @private
		 */ 
		public function set iconFunction(value:Function):void
		{
			if (value == _iconFunction)
				return;
			
			_iconFunction = value;
			iconFieldOrFunctionChanged = true;
			iconChanged = true;
			
			invalidateProperties();
		}
		
		//----------------------------------
		//  iconHeight
		//----------------------------------
		
		/**
		 *  @private 
		 */ 
		private var _iconHeight:Number;
		
		/**
		 *  The height of the icon.  If unspecified, the 
		 *  intrinsic height of the image is used.
		 *
		 *  @default NaN
		 * 
		 *  @langversion 3.0
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get iconHeight():Number
		{
			return _iconHeight;
		}
		
		/**
		 *  @private
		 */ 
		public function set iconHeight(value:Number):void
		{
			value = Device.getScaledSize(value);
			if (value == _iconHeight)
				return;
			
			_iconHeight = value;
			
			if (iconDisplay)
				iconDisplay.explicitHeight = _iconHeight;
			
			invalidateSize();
			invalidateDisplayList();
		}
		
		//----------------------------------
		//  iconPlaceholder
		//----------------------------------
		
		/**
		 *  @private 
		 */ 
		private var _iconPlaceholder:Object;
		
		/**
		 *  The icon asset to use while an externally loaded asset is
		 *  being downloaded.
		 * 
		 *  <p>This asset should be an embedded image and not an externally 
		 *  loaded image.</p>
		 *
		 *  @default null
		 * 
		 *  @langversion 3.0
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get iconPlaceholder():Object
		{
			return _iconPlaceholder;
		}
		
		/**
		 *  @private
		 */ 
		public function set iconPlaceholder(value:Object):void
		{
			if (value == _iconPlaceholder)
				return;
			
			_iconPlaceholder = value;
			
			iconChanged = true;
			invalidateProperties();
			
			// clear clearOnLoad if necessary
			if (iconDisplay)
				iconDisplay.clearOnLoad = (iconPlaceholder == null);
		}
		
		//----------------------------------
		//  iconScaleMode
		//----------------------------------
		
		/**
		 *  @private 
		 */ 
		private var _iconScaleMode:String = BitmapScaleMode.STRETCH;
		
		[Inspectable(category="General", enumeration="stretch,letterbox", defaultValue="stretch")]
		
		/**
		 *  @copy spark.primitives.BitmapImage#scaleMode
		 *
		 *  @default <code>mx.graphics.BitmapScaleMode.STRETCH</code>
		 *
		 *  @see mx.graphics.BitmapScaleMode
		 * 
		 *  @langversion 3.0
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get iconScaleMode():String
		{
			return _iconScaleMode;
		}
		
		/**
		 *  @private
		 */ 
		public function set iconScaleMode(value:String):void
		{
			if (value == _iconScaleMode)
				return;
			
			_iconScaleMode = value;
			
			if (iconDisplay)
				iconDisplay.scaleMode = _iconScaleMode;
		}
		
		//----------------------------------
		//  iconWidth
		//----------------------------------
		
		/**
		 *  @private 
		 */ 
		private var _iconWidth:Number;
		
		/**
		 *  The width of the icon.  If unspecified, the 
		 *  intrinsic width of the image is used.
		 *
		 *  @default NaN
		 * 
		 *  @langversion 3.0
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get iconWidth():Number
		{
			return _iconWidth;
		}
		
		/**
		 *  @private
		 */ 
		public function set iconWidth(value:Number):void
		{
			value = Device.getScaledSize(value);
			if (value == _iconWidth)
				return;
			
			_iconWidth = value;
			
			if (iconDisplay)
				iconDisplay.explicitWidth = _iconWidth;
			
			invalidateSize();
			invalidateDisplayList();
		}
		
		//----------------------------------
		//  redrawRequested
		//----------------------------------
		
		/**
		 *  @private
		 */
		private var _redrawRequested:Boolean = false;
		
		/**
		 *  @inheritDoc
		 * 
		 *  <p>We implement this as part of ISharedDisplayObject so the iconDisplay 
		 *  can share our display object.</p>
		 *  
		 *  @langversion 3.0
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get redrawRequested():Boolean
		{
			return _redrawRequested;
		}
		
		/**
		 *  @private
		 */
		public function set redrawRequested(value:Boolean):void
		{
			_redrawRequested = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  IGraphicElementContainer
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Notify the host that an element layer has changed.
		 *
		 *  The <code>IGraphicElementHost</code> must re-evaluates the sequences of 
		 *  graphic elements with shared DisplayObjects and may need to re-assign the 
		 *  DisplayObjects and redraw the sequences as a result. 
		 * 
		 *  Typically the host will perform this in its 
		 *  <code>validateProperties()</code> method.
		 *
		 *  @param element The element that has changed size.
		 * 
		 *  @langversion 3.0
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function invalidateGraphicElementSharing(element:IGraphicElement):void
		{
			// since the only graphic elements are hooked up to drawing with the background,
			// just invalidate display list
			if (element == iconDisplay)
				iconNeedsDisplayObjectAssignment = true;
			invalidateProperties();
		}
		
		/**
		 *  Notify the host component that an element changed and needs to validate properties.
		 * 
		 *  The <code>IGraphicElementHost</code> must call the <code>validateProperties()</code>
		 *  method on the IGraphicElement to give it a chance to commit its properties.
		 * 
		 *  Typically the host will validate the elements' properties in its
		 *  <code>validateProperties()</code> method.
		 *
		 *  @param element The element that has changed.
		 * 
		 *  @langversion 3.0
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function invalidateGraphicElementProperties(element:IGraphicElement):void
		{
			if (element == iconDisplay)
				iconNeedsValidateProperties = true;
			invalidateProperties();
		}
		
		/**
		 *  Notify the host component that an element size has changed.
		 * 
		 *  The <code>IGraphicElementHost</code> must call the <code>validateSize()</code>
		 *  method on the IGraphicElement to give it a chance to validate its size.
		 * 
		 *  Typically the host will validate the elements' size in its
		 *  <code>validateSize()</code> method.
		 *
		 *  @param element The element that has changed size.
		 * 
		 *  @langversion 3.0
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function invalidateGraphicElementSize(element:IGraphicElement):void
		{
			if (element == iconDisplay)
				iconNeedsValidateSize = true;
			invalidateSize();
		}
		
		/**
		 *  Notify the host component that an element has changed and needs to be redrawn.
		 * 
		 *  The <code>IGraphicElementHost</code> must call the <code>validateDisplayList()</code>
		 *  method on the IGraphicElement to give it a chance to redraw.
		 * 
		 *  Typically the host will validate the elements' display lists in its
		 *  <code>validateDisplayList()</code> method.
		 *
		 *  @param element The element that has changed.
		 * 
		 *  @langversion 3.0
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function invalidateGraphicElementDisplayList(element:IGraphicElement):void
		{
			if (element.displayObject is ISharedDisplayObject)
				ISharedDisplayObject(element.displayObject).redrawRequested = true;
			
			invalidateDisplayList();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods: UIComponent
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			// create any children you need in here
			
			// iconDisplay and decoratorDisplay are created in 
			// commitProperties() since they are dependent on 
			// other properties and we don't always create them
			// labelText just uses labelElement to display its data
		}
		
		/**
		 *  @private
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (iconFieldOrFunctionChanged)
			{
				iconFieldOrFunctionChanged = false;
				
				// let's see if we need to create or remove it
				if ((iconField || (iconFunction != null)) && !iconDisplay)
				{
					createIconDisplay();
					
					if (iconDisplay)
						attachLoadingListenersToIconDisplay();
				}
				else if (!(iconField || (iconFunction != null)) && iconDisplay)
				{
					destroyIconDisplay();
				}
				
				invalidateSize();
				invalidateDisplayList();
			}
			
			// label is created in super.createChildren()
			
			if (iconChanged)
			{
				iconChanged = false;
				
				// we set the icon after a delay for performance benefits and 
				// so we can cancel the load if we're scrolling fast
				// we still grab the source here so we can make sure we don't
				// cancel a load when the data is reset (if the source is the same)
				// if icon, try setting that
				
				if (iconFunction != null)
				{
					setIconDisplaySource(iconFunction(data));
				}
				else if (iconField)
				{
					try
					{
						if (iconField in data && data[iconField] != null)
							setIconDisplaySource(data[iconField]);
						else
							setIconDisplaySource(null);
					}
					catch(e:Error)
					{
						setIconDisplaySource(null);
					}
				}
			}
			
			if (labelChanged)
			{
				labelChanged = false;
				
				// if label, try setting that
				if (labelFunction != null)
				{
					labelText = labelFunction(data);
					if (!labelDisplay)
						createLabelDisplay();
					labelDisplay.text = labelText;
				}
				else if (labelField) // if labelField is not null or "", then this is a user-set value
				{
					try
					{
						if (labelField in data && data[labelField] != null)
						{
							labelText = data[labelField];
							if (!labelDisplay)
								createLabelDisplay();
							labelDisplay.text = labelText;
						}
						else
						{
							labelText = "";
							if (!labelDisplay)
								createLabelDisplay();
							labelDisplay.text = labelText;
						}
					}
					catch(e:Error)
					{
						labelText = "";
						if (!labelDisplay)
							createLabelDisplay();
						labelDisplay.text = labelText;
					}
				}
				else if (label && labelField === null) // if there's a label and labelField === null, then show label
				{
					labelText = label;
					if (!labelDisplay)
						createLabelDisplay();
					labelDisplay.text = labelText;
				}
				else // if labelField === ""
				{
					// get rid of labelDisplay if present
					if (labelDisplay)
						destroyLabelDisplay();
				}
				
				invalidateSize();
				invalidateDisplayList();
			}
			
			if (iconNeedsDisplayObjectAssignment)
			{
				iconNeedsDisplayObjectAssignment = false;
				assignDisplayObject(iconDisplay);
			}
		}
		
		/**
		 *  @private
		 */
		override public function validateProperties():void
		{
			super.validateProperties();
			
			// Since IGraphicElement is not ILayoutManagerClient, we need to make sure we
			// validate properties of the elements
			if (iconNeedsValidateProperties)
			{
				iconNeedsValidateProperties = false;
				if (iconDisplay)
					iconDisplay.validateProperties();
			}
			
		}
		
		/**
		 *  @private
		 */
		private function assignDisplayObject(bitmapImage:BitmapImage):void
		{
			if (bitmapImage)
			{
				// try using this display object first
				if (bitmapImage.setSharedDisplayObject(this))
				{
					bitmapImage.displayObjectSharingMode = DisplayObjectSharingMode.USES_SHARED_OBJECT;
				}
				else
				{
					// if we can't use this as the display object, then let's see if 
					// the icon already has and owns a display object
					var ownsDisplayObject:Boolean = (bitmapImage.displayObjectSharingMode != DisplayObjectSharingMode.USES_SHARED_OBJECT);
					
					// If the element doesn't have a DisplayObject or it doesn't own
					// the DisplayObject it currently has, then create a new one
					var displayObject:DisplayObject = bitmapImage.displayObject;
					if (!ownsDisplayObject || !displayObject)
						displayObject = bitmapImage.createDisplayObject();
					
					// Add the display object as a child
					// Check displayObject for null, some graphic elements
					// may choose not to create a DisplayObject during this pass.
					if (displayObject)
						addChild(displayObject);
					
					bitmapImage.displayObjectSharingMode = DisplayObjectSharingMode.OWNS_UNSHARED_OBJECT;
				}
			}        
		}
		
		/**
		 *  @private
		 *  Creates the iconDisplay component.
		 * 
		 *  @langversion 3.0
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */ 
		protected function createIconDisplay():void
		{
			iconDisplay = new iconDisplayClass();
			
			iconDisplay.contentLoader = iconContentLoader;
			iconDisplay.fillMode = iconFillMode;
			iconDisplay.scaleMode = iconScaleMode;

			if(iconDisplay.contentLoader == null) {
				iconWidth = NaN;
				iconHeight = NaN;
			}
			
			
			if (!isNaN(iconWidth)) {
				iconDisplay.explicitWidth = iconWidth;
			}
			if (!isNaN(iconHeight) && iconContentLoader != null)
				iconDisplay.explicitHeight = iconHeight;
			
			iconDisplay.parentChanged(this);
			
			iconNeedsDisplayObjectAssignment = true;
		}
		
		/**
		 *  @private
		 *  Destroys the iconDisplay component.
		 * 
		 *  @langversion 3.0
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */ 
		protected function destroyIconDisplay():void
		{
			// need to remove the display object
			var oldDisplayObject:DisplayObject = iconDisplay.displayObject;
			if (oldDisplayObject)
			{ 
				// If the element created the display object
				if (iconDisplay.displayObjectSharingMode != DisplayObjectSharingMode.USES_SHARED_OBJECT &&
					oldDisplayObject.parent == this)
				{
					removeChild(oldDisplayObject);
				}
			}
			
			iconDisplay.parentChanged(null);
			iconDisplay = null;
		}
		
		/**
		 *  @private
		 */
		private function attachLoadingListenersToIconDisplay():void
		{
			if (iconDisplay)
			{
				iconDisplay.addEventListener(IOErrorEvent.IO_ERROR, iconDisplay_loadErrorHandler, false, 0, true);
				iconDisplay.addEventListener(SecurityErrorEvent.SECURITY_ERROR, iconDisplay_loadErrorHandler, false, 0, true);
			}
		}
		
		/**
		 *  @private
		 *  Method is called when an IOError or SecurityError is dispatched
		 *  while trying to load the icon display.  The default implementation
		 *  sets the iconDisplay's source to the iconPlaceholder.
		 */ 
		mx_internal function iconDisplay_loadErrorHandler(event:Event):void
		{
			iconDisplay.source = iconPlaceholder;
		}
		
		/**
		 *  @private
		 */
		private function loadExternalImage(source:Object, iconDelay:Number):void
		{
			// set iconDisplay's source now to either iconPlaceholder 
			// or null (if no iconPlaceholder).  this is so we don't display the old 
			// data while we're loading.
			iconDisplay.source = iconPlaceholder;
			
			// while we're loading,if iconPlaceholder is set, 
			// we'll keep that image up while we're loading
			// the external content
			iconDisplay.clearOnLoad = (iconPlaceholder == null);
			
			if (iconDelay > 0)
			{
				// set what we're gonna load and start the timer
				iconSourceToLoad = source;
				
				if (!iconSetterDelayTimer)
				{
					iconSetterDelayTimer = new Timer(iconDelay, 1);
					iconSetterDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, iconSetterDelayTimer_timerCompleteHandler);
				}
				
				iconSetterDelayTimer.start();
			}
			else // iconDelay == 0
			{
				// load up the image immediately
				
				// need to call validateProperties because we need this iconPlaceholder
				// to actually get loaded up since we set iconDisplay.source to a remote 
				// image on the next line.  BitmapImage doesn't actually attempt to load 
				// up the image (even if it's a locally embedded asset) until commitProperties()
				iconDisplay.validateProperties();
				
				iconDisplay.source = source;
			}
		}
		
		/**
		 *  @private
		 */
		private function stopLoadingExternalImage():void
		{
			// stop any asynch operation:
			if (iconSetterDelayTimer)
			{
				iconSourceToLoad = null
				iconSetterDelayTimer.stop();
				iconSetterDelayTimer.reset();
			}
		}
		
		/**
		 *  @private
		 */
		private function setIconDisplaySource(source:Object):void
		{
			var iconDelay:Number = getStyle("iconDelay");
			
			// if not a string or URL request (or null), load it up immediately
			var isExternalSource:Boolean = (source is String || source is URLRequest);
			if (!isExternalSource)
			{
				// get the icon source to find out if it is external or not
				if (source is MultiDPIBitmapSource)
				{
					var app:Object = FlexGlobals.topLevelApplication;
					var dpi:Number;
					if ("runtimeDPI" in app)
						dpi = app["runtimeDPI"];
					else
						dpi = DensityUtil.getRuntimeDPI();
					
					var multiSource:Object = MultiDPIBitmapSource(source).getSource(dpi);  
					isExternalSource = (multiSource is String || multiSource is URLRequest);
				}
			}        
			
			// if null or embedded asset do it synchronously
			if (!isExternalSource)
			{
				stopLoadingExternalImage();
				
				// load it up
				iconDisplay.source = source;
				
				return;
			}
			
			// if it's the same source, don't cancel this load--let it continue 
			if (iconSourceToLoad == source)
				return;
			
			// At this point, we know we can cancel the old asynch operation 
			// since we're not going to use it anymore
			stopLoadingExternalImage();
			
			// we know we're loading external content, check the cache first:
			var contentCache:ContentCache = iconContentLoader as ContentCache;
			if (contentCache)
			{
				if (contentCache.getCacheEntry(source))
				{
					// We know we have this item cached (or atleast have attempted 
					// to load this item and cache it).  Because we're not sure whether 
					// this item has finished loading or not, let's set the icon's 
					// source to the placeholder (or null) first so that we can make sure
					// we don't leave in a stale image while the load is still happening.
					iconDisplay.source = iconPlaceholder;
					
					// while we're loading,if iconPlaceholder is set, 
					// we'll keep that image up while we're loading
					// the external content
					iconDisplay.clearOnLoad = (iconPlaceholder == null);
					
					// need to call validateProperties because we need this iconPlaceholder
					// to actually get loaded up since we set iconDisplay.source to a remote 
					// image on the next line.  BitmapImage doesn't actually attempt to load 
					// up the image (even if it's a locally embedded asset) until commitProperties()
					iconDisplay.validateProperties();
					
					// now attempt to load up our other image (or grab it from the cache
					// if the load had finished already)
					iconDisplay.source = source;
					
					return;
				}
			}
			
			// otherwise, we need to load an external asset and use a Timer
			loadExternalImage(source, iconDelay);
		}
		
		/**
		 *  @private
		 */
		private function iconSetterDelayTimer_timerCompleteHandler(event:TimerEvent):void
		{
			// if we're off-screen, don't do anything
			// when we get re-included, our data will be reset as well
			if (!includeInLayout)
			{
				iconSourceToLoad = null;
				return;
			}
			
			if (iconDisplay)
				iconDisplay.source = iconSourceToLoad;
			
			iconSourceToLoad = null;
		}
		
		/**
		 *  @private
		 */
		override public function validateSize(recursive:Boolean = false):void
		{
			// Since IGraphicElement is not ILayoutManagerClient, we need to make sure we
			// validate sizes of the elements, even in cases where recursive==false.
			
			// Validate element size
			if (iconNeedsValidateSize)
			{
				iconNeedsValidateSize = false;
				if (iconDisplay)
					iconDisplay.validateSize();
			}
			
			super.validateSize(recursive);
		}
		
		/**
		 *  @private
		 */
		override protected function measure():void
		{
			// don't call super.measure() because there's no need to do the work that's
			// in there--we do it all in here.
			//super.measure();
			
			// start them at 0, then go through icon, label, and decorator
			// and add to these
			var myMeasuredWidth:Number = 0;
			var myMeasuredHeight:Number = 0;
			var myMeasuredMinWidth:Number = 0;
			var myMeasuredMinHeight:Number = 0;
			
			// calculate padding and horizontal gap
			// verticalGap is already handled above when there's a label
			// since that's the only place verticalGap matters.
			// if we handled verticalGap here, it might add it to the icon if 
			// the icon was the tallest item.
			var numHorizontalSections:int = 0;
			if (iconDisplay)
				numHorizontalSections++;
			
			if (labelDisplay)
				numHorizontalSections++;
			
			var paddingAndGapWidth:Number = getStyle("paddingLeft") + getStyle("paddingRight");
			if (numHorizontalSections > 0)
				paddingAndGapWidth += (getStyle("horizontalGap") * (numHorizontalSections - 1));
			
			var hasLabel:Boolean = labelDisplay && labelDisplay.text != "";
			
			var paddingHeight:Number = getStyle("paddingTop") + getStyle("paddingBottom");
			
			// Icon is on left
			var myIconWidth:Number = 0;
			var myIconHeight:Number = 0;
			if (iconDisplay && iconDisplay.contentLoader)
			{
				myIconWidth = (isNaN(iconWidth) ? getElementPreferredWidth(iconDisplay) : iconWidth);
				myIconHeight = (isNaN(iconHeight) ? getElementPreferredHeight(iconDisplay) : iconHeight);
				
				myMeasuredWidth += myIconWidth;
				myMeasuredMinWidth += myIconWidth;
				myMeasuredHeight = Math.max(myMeasuredHeight, myIconHeight);
				myMeasuredMinHeight = Math.max(myMeasuredMinHeight, myIconHeight);
			}
			
			// Decorator is up next
			var decoratorWidth:Number = 0;
			var decoratorHeight:Number = 0;
			
			// Text is aligned next to icon
			var labelWidth:Number = 0;
			var labelHeight:Number = 0;
			var messageWidth:Number = 0;
			var messageHeight:Number = 0;
			
			if (hasLabel)
			{
				// reset text if it was truncated before.
				if (labelDisplay.isTruncated)
					labelDisplay.text = labelText;
				
				labelWidth = getElementPreferredWidth(labelDisplay);
				labelHeight = getElementPreferredHeight(labelDisplay);
			}
			
			myMeasuredWidth += labelWidth;
			myMeasuredHeight = Math.max(myMeasuredHeight, labelHeight);
			
			myMeasuredWidth += paddingAndGapWidth;
			myMeasuredMinWidth += paddingAndGapWidth;
			
			// verticalGap handled in label and message
			myMeasuredHeight += paddingHeight;
			myMeasuredMinHeight += paddingHeight;
			
			// now set the local variables to the member variables.
			measuredWidth = myMeasuredWidth;
			measuredHeight = myMeasuredHeight;
			
			measuredMinWidth = myMeasuredMinWidth;
			measuredMinHeight = myMeasuredMinHeight;
		}
		
		/**
		 *  @private
		 *  If we invalidate display list, we need to redraw any graphic elements sharing 
		 *  our display object since we call graphics.clear() in super.updateDisplayList()
		 */
		override public function invalidateDisplayList():void
		{
			redrawRequested = true;
			super.invalidateDisplayList();
		}
		
		/**
		 *  @private
		 */
		override public function validateDisplayList():void
		{
			super.validateDisplayList();
			
			// Since IGraphicElement is not ILayoutManagerClient, we need to make sure we
			// validate properties of the elements
			
			// see if we have an icon that needs to be validated
			if (iconDisplay && 
				iconDisplay.displayObject is ISharedDisplayObject && 
				ISharedDisplayObject(iconDisplay.displayObject).redrawRequested)
			{
				ISharedDisplayObject(iconDisplay.displayObject).redrawRequested = false;
				iconDisplay.validateDisplayList();
			}
		}
		
		/**
		 *  @private
		 */
		override protected function layoutContents(unscaledWidth:Number,
												   unscaledHeight:Number):void
		{
			// no need to call super.layoutContents() since we're changing how it happens here
			
			// start laying out our children now
			var iconWidth:Number = 0;
			var iconHeight:Number = 0;

			var hasLabel:Boolean = labelDisplay && labelDisplay.text != "";
			
			var paddingLeft:Number   = getStyle("paddingLeft");
			var paddingRight:Number  = getStyle("paddingRight");
			var paddingTop:Number    = getStyle("paddingTop");
			if(isGroup) {
				paddingTop += 15;
			}
			
			var paddingBottom:Number = getStyle("paddingBottom");
			var horizontalGap:Number = getStyle("horizontalGap");
			var verticalAlign:String = getStyle("verticalAlign");
			
			var vAlign:Number;
			if (verticalAlign == "top")
				vAlign = 0;
			else if (verticalAlign == "bottom")
				vAlign = 1;
			else // if (verticalAlign == "middle")
				vAlign = 0.5;
			// made "middle" last even though it's most likely so it is the default and if someone 
			// types "center", then it will still vertically center itself.
			
			var viewWidth:Number  = unscaledWidth  - paddingLeft - paddingRight;
			var viewHeight:Number = unscaledHeight - paddingTop  - paddingBottom;
			
			// icon is on the left
			if (iconDisplay && iconDisplay.source)
			{
				// set the icon's position and size
				setElementSize(iconDisplay, this.iconWidth, this.iconHeight);
				
				iconWidth = iconDisplay.getLayoutBoundsWidth();
				iconHeight = iconDisplay.getLayoutBoundsHeight();
				
				// use vAlign to position the icon.
				var iconDisplayY:Number = Math.round(vAlign * (viewHeight - iconHeight)) + paddingTop;
				setElementPosition(iconDisplay, paddingLeft, iconDisplayY);
			}
			
			// Figure out how much space we have for label and message as well as the 
			// starting left position
			var labelComponentsViewWidth:Number = viewWidth - iconWidth;
			
			// don't forget the extra gap padding if these elements exist
			if (iconDisplay && iconDisplay.source)
				labelComponentsViewWidth -= horizontalGap;
			
			var labelComponentsX:Number = paddingLeft;
			
			if (iconDisplay && iconDisplay.source)
				labelComponentsX += iconWidth + horizontalGap;
			
			// calculte the natural height for the label
			var labelTextHeight:Number = 0;
			
			if (hasLabel)
			{
				// reset text if it was truncated before.
				if (labelDisplay.isTruncated)
					labelDisplay.text = labelText;
				
				// commit styles to make sure it uses updated look
				labelDisplay.commitStyles();
				
				labelTextHeight = getElementPreferredHeight(labelDisplay);
			}
			
			// now size and position the elements, 3 different configurations we care about:
			// 1) label and message
			// 2) label only
			// 3) message only
			
			// label display goes on top
			// message display goes below
			
			var labelWidth:Number = 0;
			var labelHeight:Number = 0;
			var messageWidth:Number = 0;
			var messageHeight:Number = 0;
			
			if (hasLabel)
			{
				// handle labelDisplay.  it can only be 1 line
				
				// width of label takes up rest of space
				// height only takes up what it needs so we can properly place the message
				// and make sure verticalAlign is operating on a correct value.
				labelWidth = Math.max(labelComponentsViewWidth, 0);
				labelHeight = labelTextHeight;
				
				if(isGroup) {
					labelHeight += 15;
				}
				if (labelWidth == 0)
					setElementSize(labelDisplay, NaN, 0);
				else
					setElementSize(labelDisplay, labelWidth, labelHeight);
				
				// attempt to truncate text
				labelDisplay.truncateToFit();
			}
			
			// Position the text components now that we know all heights so we can respect verticalAlign style
			var totalHeight:Number = 0;
			var labelComponentsY:Number = 0; 
			
			// Heights used in our alignment calculations.  We only care about the "real" ascent 
			var labelAlignmentHeight:Number = 0; 
			if (hasLabel)
				labelAlignmentHeight = getElementPreferredHeight(labelDisplay);
			
			totalHeight = labelAlignmentHeight;          
			labelComponentsY = Math.round(vAlign * (viewHeight - totalHeight)) + paddingTop ;
			
			if (labelDisplay)
				setElementPosition(labelDisplay, labelComponentsX, labelComponentsY);
			
		}
		
		
		override protected function drawBorder(unscaledWidth:Number, unscaledHeight:Number):void
		{
			// draw separators
			// don't draw top separator for down and selected states
			if (!(selected || down))
			{
				graphics.beginFill(topSeparatorColor, topSeparatorAlpha);
				graphics.drawRect(0, 0, unscaledWidth, 1);
				graphics.endFill();
				labelDisplay.setStyle("color", (selected || down)?"0xffffff":IntoToHexString.convertToHex(Device.getDefaultColor()));
			} else {
				labelDisplay.setStyle("color", (selected || down)?"0xffffff":IntoToHexString.convertToHex(Device.getDefaultColor()));
			}
			
			
			graphics.beginFill(bottomSeparatorColor, bottomSeparatorAlpha);
			graphics.drawRect(0, unscaledHeight - (isLastItem ? 0 : 1), unscaledWidth, 1);
			graphics.endFill();
			
			
			// add extra separators to the first and last items so that 
			// the list looks correct during the scrolling bounce/pull effect
			// top
			if (itemIndex == 0)
			{
				graphics.beginFill(bottomSeparatorColor, bottomSeparatorAlpha);
				graphics.drawRect(0, -1, unscaledWidth, 1);
				graphics.endFill(); 
			}
			
			// bottom
			if (isLastItem)
			{
				// we want to offset the bottom by 1 so that we don't get
				// a double line at the bottom of the list if there's a 
				// border
				graphics.beginFill(topSeparatorColor, topSeparatorAlpha);
				graphics.drawRect(0, unscaledHeight + 1, unscaledWidth, 1);
				graphics.endFill(); 
			}
		}
		
		override protected function drawBackground(unscaledWidth:Number, 
										  unscaledHeight:Number):void
		{
			if(!data.isGroup)  {
				super.drawBackground(unscaledWidth, unscaledHeight);
			}
		}
		
		public function get topSeparatorColor():uint
		{
			return this._topSeparatorColor;	
		}
		
		public function set topSeparatorColor(topSeparatorColor:uint): void
		{
			this._topSeparatorColor = topSeparatorColor;	
		}
		
		public function get topSeparatorAlpha():Number
		{
			return this._topSeparatorAlpha;
		}
		
		public function set topSeparatorAlpha(topSeparatorAlpha:Number):void
		{
			this._topSeparatorAlpha = topSeparatorAlpha;
		}
		
		public function get bottomSeparatorColor():uint
		{
			return this._bottomSeparatorColor;	
		}
		
		public function set bottomSeparatorColor(bottomSeparatorColor:uint): void
		{
			this._bottomSeparatorColor = bottomSeparatorColor;	
		}
		
		public function get bottomSeparatorAlpha():Number
		{
			return this._bottomSeparatorAlpha;
		}
		
		public function set bottomSeparatorAlpha(bottomSeparatorAlpha:Number):void
		{
			this._bottomSeparatorAlpha = bottomSeparatorAlpha;
		}
		
		public function set styles(obj:Object):void
		{
			for (var styleProp:String in obj) 
			{
				setStyle(styleProp,obj[styleProp]);
			}
		}
		
	}
}