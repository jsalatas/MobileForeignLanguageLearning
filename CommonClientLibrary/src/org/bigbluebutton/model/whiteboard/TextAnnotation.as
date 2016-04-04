package org.bigbluebutton.model.whiteboard {
	
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import spark.components.RichText;
	
	import flashx.textLayout.formats.VerticalAlign;
	
	import org.bigbluebutton.view.navigation.pages.whiteboard.WhiteboardCanvas;
	
	public class TextAnnotation extends Annotation  {
		private var _fontSize:Number;
		
		private var _calcedFontSize:Number;
		
		private var _dataPoints:String;
		
		private var _textBoxHeight:Number;
		
		private var _textBoxWidth:Number;
		
		private var _x:Number;
		
		private var _y:Number;
		
		private var _text:String;
		
		private var _richText:RichText;
		
		public function TextAnnotation(type:String, anID:String, whiteboardID:String, status:String, color:Number, fontSize:Number, calcedFontSize:Number, dataPoints:String, textBoxHeight:Number, textBoxWidth:Number, x:Number, y:Number, text:String) {
			super(type, anID, whiteboardID, status, color);
			_fontSize = fontSize;
			_calcedFontSize = calcedFontSize;
			_dataPoints = dataPoints;
			_textBoxHeight = textBoxHeight;
			_textBoxWidth = textBoxWidth;
			_x = x;
			_y = y;
			_text = text;
		}
		
		public function get fontSize():Number {
			return _fontSize;
		}
		
		public function get calcedFontSize():Number {
			return _calcedFontSize;
		}
		
		public function get dataPoints():String {
			return _dataPoints;
		}
		
		public function get textBoxHeight():Number {
			return _textBoxHeight;
		}
		
		public function get textBoxWidth():Number {
			return _textBoxWidth;
		}
		
		public function get x():Number {
			return _x;
		}
		
		public function get y():Number {
			return _y;
		}
		
		public function get text():String {
			return _text;
		}
		
		override public function update(an:Annotation):void {
			if (an.anID == this.anID) {
				super.update(an);
				_fontSize = TextAnnotation(an).fontSize;
				_calcedFontSize = TextAnnotation(an).calcedFontSize;
				_dataPoints = TextAnnotation(an).dataPoints;
				_textBoxHeight = TextAnnotation(an).textBoxHeight;
				_textBoxWidth = TextAnnotation(an).textBoxWidth;
				_x = TextAnnotation(an).x;
				_y = TextAnnotation(an).y;
				_text = TextAnnotation(an).text;
			}
		}
		
		override public function draw(canvas:WhiteboardCanvas, zoom:Number):void {
			if (!_richText) {
				_richText = new RichText();
			}
			_richText.text = _text;
			trace("text: = " + _text);
			_richText.setStyle("fontSize", zoom * _fontSize);
			_richText.setStyle("fontFamily", "Arial");
			_richText.setStyle("color", color);
			_richText.setStyle("verticalAlign", VerticalAlign.TOP);
			_richText.x = denormalize(_x, canvas.width);
			_richText.y = denormalize(_y, canvas.height);
			_richText.width = denormalize(_textBoxWidth, canvas.width);
			_richText.height = denormalize(_textBoxHeight, canvas.height);
			if (!canvas.containsElement(_richText)) {
				canvas.addElement(_richText);
			}
		}
		
		override public function remove(canvas:WhiteboardCanvas):void {
			if (!!_richText && canvas.containsElement(_richText)) {
				canvas.removeElement(_richText);
			}
		}
	}
}
