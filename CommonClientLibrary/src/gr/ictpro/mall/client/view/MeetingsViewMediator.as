package gr.ictpro.mall.client.view
{
	import gr.ictpro.mall.client.model.AbstractModel;
	import gr.ictpro.mall.client.model.ConfigModel;
	import gr.ictpro.mall.client.model.MeetingModel;
	import gr.ictpro.mall.client.model.UserModel;
	import gr.ictpro.mall.client.runtime.RuntimeSettings;

	public class MeetingsViewMediator extends TopBarListViewMediator
	{
		[Inject]
		public var runtimeSettings:RuntimeSettings;

		[Inject]
		public var configModel:ConfigModel;

		[Inject]
		public function set meetingModel(model:MeetingModel):void
		{
			super.model = model as AbstractModel;
			
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			if(!runtimeSettings.user.allowNewMeetings()) {
				view.disableAdd();
			}
			
			if(UserModel.isStudent(runtimeSettings.user)) {
				var allowNewMeetings:Boolean = configModel.getItemByField("name", "allow_unattended_meetings").value == "true";
				if(!allowNewMeetings) {
					view.disableAdd();
				}
			}
				
		}
	}
}