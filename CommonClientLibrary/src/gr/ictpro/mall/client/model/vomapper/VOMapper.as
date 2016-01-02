package gr.ictpro.mall.client.model.vomapper
{
	import flash.utils.getQualifiedClassName;
	
	import gr.ictpro.mall.client.model.AbstractModel;
	
	import org.robotlegs.core.IInjector;

	public class VOMapper
	{
		[Inject]
		public var injector:IInjector;
		
		private var _map:Object = new Object();
		
		public function VOMapper()
		{
		}
		
		public function mapClass(model:AbstractModel, voClass:Class, viewClass:Class):void
		{
			var voClassName:String = getQualifiedClassName(voClass).replace(".", "-").replace("::", "-");
			var m:Object = new Object();
			m.model = model;
			m.viewClass = viewClass;
			this._map[voClassName] = m;
		}
		
		public function getModelforVO(voClass:Class):AbstractModel
		{
			var voClassName:String = getQualifiedClassName(voClass).replace(".", "-").replace("::", "-");
			return this._map[voClassName].model;
		}

		public function getViewforVO(voClass:Class):AbstractModel
		{
			var voClassName:String = getQualifiedClassName(voClass).replace(".", "-").replace("::", "-");
			return this._map[voClassName].viewClass;
		}

	}
}