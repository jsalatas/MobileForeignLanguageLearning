package gr.ictpro.mall.client.model.vomapper
{
	import flash.errors.IllegalOperationError;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	import gr.ictpro.mall.client.components.VOEditor;
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
		
		public function mapClass(model:AbstractModel, voClass:Class, viewClass:Class, editorClass:Class):void
		{
			var typeXML:XML = describeType(editorClass);
			if(typeXML.factory.extendsClass.(@type=="VOEditor").length() > 0) {
				throw new IllegalOperationError("editorClass should inherit VOEditor");
			}
			
			var voClassName:String = getQualifiedClassName(voClass).replace(".", "-").replace("::", "-");
			var m:Object = new Object();
			m.model = model;
			m.viewClass = viewClass;
			m.editorClass = editorClass;
			this._map[voClassName] = m;
		}
		
		public function getModelforVO(voClass:Class):AbstractModel
		{
			var voClassName:String = getQualifiedClassName(voClass).replace(".", "-").replace("::", "-");
			return this._map[voClassName].model;
		}

		public function getViewforVO(voClass:Class):Class
		{
			var voClassName:String = getQualifiedClassName(voClass).replace(".", "-").replace("::", "-");
			return this._map[voClassName].viewClass;
		}

		public function getEditorForVO(voClass:Class):Class
		{
			var voClassName:String = getQualifiedClassName(voClass).replace(".", "-").replace("::", "-");
			return this._map[voClassName].editorClass;
		}

	}
}