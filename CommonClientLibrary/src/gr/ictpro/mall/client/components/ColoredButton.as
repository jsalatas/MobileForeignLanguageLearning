package gr.ictpro.mall.client.components
{
	import flash.events.Event;

	public class ColoredButton extends Button
	{
		
		private var _bgColor:uint;
		
		public function ColoredButton()
		{
			super();
		}

		[Bindable]
		public function set bgColor(value:uint):void
		{
			this._bgColor = value;
			skin.invalidateDisplayList();
		}
		
		public function get bgColor():uint
		{
			return this._bgColor;
		}
		
	}
}