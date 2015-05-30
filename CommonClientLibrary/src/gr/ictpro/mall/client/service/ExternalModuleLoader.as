package gr.ictpro.mall.client.service
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	
	import gr.ictpro.mall.client.model.Device;
	import gr.ictpro.mall.client.model.Modules;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	import gr.ictpro.mall.client.signal.ServerConnectErrorSignal;
	
	import mx.core.IVisualElement;
	import mx.events.ModuleEvent;
	import mx.modules.IModuleInfo;
	import mx.modules.ModuleManager;
	
	import org.swiftsuspenders.Injector;
	
	import spark.modules.Module;
	import spark.modules.ModuleLoader;
	import spark.skins.SparkSkin;
	
	public class ExternalModuleLoader
	{
		[Inject]
		public var addView:AddViewSignal;
		
		[Inject]
		public var serverConnectError:ServerConnectErrorSignal;
		
		[Inject]
		public var loadedModules:Modules;

		private var _url:String;
		
		private var _loader:ModuleLoader;

		public function ExternalModuleLoader(url:String)
		{
			this._url = url;
		}
		
		
		public function load():void
		{
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, handleDownloaded);
			loader.load(new URLRequest(_url));
			
		}
		
		public function handleError(event:Event):void
		{
			serverConnectError.dispatch();
		}
		
		public function handleDownloaded(event:Event):void
		{
			_loader = new ModuleLoader();
			var moduleBytes:ByteArray = ByteArray(URLLoader(event.target).data);
			_loader.applicationDomain = ApplicationDomain.currentDomain;
			_loader.addEventListener(ModuleEvent.READY, handleLoaded);
			_loader.addEventListener(ModuleEvent.ERROR, handleError);
			_loader.loadModule(_url, moduleBytes);
		}

		public function handleLoaded(event:ModuleEvent):void
		{
			loadedModules.module = _loader;
			var e:IVisualElement = event.module.factory.create()as IVisualElement;
			addView.dispatch(e);
		}
	}
}