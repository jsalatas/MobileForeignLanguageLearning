package gr.ictpro.mall.client.model
{
	import flash.text.ReturnKeyLabel;
	
	import mx.collections.ArrayList;

	public dynamic class PersistentData  
	{
		public function PersistentData()
		{
			super();
		}
		
		public function addValue(name:String, value: *): void
		{
			this[name] = value;
		}
		
			
	}
}