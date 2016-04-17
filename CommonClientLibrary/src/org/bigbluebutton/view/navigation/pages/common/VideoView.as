package org.bigbluebutton.view.navigation.pages.common {
	
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.StatusEvent;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.system.Capabilities;
	
	import mx.utils.ObjectUtil;
	
	import spark.components.Group;
	
	public class VideoView extends Group {
		protected var ns:NetStream;
		
		protected var video:Video;
		
		protected var streamName:String;
		
		protected var aspectRatio:Number = 0;
		
		public var originalVideoWidth:Number;
		
		public var originalVideoHeight:Number;
		
		protected var connection:NetConnection;
		
		public var userID:String;
		
		public var userName:String;
		
		public function VideoView():void {
			video = new Video();
		}
		
		public function startStream(connection:NetConnection, name:String, streamName:String, userID:String, width0:Number, height0:Number):void {
			initializeScreenSizeValues(width0, height0);
			this.userName = name;
			this.userID = userID;
			this.streamName = streamName;
			this.connection = connection;
			ns = new NetStream(connection);
			ns.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			ns.client = this;
			ns.bufferTime = 0;
			ns.receiveVideo(true);
			ns.receiveAudio(false);
			video.smoothing = true;
			video.attachNetStream(ns);
			// Users on iOS devices cannot watch H.264 video, http://dev.mconf.org/redmine/issues/1483
			if (connection.uri.indexOf("/video/") != -1 && Capabilities.version.indexOf('IOS') >= 0) {
				ns.play("h263/" + streamName);
			} else {
				ns.play(streamName);
			}
		}

		public function startPreview(camera:Camera, height:Number, width:Number):void {
			initializeScreenSizeValues(width, height);
			video.attachCamera(camera);
		}
		
		public function initializeScreenSizeValues(originalVideoWidth0:Number, originalVideoHeight0:Number):void {
			this.originalVideoWidth = originalVideoWidth0;
			this.originalVideoHeight = originalVideoHeight0;
		}
		
		private function onNetStatus(e:NetStatusEvent):void {
			switch (e.info.code) {
				case "NetStream.Publish.Start":
					trace("NetStream.Publish.Start for broadcast stream " + streamName);
					break;
				case "NetStream.Play.UnpublishNotify":
					this.close();
					break;
				case "NetStream.Play.Start":
					trace("Netstatus: " + e.info.code);
					break;
				case "NetStream.Play.FileStructureInvalid":
					trace("The MP4's file structure is invalid.");
					break;
				case "NetStream.Play.NoSupportedTrackFound":
					trace("The MP4 doesn't contain any supported tracks");
					break;
			}
		}
		
		private function onAsyncError(e:AsyncErrorEvent):void {
			trace("VideoWindow::asyncerror " + e.toString());
		}
		
		public function close():void {
			if (video && video.parent) {
				video.parent.removeChild(video);
				video.attachNetStream(null);
				video = null;
			}
			if (ns) {
				ns.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
				ns.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
				ns.close();
				ns = null;
			}
		}
	}
}
