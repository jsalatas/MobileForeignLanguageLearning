package gr.ictpro.mall.client.model.menu
{
	import spark.core.SpriteVisualElement;
	import spark.filters.ColorMatrixFilter;
	import spark.primitives.Graphic;

	public class MenuItemModule extends MenuItemIcon
	{
		private var _moduleName:String;
		public function MenuItemModule(text:String, icon:Object, colorTransformation:ColorMatrixFilter, moduleName:String)
		{
			super(text, icon, colorTransformation);
			this._moduleName = moduleName;
		}
	}
}