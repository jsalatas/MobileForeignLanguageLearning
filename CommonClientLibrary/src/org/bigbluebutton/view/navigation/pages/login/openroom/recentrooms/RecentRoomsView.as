package org.bigbluebutton.view.navigation.pages.login.openroom.recentrooms {
	
	import spark.components.List;
	
	public class RecentRoomsView extends RecentRoomsViewBase  {
		override protected function childrenCreated():void {
			super.childrenCreated();
		}
		
		public function dispose():void {
		}
		
		public function get roomsList():List {
			return roomsList0;
		}
	}
}
