package gr.ictpro.mall.client.service
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	
	import mx.core.IVisualElement;
	import mx.events.ModuleEvent;
	
	import spark.modules.ModuleLoader;
	
	import gr.ictpro.mall.client.signal.AddViewSignal;
	import gr.ictpro.mall.client.signal.ServerConnectErrorSignal;
	
	import org.robotlegs.core.IInjector;
	
	public class ExternalModuleLoader
	{
		[Inject]
		public var addView:AddViewSignal;
		
		[Inject]
		public var injector:IInjector;
		
		[Inject]
		public var serverConnectError:ServerConnectErrorSignal;
		
		[Inject]
		public var loadedSWFs:LoadedSWFs;

		private var _url:String;
		private var _className:String;
		
		private var _loader:ModuleLoader;

		public function ExternalModuleLoader(url:String, className:String)
		{
			this._url = url;
			this._className = className;
		}
		
		
		public function load():void
		{
			if(loadedSWFs.isLoaded(_url)) {
				showClass();
			} else {
				var loader:URLLoader = new URLLoader();
				loader.dataFormat = URLLoaderDataFormat.BINARY;
				loader.addEventListener(Event.COMPLETE, handleDownloaded);
				loader.addEventListener(ErrorEvent.ERROR, handleError);
				loader.addEventListener(IOErrorEvent.IO_ERROR, handleError);
				loader.load(new URLRequest(_url));
			}
			
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
			if(!loadedSWFs.isLoaded(_url)) {
				var initialize:Object = event.target.child; 
				injector.injectInto(initialize);
				loadedSWFs.add(_url);
			}
			showClass();
		}
		
		public function showClass():void 
		{
			var c:Class = ApplicationDomain.currentDomain.getDefinition(_className) as Class;
			var e:IVisualElement = new c() as IVisualElement;
			addView.dispatch(e);
		}
	}
}