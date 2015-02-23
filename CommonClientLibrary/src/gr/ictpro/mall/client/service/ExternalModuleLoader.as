package gr.ictpro.mall.client.service
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	
	import gr.ictpro.mall.client.model.Modules;
	import gr.ictpro.mall.client.signal.AddViewSignal;
	import gr.ictpro.mall.client.signal.ServerConnectErrorSignal;
	
	import mx.core.IVisualElement;
	import mx.events.ModuleEvent;
	import mx.modules.IModuleInfo;
	import mx.modules.ModuleManager;
	
	import spark.modules.ModuleLoader;
	
	public class ExternalModuleLoader
	{
		[Inject]
		public var addView:AddViewSignal;
		
		[Inject]
		public var serverConnectError:ServerConnectErrorSignal;
		
		[Inject]
		public var loadedModules:Modules;

		private var _url:String;
		
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
		
		//private var a:ModuleLoader = new ModuleLoader();
		public function handleDownloaded(event:Event):void
		{
			var a:ModuleLoader= new ModuleLoader();
			// keep reference so that garbage collector cannot free its memory.
			// TODO: need to find a better way to handle this
			// look at http://gingerbinger.com/2010/07/actionscript-3-0-events-the-myth-of-useweakreference/
			loadedModules.add(a);
			var moduleBytes:ByteArray = ByteArray(URLLoader(event.target).data);
			a.applicationDomain = ApplicationDomain.currentDomain;
			a.addEventListener(ModuleEvent.READY, handleLoaded);
			a.addEventListener(ModuleEvent.ERROR, handleError);
			a.loadModule(_url, moduleBytes);
		}

		public function handleLoaded(event:ModuleEvent):void
		{
			var e:IVisualElement = event.module.factory.create()as IVisualElement;
			addView.dispatch(e);
		}
	}
}