package gr.ictpro.mall.client.model
{
	import flash.utils.getQualifiedClassName;
	
	import org.robotlegs.core.IInjector;

	public class VOToModelMapper
	{
		[Inject]
		public var injector:IInjector;
		
		private var _map:Object = new Object();
		
		public function VOToModelMapper()
		{
		}
		
		public function mapClass(model:AbstractModel, voClass:Class):void
		{
			var voClassName:String = getQualifiedClassName(voClass).replace(".", "-").replace("::", "-");
			this._map[voClassName] = model;
		}
		
		public function getModelforVO(voClass:Class):AbstractModel
		{
			var voClassName:String = getQualifiedClassName(voClass).replace(".", "-").replace("::", "-");
			return this._map[voClassName];
		}
		
	}
}