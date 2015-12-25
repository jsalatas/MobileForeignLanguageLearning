package gr.ictpro.mall.client.components.menu
{
	import flash.geom.ColorTransform;
	
	import spark.filters.ColorMatrixFilter;

	public class MenuItemCommand extends MenuItemIcon
	{
		private var _command:Function;
		public function MenuItemCommand(text:String, icon:Object, colorTransform:ColorTransform, command:Function)
		{
			super(text, icon, colorTransform);
			this._command = command;
		}
		
		public function execute():*
		{
			return this._command();
		}
	}
}