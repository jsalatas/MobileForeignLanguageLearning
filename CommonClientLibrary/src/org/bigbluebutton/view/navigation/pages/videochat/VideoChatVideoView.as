package org.bigbluebutton.view.navigation.pages.videochat {
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.media.Video;
	import flash.text.TextField;
	
	import mx.utils.ObjectUtil;
	
	import org.bigbluebutton.view.navigation.pages.common.VideoView;
	
	public class VideoChatVideoView extends VideoView {
		private var _userName:TextField;
		
		private var _shape:Shape;
		
		private var _loader:Loader;
		
		public function setVideoPosition(name:String):void {
			if (video && video.parent) {
				var videoParent:DisplayObjectContainer = video.parent;
				video.parent.removeChild(video);
				videoParent.addChild(video);
			}
		}
		
		public function get videoViewVideo():Video {
			return video;
		}
		
		override public function close():void {
			if (video) {
				if (_userName && video.parent.contains(_userName)) {
					video.parent.removeChild(_userName);
				}
				if (_shape && video.parent.contains(_shape)) {
					video.parent.removeChild(_shape);
				}
				if (_loader && video.parent.contains(_loader)) {
					video.parent.removeChild(_loader);
				}
			}
			super.close();
		}
		
		public function onMetaData(... rest):void {
			trace("onMetaData() " + ObjectUtil.toString(rest));
		}
	}
}
