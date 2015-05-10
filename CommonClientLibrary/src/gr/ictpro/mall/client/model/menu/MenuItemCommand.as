package gr.ictpro.mall.client.model.menu
{
	import spark.filters.ColorMatrixFilter;

	public class MenuItemCommand extends MenuItemIcon
	{
		private var _command:Function;
		public function MenuItemCommand(text:String, icon:Object, colorTransformation:ColorMatrixFilter, command:Function)
		{
			super(text, icon, colorTransformation);
			this._command = command;
		}
		
		public function execute():*
		{
			return this._command();
		}
	}
}