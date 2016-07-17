package gr.ictpro.mall.client.potato
{
	import gr.ictpro.mall.client.components.SharedBoard;
	
	public class PotatoBoard extends SharedBoard
	{
		public function PotatoBoard()
		{
			super();
		}
		
		override public function boardUpdated(obj:Object):void {
			trace("board updated: name = " + obj.name + " -" + obj.className);
			var updatedObject = this.getChildByName(obj.name);
			if(obj.hasOwnProperty("removed")) {
				if(updatedObject != null) {
					removeChild(updatedObject);
				}
			} else {
				if(updatedObject == null) {
					// object doesn't exist. Create it
					var cls:Class = Class(getDefinitionByName(obj.className)); 
					updatedObject = new cls();
					updatedObject.name = obj.name;
					addChild(updatedObject);
				}
				updatedObject.x = obj.x;
				updatedObject.y = obj.y;
			}
		}
	}
}
