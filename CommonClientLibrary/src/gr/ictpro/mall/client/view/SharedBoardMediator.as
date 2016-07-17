package gr.ictpro.mall.client.view
{
	import flash.events.NetStatusEvent;
	import flash.events.SyncEvent;
	import flash.net.NetConnection;
	import flash.net.SharedObject;
	
	import gr.ictpro.mall.client.components.SharedBoard;
	
	import org.bigbluebutton.model.ConferenceParameters;
	import org.bigbluebutton.model.UserSession;
	import org.robotlegs.mvcs.SignalMediator;
	
	public class SharedBoardMediator extends SignalMediator
	{
		[Inject]
		public var userSession: UserSession;
		
		[Inject]
		public var conferenceParameters:ConferenceParameters;
		
		[Inject]
		public var view:SharedBoard; 
		
		private var connection:NetConnection;
		private var rso:SharedObject;
		private var sharedBoardUrl:String;
		
		override public function onRegister():void
		{
			super.onRegister();
			connection = new NetConnection();
			sharedBoardUrl = conferenceParameters.host.replace("http://", "rtmp://") +"/SharedBoard"; 
			connection.connect(sharedBoardUrl);
			connection.addEventListener(NetStatusEvent.NET_STATUS, onConnectionNetStatus);
			connection.client = this;	

			rso = SharedObject.getRemote(conferenceParameters.meetingID, connection.uri);
			rso.addEventListener(SyncEvent.SYNC, onSync);
			rso.connect(connection);

			addToSignal(view.updateBoardSignal, updateBoard);
		}

		private function onSync(event:SyncEvent):void {
			trace("event: " + event);
			for(var i:Object in event.changeList) {
				var changeObj:Object = event.changeList[i];
				switch(changeObj.code)
				{
					case "success":
						break;
					
					case "change":
						view.boardUpdated(this.rso.data[changeObj.name]);
						break;
					
				}
			}
		}
		

		private function updateBoard(obj:Object):void {
			rso.setProperty(conferenceParameters.meetingID, obj);
		}
		
		public function onConnectionNetStatus(event:NetStatusEvent) : void {
			// did we successfully connect
			if(event.info.code == "NetConnection.Connect.Success") {
				trace("Connected");
			} else {
				trace("Connection failed");
			}
		}

	}
}