/*

The MIT License

Copyright (c) 2008 Paul Whitelock

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.



Adapted by John Salatas

*/

package gr.ictpro.mall.client.components {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	import mx.core.UIComponent;
	

	// Events
	/**
	 * This event is dispatched when the component has completed loading an image from a URL or when a <code>BitmapData</code> 
	 * object is specified for the <code>sourceImage</code> parameter.
	 */ 
	
	[Event(name="sourceImageReady")]
	
	/**
	 * This event is dispatched whenever the cropping rectangle is resized or repositioned using the mouse.
	 */
	 
	[Event(name="cropRectChanged")]
	
	/**
	 * This event is dispatched whenever <code>constrainToAspectRatio</code> is set to <code>true</code> and the component 
	 * alters the aspect ratio of the cropping rectangle.
	 * 
	 * <p>One situation where the component will alter the aspect ratio of the cropping rectangle is if the cropping 
	 * rectangle handle size is increased and the cropping rectangle is not large enough to contain the increased size 
	 * of the handles. The other situation where the component will alter the aspect ratio of the cropping rectangle is 
	 * when the cropping rectangle is initialized following a call to <code>setCropRect</code> and the parameters passed 
	 * to <code>setCropRect</code> necessitate that the component change the cropping rectangle in order for it to be 
	 * properly displayed within the component (e.g., the coordinates passed for the cropping rectangle place part of the 
	 * cropping rectangle outside of the component's display area).</p>
	 */
	 
	[Event(name="cropConstraintChanged")]
	
	/**
	 * If <code>constrainToAspectRatio</code> is set to <code>true</code> and a call to <code>setCropRect</code> is executed 
	 * with a <code>width</code> or <code>height</code> value less than or equal to zero, then <code>constrainToAspectRatio</code> 
	 * will be disabled and this event will be dispatched.
	 */	
	
	[Event(name="cropConstraintDisabled")]
	
	/**
	 * This event is dispatched whenever the component alters the position of the cropping rectangle.
	 * 
	 * <p>If the cropping rectangle handle size is increased by setting the <code>handleSize</code> property and there is not 
	 * enough room within the cropping rectangle to contain the larger handles, then the component will increase the size of 
	 * the cropping rectangle. If the position of the cropping rectangle changes when its size is increased, then this event
	 * will be dispatched.</p>
	 * 
	 * <p>This event is also dispatched if the position of the cropping rectangle is specified in a call to <code>setCropRect</code>
	 * but the cropping rectangle cannot be properly displayed in the component at the specified position. In this case the 
	 * component will adjust the position of the cropping rectangle and dispatch the <code>cropPositionChanged</code> event.
	 */	
	
	[Event(name="cropPositionChanged")]

	/**
	 * This event is dispatched whenever the component alters the dimensions of the cropping rectangle.
	 * 
	 * <p>If the cropping rectangle handle size is increased by setting the <code>handleSize</code> property and there is not 
	 * enough room within the cropping rectangle to contain the larger handles, then the component will increase the size of 
	 * the cropping rectangle and dispatch this event.</p>
	 * 
	 * <p>This event is also dispatched if the width and height of the cropping rectangle are specified in a call to 
	 * <code>setCropRect</code> but the cropping rectangle cannot be properly displayed in the component using the specified 
	 * dimensions. In this case the component will adjust the dimensions of the cropping rectangle and dispatch the 
	 * <code>cropDimensionsChanged</code> event.
	 */	
	
	[Event(name="cropDimensionsChanged")]
	
	/**
	 * The ImageCropper component accepts a <code>String</code> (URL) pointing to an image file, or a <code>BitmapData</code> 
	 * object that contains an image, and displays the image within the component. If the size of the image exceeds the 
	 * component's dimensions then the image is scaled so that it will entirely fit within the component.
	 *  
	 * <p>The image may be visually cropped by adjusting the boundries of a cropping rectangle using any of the four handles 
	 * on the corners of the rectangle. At any time a <code>BitmapData</code> object containing the cropped portion of the 
	 * image may be retrieved, or a <code>Rectangle</code> may be retrieved that defines the cropped portion of the image.</p>
	 * 
	 * <p>The cropping rectangle may be initialized using coordinates and dimensions relative to the component's display or 
	 * relative to the source image.</p>
	 */
	
	public class ImageCropper extends UIComponent {
		
		// Track the enabled state of the component
		private var componentEnabled:Boolean = true;
		
		// Source image object (can be a String object or a BitmapData object)
		private var imageSource:BitmapData = null;
				
		// Component dimensions
		private var componentWidth:Number;
		private var componentHeight:Number;

		// Component bitmap variables
		private var componentBitmap:Bitmap;
		private var componentBitmapData:BitmapData;

		private var mouseButtonDown:Boolean = false;

		// Variables for loading an image
		private var newImageLoaded:Boolean = false;
		
		// Component colors and alpha values
		private var bkgndColor:uint = 0xFF000000;
		private var bkgndAlpha:uint = 0xFF000000;
		private var cropMaskColor:uint = 0x4CFF0000;
		private var cropMaskAlpha:uint = 0x4C000000;
		private var cropHandleColor:uint = 0xFFFF0000;
		private var cropHandleAlpha:Number = .5;
		private var cropSelectionOutlineColor:uint = 0xFFFFFFFF;
		private var cropSelectionOutlineAlpha:Number = 1.; 
		
		// Image scaling variables		
		private var imageLocation:Point;
		private var imageScaleFactor:Number;
		private var imageScaledWidth:Number;
		private var imageScaledHeight:Number;
		private var imageBitmapData:BitmapData;
		private var scaledImageBitmapData:BitmapData;
		
		// Image cropping variables
		private var cropX:Number;
		private var cropY:Number;
		private var cropWidth:Number;
		private var cropHeight:Number;		
		private var newCroppingRect:Boolean = false;
		private var cropRatioActive:Boolean = false;
		private var cropRatio:Number = 0;
		private var cropRect:Rectangle;	
		private var croppingRectBitmapData:BitmapData;
		private var anchorX:Number;
		private var anchorY:Number;
		private var activeHandle:int;
		private var croppingRectIsImageScale:Boolean;
		private var cropMaskChanged:Boolean = false;
		
		// Crop sizing variables
		private var cropHandleSize:Number = 10;
		private var cropRectMinimumWidth:Number;
		private var cropRectMinimumHeigth:Number;
		
		// Flag used to prevent a null object reference if updateDisplayList() is called by the 
		// Flex callLaterDispatcher() after destroy() is executed
		private var destroyed:Boolean = false;
		
		// Flag to indicate whether mouse listeners are active
		private var mouseListenersActive:Boolean = false;
		
		// Event constants
		/**
		 * Constant value for the <code>sourceImageReady</code> event.
		 */

		public const SOURCE_IMAGE_READY:String = "sourceImageReady";

		/**
		 * Constant value for the <code>cropRectChanged</code> event.
		 */

		public const CROP_RECT_CHANGED:String = "cropRectChanged";

		/**
		 * Constant value for the <code>cropConstraintChanged</code> event.
		 */

		public const CROP_CONSTRAINT_CHANGED:String = "cropConstraintChanged";

		/**
		 * Constant value for the <code>cropConstraintDisabled</code> event.
		 */

		public const CROP_CONSTRAINT_DISABLED:String = "cropConstraintDisabled";
		
		/**
		 * Constant value for the <code>cropPositionChanged</code> event.
		 */

		public const CROP_POSITION_CHANGED:String = "cropPositionChanged";
				
		/**
		 * Constant value for the <code>cropDimensionsChanged</code> event.
		 */

		public const CROP_DIMENSIONS_CHANGED:String = "cropDimensionsChanged";		

		/**
		 * The version number of the ImageCropper component.
		 */

		public const VERSION:Number = 1.0;		
		
		// --------------------------------------------------------------------------------------------------
		// ImageCropper - Constructor
		// --------------------------------------------------------------------------------------------------

		/**
		 * Class constructor.
		 */
		
		public function ImageCropper() {
			super();
		}
		
		// --------------------------------------------------------------------------------------------------
		// destroy - Call this function when finished using the component to release resources for garbage collection
		// --------------------------------------------------------------------------------------------------

		/**
		 * Call this method to dereference resources when the <code>ImageCropper</code> component is no longer needed. 
		 * For example, if the <code>ImageCropper</code> component is used in a pop-up window and the window is closed, 
		 * call <code>destroy</code> when removing the window. 
		 */
		
		public function destroy():void {
			// Set to prevent a null object reference if updateDisplayList() is called by the Flex 
			// callLaterDispatcher() after destroy() is executed
			destroyed = true;

			if (componentBitmapData != null) {
				componentBitmapData.dispose();
				componentBitmapData = null;
				componentBitmap = null;
			}
			
			if (imageBitmapData != null) {
				imageBitmapData.dispose();
				imageBitmapData = null;
			}			
			
			if (scaledImageBitmapData != null) {
				scaledImageBitmapData.dispose();
				scaledImageBitmapData = null;
			}

			activateListeners(false); 
		}
		
		// --------------------------------------------------------------------------------------------------
		// GET enabled - Returns whether or not the component is enabled
		// --------------------------------------------------------------------------------------------------

		/**
		 * Whether the component can accept user interaction or changes to properties. If the <code>enabled</code> 
		 * property is set to <code>false</code> then the cropping rectangle is removed and all component properties 
		 * become read-only (except for the <code>enabled</code> property). In addition, calls to the 
		 * <code>setCropRect</code> method are ignored. 
		 * 
		 * <p>The component may be re-enabled by setting the <code>enabled</code> property to <code>true</code>. 
		 * 
		 * @default true
		 */
				
		public override function get enabled():Boolean {
			
			return componentEnabled;
		}	

		// --------------------------------------------------------------------------------------------------
		// SET enabled - Sets whether or not the component is enabled
		// --------------------------------------------------------------------------------------------------

		/**
		 * @private
		 */
		
		public override function set enabled(value:Boolean):void {
			if (componentEnabled != value) {
				super.enabled = value;
					
				componentEnabled = value;
				
				if (imageBitmapData != null) 
					activateListeners(componentEnabled);
				
				invalidateDisplayList();
			}
		}

		// --------------------------------------------------------------------------------------------------
		// GET backgroundColor - Returns the component's background color (behind the image)
		// --------------------------------------------------------------------------------------------------

		/**
		 * The background color for the component. The component background will be visible only when an image does 
		 * not entirely fill the component area.
		 * 
		 * @default 0x00000000
		 */
				
		public function get backgroundColor():uint {
			return (bkgndColor & 0x00FFFFFF);
		}	

		// --------------------------------------------------------------------------------------------------
		// SET backgroundColor - Sets the component's background color (behind the image)
		// --------------------------------------------------------------------------------------------------

		/**
		 * @private
		 */
		
		public function set backgroundColor(value:uint):void {
			if (componentEnabled) {
				bkgndColor = value;
				
				bkgndColor &= 0x00FFFFFF;
				bkgndColor |= bkgndAlpha;
				
				invalidateDisplayList();
			}
		}
						
		// --------------------------------------------------------------------------------------------------
		// GET backgroundAlpha - Returns the alpha level for the component's background color
		// --------------------------------------------------------------------------------------------------

		/**
		 * The level of transparency (0 to 1) for the component's background. The component background will be 
		 * visible only when an image does not entirely fill the component area.
		 * 
		 * @default 0
		 */
		
		public function get backgroundAlpha():Number {
			if (bkgndAlpha > 0) return (bkgndAlpha >> 48) / 100;
			else return 0;
		}

		// --------------------------------------------------------------------------------------------------
		// SET backgroundAlpha - Sets the alpha level for the component's background color
		// --------------------------------------------------------------------------------------------------

		/**
		 * @private
		 */

		public function set backgroundAlpha(value:Number):void {
			if (componentEnabled) {
				if (value > 1) 
					value = 1;
				else if (value < 0) 
					value = 0;
				
				var a:uint = Math.round(value * 255);
				bkgndAlpha = (Math.round(value * 255)) << 24;
				
				bkgndColor &= 0x00FFFFFF;
				bkgndColor |= bkgndAlpha;
				
				invalidateDisplayList();
			}
		}
				
		// --------------------------------------------------------------------------------------------------
		// GET maskColor - Returns the color used to mask unselected crop area
		// --------------------------------------------------------------------------------------------------

		/**
		 * The color of the mask used to indicate the non-selected portion of the cropped image. The mask will be 
		 * visible only when the dimensions of the cropping rectangle are smaller than the dimensions of the image.
		 * 
		 * @default 0x00FF0000
		 */

		public function get maskColor():uint {
			return (cropMaskColor & 0x00FFFFFF);
		}	

		// --------------------------------------------------------------------------------------------------
		// SET maskColor - Sets the color used to mask unselected crop area
		// --------------------------------------------------------------------------------------------------

		/**
		 * @private
		 */

		public function set maskColor(value:uint):void {
			if (componentEnabled) {
				cropMaskColor = value;
				
				cropMaskColor &= 0x00FFFFFF;
				cropMaskColor |= cropMaskAlpha;
				
				cropMaskChanged = true;
				invalidateProperties();
			}
		}
								
		// --------------------------------------------------------------------------------------------------
		// GET maskAlpha - Returns the alpha level for the unselected crop area
		// --------------------------------------------------------------------------------------------------

		/**
		 * The level of transparency (0 to 1) for the mask that is used to indicate the non-selected portion of 
		 * the cropped image. The mask will only be visible when the dimensions of the cropping rectangle are smaller 
		 * than the dimensions of the image.
		 * 
		 * @default 0.3
		 */
		
		public function get maskAlpha():Number {
			if (cropMaskAlpha > 0)
				return (cropMaskAlpha >> 48) / 100;
			else 
				return 0;
		}				

		// --------------------------------------------------------------------------------------------------
		// SET maskAlpha - Sets the alpha level for the unselected crop area
		// --------------------------------------------------------------------------------------------------

		/**
		 * @private
		 */

		public function set maskAlpha(value:Number):void {
			if (componentEnabled) {
				if (value > 1) 
					value = 1;
				else if (value < 0) 
					value = 0;
				
				var a:uint = Math.round(value * 255);
				cropMaskAlpha = (Math.round(value * 255)) << 24;
				
				cropMaskColor &= 0x00FFFFFF;
				cropMaskColor |= cropMaskAlpha;
				
				cropMaskChanged = true;
				invalidateProperties();
			}
		}		

		// --------------------------------------------------------------------------------------------------
		// GET handleColor - Returns the color of the cropping handles
		// --------------------------------------------------------------------------------------------------

		/**
		 * The color used for the four corner handles of the cropping rectangle.
		 * 
		 * @default 0x00FF0000
		 */

		public function get handleColor():uint {
			return (cropHandleColor & 0x00FFFFFF);
		}	

		// --------------------------------------------------------------------------------------------------
		// SET handleColor - Sets the color of the cropping handles
		// --------------------------------------------------------------------------------------------------

		/**
		 * @private
		 */

		public function set handleColor(value:uint):void {
			if (componentEnabled) {
				cropHandleColor = value;
				
				cropHandleColor &= 0x00FFFFFF;
				cropHandleColor |= cropHandleAlpha;
				
				cropMaskChanged = true;
				invalidateProperties();
			}
		}		
								
		// --------------------------------------------------------------------------------------------------
		// GET handleAlpha - Returns the alpha level for the crop handles
		// --------------------------------------------------------------------------------------------------

		/**
		 * The level of transparency (0 to 1) for the four corner handles of the cropping rectangle.
		 * 
		 * @default 0.5
		 */

		public function get handleAlpha():Number {
			return cropHandleAlpha;
		}

		// --------------------------------------------------------------------------------------------------
		// SET handleAlpha - Sets the alpha level for the crop handles
		// --------------------------------------------------------------------------------------------------

		/**
		 * @private
		 */

		public function set handleAlpha(value:Number):void {
			if (componentEnabled) {
				if (value > 1) 
					value = 1;
				else if (value < 0) 
					value = 0;
				
				cropHandleAlpha = value;
				
				cropMaskChanged = true;
				invalidateProperties();
			}
		}
								
		// --------------------------------------------------------------------------------------------------
		// GET outlineColor - Returns the color of the crop area outline
		// --------------------------------------------------------------------------------------------------

		/**
		 * The color used for single pixel outline drawn around the cropping rectangle and around the four 
		 * corner handles of the cropping rectangle.
		 * 
		 * @default 0x00FFFFFF
		 */

		public function get outlineColor():uint {
			return cropSelectionOutlineColor;
		}
		
		// --------------------------------------------------------------------------------------------------
		// SET outlineColor - Sets the color of the crop area outline
		// --------------------------------------------------------------------------------------------------

		/**
		 * @private
		 */

		public function set outlineColor(value:uint):void {
			if (componentEnabled) {

				cropSelectionOutlineColor = value;
				
				cropMaskChanged = true;
				invalidateProperties();
			}
		}		
		
		// --------------------------------------------------------------------------------------------------
		// GET outlineAlpha - Returns the alpha level for the crop area outline
		// --------------------------------------------------------------------------------------------------

		/**
		 * The level of transparency (0 to 1) used for the single pixel outline drawn around the cropping rectangle 
		 * and around the four corner handles of the cropping rectangle.
		 * 
		 * @default 0
		 */

		public function get outlineAlpha():Number {
			return cropSelectionOutlineAlpha;
		}
				
		// --------------------------------------------------------------------------------------------------
		// SET outlineAlpha - Sets the alpha level for the crop area outline
		// --------------------------------------------------------------------------------------------------
		public function set outlineAlpha(value:Number):void {
			if (componentEnabled) {
				if (value > 1) 
					value = 1;
				else if (value < 0) 
					value = 0;
				
				cropSelectionOutlineAlpha = value;
				
				cropMaskChanged = true;
				invalidateProperties();
			}
		}
		
		// --------------------------------------------------------------------------------------------------
		// GET handleSize - Returns the size of the cropping handles
		// --------------------------------------------------------------------------------------------------

		/**
		 * The size of each of the four corner handles of the cropping rectangle. The minimum allowed handle size is 3. 
		 * 
		 * @default 10
		 */

		public function get handleSize():Number {
			return cropHandleSize;
		}
		
		// --------------------------------------------------------------------------------------------------
		// SET handleSize - Sets the size of the cropping handles (the minimum handle size is 3)
		// --------------------------------------------------------------------------------------------------

		/**
		 * @private
		 */

		public function set handleSize(value:Number):void {
			if (componentEnabled) {
				cropHandleSize = value<3?3:value;
				
				cropMaskChanged = true;
				invalidateProperties();
			}
		}
		
		// --------------------------------------------------------------------------------------------------
		// GET constrainToAspectRatio - Returns whether or not the dimensions of the cropping rectangle 
		// are constrained to the ratio of cropping rectangle's current width and height
		// --------------------------------------------------------------------------------------------------

		/**
		 * If set to <code>true</code> then the cropping rectangle will always maintain the aspect ratio that was 
		 * active when the <code>constrainToAspectRatio</code> property was set. For example, suppose the cropping 
		 * rectangle has dimensions of 200 x 100 (an aspect ratio of 2:1). If <code>constrainToAspectRatio</code> 
		 * is set to <code>true</code> then dragging any of the handles will cause the cropping rectangle to maintain 
		 * a 2:1 relationship between the width and the height. If dragging a handle causes the width to increase 
		 * to 400, then the height of the cropping rectangle will be adjusted to 200. If the height is changed to 50, 
		 * then the width will be adjusted to 100.
		 * 
		 * <p>Enabling <code>constrainToAspectRatio</code> can be useful if you wish to crop an image so that it can 
		 * be scaled to fixed dimensions without distortion. For example, suppose that you want to crop an image so that 
		 * it will exactly fit a target area that is 400 pixels wide and 600 pixels high. Since the target area has an 
		 * aspect ratio of 2:3 you'll want to call the <code>setCropRect</code> method to set an initial cropping 
		 * rectangle with dimensions that conform to the target aspect ratio. In this case, let's say that we set the 
		 * cropping rectangle to a width of 80 and to a height of 120 (a ratio of 2:3). Now when we set <code>constrainToAspectRatio</code>
		 * to <code>true</code> the cropping rectangle will always maintain a width to height ratio of 2:3. Once the 
		 * portion of the image to crop is selected, all that needs to be done is to retrieve the <code>BitmapData</code> 
		 * from the <code>croppedBitmapData</code> parameter and then scale the <code>BitmapData</code> to the final size (400 x 600).<p>
		 * 
		 * Setting <code>constrainToAspectRatio</code> to <code>false</code> allows the width and height of the cropping 
		 * rectangle to be adjusted independently. 
		 * 
		 * @default false
		 */

		public function get constrainToAspectRatio():Boolean {
			return cropRatioActive;
		}
		
		// --------------------------------------------------------------------------------------------------
		// SET constrainToAspectRatio - Sets whether or not to constrain the dimensions of the cropping rectangle to the ratio of cropping rectangle's current width and height
		// --------------------------------------------------------------------------------------------------
		public function set constrainToAspectRatio(constrain:Boolean):void {
			if (componentEnabled) {
				if (constrain) {				
					if (cropRect != null) 
						cropRatio = cropRect.width / cropRect.height;
					else 
						cropRatio = 0;
				} else { 
					cropRatio = 0;
				}
				
				cropRatioActive = constrain;
			}
		}		

		// --------------------------------------------------------------------------------------------------
		// GET sourceImage - Returns the source image as a BitmapData object
		// --------------------------------------------------------------------------------------------------

		/**
		 * Either a <code>String</code> that contains a URL pointing to an image or a <code>BitmapData</code>
		 * object that contains an image.
		 * 
		 * <p>If a URL <code>String</code> is assigned to this parameter, then a <code>sourceImageLoading</code> 
		 * event will be dispatched and the component will begin loading the referenced image. Once the image has 
		 * been loaded then a <code>sourceImageReady</code> event will be dispatched and the image will be displayed 
		 * in the component. If an error occurs while loading the image, then a <code>sourceImageLoadError</code> 
		 * event will be dispatched</p>
		 * 
		 * <p>If a <code>BitmapData</code> object is assigned to this parameter, then a <code>sourceImageReady</code> 
		 * event will immediately be dispatched and the image contained in the <code>BitmapData</code> object will be
		 * displayed in the component.</p>
		 * 
		 * <p>When reading this parameter an <code>Object</code> will be returned of type <code>String</code> or of 
		 * type <code>BitmapData</code>, depending upon what type of object was last assigned to the <code>sourceImage</code> 
		 * parameter. If no assignment was made to the <code>sourceImage</code> parameter, then <code>null</code> is returned.</p>
		 */
		public function get sourceImage():BitmapData {
			return imageSource;
		}
								
		// --------------------------------------------------------------------------------------------------
		// SET sourceImage - Sets the source image to be cropped
		// --------------------------------------------------------------------------------------------------
		public function set sourceImage(value:BitmapData):void {
			if (componentEnabled) {
				if (value != null) {
					if (imageBitmapData != null) {
						if (componentBitmap != null) componentBitmapData.fillRect(componentBitmapData.rect, bkgndColor);		
						imageBitmapData.dispose();
						imageBitmapData = null;
						imageSource = null;
						activateListeners(false);
					}
	
					imageBitmapData = BitmapData(value).clone();
						
					newImageLoaded = true;			
						
					invalidateDisplayList();
						
					imageSource = imageBitmapData;
					
					activateListeners(true);
						
					dispatchEvent(new Event(SOURCE_IMAGE_READY));					
				}
			}
		}
		
		// --------------------------------------------------------------------------------------------------
		// GET croppedBitmapData - Returns the bitmap data for the cropped image at actual size
		// --------------------------------------------------------------------------------------------------

		/**
		 * The cropped source image as a <code>BitmapData</code> object. The cropped portion of the source image 
		 * is defined by the position and the dimensions of the cropping rectangle.
		 */

		public function get croppedBitmapData():BitmapData {
			if (componentBitmapData == null) 
				initializeDisplay(this.width, this.height);
					
			if (newImageLoaded) 
				createScaledImage();		

			if (newCroppingRect) 
				initializeCroppingRect();
			
			var croppedBitmap:BitmapData = null;
			var sourceImageRect:Rectangle = getCropRect();
			
			if (imageBitmapData != null && sourceImageRect != null && sourceImageRect.width > 0 && sourceImageRect.height > 0) {
				croppedBitmap = new BitmapData(sourceImageRect.width, sourceImageRect.height, false);
				croppedBitmap.copyPixels(imageBitmapData, sourceImageRect, new Point(0, 0));
			}
			
			return croppedBitmap;
		}
		
		// --------------------------------------------------------------------------------------------------
		// setCropRect - Set the initial crop area
		// --------------------------------------------------------------------------------------------------
		
		/**
		 * This method defines the position and the dimensions of the cropping rectangle within the component.
		 * 
		 * <p>Note that values specified for the <code>width</code>, <code>height</code>, <code>x</code> and 
		 * <code>y</code> parameters can be relative to either the component (if <code>componentRelative</code> 
		 * is <code>true</code>) or to the source image (if <code>componentRelative</code> is <code>false</code>).</p>
		 * 
  		 * <p>For example, suppose the component has dimensions of 250x250 but the source image has dimensions of 500x500. 
		 * In this case the component will automatically scale the source image so that it fits within the component area. 
		 * If <code>componentRelative</code> is set to <code>false</code> then setting a cropping rectangle with dimensions 
		 * of 100x50 will result in a cropping rectangle being drawn in the component area with dimensions of 50x25 (i.e. 
		 * the cropping rectangle dimensions are relative to the source image). If <code>componentRelative</code> is set to 
		 * <code>true</code> then the cropping rectangle will be drawn with dimensions of 100x50 (i.e. the cropping rectangle 
		 * dimensions are relative to the component area).</p>
  		 * 
  		 * <p>If the <code>width</code> or the <code>height</code> parameter is assigned a value of zero, then the cropping 
		 * rectangle will be set to the full size of the image and any values specified for the <code>x</code> and <code>y</code> 
		 * parameters will be ignored.</p>
		 * 
		 * @param width Sets the width of the cropping rectangle. Setting <code>width</code> to zero will result in both the width 
		 * and the height of the cropping rectangle being set to the size of the image displayed in the component.
		 * 
		 * @param height Sets the height of the cropping rectangle. Setting <code>height</code> to zero will result in both the width 
		 * and the height of the cropping rectangle being set to the size of the image displayed in the component.
		 * 
		 * @param x Sets the horizontal position of the cropping rectangle. Setting <code>x</code> to -1 will result in the cropping 
		 * rectangle being centered vertically and horizontally in the component.
		 * 
		 * @param y Sets the vertical position of the cropping rectangle. Setting <code>y</code> to -1 will result in the cropping 
		 * rectangle being centered vertically and horizontally in the component.
		 * 
		 * @param componentRelative When set to <code>true</code> then the <code>width</code>, <code>height</code>, <code>x</code> 
		 * and <code>y</code> parameters are relative to the image displayed in the component. When <code>componentRelative</code> is 
		 * set to <code>false</code> then the parameters are relative to the source image. If the source image completely fits within
		 * the component without scaling, then <code>componentRelative</code> in essence has no effect since the component image and 
		 * the source image are identical.
		 */
		public function setCropRect(width:Number = 0, height:Number = 0, x:Number = -1, y:Number = -1, componentRelative:Boolean = false):void {
			if (componentEnabled) {
				if (width < 0) 
					width = 0;
				if (height < 0) 
					height = 0;
				if (x < -1) 
					x = -1;
				if (y < -1) 
					y = -1;
				
				cropX = x;
				cropY = y;
				
				cropWidth = width;
				cropHeight = height;
	
				if (cropWidth == 0 || cropHeight == 0) {
					cropWidth = 0;
					cropHeight = 0;

					if (cropRatioActive) {
						if (scaledImageBitmapData != null) {
							cropWidth = scaledImageBitmapData.width - 1;
							cropHeight = scaledImageBitmapData.height - 1;
						} else {
							dispatchEvent(new Event(CROP_CONSTRAINT_DISABLED));
							cropRatioActive = false;
						}
					}
				}
				
				croppingRectIsImageScale = !componentRelative;

				if (cropRatioActive) 
					cropRatio = cropWidth / cropHeight;
				else 
					cropRatio = 0;
				
				newCroppingRect = true;
				
				cropRectMinimumWidth = cropWidth;
				cropRectMinimumHeigth = cropHeight;
				
				invalidateDisplayList();
			}		
		}	
				
		// --------------------------------------------------------------------------------------------------
		// getCropRect - Return the selected crop area
		// --------------------------------------------------------------------------------------------------

		/**
		 * Returns the position and the dimensions of the cropped portion of the image as a <code>Rectangle</code>.
		 * 
		 * @param componentRelative If set to <code>true</code> then the <code>Rectangle</code> returned represents 
		 * the position and dimensions of the cropping rectangle in the component. If set to <code>false</code> then 
		 * the <code>Rectangle</code> returned represents the position and dimensions of the crop area in the source image.
		 * 
		 * @param roundValues If set to <code>true</code> then all values in the returned <code>Rectangle</code> are 
		 * rounded to integer values.
		 * 
		 * @return The position and dimensions of the crop area relative to the component (if <code>componentRelative</code> 
		 * is <code>true</code>) or relative to the source image (if <code>componentRelative</code> is <code>false</code>). 
		 * If a cropping rectangle has not been defined, then <code>null</code> will be returned.
		 */
		public function getCropRect(componentRelative:Boolean = false, roundValues:Boolean = false):Rectangle {
			if (cropRect != null) {
				var requestedRect:Rectangle;
			
				if (componentRelative) 
					requestedRect = cropRect.clone();
				else 
					requestedRect = new Rectangle(cropRect.x / imageScaleFactor, cropRect.y / imageScaleFactor, cropRect.width / imageScaleFactor, cropRect.height / imageScaleFactor);
				
				if (roundValues) {
					requestedRect.x = Math.round(requestedRect.x);
					requestedRect.y = Math.round(requestedRect.y);
					requestedRect.width = Math.round(requestedRect.width);
					requestedRect.height = Math.round(requestedRect.height);
				}
				
				return requestedRect; 
			}
			
			else return null;
		}								
		
		// --------------------------------------------------------------------------------------------------
		// activateListeners - Called to assign or release listeners for the component (mouse listeners 
		// should only be active when a source image is assigned) 
		// --------------------------------------------------------------------------------------------------
		private function activateListeners(addListeners:Boolean):void {
			if (addListeners && !mouseListenersActive) {
				this.addEventListener(MouseEvent.MOUSE_DOWN, doMouseDown);
				this.addEventListener(MouseEvent.MOUSE_MOVE, doMouseMove);
				mouseListenersActive = true;
			} else if (!addListeners && mouseListenersActive) {
				this.removeEventListener(MouseEvent.MOUSE_MOVE, doMouseMove);
				this.removeEventListener(MouseEvent.MOUSE_DOWN, doMouseDown);
				this.removeEventListener(MouseEvent.MOUSE_UP, doMouseUp);
				systemManager.stage.removeEventListener(Event.MOUSE_LEAVE, doMouseUp);
				systemManager.stage.removeEventListener(MouseEvent.MOUSE_UP, doMouseUp);
				mouseListenersActive = false;
			}		
		}
		
		// --------------------------------------------------------------------------------------------------
		// mouseLocation - Given a mouse event, returns -1 if the mouse is outside of the cropping rectangle,  
		//                 1 if the mouse is in the top-left handle, 2 if the mouse is in the top-right handle,
		//                 3 if the mouse is in the bottom-left handle, 4 if the mouse is in the bottom-right 
		//                 handle, or 0 if the mouse is in the interior of the cropping rectangle
		// --------------------------------------------------------------------------------------------------
		private function mouseLocation(event:MouseEvent):int {
			var mouseXLoc:Number = event.localX - imageLocation.x;
			var mouseYLoc:Number = event.localY - imageLocation.y;
						
			if (cropRect != null && cropRect.contains(mouseXLoc, mouseYLoc)) {
				var mouseDeltaX:Number = mouseXLoc - cropRect.x;
				var mouseDeltaY:Number = mouseYLoc - cropRect.y;
				
				if (mouseDeltaX <= cropHandleSize && mouseDeltaY <= cropHandleSize) 
					return 1;
				else if (mouseDeltaX >= cropRect.width - cropHandleSize && mouseDeltaY <= cropRect.width && mouseDeltaY <= cropHandleSize) 
					return 2;
				else if (mouseDeltaX <= cropHandleSize && mouseDeltaY >= cropRect.height - cropHandleSize && mouseDeltaY <= cropRect.height) 
					return 3;
				else if (mouseDeltaX >= cropRect.width - cropHandleSize && mouseDeltaY <= cropRect.height && mouseDeltaY >= cropRect.height - cropHandleSize && mouseDeltaY <= cropRect.height) 
					return 4;
				else 
					return 0;
			}
			
			else return -1;
		}								
				
		// --------------------------------------------------------------------------------------------------
		// doMouseDown
		// --------------------------------------------------------------------------------------------------
		private function doMouseDown(event:MouseEvent):void {
			var mouseLoc:int = mouseLocation(event);			
			mouseButtonDown = true;
			
			if (mouseLoc >= 0) {
				var mouseDeltaX:Number = event.localX - imageLocation.x - cropRect.x;
				var mouseDeltaY:Number = event.localY - imageLocation.y - cropRect.y;

				if (mouseLoc == 1) {
					anchorX = mouseDeltaX;
					anchorY = mouseDeltaY;					
					activeHandle = 1;
				} else if (mouseLoc == 2) {
					anchorX = mouseDeltaX - cropRect.width;
					anchorY = mouseDeltaY;	
					activeHandle = 2;
				} else if (mouseLoc == 3) {
					anchorX = mouseDeltaX;
					anchorY = mouseDeltaY - cropRect.height;	
					activeHandle = 3;
				} else if (mouseLoc == 4) {
					anchorX = mouseDeltaX - cropRect.width;
					anchorY = mouseDeltaY - cropRect.height;	
					activeHandle = 4;
				} else {
					anchorX = mouseDeltaX;
					anchorY = mouseDeltaY;
					activeHandle = 0;
				}
				
				this.addEventListener(MouseEvent.MOUSE_UP, doMouseUp);
				systemManager.stage.addEventListener(Event.MOUSE_LEAVE, doMouseExit);
				systemManager.stage.addEventListener(MouseEvent.MOUSE_UP, doMouseUp);
			}
		}
			
		// --------------------------------------------------------------------------------------------------
		// doMouseExit - Called when the mouse is outside of the Player area
		// --------------------------------------------------------------------------------------------------
		private function doMouseExit(event:Event):void {
			doMouseUp(null);
		}
		
		// --------------------------------------------------------------------------------------------------
		// doMouseUp
		// --------------------------------------------------------------------------------------------------
		private function doMouseUp(event:MouseEvent):void {
			mouseButtonDown = false;
			activeHandle = -1;
			
			this.removeEventListener(MouseEvent.MOUSE_UP, doMouseUp);
			systemManager.stage.removeEventListener(Event.MOUSE_LEAVE, doMouseUp);
			systemManager.stage.removeEventListener(MouseEvent.MOUSE_UP, doMouseUp);
			
			dispatchEvent(new Event(CROP_RECT_CHANGED));
		}		
					
		// --------------------------------------------------------------------------------------------------
		// doMouseMove - Follow the mouse and move or resize the cropping rectangle
		// --------------------------------------------------------------------------------------------------
		private function doMouseMove(event:MouseEvent):void {
			if (croppingRectBitmapData != null && mouseButtonDown) {
				var topX:Number;
				var topY:Number;
				var btmX:Number;
				var btmY:Number;
				
				var scaledW:Number;
				var scaledH:Number; 
			
				var mouseX:Number = event.localX - imageLocation.x;
				var mouseY:Number = event.localY - imageLocation.y;
				
				if (activeHandle == 0) {
					cropRect.x = mouseX - anchorX;
					cropRect.y = mouseY - anchorY;
					
					if (cropRect.x < 0) 
						cropRect.x = 0;
					else {
						var maxX:Number = Math.floor(imageScaledWidth - cropRect.width - 1);
						if (cropRect.x > maxX) cropRect.x = maxX;
					}
					
					if (cropRect.y < 0) 
						cropRect.y = 0;
					else {
						var maxY:Number = Math.floor(imageScaledHeight - cropRect.height - 1);
						if (cropRect.y > maxY) cropRect.y = maxY;
					}
				} else if (activeHandle == 1) {
					topX = mouseX - anchorX;
					topY = mouseY - anchorY;
					if (topX < 0) 
						topX = 0;
					if (topY < 0) 
						topY = 0;
					
					btmX = cropRect.x + cropRect.width;
					btmY = cropRect.y + cropRect.height;
					
					cropRect.width = btmX - topX;
					
					// If the new width is less than the minimum allowed size then set the new width to the minimum
					
					if (cropRect.width < cropRectMinimumWidth) {
						cropRect.width = cropRectMinimumWidth;
						topX = btmX - cropRectMinimumWidth;
					}
					
					cropRect.x = topX;

					cropRect.height = btmY - topY;
					
					if (cropRect.height < cropRectMinimumHeigth) {
						cropRect.height = cropRectMinimumHeigth;
						cropRect.y = btmY - cropRectMinimumHeigth;
					}
					else 
						cropRect.y = topY;
					
					if (cropRatioActive) {
						if (cropRect.width / cropRect.height != cropRatio) {
							scaledW = cropRect.height * cropRatio;
							if (scaledW < cropRectMinimumWidth) {
								scaledW = cropRectMinimumWidth;
								scaledH = scaledW / cropRatio;
								cropRect.y = cropRect.y + (cropRect.height - scaledH);
								cropRect.height = scaledH;
							}
							
							cropRect.x += cropRect.width - scaledW;

							if (cropRect.x < 0) {
								scaledW += cropRect.x;
								cropRect.x = 0;
								scaledH = scaledW / cropRatio;
								cropRect.y = cropRect.y + (cropRect.height - scaledH);
								cropRect.height = scaledH;
							}
							cropRect.width = scaledW;														
						}
					}					
				} else if (activeHandle == 2) {
					topX = mouseX - anchorX;
					topY = mouseY - anchorY;

					btmX = cropRect.x;
					btmY = cropRect.y + cropRect.height;
					
					if (topX > imageScaledWidth - 1) 
						topX = imageScaledWidth - 1;
					if (topY < 0) 
						topY = 0;
					
					cropRect.width = topX - btmX;
					
					if (cropRect.width < cropRectMinimumWidth) {
						cropRect.width = cropRectMinimumWidth;
						topX = btmX + cropRectMinimumWidth;
					}
					
					cropRect.x = btmX;
					cropRect.height = btmY - topY;
					
					if (cropRect.height < cropRectMinimumHeigth) {
						cropRect.height = cropRectMinimumHeigth;
						cropRect.y = btmY - cropRectMinimumHeigth;
					}
					else 
						cropRect.y = topY;
					
					if (cropRatioActive) {
						if (cropRect.width / cropRect.height != cropRatio) {
							scaledW = cropRect.height * cropRatio;
							if (scaledW < cropRectMinimumWidth) {
								scaledW = cropRectMinimumWidth;
								scaledH = scaledW / cropRatio;
								cropRect.y = cropRect.y + (cropRect.height - scaledH);
								cropRect.height = scaledH;
							}
							if (cropRect.x + scaledW > imageScaledWidth - 1) {
								scaledW = imageScaledWidth - 1 - cropRect.x;
								scaledH = scaledW / cropRatio;
								cropRect.y = cropRect.y + (cropRect.height - scaledH);
								cropRect.height = scaledH;
							}
							cropRect.width = scaledW;							
						}
					}
				} else if (activeHandle == 3) {
					btmX = mouseX - anchorX;
					btmY = mouseY - anchorY;

					if (btmX < 0) 
						btmX = 0;
					if (btmY > imageScaledHeight - 1) 
						btmY = imageScaledHeight - 1;

					topX = cropRect.x + cropRect.width;
					topY = cropRect.y;

					cropRect.width = topX - btmX;

					if (cropRect.width < cropRectMinimumWidth) {
						cropRect.width = cropRectMinimumWidth;
						btmX = topX - cropRectMinimumWidth;
					}
					
					cropRect.x = btmX;
					cropRect.height = btmY - topY;
					
					if (cropRect.height < cropRectMinimumHeigth) 
						cropRect.height = cropRectMinimumHeigth;

					cropRect.y = topY;
					
					if (cropRatioActive) {
						if (cropRect.width / cropRect.height != cropRatio) {
							scaledW = cropRect.height * cropRatio;
							if (scaledW < cropRectMinimumWidth) {
								scaledW = cropRectMinimumWidth;
								scaledH = scaledW / cropRatio;
								cropRect.height = scaledH;
							}
							cropRect.x += cropRect.width - scaledW;

							if (cropRect.x < 0) {
								scaledW += cropRect.x;
								cropRect.x = 0;
								scaledH = scaledW / cropRatio;
								cropRect.height = scaledH;
							}
							cropRect.width = scaledW;														
						}
					}					
				} else if (activeHandle == 4) {
					btmX = mouseX - anchorX;
					btmY = mouseY - anchorY;

					if (btmX > imageScaledWidth - 1) btmX = imageScaledWidth - 1;
					if (btmY > imageScaledHeight - 1) btmY = imageScaledHeight - 1;

					topX = cropRect.x;
					topY = cropRect.y;
					
					cropRect.width = btmX - topX;
					
					if (cropRect.width < cropRectMinimumWidth) {
						cropRect.width = cropRectMinimumWidth;
						btmX = topX + cropRectMinimumWidth;
					}
										
					cropRect.height = btmY - topY;
					
					if (cropRect.height < cropRectMinimumHeigth) 
						cropRect.height = cropRectMinimumHeigth;
					
					if (cropRatioActive) {
						if (cropRect.width / cropRect.height != cropRatio) {
							scaledW = cropRect.height * cropRatio;
							if (scaledW < cropRectMinimumWidth) {
								scaledW = cropRectMinimumWidth;
								scaledH = scaledW / cropRatio;
								cropRect.height = scaledH;
							}

							
							if (cropRect.x + scaledW > imageScaledWidth - 1) {
								scaledW = imageScaledWidth - 1 - cropRect.x;
								scaledH = scaledW / cropRatio;
								cropRect.height = scaledH;
							}
							
							cropRect.width = scaledW;							
						}
					}					
				}		

				drawCroppingRect();
				invalidateDisplayList();				
			}
		}
		
		// --------------------------------------------------------------------------------------------------
		// drawCroppingRect
		// --------------------------------------------------------------------------------------------------
		private function drawCroppingRect():void {
			if (croppingRectBitmapData && componentEnabled) {
				croppingRectBitmapData.fillRect(croppingRectBitmapData.rect, cropMaskColor);
				croppingRectBitmapData.fillRect(cropRect, 0x00FFFFFF);

				var border:Shape = new Shape();
				border.graphics.lineStyle(1, cropSelectionOutlineColor, cropSelectionOutlineAlpha);
				border.graphics.drawRect(cropRect.x, cropRect.y, cropRect.width, cropRect.height);
				croppingRectBitmapData.draw(border);	
				
				// Draw corner handles
				var handles:Shape = new Shape();
				handles.graphics.lineStyle(1, cropSelectionOutlineColor, cropSelectionOutlineAlpha);
				
				handles.graphics.beginFill(cropHandleColor, cropHandleAlpha);
				handles.graphics.drawRect(cropRect.x, cropRect.y, cropHandleSize, cropHandleSize);
				handles.graphics.endFill();
				
				handles.graphics.beginFill(cropHandleColor, cropHandleAlpha);
				handles.graphics.drawRect(cropRect.x + cropRect.width - cropHandleSize, cropRect.y, cropHandleSize, cropHandleSize);
				handles.graphics.endFill();
				
				handles.graphics.beginFill(cropHandleColor, cropHandleAlpha);
				handles.graphics.drawRect(cropRect.x, cropRect.y + cropRect.height - cropHandleSize, cropHandleSize, cropHandleSize);
				handles.graphics.endFill();
				
				handles.graphics.beginFill(cropHandleColor, cropHandleAlpha);
				handles.graphics.drawRect(cropRect.x + cropRect.width - cropHandleSize, cropRect.y + cropRect.height - cropHandleSize, cropHandleSize, cropHandleSize);
				handles.graphics.endFill();
				
				croppingRectBitmapData.draw(handles);
			}
		}		

		// --------------------------------------------------------------------------------------------------
		// commitProperties - Handle cropping rectangle property change (called by Flex when 
		// invalidateProperties is called after a change is made to a cropping rectangle property)
		// --------------------------------------------------------------------------------------------------
		override protected function commitProperties():void {
			super.commitProperties();

			if (cropMaskChanged) {
				cropMaskChanged = false;
				
				if (cropRect != null ) {
					var origRect:Rectangle = cropRect.clone();
						
					if (cropRect.y > imageScaledHeight - 1 - cropRectMinimumHeigth) 
						cropRect.y = imageScaledHeight - 1 - cropRectMinimumHeigth;
					if (cropRect.x > imageScaledWidth - 1 - cropRectMinimumWidth) 
						cropRect.x = imageScaledWidth - 1 - cropRectMinimumWidth;
					if (cropRect.height < cropRectMinimumHeigth) 
						cropRect.height = cropRectMinimumHeigth;
					if (cropRect.width < cropRectMinimumWidth) 
						cropRect.width = cropRectMinimumWidth;
					
					if (constrainToAspectRatio && cropRect.width != cropRect.height * cropRatio) {
						var newWidth:Number = cropRect.height * cropRatio;
						var newHeight:Number = cropRect.width / cropRatio;
						
						if (newWidth > cropRectMinimumWidth) {
							cropRect.width = newWidth;
							if (cropRect.x + cropRect.width > imageScaledWidth - 1) {
								var wDelta:Number = (cropRect.x + cropRect.width) - (imageScaledWidth - 1);
								if (cropRect.x - wDelta >= 0) 
									cropRect.x = cropRect.x - wDelta;
								else {
									cropRect.x = 0;
									cropRect.width = imageScaledWidth - 1;
									cropRatio = cropRect.width / cropRect.height;
									dispatchEvent(new Event(CROP_CONSTRAINT_CHANGED));
								}
							}
						} else {
							cropRect.height = newHeight;

							if (cropRect.y + cropRect.height > imageScaledHeight - 1) {
								var hDelta:Number = (cropRect.y + cropRect.height) - (imageScaledHeight - 1);
								if (cropRect.y - hDelta >= 0) 
									cropRect.y = cropRect.y - hDelta;
								else {
									cropRect.y = 0;
									cropRect.height = imageScaledHeight - 1;
									cropRatio = cropRect.width / cropRect.height;
									dispatchEvent(new Event(CROP_CONSTRAINT_CHANGED));
									
								}
							}							
						}
					}

					if (cropRect.x != origRect.x || cropRect.y != origRect.y) 
						dispatchEvent(new Event(CROP_POSITION_CHANGED));
					if (cropRect.width != origRect.width || cropRect.height != origRect.height) 
						dispatchEvent(new Event(CROP_DIMENSIONS_CHANGED));
				}
				
				drawCroppingRect();
				invalidateDisplayList();
			}
		}

		// --------------------------------------------------------------------------------------------------
		// measure - Sets the default component size and the component's minimum size in pixels 
		// --------------------------------------------------------------------------------------------------
		override protected function measure():void {
			super.measure();
			
			if (!isNaN(componentWidth) && !isNaN(componentHeight)) {
				measuredWidth = componentWidth;
				measuredHeight = componentHeight;
				
				measuredMinWidth = componentWidth;
				measuredMinHeight = componentHeight;
			}			
		}	

		// --------------------------------------------------------------------------------------------------
		// updateDisplayList - This method is called to size and position the children of the component based 
		//                     on all previous property and style settings.
		//                     It also draws any skins or graphic elements that the component uses. Note that 
		//                     the parent container determines the size of the component itself.
		// --------------------------------------------------------------------------------------------------
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			if (!destroyed) {
				super.updateDisplayList(unscaledWidth, unscaledHeight);

				if (unscaledWidth != componentWidth || unscaledHeight != componentHeight) 
					initializeDisplay(unscaledWidth, unscaledHeight);
				if (imageBitmapData != null) {	
					if (newImageLoaded) 
						createScaledImage();
					if (newCroppingRect) 
						initializeCroppingRect();
					
					componentBitmapData.fillRect(componentBitmapData.rect, bkgndColor);
					componentBitmapData.copyPixels(scaledImageBitmapData, scaledImageBitmapData.rect, imageLocation, null, null, true);
					if (componentEnabled && croppingRectBitmapData != null) 
						componentBitmapData.copyPixels(croppingRectBitmapData, croppingRectBitmapData.rect, imageLocation, null, null, true);
				}
			}			
		}

		// --------------------------------------------------------------------------------------------------
		// initializeDisplay - Create the bitmap that represents the component's display
		// --------------------------------------------------------------------------------------------------
		private function initializeDisplay(newWidth:int, newHeight:int):void {
			if (newWidth > 0 && newHeight > 0) {
				if (componentBitmap != null) {
					removeChild(componentBitmap);
					componentBitmapData.dispose();
				}

				componentBitmapData = new BitmapData(newWidth, newHeight, false, bkgndColor);
				componentBitmap = new Bitmap(componentBitmapData);
				componentBitmap.smoothing = true;
				addChild(componentBitmap);
				
				componentWidth = newWidth;
				componentHeight = newHeight;	
				createScaledImage();
				initializeCroppingRect();
				componentBitmapData.fillRect(componentBitmapData.rect, bkgndColor);

				componentBitmapData.copyPixels(scaledImageBitmapData, scaledImageBitmapData.rect, imageLocation, null, null, true);

				if (componentEnabled && croppingRectBitmapData != null) 
					componentBitmapData.copyPixels(croppingRectBitmapData, croppingRectBitmapData.rect, imageLocation, null, null, true);
				
				cropMaskChanged = true;
				commitProperties();

			}
		}		
					
		// --------------------------------------------------------------------------------------------------
		// initializeCroppingRect
		// --------------------------------------------------------------------------------------------------
		private function initializeCroppingRect():void {
			if (componentEnabled && scaledImageBitmapData != null) {
				var centerCropRect:Boolean = (cropX == -1) || (cropY == -1);
				newCroppingRect = false;
				if (croppingRectBitmapData != null) 
					croppingRectBitmapData.dispose();
				
				croppingRectBitmapData = new BitmapData(scaledImageBitmapData.width, scaledImageBitmapData.height, true, 0xAA000000);
				
				if (cropWidth == 0 || cropHeight == 0) {
					cropWidth = scaledImageBitmapData.width - 1;
					cropHeight = scaledImageBitmapData.height - 1;					

					var origRect:Rectangle = new Rectangle(cropX, cropY, cropWidth, cropHeight);
					
					if (cropRatioActive) {
						cropRatio = cropWidth / cropHeight;
						var origCropRatio:Number = cropRatio;
					}
				} else if (croppingRectIsImageScale) {
					if (cropRatioActive) 
						origCropRatio = cropRatio;

					if (cropX >= 0 && cropY >= 0) {
						cropX *= imageScaleFactor;
						cropY *= imageScaleFactor;
					}
					
					cropWidth *= imageScaleFactor;
					cropHeight *= imageScaleFactor;
					
					origRect = new Rectangle(cropX, cropY, cropWidth, cropHeight);					
					
					if (cropWidth < cropRectMinimumWidth) {
						cropHeight = cropHeight * (cropRectMinimumWidth / cropWidth)
						cropWidth = cropRectMinimumWidth;
					}
					
					if (cropHeight < cropRectMinimumHeigth) {
						cropWidth = cropWidth * (cropRectMinimumHeigth / cropHeight)
						cropHeight = cropRectMinimumHeigth;
					}
				} else 
					origRect = new Rectangle(cropX, cropY, cropWidth, cropHeight);					
				
				if (!centerCropRect) {
					if (cropX + cropWidth + 1 > scaledImageBitmapData.width) cropX = scaledImageBitmapData.width - cropWidth - 1;
					if (cropY + cropHeight + 1 > scaledImageBitmapData.height) cropY = scaledImageBitmapData.height - cropHeight - 1;
					
					if (cropX < 0) {
						cropWidth += cropX;
						if (cropWidth <= 0) 
							cropWidth = scaledImageBitmapData.width - 1;
						cropX = 0;
					}
					
					if (cropY < 0) {
						cropHeight += cropY;
						if (cropHeight <= 0) cropHeight = scaledImageBitmapData.height - 1;
						cropY = 0;
					}
				}
			
				if (cropWidth + 1 > scaledImageBitmapData.width) {
					cropWidth = scaledImageBitmapData.width - 1;
					if (cropRatioActive) cropHeight = cropWidth / cropRatio;
				}
				
				if (cropHeight + 1 > scaledImageBitmapData.height) {
					cropHeight = scaledImageBitmapData.height - 1;
					if (cropRatioActive) 
						cropWidth = cropHeight * cropRatio;
				}
				
				if (centerCropRect) {
					cropX = (scaledImageBitmapData.width - cropWidth) / 2;
					cropY = (scaledImageBitmapData.height - cropHeight) / 2;
				}
								
				if (cropX + cropWidth + 1 > scaledImageBitmapData.width) cropX = scaledImageBitmapData.width - cropWidth - 1;
				if (cropY + cropHeight + 1 > scaledImageBitmapData.height) cropY = scaledImageBitmapData.height - cropHeight - 1;
				
				if (scaledImageBitmapData.width - 1 <= cropX || scaledImageBitmapData.height - 1 <= cropY) {
					cropX = 0;
					cropY = 0;
					cropWidth = scaledImageBitmapData.width - 1
					cropHeight = scaledImageBitmapData.height - 1;
				}
				
				cropRect = new Rectangle(cropX, cropY, cropWidth, cropHeight); 
				
				drawCroppingRect();
				
				if (!centerCropRect && (cropX != origRect.x || cropY != origRect.y)) 
					dispatchEvent(new Event(CROP_POSITION_CHANGED));
				if (cropWidth != origRect.width || cropHeight != origRect.height) 
					dispatchEvent(new Event(CROP_DIMENSIONS_CHANGED));
				if (cropRatioActive && !isNaN() && cropRatio != origCropRatio) 
					dispatchEvent(new Event(CROP_CONSTRAINT_CHANGED));
			}			
		}
		
		// --------------------------------------------------------------------------------------------------
		// createScaledImage - Create a scaled version of the source image that will fit in the component's display area
		// --------------------------------------------------------------------------------------------------
		private function createScaledImage():void {
			if (imageBitmapData != null) {
				var imageWidth:Number = imageBitmapData.width;
				var imageHeight:Number = imageBitmapData.height;

				newImageLoaded = false;				
				imageScaleFactor = 1;
				var newXScale:Number = imageWidth == 0 ? 1 : componentWidth / imageWidth;
				var newYScale:Number = imageHeight == 0 ? 1 : componentHeight / imageHeight;
				
				var x:Number = 0;
				var y:Number = 0;
					
				if (newXScale > newYScale) {
					x = Math.floor((componentWidth - imageWidth * newYScale));
					imageScaleFactor = newYScale;
				}else {
					y = Math.floor((componentHeight - imageHeight * newXScale));
					imageScaleFactor = newXScale;
				}
				
				var scaleMatrix:Matrix = new Matrix();
				scaleMatrix.scale(imageScaleFactor, imageScaleFactor);
					
				imageScaledWidth = Math.ceil(imageBitmapData.width * imageScaleFactor);
				imageScaledHeight = Math.ceil(imageBitmapData.height * imageScaleFactor);
					
				imageLocation = new Point(x - ((unscaledWidth - imageScaledWidth) / 2), y - ((unscaledHeight - imageScaledHeight) / 2))			
					
				if (scaledImageBitmapData != null) 
					scaledImageBitmapData.dispose();
					
				scaledImageBitmapData = new BitmapData(imageScaledWidth, imageScaledHeight, true, bkgndColor);
					
				scaledImageBitmapData.draw(imageBitmapData, scaleMatrix, null, null, null, true);
			} else {
				imageScaledWidth = imageWidth;
				imageScaledHeight = imageHeight;
				
				imageLocation = new Point((componentWidth - imageWidth) / 2, (componentHeight - imageHeight) / 2);
					
				scaledImageBitmapData = imageBitmapData.clone();					
			}			
		}
	}
}
