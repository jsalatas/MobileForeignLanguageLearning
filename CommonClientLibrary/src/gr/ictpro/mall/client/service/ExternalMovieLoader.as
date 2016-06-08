package gr.ictpro.mall.client.service
{
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	
	import mx.collections.ArrayCollection;
	import mx.core.IVisualElement;
	import mx.events.ModuleEvent;
	
	import spark.modules.ModuleLoader;
	
	import gr.ictpro.mall.client.signal.AddViewSignal;
	import gr.ictpro.mall.client.signal.ServerConnectErrorSignal;
	
	import org.robotlegs.core.IInjector;
	
	[Bindable(event="classLoaded")]
	public class ExternalMovieLoader extends EventDispatcher
	{
		private static var inProgressLoaders:ArrayCollection = new ArrayCollection();
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
		private var _showClass:Boolean;
		
		private var _loader:Loader;
		
		public function ExternalMovieLoader(url:String, className:String)
		{
			this._url = url;
			this._className = className;
			this._showClass = false;
		}
		
		
		public function load():void
		{
			if(loadedSWFs.isLoaded(_url)) {
				if(_showClass) {
					showClass();
				}
			} else {
				inProgressLoaders.addItem(this);
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
			inProgressLoaders.removeItemAt(inProgressLoaders.getItemIndex(this));
		}
		
		public function handleDownloaded(event:Event):void
		{
			_loader = new Loader();
			var moduleBytes:ByteArray = ByteArray(URLLoader(event.target).data);
			//_loader.applicationDomain = ApplicationDomain.currentDomain;
			//_loader.trustContent = true;
			var loaderContext:LoaderContext = new LoaderContext();
			loaderContext.allowLoadBytesCodeExecution = true;
			loaderContext.allowCodeImport = true;
			loaderContext.applicationDomain = ApplicationDomain.currentDomain;
			//loaderContext.securityDomain = SecurityDomain.currentDomain;
			loaderContext.checkPolicyFile = false;
			
			//_loader.addEventListener(ModuleEvent.READY, handleLoaded);
			//_loader.addEventListener(ModuleEvent.ERROR, handleError);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoaded); 
			_loader.loadBytes(moduleBytes, loaderContext);
		}
		
		
		//public function handleLoaded(event:ModuleEvent):void
		public function handleLoaded(event:Event):void
		{
			if(!loadedSWFs.isLoaded(_url)) {
				//var initialize:Object = event.target.child;
				var tmp:String = _className.substr(0, _className.lastIndexOf(".")+1)+"Initialize";
				var initializeCls:Class = getDefinitionByName(tmp) as Class;
				
				var initialize:Object = new initializeCls();
				injector.injectInto(initialize);
				loadedSWFs.add(_url);
			}
			inProgressLoaders.removeItemAt(inProgressLoaders.getItemIndex(this));
			if(_showClass) {
				showClass();
			}
			var cls:Class =  event.target.applicationDomain.getDefinition(_className);
			var e:MovieLoadedEvent = new MovieLoadedEvent(MovieLoadedEvent.LOADED,cls); 
			dispatchEvent(e);
			
		}
		
		public function showClass():void 
		{
			var c:Class = ApplicationDomain.currentDomain.getDefinition(_className) as Class;
			var e:IVisualElement = new c() as IVisualElement;
			addView.dispatch(e);
		}
	}
}


