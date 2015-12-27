package gr.ictpro.mall.client.service
{
	import mx.collections.ArrayList;

	public class LoadedSWFs
	{
		private var _loadedSWFs:ArrayList = new ArrayList(); 
		
		public function LoadedSWFs()
		{
		}
		
		public function add(swf:String):void
		{
			if(!isLoaded(swf)) {
				_loadedSWFs.addItem(swf);
			}
		}
		
		public function isLoaded(swf:String):Boolean
		{
			return _loadedSWFs.getItemIndex(swf)>-1;
		}
	}
}