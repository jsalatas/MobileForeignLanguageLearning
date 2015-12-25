package gr.ictpro.mall.client.components.menu
{
	public class MenuItem
	{
		private var _text:String;
		
		public function MenuItem(text:String)
		{
			this._text = text;
		}
		
		public function get text():String
		{
			return this._text;
		}
		
		public function get isGroup():Boolean
		{
			return false;
		}
		
	}
}