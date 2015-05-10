package gr.ictpro.mall.client.model.menu
{
	import spark.core.SpriteVisualElement;
	import spark.filters.ColorMatrixFilter;
	import spark.primitives.Graphic;

	public class MenuItemIcon extends MenuItem
	{
		private var _icon:Object;
		
		public function MenuItemIcon(text:String, icon:Object, colorTransformation:ColorMatrixFilter)
		{
			super(text);
			this._icon = icon;
			this._icon.filters = [colorTransformation];
		}
		
		public function get icon():Object
		{
			return this._icon;
		}
	}
}