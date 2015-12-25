package gr.ictpro.mall.client.components.menu
{
	import flash.geom.ColorTransform;
	
	import spark.core.SpriteVisualElement;
	import spark.filters.ColorMatrixFilter;
	import spark.modules.Module;
	import spark.primitives.Graphic;

	public class MenuItemInternalModule extends MenuItemIcon
	{
		private var _moduleName:String;
		public function MenuItemInternalModule(text:String, icon:Object, colorTransform:ColorTransform, moduleName:String)
		{
			super(text, icon, colorTransform);
			this._moduleName = moduleName;
		}
		
		public function get moduleName():String
		{
			return this._moduleName;
		}
	}
}