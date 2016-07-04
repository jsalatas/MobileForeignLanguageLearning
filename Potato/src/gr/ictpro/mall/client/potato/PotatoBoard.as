package gr.ictpro.mall.client.potato
{
	import gr.ictpro.mall.client.components.SharedBoard;
	
	public class PotatoBoard extends SharedBoard
	{
		public function PotatoBoard()
		{
			super();
			trace("@@@@@  Potato View created");
		}
		
		override public function boardUpdated(obj:Object):void {
			trace("board updated: name = " + obj.name);
		}
	}
}
