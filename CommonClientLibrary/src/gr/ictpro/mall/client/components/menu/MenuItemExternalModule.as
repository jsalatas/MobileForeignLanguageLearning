package gr.ictpro.mall.client.components.menu
{
	import flash.geom.ColorTransform;
	
	import spark.core.SpriteVisualElement;
	import spark.filters.ColorMatrixFilter;
	import spark.primitives.Graphic;

	public class MenuItemExternalModule extends MenuItemIcon
	{
		private var _moduleName:String;
		public function MenuItemExternalModule(text:String, icon:Object, colorTransform:ColorTransform, moduleName:String)
		{
			super(text, icon, colorTransform);
			this._moduleName = moduleName;
		}
	}
}