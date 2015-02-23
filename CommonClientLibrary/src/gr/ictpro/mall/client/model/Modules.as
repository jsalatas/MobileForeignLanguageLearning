package gr.ictpro.mall.client.model
{
	import mx.collections.ArrayCollection;
	
	import spark.modules.ModuleLoader;

	public class Modules
	{
		private var _modules:ArrayCollection = new ArrayCollection();
		
		public function Modules()
		{
		}
		
		public function add(m:ModuleLoader):void
		{
			_modules.addItem(m);
		}
	}
}