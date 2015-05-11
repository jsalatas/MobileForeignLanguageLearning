package gr.ictpro.mall.client.model
{
	import flash.system.System;
	
	import mx.collections.ArrayCollection;
	import mx.events.ModuleEvent;
	
	import spark.modules.ModuleLoader;

	public class Modules
	{
		private var _activeModule:ModuleLoader = null;
		private var _previousModule:ModuleLoader = null;
		
		public function Modules()
		{
		}
		
		public function set module(m:ModuleLoader):void
		{
			_previousModule = _activeModule;
			_activeModule = m;
		}
		
		public function unloadModule():void
		{
			if(_previousModule != null) {
				_previousModule.addEventListener(ModuleEvent.UNLOAD, unloadModuleHandler);
				_previousModule.unloadModule();
			}
		}
		private function unloadModuleHandler(event:ModuleEvent):void
		{
			_previousModule = null;
			trace("unloaded");
		}
		
	}
}